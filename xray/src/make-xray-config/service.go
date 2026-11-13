package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

func makeConfig(source, tag string) ([]byte, error) {
	connection, err := parseURL(strings.TrimSpace(source))
	if err != nil {
		return nil, err
	}

	if tag == "" || tag == "direct" {
		return nil, errors.New("proxy tag must be nonempty and different from direct")
	}

	data, err := json.MarshalIndent(formatConfig(connection, tag), "", "    ")
	if err != nil {
		return nil, err
	}

	return append(data, '\n'), nil
}

type OutboundSpec struct {
	URL     string `json:"url"`
	Via     string `json:"via,omitempty"`
	Default bool   `json:"default,omitempty"`
}

// makeConfigFromDir reads the flat integration directory populated by dot.
func makeConfigFromDir(dir string) ([]byte, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, err
	}
	var config map[string]any
	var outbounds []any
	specs := map[string]OutboundSpec{}
	for _, entry := range entries {
		if entry.IsDir() || !strings.HasSuffix(entry.Name(), ".json") {
			continue
		}
		tag := strings.TrimSuffix(entry.Name(), ".json")
		if tag == "" || tag == "direct" {
			return nil, fmt.Errorf("%s: outbound tag must be nonempty and different from direct", entry.Name())
		}
		source, err := os.ReadFile(filepath.Join(dir, entry.Name()))
		if err != nil {
			return nil, err
		}
		var spec OutboundSpec
		decoder := json.NewDecoder(bytes.NewReader(source))
		decoder.DisallowUnknownFields()
		if err := decoder.Decode(&spec); err != nil {
			return nil, fmt.Errorf("%s: expected a JSON object with url, optional via string, and optional default boolean", entry.Name())
		}
		if err := decoder.Decode(new(any)); err != io.EOF {
			return nil, fmt.Errorf("%s: expected one JSON object", entry.Name())
		}
		outbound, err := parseOutbound(strings.TrimSpace(spec.URL), tag)
		if err != nil {
			return nil, fmt.Errorf("%s: %w", entry.Name(), err)
		}
		fragment := formatConfig(VlessConnection{}, tag)
		fragment["outbounds"].([]any)[0] = outbound
		specs[tag] = spec
		if spec.Via != "" {
			outbound["streamSettings"].(map[string]any)["sockopt"] = map[string]any{"dialerProxy": spec.Via}
		}
		if spec.Default {
			if config != nil {
				return nil, errors.New("exactly one outbound must set default to true; multiple defaults found")
			}
			config = fragment
			// Keep the chosen default first for unmatched traffic.
			outbounds = append([]any{outbound}, outbounds...)
		} else {
			outbounds = append(outbounds, outbound)
		}
	}
	if config == nil {
		return nil, errors.New("exactly one outbound must set default to true; no default found")
	}
	// Validate every dependency, including outbounds not selected by routing.
	states := map[string]int{}
	var visit func(string) error
	visit = func(tag string) error {
		if states[tag] == 1 {
			return fmt.Errorf("%s.json: proxy chain contains a cycle", tag)
		}
		if states[tag] == 2 {
			return nil
		}
		states[tag] = 1
		via := specs[tag].Via
		if via != "" {
			if _, exists := specs[via]; !exists {
				return fmt.Errorf("%s.json: via must reference an existing outbound", tag)
			}
			if err := visit(via); err != nil {
				return err
			}
		}
		states[tag] = 2
		return nil
	}
	for _, entry := range entries {
		tag := strings.TrimSuffix(entry.Name(), ".json")
		if _, exists := specs[tag]; exists {
			if err := visit(tag); err != nil {
				return nil, err
			}
		}
	}
	config["outbounds"] = append(outbounds, config["outbounds"].([]any)[1])
	data, err := json.MarshalIndent(config, "", "    ")
	if err != nil {
		return nil, err
	}
	return append(data, '\n'), nil
}

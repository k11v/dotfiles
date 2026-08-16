# Writing Notes

## Goal

Produce compact, high-signal notes that capture essential facts, structure, and
practical pointers about a topic. Notes should be readable in seconds and useful
as a reference without additional context.

## Structure

Each note follows a minimal, consistent layout:

```
# <Title>

<Short factual paragraph>

<Optional short paragraphs or bullet points>

## References

<Commands, paths, links>
```

### Title

- Use a precise, descriptive name.
- Prefer canonical terminology (e.g., "macOS Root Directory", not "Mac
  Folders").

### Opening Paragraph

- 1–3 sentences.
- State what the thing _is_ and its defining properties.
- Avoid motivation, history, or opinion unless essential.

### Body

- Add only if needed.
- Use short paragraphs or bullet points.
- Each item should convey one fact or relationship.
- Prefer structure over prose.

Typical content:

- Composition (what it consists of)
- Source/origin (where parts come from)
- Key invariants or constraints
- Mappings/redirects/relationships
- Edge cases or non-obvious behavior

### References

- Always include at the end.
- Prefer concrete, reproducible artifacts:
  - CLI commands
  - File paths
  - Config files
  - Minimal links (if necessary)
- Avoid explanations here; keep it as a lookup list.

---

## Style Guidelines

### Conciseness

- Eliminate filler words.
- Avoid redundancy.
- Prefer dense phrasing over full explanations.

### Factual Tone

- No opinions, speculation, or conversational language.
- Write as if documenting a system, not explaining to a beginner.

### Precision

- Use exact terms (e.g., “APFS volume”, not “disk part”).
- Avoid vague qualifiers (“some”, “kind of”).

### Structure Over Narrative

- Prefer:
  - bullet points
  - short paragraphs
- Avoid long continuous text.

### Local Completeness

- The note should stand alone.
- Do not assume prior context from other notes.

## Content Selection

Include:

- Core definition
- Structural relationships
- Non-obvious mechanics
- Practical implications (if directly derived from facts)

Exclude:

- Step-by-step tutorials
- Exploration logs
- Personal reasoning
- Historical background (unless critical)

## Good vs Bad

### Good

```
# APFS Snapshot

An APFS snapshot is a read-only, point-in-time copy of a volume sharing underlying storage blocks.

Snapshots are space-efficient due to copy-on-write semantics.

They are used by Time Machine and system updates.

## References

- `diskutil apfs listSnapshots /`
- `tmutil listlocalsnapshots /`
```

### Bad

- Too verbose
- Contains opinions
- Explains basics unnecessarily
- Mixes commands with explanations inline

## Heuristics

- If a sentence does not add new information, remove it.
- If a concept can be expressed as a mapping or relation, do that.
- If unsure whether to include something, omit it.
- Optimize for future you scanning the note quickly.

## Optional Extensions

Use only when needed:

- Tables for structured comparisons
- Minimal diagrams (ASCII) for relationships
- Code blocks for commands (only in References or clearly separated)

## Summary

A good note is:

- Short
- Precise
- Structured
- Self-contained
- Focused on facts and relationships

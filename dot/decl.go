package main

type Alias struct {
	Key   string
	Value string
}

type BrewCask struct {
	Name string
}

type BrewFormula struct {
	Name string
}

// Value's type is one of:
//
//	string         // -string <string_value>
//	[]byte         // -data <hex_digits>
//	int            // -int <integer_value>
//	float          // -float  <floating-point_value>
//	bool           // -bool (true | false | yes | no)
//	time.Time      // -date <date_rep>
//	[]any          // -array <value1> <value2> ...
//	map[string]any // -dict <key1> <value1> <key2> <value2> ...
type Default struct {
	Domain string
	Key    string
	Value  any
}

type Env struct {
	Key   string
	Value string
}

type File struct {
	Dst string
	Src string
}

type Mas struct {
	Name string
}

type Run struct {
	Command string
}

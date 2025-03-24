package main

type Decl interface {
	decl()
}

type Base struct{}

func (d Base) decl() {}

type BrewCask struct {
	Base
	Name string
}

type BrewFormula struct {
	Base
	Name string
}

// Value's type is one of:
//
//	string         // writes -string <string_value>
//	[]byte         // writes -data <hex_digits>
//	int            // writes -int <integer_value>
//	float64        // writes -float <floating-point_value>
//	bool           // writes -bool (true | false | yes | no)
//	time.Time      // writes -date <date_rep>
//	[]any          // writes -array <value1> <value2> ...
//	map[string]any // writes -dict <key1> <value1> <key2> <value2> ...
//	nil            // deletes
type Default struct {
	Base
	Domain string
	Key    string
	Value  any
}

type EnvAlias struct {
	Base
	Key   string
	Value string
}

type EnvVar struct {
	Base
	Key   string
	Value string
}

type Link struct {
	Base
	Dst string
	Src string
}

type Mas struct {
	Base
	ID string
}

type Run struct {
	Base
	Command string
}

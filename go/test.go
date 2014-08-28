package main

import (
	"fmt"
	"io/ioutil"
	"offend.me.uk/babel"
)

func main() {
	input, _ := ioutil.ReadFile("example.babel")

	output := babel.BabelParse(string(input))

	for k, v := range output {
		fmt.Printf("%s -> '%s'\n", k, v)
	}
}

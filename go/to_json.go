package main

import (
    "encoding/json"
	"fmt"
	"io/ioutil"
	"offend.me.uk/babel"
    "os"
)

func main() {
	input, _ := ioutil.ReadAll(os.Stdin)

	data := babel.BabelParse(string(input))

    output, _ := json.Marshal(data)

    fmt.Println(string(output))
}

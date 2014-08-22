package babel

import (
    "fmt"
    "regexp"
    "strings"
)

var line_re, _ = regexp.Compile(`^(\s*(\w+(?:/\w+)*)\s*)=(.*)$`)
var ignore_re, _ = regexp.Compile(`^(\s*#|\s*$)`)

func babelGetValue(output *map[string]string, name string) string {
    return (*output)[name]
}

func babelSetValue(output *map[string]string, name string, value string) {
    (*output)[name] = value
}

func BabelParse(inputString string) map[string]string {
    input := strings.Split(inputString, "\n")
    output := make(map[string]string)

    var match []string = nil
    var cont_match []string = nil

    var last_var string
    var cont_re *regexp.Regexp

    for _, line := range(input) {
        match = line_re.FindStringSubmatch(line)

        if last_var != "" {
            cont_match = cont_re.FindStringSubmatch(line)
        }

        if match != nil {
            cont_re, _ = regexp.Compile(fmt.Sprintf("^ {%d}[ =](.*)$", len(match[1])))

            babelSetValue(&output, match[2], match[3])

            last_var = match[2]
        } else if last_var != "" && cont_match != nil {
            babelSetValue(&output, last_var, babelGetValue(&output, last_var) + fmt.Sprintf("\n%s", cont_match[1]))
        } else if !ignore_re.MatchString(line) {
            panic(fmt.Sprintf("Invalid line: '%s'", line))
        }
    }

    return output
}

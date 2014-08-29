var VAR_RE = /^( *(\w+(?:\/\w+)*) *)=(.*)$/;
var IGNORE_RE = /^(?:\s*#|\s*$)/;

function babel_detect_arrays(output) {
    var is_arraylike = true;

    if(typeof(output) === "object" &! Array.isArray(output)) {
        var sorted_keys = Object.keys(output).sort();

        for(var i=0; i<sorted_keys.length; i++) {
            if(sorted_keys[i] != i) {
                is_arraylike = false;
                break;
            }
        }
    } else {
        is_arraylike = false;
    }

    if(is_arraylike) {
        return Object.keys(output).sort().map(function(key) {
            return babel_detect_arrays(output[key]);
        });
    } else {
        if(typeof(output) === "object") {
            Object.keys(output).forEach(function(key) {
                output[key] = babel_detect_arrays(output[key]);
            });
        }

        return output;
    }
}

function babel_get_value(output, name, options) {
    if(options.flat) {
        return output[name];
    }

    var temp = output;

    name.split("/").forEach(function(key) {
        temp = temp[key];
    });

    return temp;
}

function babel_set_value(output, name, value, options) {
    if(options.flat) {
        if(!output.hasOwnProperty(name)) {
            output[name] = value;
        } else {
            output[name] += "\n" + value;
        }
    } else {
        var temp = output;

        var keys = name.split("/");

        for(var i=0; i<keys.length - 1; i++) {
            var key = keys[i];

            if(!temp.hasOwnProperty(key)) {
                temp[key] = {};
            } else if(typeof(temp[key]) != "object") {
                var old_value = temp[key];
                temp[key] = {"": old_value};
            }

            temp = temp[key];
        }

        temp[keys[keys.length - 1]] = value;
    }
}

function babel_parse(input, options) {
    options = options || {};

    if(options.flat === undefined) {
        options.flat = true;
    }

    if(options.detect_arrays === undefined) {
        options.detect_arrays = false;
    }

    if(options.detect_arrays) {
        options.flat = false;
    }

    var output = {};
    var last_var = null;
    var cont_re = null;

    input.split("\n").forEach(function(line) {
        var match = VAR_RE.exec(line);

        if(cont_re) {
            var cont_match = cont_re.exec(line);
        }

        if(match) {
            cont_re = RegExp("^ {" + match[1].length + "}[ =](.*)$");

            babel_set_value(
                output,
                match[2],
                match[3],
                options
            );

            last_var = match[2];
        } else if(last_var != null && cont_match) {
            babel_set_value(
                output,
                last_var,
                cont_match[1],
                options
            );
        } else if(!IGNORE_RE.test(line)) {
            throw "Invalid line: '" + line + "'";
        }
    });

    if(options.detect_arrays) {
        output = babel_detect_arrays(output);
    }

    return output;
}

function babel_generate(input, prefix) {
    prefix = prefix || "";

    var output = [];

    Object.keys(input).forEach(function(key) {
        var value = input[key];

        if(Array.isArray(value)) {
            var temp = {};
            value.map(function(entry, index) {
                temp[index] = entry;
            });

            output = output.concat(babel_generate(temp, prefix + key + "/"));
        } else if(typeof(value) == "object") {
            output = output.concat(babel_generate(value, prefix + key + "/"));
        } else {
            var indent_len = prefix.length + key.toString().length + 1;
            value = value.replace(/\n/g, "\n" + new Array(indent_len + 1).join(" "));

            if(key == "") {
                output.push(prefix.substr(0, prefix.length - 1) + "=" + value)
            } else {
                output.push(prefix + key + "=" + value)
            }
        }
    });

    return output;
}

exports.parse = babel_parse;
exports.generate = babel_generate;

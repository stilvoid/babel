#!/usr/bin/env node

var babel = require("./babel");
var fs = require("fs");

function fail(actual, expected) {
    throw "'" + actual + "' did not match '" + expected + "'";
}

function compare(actual, expected) {
    if(actual === expected) {
        process.stdout.write(".");
    } else {
        fail(actual, expected);
    }
}

function def(value, default_value) {
    if(value === undefined) {
        return default_value;
    }

    return value;
}

function test(input, options) {
    options = options || {};
    options.flat = def(options.flat, true);
    options.detect_arrays = def(options.detect_arrays, false);

    if(options.flat &! options.detect_arrays) {
        compare(Object.keys(foo).length, 15);
        compare(foo["map/jeff"], "bridges");
        compare(foo["map/kate"], "beckinsale");
        compare(foo["array/0"], "first one");
        compare(foo["array/1"], "second one");
        compare(foo["array/2"], "third one");
        compare(foo["array/3"], "split");
        compare(foo["array/3/left"], "fourth");
        compare(foo["array/3/right"], "one");
        compare(foo["other_array/1"], "sparse");
        compare(foo["other_array/6"], "arrays");
    } else {
        compare(Object.keys(foo).length, 8);
        compare(Object.keys(foo["map"]).length, 2);
        compare(foo["map"]["jeff"], "bridges");
        compare(foo["map"]["kate"], "beckinsale");
        compare(Object.keys(foo["array"]).length, 4);
        compare(Object.keys(foo["other_array"]).length, 2);
        compare(foo["other_array"]["1"], "sparse");
        compare(foo["other_array"]["6"], "arrays");

        if(options.detect_arrays) {
            compare(Array.isArray(foo["array"]), true);
            compare(foo["array"][0], "first one");
            compare(foo["array"][1], "second one");
            compare(foo["array"][2], "third one");
            compare(Object.keys(foo["array"][3]).length, 3);
            compare(foo["array"][3][""], "split");
            compare(foo["array"][3]["left"], "fourth");
            compare(foo["array"][3]["right"], "one");
        } else {
            compare(foo["array"]["0"], "first one");
            compare(foo["array"]["1"], "second one");
            compare(foo["array"]["2"], "third one");
            compare(Object.keys(foo["array"]["3"]).length, 3);
            compare(foo["array"]["3"][""], "split");
            compare(foo["array"]["3"]["left"], "fourth");
            compare(foo["array"]["3"]["right"], "one");
        }
    }

    // Common
    compare(foo["fred"], "My name is Bertie.");
    compare(foo["long_test"], "This is some long text.\nLines breaks can be included by indenting\nlevel with the opening line");
    compare(foo["indented"], "whatever");
    compare(foo["unindent"], "1");
    compare(foo["other"], "side\nthing");
}


// Flat
console.log("Testing babel.py with flat parsing");

var babel_text = fs.readFileSync("example.babel", "utf8");
var foo = babel.parse(babel_text);
test(foo);

console.log()
console.log("Success")
console.log()


// Not flat
console.log("Testing babel.py with hierarchical parsing")

var options = {flat: false};
var foo = babel.parse(babel_text, options);
test(foo, options);

console.log()
console.log("Success")
console.log();


// Detect lists
console.log("Testing babel.py with list detection")

var options = {detect_arrays: true};
var foo = babel.parse(babel_text, options);
test(foo, options);

console.log()
console.log("Success")
console.log()


// Generate
console.log("Testing babel.py generation")

// Generate some babel from the last foo
var babel_text = babel.generate(foo);
babel_text = babel_text.join("\n");

foo = babel.parse(babel_text);
test(foo);

console.log();
console.log("Success");
console.log();

#!/usr/bin/env node

var babel = require("./babel");
var fs = require("fs");

var options = {};

if(process.argv.length >= 3 && process.argv[2] == "-noflat") {
    options.flat = false;
}

var babel_text = "";

process.stdin.setEncoding("utf8");
process.stdin.resume();
process.stdin.on("data", function(chunk) {
    babel_text += chunk;
});

process.stdin.on("end", function(chunk) {
    var data = babel.parse(babel_text, options);

    console.log(JSON.stringify(data));
});

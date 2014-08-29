require "json"

When /^I parse the input(?: with the flat option (disabled|enabled))?$/ do |flat|
    case ENV["sut"]
    when "bash"
        command = "bash bash/to_json.sh"
    when "python"
        command = "python python/to_json.py"
    else
        raise "Unknown system for testing"
    end

    if flat == "disabled"
        command += " -noflat"
    end

    output = `echo "#{@babel}" | #{command}`

    @parsed = JSON.parse output
end

Given /^the input "(.*?)"$/ do |babel|
    step "the input:", babel
end

Given /^the input:$/ do |babel|
    @babel = babel
end

Then /^I have (\d+) keys?$/ do |n|
    assert(@parsed.keys.length == n.to_i, "#{n} did not match the expected keys: #{@parsed.keys.length}")
end

Then /^I have the key "(.*?)" with the value "(.*?)"$/ do |key, value|
    step "I have the key \"#{key}\" with the value:", value
end

Then /^I have the key "(.*?)" with the value:$/ do |key, value|

    assert(@parsed.has_key?(key), "Missing key: '#{key}'")

    if value.class == Cucumber::Ast::Table
        assert(@parsed[key].class == Hash, "#{value.class} Value was of wrong type: #{@parsed[key].class}")

        oldparsed = @parsed
        @parsed = oldparsed[key]

        value.rows_hash.each do |k, v|
            step "I have the key #{k} with the value #{v}"
        end

        @parsed = oldparsed
    elsif
        assert(@parsed[key].class == String, "#{value.class} Value was of wrong type: #{@parsed[key].class}")
        assert(@parsed[key] == value, "Incorrect value: '#{@parsed[key]}'")
    end
end

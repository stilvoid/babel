Feature: Parse a babel file
    As a developer
    I want to use a library to parse babel
    So that I can use data in my programs

    Scenario Outline: Single line, no frills
        Given the input <babel>
        When I parse the input
        Then I have 1 key
        And I have the key <key> with the value <value>

        Examples:
            | babel                  | key        | value         |
            | "one=1"                | "one"      | "1"           |
            | "a_string=Hello there" | "a_string" | "Hello there" |
            | "123key=123value"      | "123key"   | "123value"    |
            | "boolean=true"         | "boolean"  | "true"        |

    Scenario Outline: Spaces around key are stripped
        Given the input <babel>
        When I parse the input
        Then I have the key <key> with the value <value>

        Examples:
            | babel          | key    | value   |
            | " left=right"  | "left" | "right" |
            | "left =right"  | "left" | "right" |
            | " left =right" | "left" | "right" |

    Scenario Outline: Spaces around value are not stripped
        Given the input <babel>
        When I parse the input
        Then I have the key <key> with the value <value>

        Examples:
            | babel          | key    | value     |
            | "left= right"  | "left" | " right"  |
            | "left=right "  | "left" | "right "  |
            | "left= right " | "left" | " right " |

    Scenario: Multi-line value with spaces
        Given the input:
            """
            key=Multi-line
                value
            """
        When I parse the input
        Then I have the key "key" with the value:
            """
            Multi-line
            value
            """

    Scenario: Multi-line value with equals
        Given the input:
            """
            key=Multi-line
               =value
            """
        When I parse the input
        Then I have the key "key" with the value:
            """
            Multi-line
            value
            """

    @wip
    Scenario: Multi-line value with repeated key
        Given the input:
            """
            key=Multi-line
            key=value
            """
        When I parse the input
        Then I have the key "key" with the value:
            """
            Multi-line
            value
            """

    @wip
    Scenario: Multi-line value with repeated key and intervening key
        Given the input:
            """
            key=Multi-line
            other_key=other value
            key=value
            """
        When I parse the input
        Then I have the key "key" with the value:
            """
            Multi-line
            value
            """
        And I have the key "other_key" with the value "other value"

    Scenario: Multi-line value with extra space
        Given the input:
            """
            key=Multi-line
                 value
            """
        When I parse the input
        Then I have the key "key" with the value:
            """
            Multi-line
             value
            """

    @wip
    Scenario: Invalid key
        Given the input "invalid-key=valid value"
        When I parse the input
        Then I receive the error "Invalid key: 'invalid-key'"

    @wip
    Scenario: Invalid input
        Given the input "missing equals"
        When I parse the input
        Then I receive the error "Invalid input: 'missing equals'"

    Scenario: Comments and blank lines are ignored
        Given the input:
            """
            # A comment
            left=right

              # Indented comment
            top=bottom
            """
        When I parse the input
        Then I have 2 keys
        And I have the key "left" with the value "right"
        And I have the key "top" with the value "bottom"

    Scenario: Grouping with flat parsing
        Given the input:
            """
            group=top
            group/one=first
            group/2=second
            """
        When I parse the input with the flat option enabled
        Then I have 3 keys
        And I have the key "group" with the value "top"
        And I have the key "group/one" with the value "first"
        And I have the key "group/2" with the value "second"

    @not_bash
    Scenario: Grouping with hierarchical parsing
        Given the input:
            """
            group=top
            group/one=first
            group/2=second
            """
        When I parse the input with the flat option disabled
        Then I have 1 key
        And I have the key "group" with the value:
            | ""      | "top"    |
            | "one"   | "first"  |
            | "2"     | "second" |

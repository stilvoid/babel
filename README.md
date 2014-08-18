# Babel

An easy-to-parse and easy-to-produce data exchange format for easing communication between processes written in different programming languages.

## Principles

Data is represented in pairs of identifiers and values.

Identifiers are used to give values a name that can be referred to in your programs.

### Identifiers

Identifiers must consist of letters, numbers, and the underscore character.

Examples:

    `name`

    `address1`

    `postal_code`

Additionally, the identifier may contain groupings, delimited by a forward slash (`/`). These can be used to represent related values.

Examples:

    `address/1`
    `address/2`
    `address/3`

    `name/first`
    `name/last`

    `contact/1/title`

Unlike in some data formats, there may be a value associated both with the head of a grouping and with its children.

Example:

    `address`
    `address/1`
    `address/2`

### Values

Pairs of identifiers and values are separated by new lines and values are assigned to identifiers by the equals sign (`=`).

Examples:

    `name=Bruce Willis`

    `address/1=Fhloston Paradise`

If a value contains more than one line, line after the first should be indented with spaces so that they line up with the first line (after the equals sign).

Example:

        long_text=This is a long piece of text
                  that contains more than one line.
                  It's quite readable :)

### Comments

Babel files may contain blank lines and comment lines which will be ignored by the parser.

Comment lines start with `#` though there may be spaces before it.

Example:

        # Actor
        name=Bruce Willis
        address/1=New York

        # Film
        title=Die Hard

### Aesthetics

Once you have more than a few pieces of information in a file, it can start to look messy. To help with this, you can put spaces before or after the identifier name so that the equals signs line up.

Examples:

        # Spaces before the identifier
        first_name=Butch
         last_name=Coolidge
               dob=1955-03-19

        # Spaces before the identifier
        first_name=Winston
        last_name =Wolfe
        nick      =The Wolf

        # Spaces on both sides
        first_name=Vincent
          surname =Vega
           dob    =1954-02-18

## Putting it all together

Here's a more realistic example of some babel data.

    # Header information
    title             =Contact list
    owner             =Mr. Church
    version           =1

    # Begin contact list
    contact/1/name    =Barney Ross
    contact/1/phone   =555 12345

    contact/2/name    =Lee Christmas
    contact/2/phone   =+44 20 987 6543
    contact/2/country =UK

    contact/3/name    =Yin Yang
    contact/3/country =US
    # End contact list

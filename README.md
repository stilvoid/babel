# Babel

An easy-to-parse and easy-to-produce data exchange format for easing communication between processes written in different programming languages.

Example:

    # Movie list
    title          =Favourite movies
    author         =Stilvoid
    author/email   =steve@offend.me.uk

    # Bowie!
    movies/0/name  =Labyrinth
    movies/0/year  =1986

    movies/1/name  =Excalibur
                   # Was it really that long ago?!
    movies/1/year  =1981

    movies/2/name  =Tron: Legacy
    movies/2/year  =2010
    movies/2/notes =Very, very shiny with a nice sci-fi storyline.
                    Basically just one big music video :)
                    But who cares!

## Principles

Data is represented in pairs of identifiers and values.

Identifiers are used to give values a name that can be referred to in your programs.

### Identifiers

Identifiers may consist of letters, numbers, and the underscore character (`_`).

Examples:

    name

    address1

    postal_code

Additionally, the identifier may contain groupings, delimited by a forward slash (`/`). These can be used to represent related values.

Examples:

    address/1
    address/2
    address/3

    name/first
    name/last

    contact/1/title

Unlike in some data formats, there may be a value associated both with the head of a grouping and with its children.

Example:

    address
    address/1
    address/2

### Values

Pairs of identifiers and values must start on their own lines.

Values are linked to identifiers by the equals sign (`=`).

Examples:

    name=Bruce Willis
    address/1=Fhloston Paradise

If a value contains line breaks, each line after the first should be indented with spaces so that it lines up with the first line (after the equals sign).

Example:

    long_text=This is a long piece of text
              that contains more than one line.
              It's quite readable :)

Optionally, the extra lines may also include the equals sign. This can aid readability where the value contains a blank line.

Example:

    longer_text=This long piece of text
               =contains a blank line.
               =
               =See? :)

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

    # Spaces after the identifier
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

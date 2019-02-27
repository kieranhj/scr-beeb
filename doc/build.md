# Windows

Requirements:

* Python 2.x
* [BeebAsm](https://github.com/stardot/beebasm) - use the 1.09 exe
  from the repo

All additional dependencies should be included in the repo.

Steps:

1. Set the `PYTHON` environment variable to point to your `python.exe`

2. Run `make.bat`

The output is `scr-beeb.ssd` in the root of the working copy.

# OS X/Linux

Requirements:

* Python 2.x
* [Specific version of pucrunch](https://github.com/tom-seddon/pucrunch) -
  follow repo instructions to build
* [BeebAsm](https://github.com/stardot/beebasm) - follow repo
  instructions to build

Steps:

1. `make`

The output is `scr-beeb.ssd` in the root of the working copy.

## tools not on `PATH`? ##

The Makefile assumes you have appropriate `beebasm` and `pucrunch` on
the path. If not, supply `PUCRUNCH=<<path to pucrunch>>` and/or
`BEEBASM=<<path to beebasm>>` on the make command line. For example:

    make BEEBASM=~/beebasm/beebasm PUCRUNCH=~/pucrunch/pucrunch

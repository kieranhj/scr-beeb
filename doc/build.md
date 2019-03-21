# Windows

Requirements:

* Python 2.x

All additional dependencies should be included in the repo.

Steps:

1. Set the `PYTHON` environment variable to point to your `python.exe`

2. Run `bin\snmake`

# OS X/Linux

Requirements:

* Python 2.x
* [Exomizer v3.0.2](https://bitbucket.org/magli143/exomizer/wiki/Home)
* [BeebAsm](https://github.com/stardot/beebasm) - follow repo
  instructions to build

Steps:

1. `make`

## tools not on `PATH`? ##

The Makefile assumes you have appropriate `beebasm` and `exomizer` on
the path. If not, supply `EXOMIZER=<<path to exomizer>>` and/or
`BEEBASM=<<path to beebasm>>` on the make command line. For example:

    make BEEBASM=~/beebasm/beebasm EXOMIZER=~/exomizer-3.0.2/src/exomizer
	
# output files (all platforms)

The output is `build/scr-beeb.adl` (ADFS) and `build/scr-beeb.ssd`
(DFS).


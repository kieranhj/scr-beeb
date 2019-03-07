# Stunt Car Racer

<img src="https://github.com/kieranhj/scr-beeb/raw/master/graphics/TitleScreen_BBC.png" width="160" height="128" />

## **About**

Legendary video game developer [Geoff Crammond](https://en.wikipedia.org/wiki/Geoff_Crammond) created many seminal titles for the BBC Micro including [Aviator](http://bbcmicro.co.uk/game.php?id=39), [Revs](http://bbcmicro.co.uk/game.php?id=267) and [The Sentinel](http://bbcmicro.co.uk/game.php?id=2527). It seemed a real shame that one of his best-loved works, [Stunt Car Racer](https://en.wikipedia.org/wiki/Stunt_Car_Racer), never made it to the platform he began his career on... until now, some 30 years after its original release! This is our thank you to Geoff for his inspiration and contribution to BBC Micro game history.


## **Port**

This port was inspired by the work of [Fandal](http://a8.fandal.cz/) who converted the original C64 version of the game to the [Atari XE](http://a8.fandal.cz/detail.php?files_id=7541), starting only with a 6502 disassembly of the raw 64K memory map.

From the same starting point we have reverse engineered the functionality and data structures of the game so it could be rearranged into the BBC Master 128K memory map. Next all graphics, sound and I/O routines were replaced or augmented with brand new code specifically for the BBC hardware. Finally, new artwork was drawn to accomodate palette limitations and music added to round off this brand new version of one our favourite games of all time.

<p float="left">
<img src="https://github.com/kieranhj/scr-beeb/raw/master/doc/league.png" width="160" height="100" />
<img src="https://github.com/kieranhj/scr-beeb/raw/master/doc/track-preview.png" width="160" height="100" />
<img src="https://github.com/kieranhj/scr-beeb/raw/master/doc/drop-start.png" width="160" height="100" />
<img src="https://github.com/kieranhj/scr-beeb/raw/master/doc/ramp.png" width="160" height="100" />

## **How to Play**

The original Amiga manual can be found on [Open Retro](https://openretro.org/amiga/stunt-car-racer/docs).


### Game Controls

**Player Control Keys**

BBC Computer keyboard layout (your emulator layout may vary!):

* `S` - Steer left
* `D` - Steer right
* `RETURN` - Boost
* `:` or `*` - Brake / reverse
* `SPACE` - Hard brake / reverse
* `ESCAPE` - Leave race

**Additional Keys**

* `P` - Pause game
* `O` - Unpause game
* `F1` - Redefine keys (whilst paused)
* `M` - Toggle menu music on / off 
* `Keypad +` - Increase sound volume
* `Keypad -` - Decrease sound volume

To reset the game entirely hold `F1` whilst selecting the `Restart Season` option from the `Load / Save` menu.

## **How to Build**

See [build.md](doc/build.md).

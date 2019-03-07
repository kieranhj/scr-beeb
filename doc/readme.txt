
STUNT CAR RACER
---------------
Original concept, design and
programming by Geoff Crammond

Originally published for C64
by MicroStyle (c) 1989


Ported to the BBC Master by
the Bitshifters Collective!


ABOUT
-----
Legendary video game developer Geoff
Crammond created many seminal titles
for the BBC Micro but it seemed a
shame that one of his best-loved works
never made it to the platform he began
his career on... until now, some 30
years after its original release! This
is our thank you to Geoff for his
inspiration and contributions to BBC
Micro game history.

This port was inspired by the work of
Fandal who converted the original C64
version of the game to the Atari XE,
starting only with a 6502 disassembly
of the raw 64K memory map.

From the same starting point we have
reverse engineered the functionality
and data structures of the game so it
could be rearranged into the  Master
128K memory map. Next all graphics,
sound and I/O routines were replaced
or augmented with brand new code
specifically for the BBC hardware.
Finally, new artwork was drawn to
accommodate palette limitations and
music added to round off this brand
new version of one our favourite games
of all time.


CONTROLS
--------
- Steer left = S
- Steer right = D
- Boost = Return
- Brake / Reverse = * or :
- Boost backwards = Space
- Quit race = Escape

- Pause = P
- Unpause = O
- Redefine keys = F1 (whilst paused)

- Toggle menu music = M
- Volume up/down = Keypad +/-

To reset the game entirely hold 'F1'
whilst selecting the 'Replay' option
from the File menu.


HOW TO PLAY
-----------
See separate file 'GUIDE' on this disc
*TYPE GUIDE to read


CREDITS
-------
BBC Master port by Kieran Connell
Additional programming by Tom Seddon
Additional programming by HEx
Music conversion & code by Simon Morris
BBC graphics by John 'Dethmunk' Blythe

'Out Run Europa' music composed by
Matt Furniss for the Atari ST YM2149F
sound chip.

Lovingly converted for the BBC Micro
SN76489 sound chip by Simon Morris.


CONTACT
-------
Visit our BBC Retro Coding webpage
https://bitshifters.github.io

Find us on Facebook
https://www.facebook.com/bitshiftrs/

Say hello on Twitter
https://twitter.com/khconnell

Join the Acorn community at Stardot
http://stardot.org.uk/forums/


MANY THANKS
-----------
Geoff Crammond
John Cummins
Matt Furniss
Fandal & Irgendwer
Inverse Phase
Matt Godbolt
Richard 'Tricky' Broadhurst
Rich Talbot-Watkins
Sarah Walker
Stewart Badger
All our friends & supporters on Stardot

C64 Wiki
Mapping the C64 by Sheldon Leemon
Project 64 - David Holz, Cris Berneburg


TOOLS USED
----------
BeebAsm, b-em emulator, b2 emulator
jsbeeb emulator, Exomizer 3, Visual
Studio Code, GitHub & more...

https://github.com/simondotm/ym2149f
https://github.com/simondotm/vgm-packer
https://bitbucket.org/magli143/exomizer


TECHNICAL SUPPORT
-----------------
This game requires a standard issue
BBC Master 128K computer.

All 4x sideways RAM banks 4 - 7 must be
available for use. If you have ROMs
installed internally these may be
occupying sideways RAM banks. You will
need to remove them and check links
LK18 and LK19 are set correctly as per
the Master Reference manual.

PAGE must be at &E00. Type "P.~PAGE"
in BASIC to check your PAGE value.
If this is higher than &E00 then you
may have a ROM installed that is
claiming precious RAM!  Try unplugging
any non-essential ROMS with *UNPLUG.

This game has been tested on real
floppy disc hardware, Retroclinic
DataCentre and MAMMFS for MMC devices.

If you experience a crash or other bug
please report this on our GitHub page
along with an emulator save state file
if possible.

https://github.com/kieranhj/scr-beeb


RELEASE NOTES
-------------
7/3/2019 Version 1.0
Initial release!

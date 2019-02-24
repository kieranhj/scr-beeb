STUNT CAR RACER
by Geoff Crammond
with graphics by John Cumming

BBC Master version
Ported by the Bitshifters Collective


ABOUT
This port was inspired by the work of
Fandal who converted the original C64
version of the game to the Atari XE
starting only with a raw 6502 dis-
assembly of the 64K memory map.

From the same starting point we have
painstakingly pieced together the
functionality and memory map of the
game so it could first be rearranged
into BBC sideways RAM banks and then
all graphics, sound and I/O routines
replaced or augmented with brand new
code specifically for the BBC Master.


CONTROLS
- Steer left = S
- Steer right = D
- Boost = Return
- Brake / Reverse = * or :
- Boost backwards = Space
- Quit race = Escape

- Pause = P
- Unpase = O
- Redefine keys = F1 (whilst paused)

- Toggle music = M

To reset the game entirely hold 'F1'
whilst selecting the 'Replay' option
from the File menu.


HOW TO PLAY
See separate file 'GUIDE' on this disc
*TYPE GUIDE to read


CREDITS
BBC Master port by Kieran Connell
Additional programming by Tom Seddon
Music conversion & code by Simon Morris
BBC graphics by John 'Dethmunk' Blythe

Music 'Outrun Europa' by Matt Furniss
composed for the Atari ST YM2149F
sound chip.

Lovingly converted for the BBC Micro
SN76489 sound chip by Simon Morris.


CONTACT
Visit our BBC Retro Coding webpage
https://bitshifters.github.io

Find us on Facebook
https://www.facebook.com/bitshiftrs/

Say hello on Twitter
https://twitter.com/khconnell

Join the Acorn community at Stardot
http://stardot.org.uk/forums/


MANY THANKS
Geoff Crammond
Fandal & Irgendwer
HEx
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
BeebAsm, b-em emulator, b2 emulator
jsbeeb emulator, pucrunch, Visual
Studio Code, GitHub & more...

https://github.com/simondotm/ym2149f
https://github.com/simondotm/vgm-packer
https://github.com/mist64/pucrunch


TECHNICAL SUPPORT
This game requires a standard issue
BBC Master 128K computer.

All 4x sideways RAM banks 4 - 7 must be
available for use. If you have ROMs
installed internally these may be
occupying sideways RAM banks. You will
need to remove them and check links
LK18 and LK19 are set correcly as per
the Master Reference manual.

PAGE must be at &E00. Type "P.~PAGE"
in BASIC to check your PAGE value.
If this is higher than &E00 then you
may have a ROM installed that is
claiming precious RAM!  Try unplugging
any non-essential ROMS with *UNPLUG.

Co-processors and the Tube must be
disabled. Type *CONF.NOTUBE and reset.

This game has been tested on real
floppy disc hardware, Retroclinic
DataCentre and MAMMFS for MMC devices.

If you experience a crash or other bug
please report this on our GitHub page
along with an emulator save state file
if possible.


RELEASE NOTES
1/3/2019 Version 1.0
Initial release!

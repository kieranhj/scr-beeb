# scr-beeb: start here

Stunt Car Racer for the BBC Master 128: a port of Geoff Crammond's game, rebuilt from a 6502
disassembly of the C64 version, with new BBC graphics, sound and music (Bitshifters, with Tom
Seddon). Released game (v1.1, 2019-03).

| | |
|---|---|
| GitHub | https://github.com/kieranhj/scr-beeb (public); extra remote `kieranhj` = the same URL |
| Upstream | Stunt Car Racer (C64), via Fandal's Atari XE conversion's disassembly |
| Local path | D:\beeb\mine\scr-beeb (moved from OneDrive\BEEB\Repos\scr-beeb on 2026-11-22) |
| Branch | master; others: release-candidate, text-sprites, wip/compress-disc, wip/new_front_end_header (both pushed), and 5 whose remote branch is gone (bug-super-league, hexwab-changes, wip/centre_2MHz_modes, wip/new-track-preview: merged; memory-scribble-fix: not merged, 2019-01) |
| Last commit | 2021-05-31: Fix Makefile on Windows. |

## What's in here
- `scr-beeb.asm` top level; `game/` the game code; `lib/`; `sources/` the disassembly
- `graphics/` PNG art, `data/` mode 7 screens etc., `build/` generated tables and crunched art
- `bin/` Python converters (png2bbc, flames, wheels, track_preview, ...), exomizer.exe, beebasm.exe, snmake
- `doc/`, `reference/`; `Makefile` (Tom's GNU make build), `make.bat` (the older batch build); `scr-beeb.ssd` tracked

## Build and run
- `make`: **blocked**. The Makefile is the right build (Windows-aware: `bin\beebasm.exe`,
  `bin\exomizer.exe`) but its Python tools are **Python 2** (`print '...'`, e.g. bin/track_preview.py);
  this machine has only Python 3. It fails at `python bin/track_preview.py`.
- `make.bat` is also Python 2 (defaults `PYTHON=C:\Home\Python27\python.exe`) and calls
  `..\beebasm\beebasm.exe`, a sibling folder that no longer exists (beebasm is now D:\beeb\third-party\beebasm,
  or D:\beeb\Bin\beebasm.exe).
- To revive: port bin/*.py to Python 3 (mostly print statements), or install Python 2.7 and run
  `make PYTHON=<python2>`. Makefile targets also include `disc_images`, `clean`, and b2 HTTP
  test targets (curl to localhost:48075, needs b2 running).
- Run `scr-beeb.ssd` on a Master 128; keys in README.md.

## Local changes
- None. Clean working tree; no stashes.

## Status and next steps
- Released v1.1 (2019-03-22); 2021 Makefile fix for Windows. No TODO/plan files.
- Branches look abandoned: the four merged ones whose remote is gone can be deleted; memory-scribble-fix
  (unmerged, 2019-01) needs a look first.

## See also
README.md (story, keys, credits).

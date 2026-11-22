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
- `make`: works. The Makefile is the right build; its Python tools in `bin/` were ported to Python 3 on
  2026-11-22. `bin\beebasm.exe` no longer runs (missing DLL), so the Makefile's Windows `BEEBASM` default is
  now `..\..\third-party\beebasm\beebasm.exe` (beebasm 1.11). The rebuilt `build\scr-beeb.ssd` is
  byte-identical to the released v1.1 disc (`bitshifters.github.io\content\bs-scr-beeb.ssd`).
- `make` also writes the tracked top-level `scr-beeb.ssd` (beebasm's intermediate disc). It was stale (2019-03-07) and was
  recommitted from the current source on 2026-11-22, so a clean build leaves it unchanged.
  The `rd`/`mkdir` steps in `disc_images` print errors on Windows (forward slashes); they are ignored and harmless.
- `make.bat` (older batch build) now defaults `PYTHON=py -3` and uses `..\..\third-party\beebasm\beebasm.exe`.
- Makefile targets also include `disc_images`, `clean`, and b2 HTTP test targets (curl to localhost:48075,
  needs b2 running). `sources/*.py` (disassembly tools) were not ported.
- Run `scr-beeb.ssd` on a Master 128; keys in README.md.

## Local changes
- None. Clean working tree; no stashes.

## Status and next steps
- Released v1.1 (2019-03-22); 2021 Makefile fix for Windows. No TODO/plan files.
- Branches look abandoned: the four merged ones whose remote is gone can be deleted; memory-scribble-fix
  (unmerged, 2019-01) needs a look first.

## See also
README.md (story, keys, credits).

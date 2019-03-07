;******************************************************************
; 6502 BBC Micro Compressed VGM (VGC) Music Player
; By Simon Morris
; https://github.com/simondotm/vgm-packer
;******************************************************************


; VGM player supports VGC files that are plain LZ4 or Huffman LZ4 if ENABLE_HUFFMAN is TRUE
; Huffman decoding is variable speed and requires more Zero page, so...
; For optimal performance & memory usage you can disable huffman support.
; (just make sure you compile your VGC files without huffman of course) 
ENABLE_HUFFMAN = TRUE

; Enable this to capture the SN chip register settings (for fx etc.)
ENABLE_VGM_FX = FALSE

;-------------------------------
; workspace/zeropage vars
;-------------------------------

; Declare where VGM player should locate its zero page vars
; VGM player uses:
;  8 zero page vars without huffman
; 19 zero page vars with huffman
;.VGM_ZP SKIP 2 ; must be in zero page 
VGM_ZP = $00  ; SCR ONLY!

; declare zero page registers used for each compressed stream (they are context switched)
lz_zp = VGM_ZP + 0
zp_stream_src   = lz_zp + 0    ; stream data ptr LO/HI          *** ONLY USED 1-2 TIMES PER FRAME ***, not worth ZP?


;-------------------------------------------
; VGM internal routines
; Not user callable.
;-------------------------------------------

; LZ4_FORMAT is a legacy define. May get reactivated if we ever do the full lz4 support
LZ4_FORMAT = FALSE

; HUFFMAN_INLINE is an experimental optimization that inlines huffman/lz fetch_byte routines.
; Not sure its worth it for the huffman code path since it's inherently slower
;  and not likely to be much of a benefit.
HUFFMAN_INLINE = FALSE 



VGM_MUSIC_BPM = 125
VGM_BEATS_PER_PATTERN = 8

VGM_FRAMES_PER_BEAT = 50 * (60.0 / VGM_MUSIC_BPM)
VGM_FRAMES_PER_PATTERN = VGM_FRAMES_PER_BEAT * VGM_BEATS_PER_PATTERN
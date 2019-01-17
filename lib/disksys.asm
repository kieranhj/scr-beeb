; DFS/ADFS Disk op routines
; helpful for streaming, faster loading to SWR etc.
; http://chrisacorns.computinghistory.org.uk/docs/Acorn/Manuals/Acorn_DiscSystemUGI2.pdf
; Our SWR loader is 60% faster than *SRLOAD

.beeb_disksys_start

\*-------------------------------
\*  DISKSYS OSFILE PARAMS
\*-------------------------------

.osfile_params
.osfile_nameaddr
EQUW &FFFF
; file load address
.osfile_loadaddr
EQUD 0
; file exec address
.osfile_execaddr
EQUD 0
; start address or length
.osfile_length
EQUD 0
; end address of attributes
.osfile_endaddr
EQUD 0

;--------------------------------------------------------------
; Load a file from disk to memory (SWR supported)
; Loads in sector granularity so will always write to page aligned address
;--------------------------------------------------------------
; A=memory address MSB (page aligned)
; X=filename address LSB
; Y=filename address MSB
.disksys_load_direct
{
    STA osfile_loadaddr+1

    \ Point to filename
    STX osfile_nameaddr
    STY osfile_nameaddr+1

    \ Ask OSFILE to load our file
	LDX #LO(osfile_params)
	LDY #HI(osfile_params)
	LDA #&FF
    JMP osfile
}

.disksys_load_file
{
    \ Final destination
    STA write_to+1

    \ Where to?
    LDA write_to+1
    BPL load_direct

    \ Load to screen if can't load direct
    LDA #HI(disksys_loadto_addr)

    \ Load the file
    .load_direct
    JSR disksys_load_direct

    \ Do we need to copy it anywhere?
    .write_to
    LDX #&FF
    BPL disksys_copy_block_return

    \ Get filesize 
    LDY osfile_length+1
    LDA osfile_length+0
    BEQ no_extra_page

    INY             ; always copy a whole number of pages
    .no_extra_page

    \ Read from
    LDA #HI(disksys_loadto_addr)
}
\\ Fall through!

; A=read from PAGE, X=write to page, Y=#pages
.disksys_copy_block
{
    STA read_from+2
    STX write_to+2

    \ We always copy a complete number of pages

    LDX #0
    .read_from
    LDA &FF00, X
    .write_to
    STA &FF00, X
    INX
    BNE read_from
    INC read_from+2
    INC write_to+2
    DEY
    BNE read_from
}
.disksys_copy_block_return
    RTS

IF 0        \\ enable when we have PuCrunch
.disksys_decrunch_file
{
    \ Final destination is baked into pu file
    STA unpack_addr+1

    \ Load to screen as can't load direct
    LDA #HI(disksys_loadto_addr)
    JSR disksys_load_direct

    .unpack_addr
    LDA #&00
    LDX #LO(disksys_loadto_addr)
    LDY #HI(disksys_loadto_addr)
    JMP PUCRUNCH_UNPACK
}
ENDIF

.beeb_disksys_end

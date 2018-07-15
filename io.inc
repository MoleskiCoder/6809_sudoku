
;
; Output routines
;

chrout	equ	$a002

; Output a single character contained in A
outchr  jsr	[chrout]
	rts

; Output a string pointed to by X
outstr	pshu	a
1	lda     ,x+
        beq     1f
        bsr     outchr
        bra     1b
1	rts

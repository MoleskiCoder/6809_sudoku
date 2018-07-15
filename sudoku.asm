;
; From: https://see.stanford.edu/materials/icspacs106b/H19-RecBacktrackExamples.pdf
;
; A straightforward port from 6502 to 6809 assembler
;

        org     $3f00

start   jmp	reset

; http://www.telegraph.co.uk/news/science/science-news/9359579/Worlds-hardest-sudoku-can-you-crack-it.html

unassigned	equ	0
board_size	equ	9
cell_count	equ	(board_size * board_size)

	include	"io.inc"

puzzle
	fcb	8, 0, 0, 0, 0, 0, 0, 0, 0
	fcb	0, 0, 3, 6, 0, 0, 0, 0, 0
	fcb	0, 7, 0, 0, 9, 0, 2, 0, 0
	fcb	0, 5, 0, 0, 0, 7, 0, 0, 0
	fcb	0, 0, 0, 0, 4, 5, 7, 0, 0
	fcb	0, 0, 0, 1, 0, 0, 0, 3, 0
	fcb	0, 0, 1, 0, 0, 0, 0, 6, 8
	fcb	0, 0, 8, 5, 0, 0, 0, 1, 0
	fcb	0, 9, 0, 0, 0, 0, 4, 0, 0 


print_board_element
	lda	#' 
	bsr	outchr
	pulu	x
	lda	puzzle,x
	beq	1f
	adca	#'0
	jsr	outchr
	jmp	2f
1	lda	#'-
	jsr	outchr
2	lda	#' 
	jsr	outchr
	rts

print_box_break_vertical
	lda	#'|
	jsr	outchr
	rts

print_box_break_horizontal
	ldx	#1f
	jsr	outstr
	rts
1	fcn	" --------+---------+--------"


cr	equ	$d
lf	equ	$a

print_newline
	lda	#cr
	jsr	outchr
	lda	#lf
	jsr	outchr
	rts


print_board
	jsr	print_newline
	jsr	print_newline

	jsr	print_box_break_horizontal
	jsr	print_newline

	ldy	#0
1
	; loop
	pshu	y
	jsr	print_board_element

	inc	y

	; horizontal box break
	lda	table_move2box_y,y
	bne	2f
	lda	table_move2x,y
	bne	2f
	jsr	print_newline
	jsr	print_box_break_horizontal

2
	; newline only
	lda	table_move2x,y
	bne	3f
	jsr	print_newline
	jmp	4f

3
	; vertical box break
	lda	table_move2box_x,y
	bne	4f
	jsr	print_box_break_vertical

4
	cmpy	#cell_count
	bne	1b
	rts

;
; ** Move and grid position translation methods
;

table_move2x
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8
	fcb 0, 1, 2, 3, 4, 5, 6, 7, 8

table_move2y
	fcb 0, 0, 0, 0, 0, 0, 0, 0, 0
	fcb 1, 1, 1, 1, 1, 1, 1, 1, 1
	fcb 2, 2, 2, 2, 2, 2, 2, 2, 2
	fcb 3, 3, 3, 3, 3, 3, 3, 3, 3
	fcb 4, 4, 4, 4, 4, 4, 4, 4, 4
	fcb 5, 5, 5, 5, 5, 5, 5, 5, 5
	fcb 6, 6, 6, 6, 6, 6, 6, 6, 6
	fcb 7, 7, 7, 7, 7, 7, 7, 7, 7
	fcb 8, 8, 8, 8, 8, 8, 8, 8, 8

table_move2box_x
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2
	fcb 0, 1, 2, 0, 1, 2, 0, 1, 2

table_move2box_y
	fcb 0, 0, 0, 0, 0, 0, 0, 0, 0
	fcb 1, 1, 1, 1, 1, 1, 1, 1, 1
	fcb 2, 2, 2, 2, 2, 2, 2, 2, 2
	fcb 0, 0, 0, 0, 0, 0, 0, 0, 0
	fcb 1, 1, 1, 1, 1, 1, 1, 1, 1
	fcb 2, 2, 2, 2, 2, 2, 2, 2, 2
	fcb 0, 0, 0, 0, 0, 0, 0, 0, 0
	fcb 1, 1, 1, 1, 1, 1, 1, 1, 1
	fcb 2, 2, 2, 2, 2, 2, 2, 2, 2

; ** Row, column and box start positions

table_move2row_start
	fcb 0, 0, 0, 0, 0, 0, 0, 0, 0
	fcb 9, 9, 9, 9, 9, 9, 9, 9, 9
	fcb 18, 18, 18, 18, 18, 18, 18, 18, 18
	fcb 27, 27, 27, 27, 27, 27, 27, 27, 27
	fcb 36, 36, 36, 36, 36, 36, 36, 36, 36
	fcb 45, 45, 45, 45, 45, 45, 45, 45, 45
	fcb 54, 54, 54, 54, 54, 54, 54, 54, 54
	fcb 63, 63, 63, 63, 63, 63, 63, 63, 63
	fcb 72, 72, 72, 72, 72, 72, 72, 72, 72

table_move2box_start
	fcb 0,  0,  0,  3,  3,  3,  6,  6,  6
	fcb 0,  0,  0,  3,  3,  3,  6,  6,  6
	fcb 0,  0,  0,  3,  3,  3,  6,  6,  6
	fcb 27, 27, 27, 30, 30, 30, 33, 33, 33
	fcb 27, 27, 27, 30, 30, 30, 33, 33, 33
	fcb 27, 27, 27, 30, 30, 30, 33, 33, 33
	fcb 54, 54, 54, 57, 57, 57, 60, 60, 60
	fcb 54, 54, 54, 57, 57, 57, 60, 60, 60
	fcb 54, 54, 54, 57, 57, 57, 60, 60, 60

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reset
	jsr print_board
	rts

        end

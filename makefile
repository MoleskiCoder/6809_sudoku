%.bin : %.asm
	asm6809 --verbose --dragondos --listing $(*F).lst --output $(*F).bin $<

all: sudoku.bin

.PHONY : clean

clean :
	rm -fv *.o *.bin *.lst *~ .*~

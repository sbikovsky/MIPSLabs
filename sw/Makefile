CFLAGS =	-O2 -Wall -c -s 

GCC_MIPS       = mips-sde-elf-gcc $(CFLAGS)
AS_MIPS        = mips-sde-elf-as
LD_MIPS        = mips-sde-elf-ld
DUMP_MIPS      = mips-sde-elf-objdump
COPY_MIPS      = mips-sde-elf-objcopy
CONVERT        = python convert.py 512 1024

LIBS =

all:	
	$(AS_MIPS) -o test.o test.asm
	$(LD_MIPS) -Ttext 0x0 -Tdata 0x200 -eentry -o test.axf test.o
	$(DUMP_MIPS) --disassemble test.axf > test.lst
	$(COPY_MIPS) -O verilog -R .text test.axf data.vh
	$(COPY_MIPS) -O verilog -R .data test.axf text.vh
	$(CONVERT)

clean:
	rm -f *.o

CFLAGS =	-O2 -Wall -c -s 

GCC_MIPS     = mips-sde-elf-gcc $(CFLAGS)
AS_MIPS      = mips-sde-elf-as
LD_MIPS      = mips-sde-elf-ld
DUMP_MIPS    = mips-sde-elf-objdump
COPY_MIPS    = mips-sde-elf-objcopy
CONVERT_TEXT = cat text.vh | perl -pe 's/([\dA-F]{2})\s+([\dA-F]{2})\s+([\dA-F]{2})\s+([\dA-F]{2})/$$1$$2$$3$$4/g;' > text.rom
CONVERT_DATA = cat data.vh | perl -pe 's/([\dA-F]{2})\s+([\dA-F]{2})\s+([\dA-F]{2})\s+([\dA-F]{2})/$$1$$2$$3$$4/g;' > data.rom

LIBS =

all:	
	$(AS_MIPS) -o test.o test.asm
	$(LD_MIPS) -Ttext 0x0 -Tdata 0x200 -eentry -o test.axf test.o
	$(DUMP_MIPS) --disassemble test.axf > test.lst
	$(COPY_MIPS) -O verilog -R .text test.axf data.vh
	$(COPY_MIPS) -O verilog -R .data test.axf text.vh
	$(CONVERT_TEXT)
	$(CONVERT_DATA)

clean:
	rm -f *.o

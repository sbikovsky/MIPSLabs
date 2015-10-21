.global entry

.data                  /* data section*/
        .word 0x0001 
        .word 0x0002
        .word 0xFFFF   
.text                  /* code goes to text section*/
.ent entry
entry:
        lw $t0, 0x1000         /* t0 = 1*/
	sw $t0, 0x1002
        lw $t1, 0x1001         /* t1 = 1*/
	lw $t1, 0x1000         /* t0 = 1*/
        add $t0, $t0, $t1     /* t0 = t0 + t1 = 2*/ 
	sw $t0, 0x1200
        add $t0, $t0, 0xB     /* t0 = t0 + 0xB  == 0xD*/
        sub $t0, $t0, $t1     /* t0 = t0 - $t1  == 0xC*/
        or $t0, $t0, 0x10     /* t0 = t0 | 0x10 == 0x1C*/
        xor $t0, $t0, $t1     /* t0 = t0 ^ t1   == 0x1D*/
        slt $t0, $t0, $t1     /* t0 = t0 < t1   == 0*/
        add $t0, $t0, $t1     /* t0 = t0 + t1   == 1*/
        beq $t0, $t1, entry   /* PC = entry if t0 == t1*/
.end entry

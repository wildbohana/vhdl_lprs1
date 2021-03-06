// C code:

/*
const short N = 10;
short a[10] = {14, 32, 14, 28, 31, 32, 25, 10, 2, 30};
short b[10] = {18, 4, 2, 27, 24, 27, 15, 0, 4, 22};
short c[10] = {13, 23, 13, 2, -5, 10, -3, 4, 2, 9};
void main() {
	short* pa; short* pb; short* pc; short* pae; short* pce; short e;
	for(pb = b, pc = c, pa = a+N-1, pbe = b+N; pb != pbe; pb++, pc++, pa--)
		*pa = *pb | *pc;
	for(pa = a+N-1, e = 0x0000, pae = a-1; pa != pae; pa--)
		if(*pa < e)
			e = *pa;
}	
*/


// Assembly code

	.data
	10						// n = 10
	14, 32, 14, 28, 31, 32, 25, 10,  2, 30		// niz a
	18,  4,  2, 27, 24, 27, 15,  0,  4, 22		// niz b
	13, 23, 13,  2, -5, 10, -3,  4,  2,  9		// niz c

.text
main:
	ld R7, R0			// n = 10

// Prva for petlja
prep_for_1:				// pa, pb, pbe, pc
	inc R0, R0			// a[0]
	add R0, R0, R7			// a+n (b)
	mov R1, R0			// *pb = a+n	<-- R1 - pb
	dec R0, R0			// *pa = a+n-1	<-- R0 - pa
	add R2, R1, R7			// *pbe = b+n	<-- R2 - pbe
	mov R3, R2			// *pc = b+n	<-- R3 - pc

for_1_check:
	sub R4, R2, R1			// pbe - pb
	jmpz prep_for_2			// zavrsili smo sa prvom for petljom

for_1:
	ld R5, R1			// dereferenciranje
	ld R6, R3			// dereferenciranje

	or R7, R5, R6
	st R7, R0			// smestanje u niz a

	inc R3, R3			// pc++
	inc R1, R1			// pb++
	dec R0, R0			// pa--
	jmp for_1_check


// Druga for petlja
prep_for_2:				// pa, pae, e
	sub R0, R0, R0
	ld R7, R0			// n = 10

	mov R2, R0			// *pae = a-1	<-- R2 - pae
	add R1, R2, R7			// *pa = a-1+n	<-- R1 - pa	
	sub R3, R3, R3			// e = 0x0000	<-- R3 - e

	for_2_check:
	sub R7, R1, R2			// pae - pa
	jmpz end

for_2:
	ld R4, R1			// dereferenciranje
	sub R5, R1, R3			// pa < e ?
	jmps for_2_dodela
	jmp for_2_dec

for_2_dodela:
	mov R3, R4			// smesti pa u e

for_2_dec:
	dec R1, R1			// pa--
	jmp for_2_check

end:
	jmp end				// beskonačna petlja na kraju

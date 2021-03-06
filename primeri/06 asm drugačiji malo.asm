/*
.data
	short* p_result		= 0x1A;
	short* p_done		= 0x20;
	short N = 5;
	short a[5] = {-1, -2, -3, -4,  6};
*/

.data
	0x1A
	0x20
	5
	-1, -2, -3, -4, 6

/*
.text
	short res = 0;
	short pow = 0;
	
	pow = 2^N;
	
	for(int i = 0; i<N; i++)
	{
		res += a[i];
	}
	res += pow;
	res /= 4;
	
	*p_result = res;
	*p_done = 1;
*/

.text
/*
	Recommended register list:
	R0 - res
	R1 - pow
	R2 - N
	R3 - a[i]
	R4 - p_result
	R5 - p_done
	R6 - tmp
	R7 - tmp
*/
begin:
	ld  R4, R3		// p_result -> R4
	inc R3, R3
	ld  R5, R3		// p_done -> R5
	inc R3, R3
	ld  R2, R3		// N -> R2
	inc R3, R3		// a[i] -> R3


pow_prep:
	inc R1, R1		// R1 = 1 -> sad šift ulevo
	mov R6, R2		// temp za N -> R6
	inc R6, R6		// štimanje da valja

pow_check:
	dec R6, R6
	jmpz for_prep

pow_shl:
	shl R1, R1
	jmp pow_check



for_prep:
	sub R7, R7, R7		// i = 0
	sub R6, R6, R6		// za proveru kraja, za očitavanje a[i]

for_check:
	sub R6, R7, R2
	jmpz zbir

for_deref:
	ld R6, R3

for_add:
	add R0, R0, R6

for_inc:
	inc R7, R7
	inc R3, R3
	jmp for_check


zbir:
	add R0, R0, R1

deljenje:
	ashr R0, R0
	ashr R0, R0


jedinica:
	sub R7, R7, R7
	inc R7, R7

cuvanje:
	st R0, R4
	st R7, R5
	
end:
	jmp end

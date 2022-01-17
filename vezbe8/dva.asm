/*
Nizovi: vrednost < indeks
Napisati program u asemblerskom jeziku koji pronalazi sve elemente niza od N elemenata čija je vrednost manja od njihovog rednog broja (indeksa).
Elemente niza a koji zadovoljavaju uslov upisati u novi niz b u memoriji za podatke počevši od adrese 0x16.

short N = 10
short a[N] = { 65, 0, 6, -1, 23, 76, 1, -2, 65, 3};
int j = 0x16;
for (short i = 0; i < N; i++)
	if(a[i] < i)
	{
		b[j] = a[i];
		j++;
	}
*/

.data
    10                                      // n = 10
    0x16									// početna adresa za niz b
    65, 0, 6, -1, 23, 76, 1, -2, 65, 3      // niz a
    // novi niz: 0, -1, 1, -2, 3
.text

begin:
    ld  R7, R0                              // N = 10
    dec R7, R7                              // R7 = 9

    inc R0, R0                              // j = 0x16 (22)
    ld  R6, R0                              // R6 = 0x16

    sub R5, R5, R5                          // R5 = 0 (i = 0)
    inc R0, R0								// početak niza a
for:
    sub R3, R7, R5							// N-i ??
    jmps end								// ako ode ispod 0 onda smo prošli ceo niz
    
    ld  R1, R0                              // i-ti element u nizu
    sub R2, R1, R5                          // R2 = niz[i] - i	(R1 - R5)
    jmps upisUNoviNiz						// ako je redni broj niza veći od vrednosti na toj adresi, onda će biti negativna vrednost
    jmp inkrement

inkrement:
    inc R0, R0                              // sledeci element
    inc R5, R5                              // i++
    jmp for

upisUNoviNiz:
    st  R1, R6                              // novi[j] = niz[i] 
    inc R6, R6
    jmp inkrement

end:
    jmp end

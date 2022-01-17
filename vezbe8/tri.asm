// Zadatak 3
// Obrtanje niza od 10 elemenata

.data
    10 				// N = 10
    15, 12, 6, 33, 23, 76, 1, -5, 65, 7
.text

/*
R0 - i - index niza koji se čita od početka
R1 - j - index niza koji se čita od nazad
R2 - temp sa pocetka
R3 - temp sa kraja
*/

begin:
    ld R1, R0 		// R1 = N = j = 10
    inc R0, R0 		// R0 sada ima adresu prvog elementa niza

end_test:
    sub R7, R1, R0 	// i < j
    jmps end

zamena:
    ld R2, R0 		// R2 = a[i]
    ld R3, R1 		// R3 = a[j]
    st R3, R0 		// a[i] = R3
    st R2, R1 		// a[j] = R2

sledeci:
    inc R0, R0 		// i++
    dec R1, R1 		// j--
    jmp end_test

end:
    jmp end 		// Beskonačna petlja za kraj

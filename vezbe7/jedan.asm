/*
Umetanje elementa u niz u memoriji
Napisati program u asemblerskom jeziku koji u zadati niz od N elemenata izvršava umetanje broja 0xFFFF na zadatu poziciju k (0 < k < N-1). Poziciju zadati u memoriji za podatke.
Voditi računa o poziciji elemenata niza u memoriji za podatke!
*/

.data
    10                                      // n = 10
    5                                       // k = 5 (pozicija)
    0xFFFF                                  // broj za umetanje
    -8, 12, 6, 33, 23, 76, 1, -5, 65, 7     // niz
.text

begin:
    ld R7, R0                               // N  = 10, R0 ima vrednost 0 i zbog toga učitavamo prvi podatak iz .data
    dec R7, R7                              // N  = 9 -> zašto se ovo smanjuje? jer se ne sme smestiti na poslednju lokaciju u nizu ili šta?

    inc R0, R0                              // k  = 5 
    ld  R6, R0                              // R6 = 5 -> sada R0 ima vrednost 1 tj sada ćemo učitavati drugi podatak iz .data
    dec R6, R6                              // R6 = 4
    shl R6, R6                              // shl je Rx * 2 (R6 = 8)
    dec R6, R6                              // 7

    inc R0, R0                              // pokazuje na broj za umetanje, R0 ima vrednost 2
    ld R5,  R0                              // R5 = 0xFFFF

    inc R0, R0                              // pokazuje prvi element niza, R0 ima vrednost 3
    add R0, R0, R7                          // R0 = niz[N - 2], 
    inc R0, R0                              // mem[12] -> adresa poslednjeg elementa u nizu
    mov  R1, R0                             // R1 = niz[N - 1]
    inc R0, R0                              // mem[13] -> prva adresa posle kraja niza
    
    add R7, R7, R6                          // indeks = 9 + 7
    dec R7, R7                              // 15
    dec R7, R7                              // 14
    dec R7, R7                              // 13

for:
    sub R4, R7, R6                          // R4 = R7 - R6 (i - k)
    jmpz umetanje                           // pomereni su svi koji trebaju, izvrsiti umetanje
    mov R0, R1                              // niz[i + 1] = niz[i]
    dec R7, R7                              // i--
    dec R0, R0                              // niz[N - i]
    dec R1, R1                              // niz[N - 1 - i]
    jmp for

umetanje:
    st  R5, R0                              // niz[k - 1] = 0xFFFF 
    jmp end

end:
    jmp end

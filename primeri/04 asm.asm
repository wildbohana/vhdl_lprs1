// Podaci koje učitavamo u toku zadatka
.data
10

// Sam zadatak -> main i ostalo
.text
main:
// R0 pokazuje na početak .data memorije, njega i ld koristimo da smeštamo podatke u registre
// R0 se u glavnom koristi kao pokazivač na memoriju (sad da li je to ovde stek, nemam pojma tbh)

memorija:
  ld  R1, R0		  // Učitavamo podatak iz adrese u R0 u R1
  mov R2, R1		  // Prebacuje sadržaj iz R1 u R2
  st  R2, R0		  // Smešta podatak iz R2 na adresu u R0

aritmetika:
  add R5, R3, R4	// R3 + R4 -> smesti ih u R5
  sub R5, R3, R4	// R3 - R4 -> smesti ih u R5

logika:
  and R5, R3, R4	// R3 & R4 -> smesti ih u R5
  or  R5, R3, R4	// R3 | R4 -> smesti ih u R5
  not R7, R6		  // not(R6) -> smesti ga u R7

incdec:
  inc R7, R6		  // R6++ -> smesti ga u R7
  dec R7, R6		  // R6-- -> smesti ga u R7

pomeranje:
  shl R7, R6		  // Logički R6<< -> smesti ga u R7
  shr R7, R6		  // Logički R6>> -> smesti ga u R7
  ashl R7, R6		  // Aritm.  R6<< -> smesti ga u R7
  ashr R7, R6		  // Aritm.  R6>> -> smesti ga u R7

skokovi:
  jmp   main		  // Skok - bezuslovni
  jmpz  main		  // Skok - ako je Zero
  jmps  main		  // Skok - ako je Sign
  jmpc  main		  // Skok - ako je Carry
  jmpnz main		  // Skok - ako NijeZero
  jmpns main		  // Skok - ako NijeSign
  jmpnc main		  // Skok - ako NijeCarry

kraj:
  jmp kraj		    // Beskonačna petlja za kraj

.data
ciag: .space 1024
tablica_slow: .space 1024
tablica_wystapien: .space 1024
podaj_stringa: .asciiz "Podaj ciag znakow \n"
blad_info: .asciiz "Podano zla wartosc \n"
enter: .asciiz "\n"
spacja: .asciiz " "
.text

.macro printString(%value)              
li $v0,4                
la $a0,%value
syscall                 
.end_macro 

.macro printInt(%value)              
move $a0,%value                
li $v0,1                
syscall                 
.end_macro 

main:
printString(podaj_stringa)
li $v0,8
la $a0,ciag
li $a1,1024
syscall

la $a0,ciag
la $a1,tablica_slow
sw $a0,0($a1)

podzial:
lb $t0,0($a0)
beq $t0,32,nowe_slowo
beq $t0,10,wypisz
blt $t0,65,blad 
bgt $t0,122,blad
blt $t0,97,moze_blad

kolejny_znak:
add $a0, $a0, 1
j podzial

moze_blad:
bgt $t0,90,blad 
j kolejny_znak

nowe_slowo:
sb $zero,0($a0)	
addi $a0,$a0,1	
addi $a1,$a1,4	
sw $a0,0($a1)
j podzial

wypisz:
sb $zero, 0($a0)
la $v0,1($a1)
move $a1, $v0
la $a0, tablica_slow
move $t3,$a0
move $t4,$a0
move $t7,$t4
move $t1,$a1

wypisywanie_petle:
move $t5, $zero
move $t4,$t7

wypisywanie_petle2:
lw $s7,0($t3)
lw $s1, 0($t4)
addi $t4,$t4,4
move $t9,$zero

loop:
lb $t6,0($s1)
lb $t8,0($s7)
blt $t6,95,zabezpieczenie
subi $t6,$t6,32

zabezpieczenie:
blt $t8,95,zabezpieczenie2
subi $t8,$t8,32

zabezpieczenie2:
bne $t6,$t8,spr_czy_koniec
addi $s1,$s1,1
addi $s7,$s7,1
bne $t6,$zero, loop
bne $t8,$zero, loop
ble $t4,$t3, jak_slowo_juz_bylo
addi $t5,$t5,1

spr_czy_koniec:
blt $t4,$t1,wypisywanie_petle2
li $v0,4
lw $a0,0($t3)
syscall	

printString(spacja)
printInt($t5)
printString(enter)
jak_slowo_juz_bylo:
addi $t3,$t3,4
blt $t3,$t1,wypisywanie_petle
j koniec

blad:
printString(blad_info)

koniec:
li $v0,10
syscall
main:la $a0, array_base 
la $a1, array_size 
jal BubbleSort
exit: j exit
BubbleSort:addi $sp, $sp, -20
sw $ra, 0($sp)
sw $s0, 4($sp)
sw $s1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
move $s0, $a0
lw $s1, 0($a1)
addi $s2, $zero, 0
OuterLoop:
addi $t1, $s1, -1
slt $t0, $s2, $t1
beq $t0, $zero, EndOuterLoop
addi $s3, $zero, 0
InnerLoop:
addi $t1, $s1, -1
sub $t1, $t1, $s2
slt $t0, $s3, $t1
beq $t0, $zero, EndInnerLoop
sll $t4, $s3, 2
add $t5, $s0, $t4
lw $t2, 0($t5)
addi $t6, $t5, 4
lw $t3, 0($t6)
sgt $t0, $t2, $t3
beq $t0, $zero, NotGreater
move $a0, $s0
move $a1, $s3
addi $t0, $s3, 1
move $a2, $t0
jal Swap # t5 is &data[j], t6 is &data[j=1]
NotGreater:
addi $s3, $s3, 1
j InnerLoop
EndInnerLoop:
addi $s2, $s2, 1
j OuterLoop
EndOuterLoop:
lw $ra, 0($sp) 
lw $s0, 4($sp)
lw $s1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
addi $sp, $sp, 20
jr $ra
Swap:sll $t0, $a1, 2
add $t0, $a0, $t0
sll $t1, $a2, 2
add $t1, $a0, $t1
lw $t2, 0($t0)
lw $t3, 0($t1)
sw $t2, 0($t1)
sw $t3, 0($t0)
jr $ra
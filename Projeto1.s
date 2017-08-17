.data
 # user program data
	msg1:		.asciiz "\nDigite a data da despesa: "
	msg2:		.asciiz "\nDefina a categoria da despesa: "
	msg3:		.asciiz "\nDigite o valor da despesa: "
	msg4:		.asciiz "\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n"
	msg5:		.asciiz "\nDigite o id da despeza: "
	msg6:		.asciiz	"\nDespezas: "
	msg7:		.asciiz "\nGasto mensal: "
	msg8:		.asciiz "\nCategoria: "
	msg9:		.asciiz "\nRanking: "
	id:		.byte 	1
	despesaArray:	.space 1200 #armazena atÃ© 40 espaÃ§os de 30 bytes
	#despesaArray precisa armazenar id (1 byte), data (8 numeros, 7 bytes), categoria (16 bytes), valor (.float, 4 bytes), TOTAL = 28 bytes

.text 			
.globl main 	#starting point: must be global
main:
		
		
menu1:	addi	$v0,$zero,4		#printa mensagem
	la	$a0,msg4
	syscall
	
	li	$v0,5			#pega inteiro da opção
	syscall
	add	$s0,$v0,$zero
#=================================================================
#------------------Comparações da opção---------------------------
#=================================================================	
	addi	$t0,$zero,1
	beq	$v0,$t0,op1
	
	addi	$t0,$zero,2
	beq	$v0,$t0,op2
	
	addi	$t0,$zero,3
	beq	$v0,$t0,op3
	
	addi	$t0,$zero,4
	beq	$v0,$t0,op4
	
	addi	$t0,$zero,5
	beq	$v0,$t0,op5
	
	addi	$t0,$zero,6
	beq	$v0,$t0,op6
	
	
#=================================================================
#-----------------------Opções------------------------------------
#=================================================================	
	
op1:	addi	$v0,$zero,4
	la	$a0,msg2
	syscall
	#codigo
	xor	$v0,$v0,$v0
	li	$v0,5
	syscall
	j	menu1
	

op2:	addi	$v0,$zero,4
	la	$a0,msg5
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

op3:	addi	$v0,$zero,4
	la	$a0,msg6
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

op4:	addi	$v0,$zero,4
	la	$a0,msg7
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

op5:	addi	$v0,$zero,4
	la	$a0,msg8
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

op6:	addi	$v0,$zero,4
	la	$a0,msg9
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1
	

# user program code
	

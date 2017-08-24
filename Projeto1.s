.data
 # user program data
	msg1:		.asciiz 	"\nDigite a data (dd/mm/aaaa) da despesa: "
	msg2:		.asciiz 	"\nDefina a categoria da despesa: "
	msg3:		.asciiz 	"\nDigite o valor da despesa: "
	msg4:		.asciiz 	"\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n"
	msg5:		.asciiz 	"\nDigite o id da despeza: "
	msg6:		.asciiz		"\nDespezas: "
	msg7:		.asciiz 	"\nGasto mensal: "
	msg8:		.asciiz 	"\nCategoria: "
	msg9:		.asciiz 	"\nRanking: "
	id:		.byte 	0
	despesaArray:	.space 	6144  	#armazena atÃ© 256 espaÃ§os de 24 bytes
	arrayPointer:	.word	0	#armazena a posição do ultimo dado no array
	#despesaArray precisa armazenar id (1 byte), data (6 numeros, 3 bytes), categoria (16 bytes), valor (.float, 4 bytes), TOTAL = 24 bytes

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
	
op1:	
	#codigo
	la	$t0, arrayPointer
	lw	$s0, 0($t0)	#valor do arrayPointer em $s0
	addi 	$s0, $s0, -24 	#24 bytes
	la	$t0, id
	lb 	$s1, 0($t0)	#valor do id em $s1
	sb 	$s1, 0($s0) 	#byte 0 das despesas recebe id (1 byte)
	addi	$s1, $s1,1	#valor do id = id + 1
	sw	$s1, 0($t0)	#guarda id atualizado na variavel id
	addi	$s0, $s0,1	#arrayPointer = arrayPointer + 1
	
	
	#chamada para receber a data (3 bytes)
	addi	$v0, $zero,4	#
	la	$a0, msg1	#Mensagem para digitar data
	syscall			#
	
	addi	$v0, $zero,5	#codigo para ler inteiros
	syscall
	add	$s1, $zero,$v0	#valor do dia em $s1
	
	addi	$v0, $zero,12
	syscall
	
	addi	$v0, $zero,5	#codigo para ler inteiros
	syscall
	add	$s2, $zero,$v0	#valor do mes em $s2
	
	
	#chamada para receber categoria (16 bytes)
	addi	$v0,$zero,4
	la	$a0,msg2
	syscall
	#chamada para receber valor (float)
	addi	$v0,$zero,4
	la	$a0,msg3
	syscall
	
	li	$v0,5 #temporÃ¡rio
	syscall
	j	menu1

#---------------------Operação 1----------------------------------	

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
	

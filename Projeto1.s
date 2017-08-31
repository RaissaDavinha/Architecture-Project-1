#BRUNO ITENS 1 E 4
#RAFAEL ITENS 2 E 5
#RAISSA ITENS 3 E 6
.data
 # user program data
	despesaArray:		.space 	6144  	#armazena atÃ© 256 espaÃ§os de 24 bytes
	msg1:				.asciiz 	"\nDigite a data (dd/mm/aaaa) da despesa: "
	msg2:				.asciiz 	"\nDefina a categoria da despesa: "
	msg3:				.asciiz 	"\nDigite o valor da despesa: "
	msg_cadastro:		.asciiz 	"\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n7-sair \n"
	msg5:				.asciiz 	"\nDigite o id da despeza: "
	msg6:				.asciiz		"\nDespezas: "
	msg7:				.asciiz 	"\nGasto mensal: "
	msg8:				.asciiz 	"\nCategoria: "
	msg9:				.asciiz 	"\nRanking: "
	msg_erro:			.asciiz "Erro! O numero que foi selecionado nao e valido!\n"
	arrayPointer:		.word	0	#armazena a posição do ultimo dado no array
	id:					.byte 	0
	#despesaArray precisa armazenar id (1 byte), data (6 numeros, 3 bytes), categoria (16 bytes), valor (.float, 4 bytes), TOTAL = 24 bytes

.text 			
.globl main
main:
	la $t0, despesaArray				#Inicializacao do vetor. Ela sera encontrada o programa inteiro em $t0.
	add $s0,$zero, $zero						#Inicializacao de $s3 como 0. Este sera o contador de quantos cadastros foram feitos.
	sw $s0, 0($t0)			#Definindo o primeiro espaco como "disponivel".	
		
menu1:	
	addi	$v0,$zero,4		#printa mensagem
	la	$a0,msg_cadastro
	syscall
	
	li	$v0,5				#pega inteiro da opção
	syscall
	add	$s0,$v0,$zero

	beq	$v0, 1, registrar			#Se igual.
	beq	$v0, 2, excluir
	beq	$v0, 3, listar_despesas
	beq	$v0, 4, exibir_gastos
	beq	$v0, 5, exibir_p_categoria
	beq	$v0, 6, ranking
	beq	$v0, 7, sair

	la $a0, msg_erro		#Caso o usuario digite um numero invalido
	li $v0, 4
	syscall
	j menu1
	
	
#=================================================================
#-----------------------Opções------------------------------------
#=================================================================	
	
registrar:	
#1) Registrar despesa: registrar dados de uma despesa, contendo no mÃ­nimo informaÃ§Ãµes
#como data (dia, mÃªs e ano em formato numÃ©rico), categoria (tipo de despesa definido pelo
#usuÃ¡rio com atÃ© 15 caracteres) e valor gasto em reais. Cada despesa registrada deve possuir
#um campo id (identificador numÃ©rico Ãºnico), iniciado com o valor 1 e incrementado de forma
#automÃ¡tica a cada nova despesa registrada. 
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
	
	sb $s1, 0($t0)		#salva dia
	addi	$s0, $s0,1	#arrayPointer = arrayPointer + 1
	
	addi	$v0, $zero,5	#codigo para ler inteiros
	syscall
	add	$s2, $zero,$v0	#valor do mes em $s2
	
	sb $s2, 0($t0)		#salva mes
	addi	$s0, $s0,1	#arrayPointer = arrayPointer + 1
	
	addi	$v0, $zero,5	#codigo para ler inteiros
	syscall
	add	$s3, $zero,$v0	#valor do ano em $s3
	
	sb $s3, 0($t0)		#salva ano
	addi	$s0, $s0,1	#arrayPointer = arrayPointer + 1
	
	
		########## TESTES ##########
		addi $v0, $zero, 1	#print dia
		add $a0, $s1, $zero
		syscall
		
		li $a0, '/'		#print /
		li $v0, 11
		syscall
	
		addi $v0, $zero, 1	#print mes	
		add $a0, $s2, $zero
		syscall
		
		li $a0, '/'		#print /
		li $v0, 11
		syscall
	
		addi $v0, $zero, 1	#print ano
		add $a0, $s3, $zero
		syscall
		###########################
	
	#chamada para receber categoria (16 bytes)
	addi	$v0,$zero,4
	la	$a0,msg2
	syscall
	
	addi	$v0, $zero, 8	#codigo para ler string
	la	$a0, 16
	add	$t0, $zero, $v0	#categoria em $t0
	syscall
	
		
		######## TESTE ########
         	move $a0,$t0 # primary address = t0 address (load pointer)
         	li $v0,4 # print string
         	syscall
	
	#chamada para receber valor (float)
	addi	$v0,$zero,4
	la	$a0,msg3
	syscall
	
	li	$v0,5 #temporÃ¡rio
	syscall
	j	menu1

#---------------------Operação 1----------------------------------	

excluir:
#2) Excluir despesa: excluir dados de uma despesa identificada pelo id informado pelo usuÃ¡rio
	addi	$v0,$zero,4
	la	$a0,msg5
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

listar_despesas:
#3) Listar despesas: exibir dados de todas as despesas cadastradas (ordenadas por data)
	addi	$v0,$zero,4
	la	$a0,msg6
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

exibir_gastos:
#4) Exibir gasto mensal: com base nos dados de todas as despesas registradas, exibir o valor
#total dos gastos em cada mÃªs
	addi	$v0,$zero,4
	la	$a0,msg7
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

exibir_p_categoria:
#5) Exibir gasto por categoria: com base nos dados de todas as despesas registradas, exibir o
#valor total dos gastos por categoria, organizadas em ordem alfabÃ©tica
	addi	$v0,$zero,4
	la	$a0,msg8
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1

ranking:
#6) Exibir ranking de despesas: com base nos dados de todas as despesas registradas, exibir
#o valor total dos gastos em cada categoria, ordenados de forma decrescente pelo valor
	addi	$v0,$zero,4
	la	$a0,msg9
	syscall
	#codigo
	xor	$v0,$v0,$v0
	addi	$v0,$zero,12
	syscall
	j	menu1
	

# user program code
sair:

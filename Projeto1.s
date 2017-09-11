#BRUNO ITENS 1 E 4
#RAFAEL ITENS 2 E 5
#RAISSA ITENS 3 E 6
.data
 # user program data
	inicioArray:	.space 		5600  	#armazena 200 espacos de 28 bytes
	arrayPointer:	.word		0	#armazena a posicao do ultimo dado no array
	msg_reg1:	.asciiz 	"\nDigite a dia da despesa: "
	msg_reg2:	.asciiz		"\nDigite o mes da despesa: "
	msg_reg3:	.asciiz		"\nDigite o ano da despeza: "
	msg_reg4:	.asciiz 	"\nDefina a categoria da despesa: "
	msg_reg5:	.asciiz 	"\nDigite o valor da despesa: "
	msg_reg6:	.asciiz		"\nDespesa registrada com sucesso!\nAperte qualquer tecla para voltar ao menu.\n"
	msg_menu1:	.asciiz 	"\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n7-sair \n"
	msg_menu2:	.asciiz 	"\nErro! O numero que foi selecionado nao e valido!\n"
	msg_despeza:	.asciiz		"\nDespezas: "
	msg_gasto:	.asciiz 	"\nGasto mensal: "
	msg_categoria:	.asciiz 	"\nCategoria: "
	msg_ranking:	.asciiz 	"\nRanking: "
	msg_data:	.asciiz		"\nData:"
	msg_id:		.asciiz		"\nId:"
	id:		.byte 		1
	#inicioArray precisa armazenar id  (1 byte), data  (6 numeros, 3 bytes), categoria  (16 bytes), valor  (.float, 4 bytes), TOTAL = 24 bytes

.text 			
.globl main
main:
	la 	$s0, inicioArray	#Inicializacao do vetor. Ela sera encontrada o programa inteiro em $t0.
	la 	$s1, arrayPointer	#endereco do arrayPointer em $s1
	sw	$s0, 0  ($s1)		#arraypointer = inicioArray pois nao ha nenhuma despesa ainda.
	add	$s1, $s0, $zero		#arrayPointer em $s1 e inicioArray em $s0		
		
menu1:	
	addi	$v0, $zero, 4		#printa mensagem
	la	$a0, msg_menu1
	syscall
	
	addi	$v0, $zero, 5			#pega inteiro da opÃ¨Â¤Â¯
	syscall

	beq	$v0, 1, registrar	#Se igual.
	beq	$v0, 2, excluir
	beq	$v0, 3, listar_despesas
	beq	$v0, 4, exibir_gastos
	beq	$v0, 5, exibir_p_categoria
	beq	$v0, 6, ranking
	beq	$v0, 7, sair

	la 	$a0, msg_menu2		#Caso o usuario digite um numero invalido
	addi 	$v0, $zero, 4
	syscall
	j 	menu1
	
	
#=================================================================
#-----------------------Operacao 1--------------------------------
#=================================================================	
	
registrar:	
#1) Registrar despesa: registrar dados de uma despesa, contendo no minimo informacoes
#como data  (dia, mes e ano em formato numerico), categoria  (tipo de despesa definido pelo
#usuario com ate 15 caracteres) e valor gasto em reais. Cada despesa registrada deve possuir
#um campo id  (identificador numerico unico), iniciado com o valor 1 e incrementado de forma
#automatica a cada nova despesa registrada.

#----------------------------Inicio-------------------------------

	addi	$s1, $s1, -28	#array pointer abre espaco para 28 bytes  (1 despesa)


	la	$t0, id		#endereco do id -> $t0
	lw	$t1, 0 ($t0)	#conteudo do id -> $t1
	sw	$t1, 0 ($s1)	#guarda id da despesa nos primeiros 4 bytes
	addi	$t1, $t1, 1	#incrementa id para proxima despesa
	sw	$t1, 0 ($t0)	#guarda id atualizado

#----------------------------Dia----------------------------------		

	la	$a0, msg_reg1	#mensagem de pegar dia
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 5
	syscall
	sb	$v0, 7 ($s1)	#guardar dia no array
	
#----------------------------Mes----------------------------------	
	
	la	$a0, msg_reg2	#mesagem de pegar mes
	addi	$v0, $zero 4
	syscall
	
	addi	$v0, $zero, 5
	syscall
	sb	$v0, 6, ($s1)	#guardar mes no array
	
#----------------------------Ano----------------------------------	
	
	la	$a0, msg_reg3	#mesagem de pegar ano
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 5
	syscall
	sh	$v0, 4, ($s1)	#guardar dia no array
	
#---------------------------Categoria-----------------------------	
	
	la	$a0, msg_reg4	#mesagem de pegar categoria
	addi	$v0, $zero, 4
	syscall
	
	addi	$a0, $s1, 8	#endereco do local aonde a string sera gravada
	addi	$a1, $zero, 16	#numero maximo de caracteres para ler
	addi	$v0, $zero, 8	#codigo da interrupcao
	syscall			#ler string
	
#---------------------------Valor---------------------------------	

	la	$a0, msg_reg5	#mesagem de pegar valor
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 6	#codigo de ler float
	syscall

	s.s	$f0, 24, ($s1)	#guarda valor no array

#---------------------------Fim------------------------------------	

	la	$a0, msg_reg6	#mensagem de registro com sucesso
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 12	#para programa ate proxima tecla ser pressionada
	syscall

	j	menu1

#=================================================================
#-----------------------Operacao 2--------------------------------
#=================================================================	

excluir:
#2) Excluir despesa: excluir dados de uma despesa identificada pelo id informado pelo usuario

#=================================================================
#-----------------------Operacao 3--------------------------------
#=================================================================	


listar_despesas:
#3) Listar despesas: exibir dados de todas as despesas cadastradas  (ordenadas por data)

	lw	$a0, 0 ($s1)
	addi	$v0, $zero, 1
	syscall
	
	lh	$a0, 4 ($s1)
	syscall

	lb	$a0, 6 ($s1)
	syscall
	
	lb	$a0, 7 ($s1)
	syscall

	addi	$a0, $s1, 8
	addi	$v0, $zero, 4
	syscall
	
	l.s	$f12, 24 ($s1)
	addi	$v0, $zero, 2
	syscall

	j	menu1

#=================================================================
#-----------------------Operacao 4--------------------------------
#=================================================================	


exibir_gastos:
#4) Exibir gasto mensal: com base nos dados de todas as despesas registradas, exibir o valor
#total dos gastos em cada mes


#=================================================================
#-----------------------Operacao 5--------------------------------
#=================================================================	


exibir_p_categoria:
#5) Exibir gasto por categoria: com base nos dados de todas as despesas registradas, exibir o
#valor total dos gastos por categoria, organizadas em ordem alfabÃƒÂ©tica

#=================================================================
#-----------------------Operacao 6--------------------------------
#=================================================================	


ranking:
#6) Exibir ranking de despesas: com base nos dados de todas as despesas registradas, exibir
#o valor total dos gastos em cada categoria, ordenados de forma decrescente pelo valor

#---------------------------------------------------------------------------------------------------#
sair:
	li $v0, 10						#Codigo para encerrar o programa
	syscall

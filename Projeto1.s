#--------OBSERVACOES E ATUALIZACOES------------------------------
#	BRUNO ITENS 2 E 4
#	RAFAEL ITENS 1 E 5
#	RAISSA ITENS 3 E 6
#
#	Mudar item 1 para receber e ordenar por data
#	Itens que cada um vai fazer foimodificado
#	Registradores com endereço do ArrayPointer e do valor do ArayPointer foram modificados
#
#----------------------------------------------------------------
.data
 # user program data
 	dynamicArray:	.space		5600	#armazenamento dinamico para sorts
	inicioArray:	.space 		5600  	#armazena 200 espacos de 28 bytes
	arrayPointer:	.word		0	#armazena a posicao do ultimo dado no array
	msg_reg1:	.asciiz 	"\nDigite a dia da despesa: "
	msg_reg2:	.asciiz		"\nDigite o mes da despesa: "
	msg_reg3:	.asciiz		"\nDigite o ano da despeza: "
	msg_reg4:	.asciiz 	"\nDefina a categoria da despesa: "
	msg_reg5:	.asciiz 	"\nDigite o valor da despesa: "
	msg_reg6:	.asciiz		"\nDespesa registrada com sucesso!\nAperte qualquer tecla para voltar ao menu.\n"
	msg_reg7:	.asciiz		"\nAperte qualquer tecla para voltar ao menu.\n"
	msg_menu1:	.asciiz 	"\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n7-sair \n"
	msg_menu2:	.asciiz 	"\nErro! O numero que foi selecionado nao e valido!\n"
	msg_despeza:	.asciiz		"\nDespezas: "
	msg_gasto:	.asciiz 	"\nGasto mensal: "
	msg_categoria:	.asciiz 	" | Categoria: "
	msg_ranking:	.asciiz 	"\nRanking: "
	msg_data:	.asciiz		" | Data:"
	msg_id:		.asciiz		"\nId:"
	msg_valor:	.asciiz		" | Valor: "
	barra:		.asciiz 	"/"
	id:		.word		0
	#inicioArray precisa armazenar id  (4 bytes), data  (6 numeros, 4 bytes), categoria  (16 bytes), valor  (.float, 4 bytes), TOTAL = 28 bytes

.text 			
.globl main
main:	
	#$s0 = endereÃ§o array pointer
	#$s1 = condteudo array pointer
	la 	$s1, inicioArray	#Inicializacao do vetor. Ela sera encontrada o programa inteiro em $t0.
	la 	$s0, arrayPointer	#endereco do arrayPointer em $s1
	sw	$s1, 0  ($s0)		#arraypointer = inicioArray pois nao ha nenhuma despesa ainda.
		
menu1:	
	addi	$v0, $zero, 4		#printa mensagem
	la	$a0, msg_menu1
	syscall
	
	addi	$v0, $zero, 5		#pega inteiro da opÃƒÆ’Ã‚Â¨Ãƒâ€šÃ‚Â¤Ãƒâ€šÃ‚Â¯
	syscall

	beq	$v0, 1, registrar	#Se igual.
	beq	$v0, 2, excluir
	beq	$v0, 3, listar_despesas
	beq	$v0, 4, exibir_gastos
	beq	$v0, 5, exibir_p_categoria
	beq	$v0, 6, ranking
	beq	$v0, 7, sairPrograma

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

	la	$s0, arrayPointer
	lw	$s1, 0 ($s0)

#----------------------------Inicio-------------------------------

	la	$t0, id		#endereco do id -> $t0
	lw	$t1, 0 ($t0)	#conteudo do id -> $t1
	addi	$t1, $t1, 1	#incrementa id para proxima despesa
	sw	$t1, 0 ($t0)	#guarda id atualizado

#----------------------------Dia----------------------------------		

	la	$a0, msg_reg1	#mensagem de pegar dia
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 5
	syscall
	add	$t2, $v0, $zero
	
#----------------------------Mes----------------------------------	
	
	la	$a0, msg_reg2	#mensagem de pegar mes
	addi	$v0, $zero 4
	syscall
	
	addi	$v0, $zero, 5
	syscall
	add	$t3, $v0, $zero
	
#----------------------------Ano----------------------------------	
	
	la	$a0, msg_reg3	#mesagem de pegar ano
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 5
	syscall
	
	sll	$s2, $v0, 8
	addu	$s2, $s2, $t3
	sll	$s2, $s2, 8
	addu	$s2, $s2, $t2	#data total em $s2

#------------------Procura local para inserir---------------------

	la	$t0, inicioArray

reg_loop1:	
	
	beq	$t0, $s1, fim_insrt
	

		
	lw	$t2, -24 ($t0)
	slt	$t3, $s2, $t2
	
	bne	$t3, $zero, shft_up	
	addi	$t0, $t0, -28
	j	reg_loop1

shft_up:
	addi	$t2, $t0, -28
	add	$s4, $s1, $zero
	
reg_loop2:

	lw	$s3, 0 ($s4)
	sw	$s3, -28 ($s4)
	
	lw	$s3, 4 ($s4)
	sw	$s3, -24 ($s4)
	
	lw	$s3, 8 ($s4)
	sw	$s3, -20 ($s4)
	
	lw	$s3, 12 ($s4)
	sw	$s3, -16 ($s4)
	
	lw	$s3, 16 ($s4)
	sw	$s3, -12 ($s4)
	
	lw	$s3, 20 ($s4)
	sw	$s3, -8 ($s4)
	
	lw	$s3, 24 ($s4)
	sw	$s3, -4 ($s4)
	
	beq	$s4, $t2, fim_insrt
	addi	$s4, $s4, 28
	j	reg_loop2
	
	
fim_insrt:
	addi	$t0, $t0, -28

	sw	$t1, 0 ($t0)
	sw	$s2, 4 ($t0)
						
#---------------------------Categoria-----------------------------	
	
	la	$a0, msg_reg4	#mesagem de pegar categoria
	addi	$v0, $zero, 4
	syscall
	
	addi	$a0, $t0, 8	#endereco do local aonde a string sera gravada
	addi	$a1, $zero, 16	#numero maximo de caracteres para ler
	addi	$v0, $zero, 8	#codigo da interrupcao
	syscall			#ler string
	
#---------------------------Valor---------------------------------	

	la	$a0, msg_reg5	#mesagem de pegar valor
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 6	#codigo de ler float
	syscall

	s.s	$f0, 24 ($t0)	#guarda valor no array

#---------------------------Fim------------------------------------	

	la	$a0, msg_reg6	#mensagem de registro com sucesso
	addi	$v0, $zero, 4
	syscall
	
	addi	$s1, $s1, -28	#array pointer abre espaco para 28 bytes  (1 despesa)
	sw 	$s1, 0 ($s0)		#salva endereco da ultima posisao no array pointer
	
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
	
	la	$s0, arrayPointer
	lw	$s1, 0 ($s0)
	
	la	$a0, msg_despeza
	addi	$v0, $zero, 4
	syscall

	la 	$s2, inicioArray
		
	beq 	$s2, $s1, sair
	
	#1-pegar endereÃ§o inicial
	#2-usar endereÃ§o para pegar dados
	#3-atualizar valor
	#4-se valor nao for igual ao arraypointer, repetir
	
	
loop:
	addi 	$s2, $s2, -28
		
	#----------------------------------#
	la	$a0, msg_id
	addi	$v0, $zero, 4
	syscall
	
	lw	$a0, 0 ($s2)
	addi	$v0, $zero, 1
	syscall
	#----------------------------------#
	la	$a0, msg_data
	addi	$v0, $zero, 4
	syscall
	
	lbu	$a0, 4 ($s2)
	addi	$v0, $zero, 1
	syscall

	la	$a0, barra
	addi	$v0, $zero, 4
	syscall

	lbu	$a0, 5 ($s2)
	addi	$v0, $zero, 1
	syscall
	
	la	$a0, barra
	addi	$v0, $zero, 4
	syscall
	
	lhu	$a0, 6 ($s2)
	addi	$v0, $zero, 1
	syscall
	#----------------------------------#
	la	$a0, msg_valor
	addi	$v0, $zero, 4
	syscall
	
	l.s	$f12, 24 ($s2)
	addi	$v0, $zero, 2
	syscall
	#----------------------------------#
	la	$a0, msg_categoria
	addi	$v0, $zero, 4
	syscall

	addi	$a0, $s2, 8
	addi	$v0, $zero, 4
	syscall
	#----------------------------------#

	bne	$s2, $s1, loop
	
sair:
	la	$a0, msg_reg7	#mensagem de termino
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 12	#para programa ate proxima tecla ser pressionada
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
#valor total dos gastos por categoria, organizadas em ordem alfabÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â©tica

#=================================================================
#-----------------------Operacao 6--------------------------------
#=================================================================

	


ranking:
#6) Exibir ranking de despesas: com base nos dados de todas as despesas registradas, exibir
#o valor total dos gastos em cada categoria, ordenados de forma decrescente pelo valor

#---------------------------------------------------------------------------------------------------#
sairPrograma:
	li $v0, 10						#Codigo para encerrar o programa
	syscall

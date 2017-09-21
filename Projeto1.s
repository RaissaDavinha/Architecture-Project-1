#-----------------------GRUPO------------------------------------
#Raissa Furlan Davinha	       RA:15032006
#Rafael Fioramonte             RA:16032708
#Bruno Vicente Donaio Kitaka   RA:16156341
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
	msg_catdespeza:	.asciiz		"\nDespezas por categoria: \n"
	msg_gasto:	.asciiz 	"\nGasto mensal: \n"
	msg_categoria:	.asciiz 	" | Categoria: "
	msg_ranking:	.asciiz 	"\nRanking:\n"
	msg_data:	.asciiz		" | Data:"
	msg_id:		.asciiz		"\nId:"
	msg_valor:	.asciiz		" | Valor: "
	barra:		.asciiz 	"/"
	msg_reg8:	.asciiz		"\nmes  |  gasto\n"
	msg_enne:	.asciiz		"\n"
	msg_espaco:	.asciiz		"  |  "
	id:		.word		0
	#inicioArray precisa armazenar id  (4 bytes), data  (6 numeros, 4 bytes), categoria  (16 bytes), valor  (.float, 4 bytes), TOTAL = 28 bytes

.text 			
.globl main
main:	
	#$s0 = endereÃƒÆ’Ã‚Â§o array pointer
	#$s1 = condteudo array pointer
	la 	$s1, inicioArray	#Inicializacao do vetor. Ela sera encontrada o programa inteiro em $t0.
	la 	$s0, arrayPointer	#endereco do arrayPointer em $s1
	sw	$s1, 0  ($s0)		#arraypointer = inicioArray pois nao ha nenhuma despesa ainda.
		
menu1:	
	addi	$v0, $zero, 4		#printa mensagem
	la	$a0, msg_menu1
	syscall
	
	addi	$v0, $zero, 5		#pega inteiro da opcao
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
	
	#1-pegar endereco inicial
	#2-usar endereÃƒÆ’Ã‚Â§o para pegar dados
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
	la	$a0, msg_gasto
	addi	$v0, $zero, 4
	syscall

	#1-setar primeiro mes (byte 6)
	#2-passar por todo dynamicArray
	#3-se igual, soma valor (byte 24)
	#4-se diferente, adiciona novo mes
	#5-parar quando endereco = s1

	la $s2, inicioArray
	la $s3, dynamicArray
	add $t2, $s3, $zero #contador dynamicArray = i
	addi $s2, $s2, -28
	addi $s3, $s3, -8
	
	lb $t0, 5($s2)	#preenche primeiro espaco
	sb $t0,0($s3)
	l.s $f12, 24 ($s2)
	s.s $f12, 4($s3)
	beq $s2,$s1, exibir	#se incioArray tiver apenas uma posicao, ja printa
	
exibir_loop:
	lb $t0, 0($s3)			#pega mes da posicao
	lb $t1, 5($s2)			#pega mes
	beq $t0, $t1, somar		#se igual ao mes guardado em t0, soma
	
	addi $s3, $s3, -8		#proximo espaco dynamicArray
	beq $s3,$t2, exibir_espaco	#verifica se os itens do dynamicArray acabaram
	j exibir_loop			#se nao igual, tentar proximo
exibir_loop2:
	la $s3, dynamicArray		#volta para posicao inicial
	addi $s2, $s2, -28		#proximo espaco do inicioArray
	slt $t4, $s2, $s1		#verifica se incioArray chegou ao final
	bne $t4, $zero, exibir_loop	#se for <= ao endereco final, ele repete
	beq $t4, $t3, exibir_loop
	j exibir_espaco			#se nao for, printa o resultado
	
somar:
	l.s $f12, 24 ($s2)
	l.s $f2, 4($s3)
	add.s $f12, $f2, $f12
	l.s $f12, 4($s3)

	j exibir_loop2
	
exibir_espaco:	
	#criar novo espaco
	addi $t2, $t2, -8	#proximo espaÃƒÂ§o do dynamicArray
	lb $t0, 5($s2)		#pega mes
	sb $t0,0($t2)		#salva mes
	l.s $f12, 24 ($s2)	#pega .float
	s.s $f12, 4($t2)	#salva .float
	
	j exibir_loop2		#vai para proximo espaco do incioArray
	
exibir:
	la $s3, dynamicArray	#volta ponteiro para incio do dynamicArray
exibir_loop3:
	la $a0, msg_reg8
	addi $v0, $zero, 4
	syscall

	lb $a0, 0($s3)
	addi $v0, $zero, 1
	syscall
	
	la $a0, msg_espaco
	addi $v0, $zero, 4
	syscall
	
	l.s $f12, 4($s3)
	addi $v0, $zero, 2
	syscall
	
	la $a0, msg_enne
	addi $v0, $zero, 4
	syscall
	
	slt 	$t4, $s3, $t2			#verifica se dynamicArray chegou ao final
	bne  	$t4, $zero, exibir_loop3	#se for <= ao endereco final, ele repete
	beq 	$t4, $t3, exibir_loop3

	la	$a0, msg_reg7	#mensagem de termino
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 12	#para programa ate proxima tecla ser pressionada
	syscall

	j	menu1

#=================================================================
#-----------------------Operacao 5--------------------------------
#=================================================================	
exibir_p_categoria:
#5) Exibir gasto por categoria: com base nos dados de todas as despesas registradas, exibir o
#valor total dos gastos por categoria, organizadas em ordem alfabetica
	la	$a0, msg_catdespeza
	addi	$v0, $zero, 4
	syscall
	
	#0-contador para quantidade de categorias
	#1- pega primeira categoria e manda pro dynamicArray (posiÃƒÂ§ao 8)
	#2-pega proxima categoria e compara
	#3-se igual, apenas soma despezas, se diferente, manda pro dynamicArray e soma um no contador
	#4-vai para proxima categoria
	la	$s0, arrayPointer
	lw	$s1, 0 ($s0)

	la 	$s4, dynamicArray
	add	$s3, $s4,$zero
	la 	$s5, inicioArray

	
	beq	$s5, $s1, cat_exit
	
	addi	$s5, $s5, -28
	addi	$s3, $s3, -20
	
	lw 	$s6, 8($s5)	#primeira categoria
	sw 	$s6, 0($s3)
	lw 	$s6, 12($s5)
	sw 	$s6, 4($s3)
	lw 	$s6, 16($s5)
	sw 	$s6, 8($s3)
	lw 	$s6, 20($s5)
	sw 	$s6, 12($s3)
	
	l.s 	$f12, 24 ($s5)
	s.s 	$f12, 16($s3)
	
cat_loop1:
	
	beq	$s5, $s1, cat_loop2
	addi 	$s5, $s5, -28
	add	$t3, $s4, $zero
	
cat_dif:	
	
	beq	$t3, $s3, cat_diferente
	addi	$t3, $t3, -20
	
	
	lw	$t0, 8 ($s5)
	lw	$t1, 0 ($t3)
	bne	$t1, $t0, cat_dif
	
	lw	$t0, 12 ($s5)
	lw	$t1, 4 ($t3)
	bne	$t1, $t0, cat_dif
	
	lw	$t0, 16 ($s5)
	lw	$t1, 8 ($t3)
	bne	$t1, $t0, cat_dif
	
	lw	$t0, 20 ($s5)
	lw	$t1, 12 ($t3)
	bne	$t1, $t0, cat_dif	
	
	j	cat_igual
		
cat_diferente:

	addi	$s3, $s3, -20		
	
	lw 	$s6, 8($s5)	#primeira categoria
	sw 	$s6, 0($s3)
	lw 	$s6, 12($s5)
	sw 	$s6, 4($s3)
	lw 	$s6, 16($s5)
	sw 	$s6, 8($s3)
	lw 	$s6, 20($s5)
	sw 	$s6, 12($s3)
	
	l.s 	$f12, 24 ($s5)
	s.s 	$f12, 16($s3)
	
	j	cat_loop1

cat_igual:
	
	l.s	$f0, 16 ($t3)
	l.s	$f1, 24 ($s5)
	add.s	$f0, $f0, $f1
	s.s	$f0, 16 ($t3)
	
	j	cat_loop1
	
#-----------------------------------------------		
cat_loop2:

	la	$s4, dynamicArray
	
	add	$s6, $s3, $zero
	
	addi	$s4, $s4, -20
	beq	$s4, $s3, cat_fim
	addi	$s4, $s4, 20
		
	j	cat_bubble2
			
cat_bubble1:	
	
	addi	$s6, $s6, 20
	la	$s4, dynamicArray
	beq	$s4, $s6, cat_fim	
	
cat_bubble2:

	addi	$s4, $s4, -20
	beq	$s4, $s6, cat_bubble1
	add	$t2, $zero, $zero
	
	addi	$a0, $s4, -20
	addi	$a1, $s4, 0
	addi	$t3, $a1, 16
	
#--------------------------------------------
cat_strcmp:

	lbu	$t0, 0, ($a0)
	lbu	$t1, 0, ($a1)
	sltu	$t2, $t0, $t1
	beq	$t0, $t1, cat_j1
	beq	$t2, $zero, cat_bubble2
	j	cat_bubble3

cat_j1:	lbu	$t0, 1, ($a0)
	lbu	$t1, 1, ($a1)
	sltu	$t2, $t0, $t1
	beq	$t0, $t1, cat_j2
	beq	$t2, $zero, cat_bubble2
	j	cat_bubble3
	
cat_j2:	lbu	$t0, 2, ($a0)
	lbu	$t1, 2, ($a1)
	sltu	$t2, $t0, $t1
	beq	$t0, $t1, cat_j3
	beq	$t2, $zero, cat_bubble2
	j	cat_bubble3

cat_j3:	lbu	$t0, 3, ($a0)
	lbu	$t1, 3, ($a1)
	sltu	$t2, $t0, $t1
	beq	$t0, $t1, cat_j4
	beq	$t2, $zero, cat_bubble2
	j	cat_bubble3

cat_j4:	addi	$a0, $a0, 4
	addi	$a1, $a1, 4
	beq	$t3, $a1, cat_bubble3
	
	j	cat_strcmp

#----------------------------------------------
cat_bubble3:

	lw	$t0, 0 ($s4)
	lw	$t1, -20 ($s4)
	sw	$t0, -20 ($s4)
	sw	$t1, 0 ($s4)
	lw	$t0, 4 ($s4)
	lw	$t1, -16 ($s4)
	sw	$t0, -16 ($s4)
	sw	$t1, 4 ($s4)
	lw	$t0, 8 ($s4)
	lw	$t1, -12 ($s4)
	sw	$t0, -12 ($s4)
	sw	$t1, 8 ($s4)
	lw	$t0, 12 ($s4)
	lw	$t1, -8 ($s4)
	sw	$t0, -8 ($s4)
	sw	$t1, 12 ($s4)
	
	l.s	$f0, 16 ($s4)
	l.s	$f1, -4 ($s4)
	s.s	$f0, -4 ($s4)
	s.s	$f1, 16 ($s4)
		
	j	cat_bubble2	
				
cat_fim:
	
	la	$s4, dynamicArray
	add	$s6, $s3, $zero
	
cat_print:

	beq	$s4, $s6, cat_exit
	addi	$s4, $s4, -20
	
	la	$a0, msg_valor
	addi	$v0, $zero, 4
	syscall
	
	l.s	$f12, 16 ($s4)
	addi	$v0, $zero, 2
	syscall
	
	la	$a0, msg_categoria
	addi	$v0, $zero, 4
	syscall
	
	add	$a0, $s4, $zero
	addi	$v0, $zero, 4
	syscall	

	j	cat_print
												
cat_exit:
	la	$a0, msg_reg7	#mensagem de termino
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 12	#para programa ate proxima tecla ser pressionada
	syscall

	j 	menu1 #debug

#=================================================================
#-----------------------Operacao 6--------------------------------
#=================================================================	
ranking:
#6) Exibir ranking de despesas: com base nos dados de todas as despesas registradas, exibir
#o valor total dos gastos em cada categoria, ordenados de forma decrescente pelo valor
	la	$a0, msg_ranking
	addi	$v0, $zero, 4
	syscall
	
	#0-contador para quantidade de categorias
	#1- pega primeira categoria e manda pro dynamicArray (posiÃƒÂ§ao 8)
	#2-pega proxima categoria e compara
	#3-se igual, apenas soma despezas, se diferente, manda pro dynamicArray e soma um no contador
	#4-vai para proxima categoria
	la	$s0, arrayPointer
	lw	$s1, 0 ($s0)

	la 	$s4, dynamicArray
	add	$s3, $s4,$zero
	la 	$s5, inicioArray

	beq	$s5, $s1, rnk_exit
	
	addi	$s5, $s5, -28
	addi	$s3, $s3, -20
	
	lw 	$s6, 8($s5)	#primeira categoria
	sw 	$s6, 0($s3)
	lw 	$s6, 12($s5)
	sw 	$s6, 4($s3)
	lw 	$s6, 16($s5)
	sw 	$s6, 8($s3)
	lw 	$s6, 20($s5)
	sw 	$s6, 12($s3)
	
	l.s 	$f12, 24 ($s5)
	s.s 	$f12, 16($s3)
	
rnk_loop1:
	
	beq	$s5, $s1, rnk_loop2
	addi 	$s5, $s5, -28
	add	$t3, $s4, $zero
	
rnk_dif:	
	
	beq	$t3, $s3, rnk_diferente
	addi	$t3, $t3, -20
	
	lw	$t0, 8 ($s5)
	lw	$t1, 0 ($t3)
	bne	$t1, $t0, rnk_dif
	
	lw	$t0, 12 ($s5)
	lw	$t1, 4 ($t3)
	bne	$t1, $t0, rnk_dif
	
	lw	$t0, 16 ($s5)
	lw	$t1, 8 ($t3)
	bne	$t1, $t0, rnk_dif
	
	lw	$t0, 20 ($s5)
	lw	$t1, 12 ($t3)
	bne	$t1, $t0, rnk_dif
	
	j	rnk_igual
	
rnk_diferente:

	addi	$s3, $s3, -20		
	
	lw 	$s6, 8($s5)	#primeira categoria
	sw 	$s6, 0($s3)
	lw 	$s6, 12($s5)
	sw 	$s6, 4($s3)
	lw 	$s6, 16($s5)
	sw 	$s6, 8($s3)
	lw 	$s6, 20($s5)
	sw 	$s6, 12($s3)
	
	l.s 	$f12, 24 ($s5)
	s.s 	$f12, 16($s3)
	
	j	rnk_loop1

rnk_igual:
	
	l.s	$f0, 16 ($t3)
	l.s	$f1, 24 ($s5)
	add.s	$f0, $f0, $f1
	s.s	$f0, 16 ($t3)
	
	j	rnk_loop1
	
#-----------------------------------------------		
rnk_loop2:

	la	$s4, dynamicArray
	
	add	$s6, $s3, $zero
	
	addi	$s4, $s4, -20
	beq	$s4, $s3, rnk_fim
	addi	$s4, $s4, 20
		
	j	rnk_bubble2
			
rnk_bubble1:	
	
	addi	$s6, $s6, 20
	la	$s4, dynamicArray
	beq	$s4, $s6, rnk_fim	
	
rnk_bubble2:

	addi	$s4, $s4, -20
	beq	$s4, $s6, rnk_bubble1

	l.s	$f1, 16 ($s4)
	l.s	$f2, -4 ($s4)
	
	c.lt.s	$f1, $f2
	bc1f	rnk_bubble2
	
	lw	$t0, 0 ($s4)
	lw	$t1, -20 ($s4)
	sw	$t0, -20 ($s4)
	sw	$t1, 0 ($s4)
	lw	$t0, 4 ($s4)
	lw	$t1, -16 ($s4)
	sw	$t0, -16 ($s4)
	sw	$t1, 4 ($s4)
	lw	$t0, 8 ($s4)
	lw	$t1, -12 ($s4)
	sw	$t0, -12 ($s4)
	sw	$t1, 8 ($s4)
	lw	$t0, 12 ($s4)
	lw	$t1, -8 ($s4)
	sw	$t0, -8 ($s4)
	sw	$t1, 12 ($s4)
	
	l.s	$f0, 16 ($s4)
	l.s	$f1, -4 ($s4)
	s.s	$f0, -4 ($s4)
	s.s	$f1, 16 ($s4)
		
	j	rnk_bubble2		

rnk_fim:
	
	la	$s4, dynamicArray
	add	$s6, $s3, $zero
	
rnk_print:

	beq	$s4, $s6, rnk_exit
	addi	$s4, $s4, -20
	
	la	$a0, msg_valor
	addi	$v0, $zero, 4
	syscall
	
	l.s	$f12, 16 ($s4)
	addi	$v0, $zero, 2
	syscall
	
	la	$a0, msg_categoria
	addi	$v0, $zero, 4
	syscall
	
	add	$a0, $s4, $zero
	addi	$v0, $zero, 4
	syscall
	
	j	rnk_print
												
rnk_exit:
	la	$a0, msg_reg7	#mensagem de termino
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 12	#para programa ate proxima tecla ser pressionada
	syscall


	j 	menu1 #debug

#---------------------------------------------------------------------------------------------------#
sairPrograma:
	li $v0, 10						#Codigo para encerrar o programa
	syscall

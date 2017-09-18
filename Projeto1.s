#BRUNO ITENS 1 E 4
#RAFAEL ITENS 2 E 5
#RAISSA ITENS 3 E 6
.data
 # user program data
 	dynamicArray:	.space 		5600  	#string (16bytes), valor(4bytes) = 20 bytes
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
	id:		.word		1
	#inicioArray precisa armazenar id  (4 bytes), data  (6 numeros, 4 bytes), categoria  (16 bytes), valor  (.float, 4 bytes), TOTAL = 28 bytes

.text 			
.globl main
main:	
	#$s0 = endereço array pointer
	#$s1 = condteudo array pointer
	la 	$s1, inicioArray	#Inicializacao do vetor. Ela sera encontrada o programa inteiro em $t0.
	la 	$s0, arrayPointer	#endereco do arrayPointer em $s1
	sw	$s1, 0  ($s0)		#arraypointer = inicioArray pois nao ha nenhuma despesa ainda.
	#add	$s1, $s0, $zero		#arrayPointer em $s1 e inicioArray em $s0		
		
menu1:	
	addi	$v0, $zero, 4		#printa mensagem
	la	$a0, msg_menu1
	syscall
	
	addi	$v0, $zero, 5		#pega inteiro da opÃƒÂ¨Ã‚Â¤Ã‚Â¯
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

#----------------------------Inicio-------------------------------

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
	
	addi	$s1, $s1, -28	#array pointer abre espaco para 28 bytes  (1 despesa)
	sw $s1, 0($s0)		#salva endereço da ultima posiçao no array pointer
	
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
	la	$a0, msg_despeza
	addi	$v0, $zero, 4
	syscall
	
	#1-pegar endereço inicial
	#2-usar endereço para pegar dados
	#3-atualizar valor
	#4-se valor nao for igual ao arraypointer, repetir
	
	la $s2, inicioArray
	addi $s3, $s1, -28
loop:
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
	
	lb	$a0, 7 ($s2)
	addi	$v0, $zero, 1
	syscall

	la	$a0, barra
	addi	$v0, $zero, 4
	syscall

	lb	$a0, 6 ($s2)
	addi	$v0, $zero, 1
	syscall
	
	la	$a0, barra
	addi	$v0, $zero, 4
	syscall
	
	lh	$a0, 4 ($s2)
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
	addi $s2, $s2, -28
	bne $s2, $s1, loop
	
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
#valor total dos gastos por categoria, organizadas em ordem alfabÃƒÆ’Ã‚Â©tica

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
	#1- pega primeira categoria e manda pro dynamicArray (posiçao 8)
	#2-pega proxima categoria e compara
	#3-se igual, apenas soma despezas, se diferente, manda pro dynamicArray e soma um no contador
	#4-vai para proxima categoria

	la 	$s4, dynamicArray
	la 	$s5, inicioArray
	add	$s3, $s4,$zero	
	
	beq	$s5, $s1, rnk_fim
	
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
	
	lw	$t0, 8 ($s5)
	lw	$t1, 0 ($s4)
	bne	$t1, $t0, rnk_diferente
	
	lw	$t0, 12 ($s5)
	lw	$t1, 4 ($s4)
	bne	$t1, $t0, rnk_diferente
	
	lw	$t0, 16 ($s5)
	lw	$t1, 8 ($s4)
	bne	$t1, $t0, rnk_diferente
	
	lw	$t0, 20 ($s5)
	lw	$t1, 12 ($s4)
	bne	$t1, $t0, rnk_diferente
	
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
	
	lw	$t1, 16 ($s3)
	lw	$t2, 24 ($s5)
	add	$t1, $t1, $t2
	sw	$t1, 16 ($s3)
	
	j	rnk_loop1
	
#-----------------------------------------------		
rnk_loop2:

	la	$s4, dynamicArray
	addi	$s4, $s4, -20
	beq	$s4, $s3, rnk_fim
	
	lw	$t1, 16 ($s4)
	
	
r2:	
	addi 	$t3, $t3, 1	#adicionar um ao i e 28 ao endereço do incioArray
	slt 	$t4, $t3, $t0
	bne  	$t4, $zero, r1	#se i < = ao contador, volta loop
	beq 	$t4, $t3, r1
	
				#se nao for igual a nenhum, colocamos um novo no array
	addi 	$t0, $t0, 1	#soma 1 ao contador
	addi 	$t1, $t1, 20	#proximo espaço vazio do array
	lw 	$s6, 8($t2)		
	sw 	$s6, 0($t1)
	lw 	$s6, 12($t2)
	sw 	$s6, 4($t1)
	lw 	$s6, 16($t2)
	sw 	$s6, 8($t1)
	lw 	$s6, 20($t2)
	sw 	$s6, 12($t1)
		
	l.s 	$f12, 24 ($t2)
	s.s 	$f12, 16($t1)

r3:
	addi 	$t2, $t2, 28
	bne 	$s1, $t2, r0
	
	#novo loop para printar resultado (contador em $t0)
	
rnk_fim:
	
	j 	menu1 #debug
#---------------------------------------------------------------------------------------------------#

sairPrograma:
	li 	$v0, 10						#chamada para encerrar o programa
	syscall

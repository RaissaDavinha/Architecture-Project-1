#BRUNO ITENS 1 E 4
#RAFAEL ITENS 2 E 5
#RAISSA ITENS 3 E 6
.data
 # user program data
	despesaArray:	.space 	5600  	#armazena 200 espaÃ§os de 28 bytes
	msg1:		.asciiz 	"\nDigite a data (dd/mm/aaaa) da despesa: "
	msg2:		.asciiz 	"\nDefina a categoria da despesa: "
	msg3:		.asciiz 	"\nDigite o valor da despesa: "
	msg_cadastro:	.asciiz 	"\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n7-sair \n"
	msg5:		.asciiz 	"\nDigite o id da despeza: "
	msg_despeza:	.asciiz		"\nDespezas: "
	msg_gasto:	.asciiz 	"\nGasto mensal: "
	msg_categoria:	.asciiz 	"\nCategoria: "
	msg_ranking:	.asciiz 	"\nRanking: "
	msg_data:	.asciiz		"\nData:"
	msg_id:		.asciiz		"\nId:"
	msg_erro:	.asciiz 	"Erro! O numero que foi selecionado nao e valido!\n"
	arrayPointer:	.word	0	#armazena a posiè¤¯ do ultimo dado no array
	id:		.byte 	0
        buffer: 	.space 20
	#despesaArray precisa armazenar id (1 byte), data (6 numeros, 3 bytes), categoria (16 bytes), valor (.float, 4 bytes), TOTAL = 24 bytes

.text 			
.globl main
main:
	la $s0, despesaArray		#Inicializacao do vetor. Ela sera encontrada o programa inteiro em $t0.
	la $s1, arrayPointer		#Inicializacao de $s1 como 0. Este sera o contador de quantos cadastros foram feitos.
	add $t0, $zero, $zero
	sw $t0, 0($s0)			#Definindo o primeiro espaco como "disponivel".	
		
menu1:	
	addi	$v0,$zero,4		#printa mensagem
	la	$a0,msg_cadastro
	syscall
	
	li	$v0,5			#pega inteiro da opè¤¯
	syscall
	add	$s1,$v0,$zero

	beq	$v0, 1, registrar	#Se igual.
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
#-----------------------Opè¶¥s------------------------------------
#=================================================================	
	
registrar:	
#1) Registrar despesa: registrar dados de uma despesa, contendo no minimo informacoes
#como data (dia, mes e ano em formato numerico), categoria (tipo de despesa definido pelo
#usuario com ate 15 caracteres) e valor gasto em reais. Cada despesa registrada deve possuir
#um campo id (identificador numerico unico), iniciado com o valor 1 e incrementado de forma
#automatica a cada nova despesa registrada.
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
		############################
	
	#chamada para receber categoria (16 bytes)
	addi	$v0,$zero, 4
	la	$a0, msg2
	syscall
	
	addi	$v0, $zero, 8	#codigo para ler string
	la	$a0, buffer
	li 	$a1, 16
	add	$t7, $zero, $a0	#categoria em $t7
	syscall
	
	sb $t7, 0($t0)		#salva categoria
	addi $s0, $s0, 16	#arrayPointer = arrayPointer + 16 (string)
		
		######## TESTE ########
		la $a0, buffer
         	add $a0, $zero, $t0
         	li $v0, 4 	#print string
         	syscall
         	#######################
	
	#chamada para receber valor (float)
	addi	$v0, $zero, 4
	la	$a0, msg3
	syscall
	
	addi	$v0, $zero, 6	#codigo para ler floats
	syscall
	add	$t6, $zero, $v0	#valor do ano em $t6
	sb $t6, 0($t0)		#salva categoria
	addi $s0, $s0, 1	#arrayPointer = arrayPointer + 16 (string)
	syscall
	j	menu1

#---------------------Operaè¤¯ 1----------------------------------	

excluir:
#2) Excluir despesa: excluir dados de uma despesa identificada pelo id informado pelo usuario
	addi	$v0, $zero, 4
	la	$a0, msg5
	syscall
	#codigo
	xor	$v0, $v0, $v0
	addi	$v0, $zero, 12
	syscall
	j	menu1

listar_despesas:
#3) Listar despesas: exibir dados de todas as despesas cadastradas (ordenadas por data)
#array em t6
#contador em s3
	addi	$v0, $zero ,4
	la	$a0, msg_despeza
	syscall
	
	add $t6, $t0, $zero
	add $s3, $s0, $zero
	jal bubbleSort
	
	add $t1, $0, $zero
	add $t2, $0, $zero
	add $t8, $s0, $zero
	add $t9, $zero, $zero

procura_p:						#Procura no vetor algum espaco disponivel.
	add $t1, $t1, $4
	lw $a0, 0($t1)					#ve se é igual a s3
	beq $t9, $t8, esc
	
#printar
	la $a0, msg_data				#printa msg de dia
	li $v0, 4
	syscall

	
	addi $v0, $0, 1					#Print int (Data)
	syscall
	
	
esc:
	j	menu1

exibir_gastos:
#4) Exibir gasto mensal: com base nos dados de todas as despesas registradas, exibir o valor
#total dos gastos em cada mes
	addi	$v0, $zero, 4
	la	$a0, msg_gasto
	syscall
	#codigo
	xor	$v0, $v0, $v0
	addi	$v0, $zero, 12
	syscall
	j	menu1

exibir_p_categoria:
#5) Exibir gasto por categoria: com base nos dados de todas as despesas registradas, exibir o
#valor total dos gastos por categoria, organizadas em ordem alfabÃ©tica
	addi	$v0, $zero, 4
	la	$a0, msg_categoria
	syscall
	#codigo
	xor	$v0, $v0, $v0
	addi	$v0, $zero, 12
	syscall
	j	menu1

ranking:
#6) Exibir ranking de despesas: com base nos dados de todas as despesas registradas, exibir
#o valor total dos gastos em cada categoria, ordenados de forma decrescente pelo valor
	addi	$v0, $zero, 4
	la	$a0, msg_ranking
	syscall
	#codigo
	xor	$v0, $v0, $v0
	addi	$v0, $zero, 12
	syscall
	j	menu1
	



bubbleSort:   
#array em t6
#contador em s3
	#t0, t1, t2, t6, t7, s1, s2
   	addi $sp, $sp, -40
   	sw $t0, 0($sp)						#Salvando os dados
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t6, 12($sp)
	sw $t7, 16($sp)
	sw $s1, 20($sp)
	sw $s2, 24($sp)
	sw $t4, 28($sp)
	sw $t8, 32($sp)
	sw $t9, 36($sp)
	
#  Inicializar i como 0    
	add $t0,$zero,$zero #i

     
#  Loop I   
    bubbleLoop:
	la $t6, struct
       #Se finalizado
        beq $t0,$s3,done
         
        #  loop ( 10 - i - 1 ) 
        sub $t7,$s3,$t0
        addi $t7,$t7,-1
         
        # Inicializacao J
        add $t1,$zero,$zero
         
        # Loop do J 
        jLoop:       
            beq $t1,$t7,continue
            
            lw  $s1,0($t6)
            lw  $s2,32($t6)

            sgt $t2, $s1,$s2

            beq $t2, $zero, good
            sw  $s2,0($t6)
            sw  $s1,32($t6)
            
            #before loopinho
            sll $t8, $t1,  5 #multiplica t1 (J) por 32
    	    addi $t8, $t8, 4
    	    addi $t9, $t8, 32
    	    addi $t4, $0, 0
    loopinho:
            lb  $s1, struct($t8)
            lb  $s2, struct($t9)
            sb  $s2, struct($t8)
            sb  $s1, struct($t9)
            
            addi $t4, $t4, 1
            addi $t8, $t8, 1
            addi $t9, $t9, 1
            bne  $t4, 15, loopinho

            #fim loopinho
            
            lw	$s1, 20($t6)
	    lw	$s2, 52($t6)
	    sw	$s2, 20($t6)
	    sw	$s1, 52($t6)
	
	    lw	$s1, 24($t6)
	    lw	$s2, 56($t6)
	    sw	$s2, 24($t6)
	    sw	$s1, 56($t6)
	
	    lw	$s1, 28($t6)
	    lw	$s2, 60($t6)
	    sw	$s2, 28($t6)
	    sw	$s1, 60($t6)

        good:
            addi $t1,$t1,1
            addi $t6, $t6, 32
            j jLoop

        continue:
	
	#Incrementa e da o jump
        addi $t0,$t0,1
        j bubbleLoop

done:
	lw $t0, 0($sp)						#Salvando os dados
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t6, 12($sp)
	lw $t7, 16($sp)
	lw $s1, 20($sp)
	lw $s2, 24($sp)
	lw $t4, 28($sp)
	lw $t8, 32($sp)
	lw $t9, 36($sp)
	addi $sp, $sp, 28

	jr $ra	
#---------------------------------------------------------------------------------------------------#
sair:
	li $v0, 10						#Codigo para encerrar o programa
	syscall

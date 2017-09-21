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

	la 	$s2, inicioArray
	la 	$s3, dynamicArray
	
	beq	$s2, $s1, mes_exit
	
	addi 	$s2, $s2, -28
	addi 	$t2, $s3, -8 #contador dynamicArray = i
	
	lbu 	$t0, 5($s2)	#preenche primeiro espaco
	sh 	$t0, 2($t2)
	lhu	$t0, 6($s2)
	sh	$t0, 0($t2)
	l.s 	$f12, 24 ($s2)
	s.s 	$f12, 4($t2)

	
	
	
exibir_loop:

	beq 	$s2,$s1, exibir	#se incioArray tiver apenas uma posicao, ja printa

	addi 	$s2, $s2, -28
	
	lhu 	$t0, 0($t2)			#pega mes da posicao
	sll	$t0, $t0, 16
	lhu 	$t6, 2($t2)
	add	$t0, $t0, $t6
	
	lhu 	$t1, 6($s2)
	sll	$t1, $t1, 16		#pega mes
	lbu	$t7, 5 ($s2)
	add	$t1, $t1, $t7
	beq	$t0, $t1, somar		#se igual ao mes guardado em t0, soma
	 
					#proximo espaco dynamicArray
	j 	exibir_espaco			#se nao igual, tentar proximo

somar:
	l.s 	$f12, 24 ($s2)
	l.s 	$f2, 4 ($t2)
	add.s 	$f12, $f2, $f12
	s.s 	$f12, 4 ($t2)

	j exibir_loop
	
exibir_espaco:	
	#criar novo espaco
	addi 	$t2, $t2, -8	#proximo espaÃƒÂ§o do dynamicArray
	
	lbu 	$t0, 5($s2)	#preenche primeiro espaco
	sh 	$t0, 2($t2)
	lhu	$t0, 6($s2)
	sh	$t0, 0($t2)
	l.s 	$f12, 24 ($s2)
	s.s 	$f12, 4($t2)
	
	j exibir_loop		#vai para proximo espaco do incioArray
	
exibir:
	la $a0, msg_reg8
	addi $v0, $zero, 4
	syscall
	
exibir_loop2:

	addi 	$s3, $s3, -8

	lhu 	$a0, 2($s3)
	addi 	$v0, $zero, 1
	syscall

	la	$a0, barra
	addi	$v0, $zero, 4
	syscall
		
	lhu 	$a0, 0($s3)
	addi 	$v0, $zero, 1
	syscall
	
	la 	$a0, msg_espaco
	addi 	$v0, $zero, 4
	syscall
	
	l.s 	$f12, 4($s3)
	addi	$v0, $zero, 2
	syscall
	
	la 	$a0, msg_enne
	addi 	$v0, $zero, 4
	syscall
	
	beq	$s3, $t2, mes_exit
	j	exibir_loop2

mes_exit:
	la	$a0, msg_reg7	#mensagem de termino
	addi	$v0, $zero, 4
	syscall
	
	addi	$v0, $zero, 12	#para programa ate proxima tecla ser pressionada
	syscall

	j	menu1


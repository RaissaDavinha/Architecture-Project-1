.data
 # user program data
	msg1:			.asciiz "\nDigite a data da despesa: "
	msg2:			.asciiz "\nDefina a categoria da despesa: "
	msg3:			.asciiz "\nDigite o valor da despesa: "
	msg4:			.asciiz "\n1-Registrar despesa \n2-Excluir despesa \n3-Listar despesas \n4-Exibir gasto mensal \n5-Exibir gastos por categoria \n6-Exibir ranking de despesas \n"
	id:				.byte 1
	despesaArray:	.space 1200 #armazena até 40 espaços de 30 bytes
	#despesaArray precisa armazenar id (1 byte), data (8 numeros, 7 bytes), categoria (16 bytes), valor (.float, 4 bytes), TOTAL = 28 bytes

.text 			
.globl main 	#starting point: must be global

main:
# user program code
	
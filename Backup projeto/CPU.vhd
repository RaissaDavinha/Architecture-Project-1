LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY CPU IS PORT(
	Clear			: IN 	STD_LOGIC;	
	Clock			: IN 	STD_LOGIC;	
	Instruction	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	Signal_Done	: OUT STD_LOGIC;	
	RegA  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	RegB	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg00  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg01	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	
	Reg10  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg11	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END CPU;

ARCHITECTURE behavior OF CPU IS
--==================================================================================================

component Banco_Registradores IS PORT(
   Reg1  		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	Reg2   		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	Data	  		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   RegWrite	: IN STD_LOGIC; -- load/enable.
   Clear		: IN STD_LOGIC; -- async. clear.
	Clock		: IN STD_LOGIC; -- clock.
	Reg1Data	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg2Data	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg_0  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg_1	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	
	Reg_2  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	Reg_3	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END component;

component ControlUnit IS PORT (
	Clear			: IN	  	STD_LOGIC;
	Clock			: IN 	  	STD_LOGIC;
	OP 			: IN    	STD_LOGIC_VECTOR(3 DOWNTO 0) ;
	tempWrite	: OUT		STD_LOGIC;
	XCHG			: OUT		STD_LOGIC;
	RegWrite		: OUT		STD_LOGIC;
	Signal_Done	: OUT		STD_LOGIC
	);
END component;

component ULA IS PORT(
	Sinal		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	Clear		: IN STD_LOGIC;
   DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);	
END component;

component Registrador_8_bits IS PORT(
   D   		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   RegWrite: IN STD_LOGIC; -- load/enable.
   Clear 	: IN STD_LOGIC; -- async. clear.
   Clock 	: IN STD_LOGIC; -- clock.
   Q   		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END component;

component Multiplex_2p1_8bits IS PORT(
	A	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	B	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	Sinal	: IN STD_LOGIC;
	X	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END component;
component Multiplex_2p1_2bits IS PORT(
	A	: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
	B	: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
	Sinal	: IN STD_LOGIC;
	X	: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END component;
--==================================================================================================

SIGNAL		Entrada_RA 	: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL		Sinal_XCHG	: STD_LOGIC;
SIGNAL		RegWrite		: STD_LOGIC;
SIGNAL		TempWrite	: STD_LOGIC;
SIGNAL		Saida_ULA	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL		Dado_RA		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL		Dado_RA_1	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL		Dado_RB		: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL		Dado_RB_1	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL		Dado_RB_2	: STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL		Sinal_ULA	: STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN

	stage0:	Multiplex_2p1_2bits PORT MAP(Instruction(3 DOWNTO 2), Instruction(5 DOWNTO 4), Sinal_XCHG, Entrada_RA);
	stage1:	Banco_Registradores PORT MAP(Entrada_RA, Instruction(3 DOWNTO 2), Saida_ULA, RegWrite, Clear, Clock, Dado_RA, Dado_RB, Reg00, Reg01, Reg10, Reg11);
	stage2:	Registrador_8_bits PORT MAP(Dado_RA, TempWrite, Clear, Clock, Dado_RA_1);
	stage3:	Multiplex_2p1_8bits PORT MAP("0000" & Instruction(3 DOWNTO 0), Dado_RB, Instruction(7) OR Instruction(6), Dado_RB_1);
	stage4:	Multiplex_2p1_8bits PORT MAP(Dado_RA_1, Dado_RB_1, Sinal_XCHG, Dado_RB_2);
	stage5:	ULA PORT MAP(Sinal_ULA, Clear, Dado_RA_1, Dado_RB_2, Saida_ULA);
	stage6:	Multiplex_2p1_2bits PORT MAP(Instruction(7 DOWNTO 6), Instruction(1 DOWNTO 0), Instruction(7) OR Instruction(6), Sinal_ULA);
	stage7:	ControlUnit PORT MAP(Clear, Clock, Instruction(7 DOWNTO 6) & Instruction(1 DOWNTO 0), TempWrite, Sinal_XCHG, RegWrite, Signal_Done);
	
	RegA <= Dado_RA;
	RegB <= Dado_RB;

END behavior;
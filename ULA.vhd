LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY ULA IS PORT(
	Sinal		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	Clear		: IN STD_LOGIC;
   DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ULA;

ARCHITECTURE behavior OF ULA IS

COMPONENT SomaSub
	PORT(
		Sinal		: IN STD_LOGIC;
		DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL ProdutoAux : STD_LOGIC_VECTOR (7 DOWNTO 0);

BEGIN

	stage0: SomaSub PORT MAP(Sinal(0), DataR1, DataR2, ProdutoAux);
	
	PROCESS(Clear, Sinal)
		BEGIN
		IF Clear = '1' THEN
			Produto <= "00000000";
		ELSE
			IF Sinal(1) = '1' THEN
			Produto <= ProdutoAux;
			ELSE
			Produto <= DataR2;
			END IF;
		END IF;
	END PROCESS;

END behavior;
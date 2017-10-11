LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ULA IS PORT(
	Sinal		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
   DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   Clock		: IN STD_LOGIC; -- clock
	Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ULA;

ARCHITECTURE behavior OF ULA IS

COMPONENT SomaSub
	PORT(
		Sinal		: IN STD_LOGIC;
		DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		Clock		: IN STD_LOGIC; -- clock
		Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

BEGIN
PROCESS
	BEGIN
		WAIT UNTIL Clock'EVENT AND Clock = '1';
			IF Sinal(1) = '1' THEN
				SomaSub PORT MAP(Sinal(0), DataR1, DataR2, Clock, Produto);
			ELSE
				Produto <= DataR2;
			END IF;
	END PROCESS;
END behavior;
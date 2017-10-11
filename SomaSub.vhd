LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SomaSub IS PORT(
	Sinal		: IN STD_LOGIC;
   DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   Clock		: IN STD_LOGIC; -- clock
	Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END SomaSub;


ARCHITECTURE behavior OF SomaSub IS 
BEGIN
PROCESS
	BEGIN
		WAIT UNTIL Clock'EVENT AND Clock = '1';
			IF Sinal = '1' THEN 
				Produto <= DataR1 + DataR2;
			ELSE
				Produto <= DataR1 - DataR2;
			END IF;
	END PROCESS;
END behavior;
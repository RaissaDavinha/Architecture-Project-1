LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;

ENTITY SomaSub IS PORT(
	Sinal		: IN STD_LOGIC;
   DataR1  	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	DataR2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	Produto	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END SomaSub;


ARCHITECTURE behavior OF SomaSub IS 
BEGIN
PROCESS(Sinal)
	BEGIN
			IF Sinal = '0' THEN 
				Produto <= DataR1 + DataR2;
			ELSE
				Produto <= DataR1 - DataR2;
			END IF;
	END PROCESS;
END behavior;
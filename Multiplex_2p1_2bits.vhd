LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Multiplex_2p1_2bits IS PORT(
	A	: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
	B	: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
	Sinal	: IN STD_LOGIC;
	X	: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END Multiplex_2p1_2bits;

ARCHITECTURE behavior OF Multiplex_2p1_2bits IS

BEGIN
	PROCESS(Sinal)
		BEGIN
		IF Sinal = '1' THEN
			X <= A;
		ELSE
			X <= B;
		END IF;
	END PROCESS;
END behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Multiplex_2p1_8bits IS PORT(
	A	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	B	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	Sinal	: IN STD_LOGIC;
	X	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Multiplex_2p1_8bits;

ARCHITECTURE behavior OF Multiplex_2p1_8bits IS

BEGIN
	X <= A WHEN (Sinal = '1') ELSE B;

END behavior;

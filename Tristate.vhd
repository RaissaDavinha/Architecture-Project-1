LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Tristate IS
	PORT ( 
	X : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	E : IN STD_LOGIC;
	F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Tristate ;

ARCHITECTURE Behavior OF Tristate IS
BEGIN
		F <= (OTHERS => 'Z') WHEN E = '0' ELSE X;
END Behavior;
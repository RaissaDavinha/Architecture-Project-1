LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Registrador_8_bits IS PORT(
    D   		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RegWrite: IN STD_LOGIC; -- load/enable.
    Clear 	: IN STD_LOGIC; -- async. clear.
    Q   		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- output
END Registrador_8_bits;

ARCHITECTURE description OF Registrador_8_bits IS

BEGIN
	PROCESS(Clear, RegWrite)
		BEGIN
	  if Clear = '1' then
			Q <= "00000000";
	  else
			if RegWrite = '1' then
				 Q <= D;
			end if;
	  end if;
	END PROCESS;
END description;
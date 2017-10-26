LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY Decodificador_2para4 IS
PORT(
a : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
b : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END Decodificador_2para4;

ARCHITECTURE bhv OF Decodificador_2para4 IS
	BEGIN
		PROCESS(a)
		BEGIN
			CASE a IS
				WHEN "00" => b <= "1000";
				WHEN "01" => b <= "0100";
				WHEN "10" => b <= "0010";
				WHEN "11" => b <= "0001";
			END CASE;
		END PROCESS;
END bhv;

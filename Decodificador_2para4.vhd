library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity Decodificador_2para4 is
port(
a : in STD_LOGIC_VECTOR(1 downto 0);
b : out STD_LOGIC_VECTOR(3 downto 0));
end Decodificador_2para4;

architecture bhv of Decodificador_2para4 is
	begin
		process(a)
		begin
			case a is
				when "00" => b <= "1000";
				when "01" => b <= "0100";
				when "10" => b <= "0010";
				when "11" => b <= "0001";
			end case;
		end process;
end bhv;

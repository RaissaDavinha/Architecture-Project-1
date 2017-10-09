LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Banco_Registradores IS PORT(
    Reg1  		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	 Reg2   		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	 Data	  		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RegWrite	: IN STD_LOGIC; -- load/enable.
    Clear		: IN STD_LOGIC; -- async. clear.
    Clock		: IN STD_LOGIC; -- clock.
    Reg1Data	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	 Reg2Data	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END Banco_Registradores;

ARCHITECTURE description OF Banco_Registradores IS

component Registrador_8_bits PORT(
    D   		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RegWrite: IN STD_LOGIC; -- load/enable.
    Clear 	: IN STD_LOGIC; -- async. clear.
    Clock 	: IN STD_LOGIC; -- clock.
    Q   		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- output
END component;

component Decodificador_2para4
port(
a : in STD_LOGIC_VECTOR(1 downto 0);
b : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

component Tristate
	PORT ( 
	X : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	E : IN STD_LOGIC;
	F : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END component;

SIGNAL	DecodResult1, DecodResult2 : STD_LOGIC_VECTOR(3 DownTO 0);
SIGNAL	DATA3, DATA2, DATA1, DATA0: STD_LOGIC_VECTOR(7 downTO 0);

BEGIN
    
    
        stage0: Decodificador_2para4 PORT MAP(Reg1, DecodResult1);
		  stage1: Decodificador_2para4 PORT MAP(Reg2, DecodResult2);
		  
		  stage2: Registrador_8_bits PORT MAP(Data, RegWrite AND DecodResult1(3), Clear, Clock, DATA3);
		  stage3: Registrador_8_bits PORT MAP(Data, RegWrite AND DecodResult1(2), Clear, Clock, DATA2);
		  stage4: Registrador_8_bits PORT MAP(Data, RegWrite AND DecodResult1(1), Clear, Clock, DATA1);
		  stage5: Registrador_8_bits PORT MAP(Data, RegWrite AND DecodResult1(0), Clear, Clock, DATA0);
		  
		  stage6: Tristate PORT MAP(DATA3, DecodResult1(3), Reg1Data);
		  stage7: Tristate PORT MAP(DATA3, DecodResult2(3), Reg2Data);
		  
		  stage8: Tristate PORT MAP(DATA2, DecodResult1(2), Reg1Data);
		  stage9: Tristate PORT MAP(DATA2, DecodResult2(2), Reg2Data);
		  
		  stage10: Tristate PORT MAP(DATA1, DecodResult1(1), Reg1Data);
		  stage11: Tristate PORT MAP(DATA1, DecodResult2(1), Reg2Data);
		  
		  stage12: Tristate PORT MAP(DATA0, DecodResult1(0), Reg1Data);
		  stage13: Tristate PORT MAP(DATA0, DecodResult2(0), Reg2Data);
		  
		  
    
END description;
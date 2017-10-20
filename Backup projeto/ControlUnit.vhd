LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY ControlUnit IS PORT (
			Clear			: IN	  	STD_LOGIC;
			Clock			: IN 	  	STD_LOGIC;
			OP 			: IN    	STD_LOGIC_VECTOR(3 DOWNTO 0) ;
			tempWrite	: OUT		STD_LOGIC;
			XCHG			: OUT		STD_LOGIC;
			RegWrite		: OUT		STD_LOGIC;
			Signal_Done	: OUT		STD_LOGIC);
END ControlUnit;

ARCHITECTURE Behavior OF ControlUnit IS
	TYPE STATE_TYPE IS (s0, s1, s2, done);
	SIGNAL state : STATE_TYPE;

BEGIN
	PROCESS (Clock,Clear)
	BEGIN
		IF Clear = '1' then
	ELSIF (Clock'EVENT AND Clock = '1') THEn
		CASE 	state IS
			WHEN s0=>
				state <= s1;
			WHEN s1=>
				IF (OP(3) OR OP(2) OR OP(1) OR OP(0)) = '0' THEN
					state <= s2;
				ELSE
					state <= done;
				END IF;
			WHEN s2=>
				state <= done;
			WHEN done=>
				state <= s0;
		END CASE;
	END IF;
	END PROCESS;
	PROCESS(state)
	BEGIN
		CASE state IS
			WHEN s0=>
				tempWrite 	<= '1';
				XCHG			<=	'0';
				RegWrite		<=	'0';
				Signal_Done	<=	'0';
				
			WHEN s1=>
				tempWrite 	<= '0';
				XCHG			<=	'0';
				RegWrite		<=	'1';
				Signal_Done	<=	'0';
			
			WHEN s2=>
				tempWrite 	<= '0';
				XCHG			<=	'1';
				RegWrite		<=	'1';
				Signal_Done	<=	'0';
			
			WHEN Done=>
				tempWrite 	<= '0';
				XCHG			<=	'0';
				RegWrite		<=	'0';
				Signal_Done	<=	'1';
			
			
		END CASE;
	END PROCESS;
END Behavior;
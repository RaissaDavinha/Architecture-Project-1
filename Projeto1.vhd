LIBRARY ieee;

ENTITY Register_8_bits IS
		PORT ( Clock, L, E : IN STD LOGIC ;
		Q : OUT INTEGER RANGE 0 TO modulus−1);
END Register_8_bits ;

ARCHITECTURE Behavior OF downcnt IS
	SIGNAL Count : INTEGER RANGE 0 TO modulus−1 ;
BEGIN
	PROCESS
	BEGIN
		WAIT UNTIL (Clock’EVENT AND Clock = ’1’) ;
			IF L = ’1’ THEN
				Count <= modulus−1 ;
			ELSE
				IF E = ’1’ THEN
					Count <= Count−1 ;
				END IF ;
			END IF ;
	END PROCESS;
	Q <= Count ;
END Behavior ;
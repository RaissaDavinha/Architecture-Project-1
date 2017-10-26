LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Registrador_8_bits IS PORT(
    D   		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    RegWrite: IN STD_LOGIC; -- load/enable.
    Clear 	: IN STD_LOGIC; -- async. clear.
    Clock 	: IN STD_LOGIC; -- clock.
    Q   		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- output
END Registrador_8_bits;

ARCHITECTURE description OF Registrador_8_bits IS

BEGIN
    PROCESS(Clock, Clear)
    BEGIN
        IF Clear = '1' THEN
            Q <= "00000000";
        ELSIF rising_edge(Clock) AND RegWrite = '1' THEN
                Q <= D;
        END IF;
    END PROCESS;
END description;
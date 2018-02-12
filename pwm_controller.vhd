LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY pwm IS
GENERIC (N : INTEGER);
PORT (
      clk : IN STD_LOGIC;
      pwm_count : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      pwm_out : OUT STD_LOGIC );
 
END pwm;
 
ARCHITECTURE Behavioral OF pwm IS
SIGNAL cout : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
ATTRIBUTE keep : STRING;
ATTRIBUTE keep OF cout : SIGNAL IS "true";
BEGIN
   PROCESS (clk, cout, pwm_count)
     BEGIN
      IF falling_edge(clk) THEN
        IF cout < "11111111" THEN
           cout <= cout + 1;
        ELSE
           cout <= (OTHERS => '0');
	END IF;
      END IF;
   END PROCESS;
 
   PROCESS (clk, cout, pwm_count)
     BEGIN
      IF rising_edge(clk) THEN
	IF cout < pwm_count THEN
	  pwm_out <= '1';
	ELSE
	  pwm_out <= '0';
	END IF;
      END IF;
    END PROCESS;
 
END Behavioral; 

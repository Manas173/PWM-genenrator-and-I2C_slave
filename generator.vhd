
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity pwm is
generic(N: INTEGER :=8);
port(clk:in STD_LOGIC;
		pwm_count:in STD_LOGIC_VECTOR(N-1 downto 0);
		pwm_out:out STD_LOGIC);

end pwm;

architecture Behavioral of pwm is
signal max_count:STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'1');
signal cout:STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
begin
process(clk)
begin
	if(clk'event and clk='1')then
		if(cout <= max_count) then
			if(cout <= pwm_count)then
				pwm_out <= '1';
			else
				pwm_out <= '0';
			end if;
			cout<=cout + 1;
		else
			cout<=(others=>'0');
		end if;
	end if;
end process;
end Behavioral;


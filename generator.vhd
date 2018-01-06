--Author: Manas Ranjan Swain
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity generator is
port(duty_cycle:in STD_LOGIC_VECTOR(6 downto 0);
		clk:in STD_LOGIC;
		pwm:out STD_LOGIC);
end generator;

architecture Behavioral of generator is
shared variable count:STD_LOGIC_VECTOR(6 downto 0):=(others=>'0');
signal dc: STD_LOGIC_VECTOR(6 downto 0);
begin
dc<=duty_cycle;
process(clk)
begin
if(clk'event and clk='1') then
	if(count<"1100000")then
		if(count<dc) then
			pwm<='1';
		else
			pwm<='0';
		end if;
		count:=count+1;
	else
		count:="0000000";
	end if;
	end if;
	end process;
end Behavioral;


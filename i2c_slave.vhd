library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity slave is
generic(address: STD_LOGIC_VECTOR(6 downto 0);
			N: INTEGER);
port(	clk:in std_logic;
		sda:inout std_logic:='Z';
		reset:in std_logic;
		scl:in std_logic;
		d:out STD_LOGIC_VECTOR(N-1 downto 0));
end slave;

architecture I2C of slave is
type machine is (idle,start,read_address,receive_data);
signal state:machine :=idle;
signal data:STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
signal addr:STD_LOGIC_VECTOR(6 downto 0):=(others=>'0');
shared variable count:INTEGER range N-1 downto 0:=0;
shared variable flag:STD_LOGIC:='0';

begin

process(clk,reset,scl)
begin
	if(clk'event and clk='1') then
		if reset='0' then
			case state is
				when idle=>
					if clk'event and clk='1' then
					end if;
					if(scl='1' and sda'event and sda='0') then
						state<=start;
						sda<='Z';
					end if;
				when start=>
					if(clk'event and clk='1') then
						state<=read_address;
						count:=6;
					end if;
				when read_address=>
					if(count>=0) then 
						if(scl'event and scl='1') then
							addr(count)<=sda;
							count:=count-1;
						end if;
					else
						if addr=address then
							if(scl'event and scl='0') then
								sda<='Z';
								flag:='1';
							end if;
						else
							sda<='1';
							flag:='0';
						end if;
					
						if (flag='1' and scl'event and scl='1') then
							state<=receive_data;
							count:=N-1;
							d<=(others=>'0');
							data<=(others=>'0');
						elsif(flag='0' and scl'event and scl='0') then
								state<=idle;
								sda<='Z';
								d<=(others=>'Z');
						end if;
					end if;
				when receive_data=>
					if(count >= 0) then 
						if(scl'event and scl='1') then
							data(count)<=sda;
							count:=count-1;
						end if;
					else
						if(scl'event and scl='0') then
								sda<='Z';
								flag:='1';
								d(N-1 downto 0)<=data;
								count:=N-1;
						end if;
					end if;
						
						if(flag='1' and scl='1' and sda='1' and sda'event) then
							state<=idle;
							flag:='0';
							d(N-1 downto 0)<=(others=>'0');
						end if;
				end case;
					
		else
			state<=idle;
		end if;
	end if;

end process;
end I2C;

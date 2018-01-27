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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity pwm is
generic(N: INTEGER);
port(clk:in STD_LOGIC;
		pwm_count:in STD_LOGIC_VECTOR(N-1 downto 0);
		pwm_out:out STD_LOGIC);

end pwm;

architecture Behavioral of pwm is
signal max_count:STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'1');
signal cout:STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'0');
signal pwm_input:STD_LOGIC_VECTOR(N-1 downto 0);
signal check:STD_LOGIC_VECTOR(N-1 downto 0):=(others=>'Z');
begin
process(clk)
begin
if(pwm_count=check) then
	pwm_input<=(others=>'0');
else
	pwm_input<=pwm_count;
end if;
	if(clk'event and clk='1')then
		if(cout <= max_count) then
			if(cout < pwm_input)then
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity I2Cpwm is
port(clk:in std_logic;
		sda:inout std_logic:='Z';
		reset:in std_logic;
		scl:in std_logic;
		pwm_out:out STD_LOGIC);
end I2Cpwm;

architecture Behavioral of I2Cpwm is
COMPONENT pwm
generic(N: INTEGER);
	PORT(
		clk : IN std_logic;
		pwm_count : IN std_logic_vector(7 downto 0);          
		pwm_out : OUT std_logic
		);
	END COMPONENT; 
COMPONENT slave
	generic(address: STD_LOGIC_VECTOR(6 downto 0);
				N:INTEGER);
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;
		scl : IN std_logic;    
		sda : INOUT std_logic;     
		d : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
signal dat:std_logic_vector(7 downto 0);
begin

i2c_reg1 : slave
   generic map(address=>"1010100",
					N=>8)
		port map(clk =>clk,
		reset => reset,
		scl => scl,   
		sda => sda,     
		d => dat);
i2c_reg2 : slave
   generic map(address=>"1010000",
					N=>8)
		port map(clk =>clk,
		reset => reset,
		scl => scl,   
		sda => sda,     
		d => dat);
i2c_reg3 : slave
   generic map(address=>"1010111",
					N=>8)
		port map(clk =>clk,
		reset => reset,
		scl => scl,   
		sda => sda,     
		d => dat);
i2c_reg4 : slave
   generic map(address=>"1111111",
					N=>8)
		port map(clk =>clk,
		reset => reset,
		scl => scl,   
		sda => sda,     
		d => dat);		

pwm_gen : pwm
	generic map(N=> 8)
	port map(clk => clk ,
		pwm_count => dat ,
		pwm_out => pwm_out);
	
	

end Behavioral;

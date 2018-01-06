--Author:Manas Ranjan Swain


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity i2c is
generic(slave_address:std_logic_vector(6 downto 0):="0110010"); --example address of the slave
port(scl:inout std_logic;
		sda:inout std_logic;
		tx_done:out std_logic;
		tx_byte:in std_logic_vector(7 downto 0);
		rx_byte:out std_logic_vector(7 downto 0);
		in_progress:out std_logic:='0';
		rx_data_rdy:out std_logic;
		clk:in std_logic
		);
end i2c;

architecture i2c_make of i2c is
signal sda_en:std_logic:='0';
signal sda_o:std_logic:='0';
signal reg_address:std_logic_vector(6 downto 0);
signal ack_o:std_logic:='0';
signal data:std_logic_vector(7 DOWNTO 0);
shared variable count:integer range 0 to 8;
type machine is(idle,slav_addr,ack1,wait_ack,wait_ack2,data_out,data_inp,stop);
signal state:machine:=idle;

signal rx_data_rdy_reg:std_logic:='0';
signal tx_byte_buf:std_logic_vector(7 downto 0):=(others => '0');
signal scl_d:std_logic :='1';
signal scl_d2:std_logic :='1';
signal sda_d:std_logic :='1';
signal sda_d2:std_logic :='1';

signal start_click:std_logic:='0';
signal stop_click:std_logic:='0';
signal scl_falling_click:std_logic:='0';
signal scl_rising_click:std_logic:='0';

signal rx_byte_buf:std_logic_vector(7 downto 0):=(others => '0');

signal rw:std_logic:='0';
signal continue_read:std_logic :='0';

begin
process(clk)
begin
	if(clk'event and clk='1') then
			sda_en<='0';
			sda_o<='0';
			rx_data_rdy_reg<='0';
		case state is
			when idle=>
				if(start_click='1') then
					data<=(others=>'0');
					state<=slav_addr;
					count:=0;
				end if;
			when slav_addr=>
				if scl_rising_click='1' then
					if(count<7)then
						reg_address(6-count)<=sda;
						count:=count+1;
					elsif count=7 then
						count:=count+1;
						state<=ack1;
						rw<=sda_d;
					end if;
				end if;
				
				if count=8 and scl_falling_click='1' then
					count:=0;
					if reg_address=slave_address then
						state<=ack1;
						if(rw='1') then
							tx_byte_buf<=tx_byte;
						 end if;
					else
						state<=IDLE;
					end if;
				end if;
			when ack1=>
			sda_o<='0';
			sda_en<='1';
			if scl_falling_click='1' then
				if rw='0' then
					state<=data_inp;
				else
					state<=data_out;
				end if;
			end if;

			when wait_ack=>
				if scl_rising_click='1' then
					state<=wait_ack2;
					if sda_d='1' then
						continue_read<='0';
					else
						continue_read<='1';
						tx_byte_buf<=tx_byte;
					end if;
				end if;
				
			when wait_ack2=>
				if scl_falling_click='1' then
					if continue_read='1' then
						if rw='0' then
							state<=data_inp;
						else
							state<=data_out;
						end if;
					else
						state<=stop;
					end if;
				end if;
				
			when data_inp=>
					if scl_rising_click='1' then
						if count<= 7 then
							data(7-count)<=sda_d;
							count:=count+1;
						end if;
						if count=7 then
							rx_data_rdy_reg<='1';
						end if;
						end if;
					if scl_falling_click='1' and count=8 then
						state<=ack1;
						count:=0;
					end if;
					
			when data_out=>
				sda_en<='1';
				sda_o<=tx_byte_buf(7-count);
				if scl_falling_click='1' then
					if count<7 then
						count:=count+1;
					elsif count=7 then
						state<=wait_ack;
						count:=0;
					end if;
				end if;
			when stop=>
					tx_done<='1';
					null;
			end case;
			
			if start_click='1' then
				tx_done<='0';
				count:=0;
				state<=idle;
			end if;
			
end if;
end process;

process(clk)
begin
		if(clk'event and clk='1')then
			scl_d<=scl;
			scl_d2<=scl_d;
			sda_d<=sda;
			sda_d2<=sda_d;
			
			scl_rising_click<='0';
			scl_falling_click<='0';
			
			if scl_d2='0' and scl_d='1' then
				scl_rising_click<='1';
			end if;
			if scl_d2='1' and scl_d='0' then
				scl_falling_click<='1';
			end if;
			
			start_click<='0';
			stop_click<='0';
			
			if scl_d='1' and scl_d2='1' and sda_d2='1' and sda_d='0' then
				start_click<='1';
				stop_click<='0';
			end if;
			
			if scl_d2='1' and scl_d='1' and scl_d2='0' and sda_d='1' then
				start_click<='0';
				stop_click<='1';
			end if;
		end if;
end process;

sda<=sda_o when sda_en='1' else 'Z';	
scl<='Z';	
	
rx_data_rdy<=rx_data_rdy_reg;
rx_byte<=data;

in_progress<='0' when STATE=IDLE else '1';

end i2c_make;	
	
	
	
	
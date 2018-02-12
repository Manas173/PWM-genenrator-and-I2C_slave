LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY slave IS
GENERIC (
    address : STD_LOGIC_VECTOR(6 DOWNTO 0); --Seven bit address
    N : INTEGER ); --N define the data bits size

PORT (
    sda : IN std_logic;
    reset : IN std_logic; --goes to idle state when reset is 1
    scl : IN std_logic;
    ack_addr : OUT std_logic := '0';
    ack_data : OUT std_logic;
    d : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    ); --contains data to be transmitted
END slave;

ARCHITECTURE I2C OF slave IS
TYPE machine IS (idle, read_address, receive_data, stop_pos);
SIGNAL state : machine := idle;
SIGNAL data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
SIGNAL start : STD_LOGIC;
SIGNAL stop : STD_LOGIC;
SIGNAL repeat_receive : STD_LOGIC := '0';
SIGNAL start_ack : STD_LOGIC := '0';
SIGNAL start_ack2 : STD_LOGIC := '0';
SIGNAL next_state1 : STD_LOGIC := '0';
SIGNAL next_state2 : STD_LOGIC := '0';
SIGNAL next_data : STD_LOGIC := '0';
SIGNAL address_ack : STD_LOGIC := '0';
SIGNAL count_addr : INTEGER RANGE 7 DOWNTO 0 := 7;
SIGNAL count_data : INTEGER RANGE N DOWNTO 0 := N - 1;
SIGNAL addr : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN
    PROCESS (state, sda, scl, repeat_receive, start_ack2, count_data, count_addr)
      BEGIN
         CASE state IS
             WHEN idle => 
                 stop <= '0';
                 start_ack <= '0';
		 next_state1 <= '0';
		 ack_data <= '0';
		 count_data <= N;
		IF falling_edge(sda) AND scl = '1' THEN
		    start <= '1';
		END IF;
			
	     WHEN read_address => 
		 start <= '0';
		IF rising_edge(scl) AND state = read_address AND start_ack = '0' THEN
		    IF count_addr > 0 THEN
		       addr(count_addr - 1) <= sda;
		       count_addr <= count_addr - 1;
		    END IF;
		END IF;
		IF falling_edge(scl) THEN
		    IF count_addr = 0 THEN
			start_ack <= '1';
			count_addr <= 7;
		    ELSE
			start_ack <= '0';
		    END IF;
		END IF;
		IF falling_edge(scl) THEN
		    IF count_addr = 0 AND address = addr THEN
			ack_addr <= '1';
			addr <= (OTHERS => '0');
			address_ack <= '1';
		    ELSE
			ack_addr <= '0';
			address_ack <= '0';
		    END IF;
		END IF;
 
		IF start_ack = '1' AND falling_edge(scl) THEN
			next_state1 <= '1';
		END IF;
 
 
	    WHEN receive_data => 
		IF rising_edge(scl) AND state = receive_data THEN
		    IF count_data > 0 AND start_ack2 = '0' THEN
			IF repeat_receive = '0' THEN
			    data(count_data) <= sda;
			ELSE
			    data(N - 1) <= next_data;
			    data(count_data - 1) <= sda;
			END IF;
		       count_data <= count_data - 1;
		    ELSIF start_ack2 = '0' THEN
		       data(0) <= sda;
                       count_data <= N - 1;
		   END IF;
	       END IF; 
 
	      IF falling_edge(scl) AND state = receive_data THEN
		  IF repeat_receive = '1' AND count_data = 0 THEN
		       IF start_ack2 = '0' THEN
			   start_ack2 <= '1';
			   ack_data <= '1';
		       ELSE
			   start_ack2 <= '0';
			   ack_data <= '0';
		       END IF;
		  ELSIF repeat_receive = '0' AND count_data = 7 THEN
		       IF start_ack2 = '0' THEN
			   start_ack2 <= '1';
			   ack_data <= '1';
		       ELSE
			   start_ack2 <= '0';
		           ack_data <= '0';
		       END IF;
		  END IF;
	     END IF;
		     
		     
	  WHEN stop_pos => 
	      ack_data <= '0';
	      IF rising_edge(sda) THEN
		  IF scl = '1' THEN
		       stop <= '1';
		  ELSE
		       stop <= '0';
		  END IF;
	      END IF;
 
	      IF rising_edge(scl) AND start_ack2 = '1' THEN
		  start_ack2 <= '0';
   	      END IF;
	      IF rising_edge(scl) AND NOT(addr = "0000000") THEN
		  addr <= (OTHERS => '0');
	      END IF;
	      IF rising_edge(scl) AND state = stop_pos THEN
		  repeat_receive <= '1';
		  next_data <= sda;
	      END IF;
	 END CASE;
   END PROCESS;
 
   PROCESS (reset, start, count_addr, stop, addr, count_data, repeat_receive, start_ack, next_state1, address_ack)
       BEGIN
	  IF reset = '0' THEN
	    IF falling_edge(scl) THEN
                IF start = '1' THEN
                   state <= read_address;
		END IF;
 
	    IF stop = '1' THEN
	       state <= idle;
	       d <= (OTHERS => '0');
	    END IF;
	    IF repeat_receive = '1' AND stop = '0' THEN
	       state <= receive_data;
	    END IF;
	    IF state = read_address AND count_addr = 7 THEN
		IF address_ack = '1' THEN
		    IF start_ack = '1' THEN
			state <= receive_data;
		    END IF;
		ELSIF start_ack = '1' THEN 
		    state <= idle;
		END IF;
	    END IF;
	    IF state = receive_data AND start_ack2 = '1' THEN
		state <= stop_pos;
		d <= data;
	    END IF;
	END IF;
      END IF;
END PROCESS;
 
END I2C;

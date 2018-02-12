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

 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY I2Cpwm IS
PORT (
clk : IN std_logic;
sda_in : INOUT std_logic;
reset : IN std_logic;
scl_in : IN std_logic;
pwm_out : OUT STD_logic;
sda : INOUT std_logic;
dat : INOUT Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
scl : INOUT std_logic
);
END I2Cpwm;

ARCHITECTURE Behavioral OF I2Cpwm IS

SIGNAL ack1 : std_logic := '0';
SIGNAL ack2 : std_logic := '0';
SIGNAL ack3 : std_logic := '0';
SIGNAL ack4 : std_logic := '0';
SIGNAL ack11 : std_logic := '0';
SIGNAL ack22 : std_logic := '0';
SIGNAL ack33 : std_logic := '0';
SIGNAL ack44 : std_logic := '0';
SIGNAL t1 : INTEGER RANGE 0 TO 6 := 0;
SIGNAL t2 : INTEGER RANGE 0 TO 6 := 0;
SIGNAL sda_prev : STD_LOGIC;
SIGNAL scl_prev : STD_LOGIC;
SIGNAL d1 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL d2 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL d3 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL d4 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
 
COMPONENT slave
GENERIC (
        address : STD_LOGIC_VECTOR(6 DOWNTO 0);
        N : INTEGER);
PORT (
     sda : IN std_logic;
     reset : IN std_logic; --goes to idle state when reset is 1
     scl : IN std_logic;
     ack_addr : OUT std_logic := '0';
     ack_data : OUT std_logic;
     d : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
     );
END COMPONENT;
 
COMPONENT pwm
GENERIC (N : INTEGER);
PORT (
     clk : IN std_logic;
     pwm_count : IN std_logic_vector(7 DOWNTO 0); 
     pwm_out : OUT std_logic
     );
END COMPONENT;
 
 
BEGIN
  i2c_reg1 : slave
    GENERIC MAP(
        address => "1010000", 
       N => 8)
    PORT MAP(
	ack_addr => ack1, 
	ack_data => ack11, 
	reset => reset, 
	scl => scl, 
	sda => sda, 
	d => d1
	);
	  
  i2c_reg2 : slave
    GENERIC MAP(
	address => "0011100", 
	N => 8)
    PORT MAP(
	ack_addr => ack2, 
	ack_data => ack22, 
	reset => reset, 
	scl => scl, 
	sda => sda, 
	d => d2);
	  
  i2c_reg3 : slave
    GENERIC MAP(
	address => "1010100", 
	N => 8)
    PORT MAP(
	ack_addr => ack3, 
	ack_data => ack33, 
	reset => reset, 
	scl => scl, 
	sda => sda, 
	d => d3);
	  
  i2c_reg4 : slave
    GENERIC MAP(
	address => "1011101", 
	N => 8)
    PORT MAP(
	ack_addr => ack4, 
	ack_data => ack44, 
	reset => reset, 
	scl => scl, 
	sda => sda, 
	d => d4); 
 
pwm_gen : pwm
   GENERIC MAP(N => 8)
   PORT MAP(
	clk => clk, 
	pwm_count => dat, 
	pwm_out => pwm_out); 
 
 
PROCESS (reset, scl_in, sda_in, clk, ack1, ack2, ack3, ack4, scl, sda)
  BEGIN
    IF rising_edge(clk) THEN
      IF reset = '0' THEN
          IF sda_in = sda_prev THEN
             IF t1 < 5 THEN
		t1 <= t1 + 1;
	     ELSE
		t1 <= 0;
	  	sda <= sda_prev;
	     END IF;
	  ELSE 
	     sda_prev <= sda_in;
	     t1 <= 0;
	  END IF;
	  IF scl_in = scl_prev THEN
	     IF t2 < 5 THEN
                t2 <= t2 + 1;
	     ELSE
		scl <= scl_prev;
		t2 <= 0;
	     END IF;
	  ELSE 
	     scl_prev <= scl_in;
	     t2 <= 0; 
	  END IF;
	  IF ack1 = '1' OR ack2 = '1' OR ack3 = '1' OR ack4 = '1' OR ack11 = '1' OR ack22 = '1' OR ack33 = '1' OR ack44 = '1' THEN
	     IF NOT(sda_in = '1') THEN 
		sda_in <= '0';
	     ELSE
		sda_in <= 'Z';
 	     END IF;
	  ELSE
 	     sda_in <= 'Z';
	  END IF;
	  dat <= d1 OR d2 OR d3 OR d4;
      ELSE
	  dat <= (OTHERS => '0');
      END IF;
    END IF;
END PROCESS;
END Behavioral;

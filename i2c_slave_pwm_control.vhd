LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY slave IS
GENERIC(
    address : STD_LOGIC_VECTOR(6 DOWNTO 0); --Seven bit address
    N : INTEGER); --N define the data bits size

PORT(
    sda : IN std_logic;
    reset : IN std_logic; --goes to idle state when reset is 1
    scl : IN std_logic;
    ack : OUT std_logic;
    d : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); --contains data to be transmitted
END slave;

ARCHITECTURE I2C OF slave IS
TYPE machine IS (idle, read_address, receive_data);
SIGNAL state : machine := idle;
SIGNAL data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
SIGNAL addr : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
SIGNAL count : INTEGER RANGE N - 1 DOWNTO 0 := 0;
SHARED VARIABLE flag : STD_LOGIC := '0';
ATTRIBUTE keep : STRING;
ATTRIBUTE keep OF d : SIGNAL IS "true";

BEGIN
    PROCESS (reset, scl, sda, state)
       BEGIN
	IF reset = '0' THEN
	    CASE state IS
		WHEN idle => 
		    IF (scl = '1' AND falling_edge(sda)) THEN
			state <= read_address; 
			count <= 6;
			ack <= '0';
		    END IF;
		WHEN read_address => -- Reads the address from the SDA line
		    IF count >= 0 THEN
			IF rising_edge(scl) THEN
			    addr(count) <= sda;
			    count <= count - 1;
			END IF;
		    ELSE
			IF addr = address THEN
			    IF falling_edge(scl) THEN
				ack <= '1';
				flag := '1';
			    END IF;
		        ELSE
			    ack <= '0';
			    flag := '0';
			END IF;

			IF (flag = '1' AND rising_edge(scl)) THEN
			    state <= receive_data;
			    count <= N - 1;
			    d <= (OTHERS => '0');
			    data <= (OTHERS => '0');
			ELSIF (flag = '0' AND falling_edge(scl)) THEN
			    state <= idle;
			    ack <= '0';
			d <= (OTHERS => '0');
			END IF;
		    END IF;
	        WHEN receive_data => --Goes to receive data if the address matches
		    IF count >= 0 THEN
			ack <= '0';
			IF rising_edge(scl) THEN
			    data(count) <= sda;
			    count <= count - 1;
			END IF;
		    ELSE
			IF falling_edge(scl) THEN
			    ack <= '1';
			    flag := '1';
			    d(N - 1 DOWNTO 0) <= data;
			    count <= N - 1;
			END IF;
		    END IF;

		    IF (flag = '1' AND scl = '1' AND rising_edge(sda)) THEN
			state <= idle;
			flag := '0';
			d(N - 1 DOWNTO 0) <= (OTHERS => '0');
		    END IF;
	    END CASE;

	ELSE
	    state <= idle; -- goes here when the reset is 1
	    flag := '0';
	    d(N - 1 DOWNTO 0) <= (OTHERS => '0');
	    ack <= '0';

	END IF;
    END PROCESS;
END I2C;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY pwm IS -- The pwm generator starts here
GENERIC (N : INTEGER); -- Defines the pwm data bit size

PORT (
      clk : IN STD_LOGIC;
      pwm_count : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
      pwm_out : OUT STD_LOGIC
     );
END pwm;

ARCHITECTURE Behavioral OF pwm IS
SIGNAL max_count : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '1');
SIGNAL cout : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
SIGNAL pwm_input : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
SIGNAL check : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => 'Z');
BEGIN
    PROCESS (clk, pwm_count)
	BEGIN
	    IF (pwm_count = check) THEN
		pwm_input <= (OTHERS => '0');
	    ELSE
		pwm_input <= pwm_count;
	    END IF;
		    
	    IF rising_edge(clk) THEN
	        IF cout <= max_count THEN
		    IF cout < pwm_input THEN
			pwm_out <= '1';
		    ELSE
			pwm_out <= '0';
		    END IF;
		    cout <= cout + 1;
		ELSE
		    cout <= (OTHERS => '0');
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
      scl : INOUT std_logic;
      dat : INOUT Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0')
     );
END I2Cpwm;

ARCHITECTURE Behavioral OF I2Cpwm IS
COMPONENT slave
    GENERIC (
	     address : STD_LOGIC_VECTOR(6 DOWNTO 0);
	     N : INTEGER
	    );
    PORT (
	  reset : IN std_logic;
	  scl : IN std_logic;
	  sda : IN std_logic;
	  d : OUT std_logic_vector(7 DOWNTO 0);
	  ack : OUT std_logic
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

SIGNAL ack1 : std_logic;
SIGNAL ack2 : std_logic;
SIGNAL ack3 : std_logic;
SIGNAL ack4 : std_logic;
SHARED VARIABLE t1 : INTEGER RANGE 0 TO 6 := 0;
SHARED VARIABLE t2 : INTEGER RANGE 0 TO 6 := 0;
SHARED VARIABLE sda_prev : STD_LOGIC;
SHARED VARIABLE scl_prev : STD_LOGIC;
SIGNAL d1 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL d2 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL d3 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SIGNAL d4 : Std_logic_vector(7 DOWNTO 0) := (OTHERS => '0');
SHARED VARIABLE flag : STD_LOGIC := '0';
BEGIN
    PROCESS (reset, scl_in, sda_in, clk, ack1, ack2, ack3, ack4, scl, sda)
	BEGIN
	    IF rising_edge(clk) THEN
		IF sda_in = sda_prev THEN
		    IF t1 < 5 THEN
		        t1 := t1 + 1;
		    ELSE
			t1 := 0;
			sda <= sda_prev;
	            END IF;
		ELSE 
		    sda_prev := sda_in;
		    t1 := 0;
		END IF;
		
		IF scl_in = scl_prev THEN
		    IF t2 < 5 THEN
			t2 := t2 + 1;
		    ELSE
		   	scl <= scl_prev;
			t2 := 0;
		    END IF;
		ELSE 
		    scl_prev := scl_in;
		    t2 := 0; 
		END IF;
	    END IF;
		    
	    IF ack1 = '1' OR ack2 = '1' OR ack3 = '1' OR ack4 = '1' THEN
		IF scl = '0' AND sda_in = '0' THEN
		    sda_in <= '0';
		    flag := '1';
		END IF;
	    ELSE
		sda_in <= 'Z';
		flag := '0';
	    END IF;
 
	    IF (flag = '1' AND scl = '0') THEN
		sda_in <= '0';
		flag := '0';
	    END IF;
    END PROCESS;
 
    i2c_reg1 : slave
	GENERIC MAP(address => "1010100", 
		    N => 8)
	PORT MAP(reset => reset, 
		 scl => scl, 
	         sda => sda, 
		 d => d1, 
		 ack => ack1
		);
    i2c_reg2 : slave
	GENERIC MAP(address => "1010000", 
		    N => 8)
	PORT MAP(
		reset => reset, 
		scl => scl, 
	  	sda => sda, 
		d => d2, 
		ack => ack2
		);
    i2c_reg3 : slave
	GENERIC MAP(address => "1010111", 
		    N => 8)
	PORT MAP(
		reset => reset, 
		scl => scl, 
		sda => sda, 
		d => d3, 
		ack => ack3
		);
    i2c_reg4 : slave
	GENERIC MAP(
		address => "1111111", 
		N => 8)
	PORT MAP(
		reset => reset, 
		scl => scl, 
		sda => sda, 	
		d => d4, 
		ack => ack4
		);
    dat <= d1 OR d2 OR d3 OR d4;
    pwm_gen : pwm
	GENERIC MAP(N => 8)
	    PORT MAP(
		clk => clk, 
		pwm_count => dat, 
		pwm_out => pwm_out
		);
END Behavioral;

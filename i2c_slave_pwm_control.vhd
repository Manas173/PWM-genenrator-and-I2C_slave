LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY slave IS
	GENERIC (
		address : STD_LOGIC_VECTOR(6 DOWNTO 0); --Seven bit address
	N : INTEGER); 					--N define the data bits size

	PORT (
		sda : INOUT std_logic := 'Z';
		reset : IN std_logic;			--goes to idle state when reset is 1
		scl : IN std_logic; 
	d : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); 	--contains data to be transmitted
END slave;

ARCHITECTURE I2C OF slave IS
	TYPE machine IS (idle, read_address, receive_data); 
	SIGNAL state : machine := idle;
	SIGNAL data : STD_LOGIC_VECTOR(N - 1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL addr : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
	SHARED VARIABLE count : INTEGER RANGE N - 1 DOWNTO 0 := 0;
	SHARED VARIABLE flag : STD_LOGIC := '0';

BEGIN
	PROCESS (reset, scl, sda )
	BEGIN
	    IF reset = '0' THEN
		CASE state IS
		   WHEN idle => 
			IF (scl = '1' AND falling_edge(sda)) THEN
		     	  state <= read_address;	
			  count := 6;
			  sda <= 'Z';
			END IF;
		   WHEN read_address => -- Reads the address from the SDA line
			IF count >= 0 THEN
			   IF rising_edge(scl) THEN
				addr(count) <= sda;
				count := count - 1;
  			   END IF;
			ELSE
			   IF addr = address THEN
				IF falling_edge(scl) THEN
		           	   sda <= '0';
				   flag := '1';
				END IF;
			   ELSE
		  		sda <= 'Z';
				flag := '0';
			   END IF;
 
			IF (flag = '1' AND rising_edge(scl)) THEN
				state <= receive_data;
				count := N - 1;
				d <= (OTHERS => '0');
				data <= (OTHERS => '0');
			ELSIF (flag = '0' AND falling_edge(scl)) THEN
				state <= idle;
				sda <= 'Z';
			d <= (OTHERS => 'Z');
			END IF;
			END IF;
		   WHEN receive_data => --Goes to receive data if the address matches
			IF count >= 0 THEN
 				sda <= 'Z';
			   IF rising_edge(scl) THEN
				data(count) <= sda;
				count := count - 1;
			   END IF;
			ELSE
			   IF falling_edge(scl) THEN
				sda <= '0';
				flag := '1';
				d(N - 1 DOWNTO 0) <= data;
				count := N - 1;
			   END IF;
			END IF;
 
			--STOP condition 
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
	   PROCESS (clk)
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
			
LIBRARY IEEE; --To make a combined entity of I2C slave and PWM controller
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY I2Cpwm IS
	PORT (
		clk : IN std_logic;
		sda : INOUT std_logic := 'Z';
		reset : IN std_logic;
		scl : IN std_logic;
		pwm_out : OUT STD_LOGIC;
		sda_out : INOUT STD_LOGIC;
		scl_out : INOUT STD_LOGIC
	     );
END I2Cpwm;

ARCHITECTURE Behavioral OF I2Cpwm IS
  COMPONENT pwm
    GENERIC (N : INTEGER);
      PORT (
	    clk : IN std_logic;
	    pwm_count : IN std_logic_vector(7 DOWNTO 0); 
	    pwm_out : OUT std_logic
	    );
      END COMPONENT;
 
  COMPONENT slave
     GENERIC (
	      address : STD_LOGIC_VECTOR(6 DOWNTO 0);
	      N : INTEGER
	     );
     PORT (
	    reset : IN std_logic;
	    scl : IN std_logic; 
            sda : INOUT std_logic; 
	     d : OUT std_logic_vector(7 DOWNTO 0)
	   );
   END COMPONENT;
   SIGNAL dat : std_logic_vector(7 DOWNTO 0);
   shared variable t1: INTEGER range 0 to 6;
   shared variable t2: INTEGER range 0 to 6;
signal sda_prev: STD_LOGIC;
	signal scl_prev:STD_LOGIC;
	BEGIN
		-- Spike suppressing code
		process(sda)
		begin
			sda_prev<=sda;
			t1:=0;
		end process;
		process(scl)
		begin
			scl_prev<=scl;
			t2:=0;
		end process;

		process(clk)
		begin
		if rising_edge(clk) then
			if sda = sda_prev  then
				if t1 < 5 then
					t1 := t1+1;
				else
					sda_out <= sda;
					sda_prev <= 'Z' ;
				end if;	
			end if;
			end if;
		end process;
				
		process(clk)
		begin
			if(rising_edge(clk)) then
			if scl = scl_prev  then
				if t2<5 then
					t2:=t2+1;
				else
					scl_out <= scl;
					scl_prev <= 'Z' ;
				end if;	
			end if;
			end if;
		end process;
		
		--Four I2C registers
		--Data size is kept as 8 bits
		i2c_reg1 : slave
			GENERIC MAP(
				address => "1010100", 
				N => 8)
			PORT MAP(
				reset => reset, 
				scl => scl_out, 
				sda => sda_out, 
				d => dat
				);
		i2c_reg2 : slave
			GENERIC MAP(
				address => "1010000", 
				N => 8)
			PORT MAP(
				reset => reset, 
				scl => scl_out, 
				sda => sda_out, 
				d => dat
				);
		i2c_reg3 : slave
			GENERIC MAP(
				address => "1010111", 
				N => 8)
			PORT MAP(
				reset => reset, 
				scl => scl_out, 
				sda => sda_out, 
				d => dat
				);
		i2c_reg4 : slave
			GENERIC MAP(
				address => "1111111", 
				N => 8)
			PORT MAP(
				reset => reset, 
				scl => scl_out, 
				sda => sda_out, 
				d => dat
				); 

		pwm_gen : pwm
			GENERIC MAP(N => 8)
			PORT MAP(
				clk => clk, 
				pwm_count => dat, 
				pwm_out => pwm_out
				);
 
 

END Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY sim_source IS
END sim_source;
 
ARCHITECTURE behavior OF asdas IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT I2Cpwm
    PORT(
         clk : IN  std_logic;
         sda_in : INOUT  std_logic;
         reset : IN  std_logic;
         scl_in : IN  std_logic;
         sda : INOUT  std_logic;
         pwm_out: OUT STD_LOGIC;
         scl : INOUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal scl_in : std_logic;
   signal pwm_out : std_logic;

	--BiDirs
   signal sda_in : std_logic;
   signal sda : std_logic;
   signal scl : std_logic;

 	--Outputs
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: I2Cpwm PORT MAP (
          clk => clk,
          sda_in => sda_in,
          reset => reset,
          scl_in => scl_in,
          sda => sda,
          pwm_out=>pwm_out,
          scl => scl
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
            wait for 100 ns;	
              sda_in<='0';
              scl_in<='0';
              reset<='1';
              wait for 5 us;
              reset<='0';
              scl_in<='1';
              wait for 100 ns;
              sda_in<='1';
              wait for 10 us;
              sda_in<='0';
              
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              ---------------
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 20 us;
              ---------------
              
              sda_in<='0';
                wait for 10 us;
                scl_in<='1';
               wait for 10 us;
                scl_in<='0';
              wait for 10 us;
                  sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 20 ns;
              sda_in<='0';
              wait for 5 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 5 us;
              
              sda_in<='1';
              wait for 20 ns;
              sda_in<='0';
              wait for 5 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 5 us;
              scl_in<='0';
              wait for 50 ns;
              scl_in<='1';
              wait for 5 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 5 us;
              scl_in<='0';
              wait for 50 ns;
              scl_in<='1';
              wait for 5 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              sda_in<='1';
              wait for 50 ns;
              sda_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
            
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 50 us;
              -----------------
      
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='0';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              sda_in<='1';
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
              wait for 10 us;
              sda_in<='0';
              wait for 10 us;
              
              wait for 10 us;
              scl_in<='1';
              wait for 10 us;
              scl_in<='0';
               wait for 10 us;
               sda_in<='0';
               wait for 50 us;
                                                       
               scl_in<='1';
                wait for 10 us;
                sda_in<='1';
              wait for 30 us;
               scl_in<='0';
               wait for 30 us;
               sda_in<='0';     
              ---------------
   wait;
   end process;

END;

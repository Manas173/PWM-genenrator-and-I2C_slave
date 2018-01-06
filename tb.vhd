--Author: Manas Ranjan Swain
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT generator
    PORT(
         duty_cycle : IN  std_logic_vector(6 downto 0);
         clk : IN  std_logic;
         pwm : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal duty_cycle : std_logic_vector(6 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal pwm : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: generator PORT MAP (
          duty_cycle => duty_cycle,
          clk => clk,
          pwm => pwm
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

      duty_cycle<="0010100";
      wait;
   end process;

END;

--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:09:03 03/02/2015
-- Design Name:   
-- Module Name:   C:/Users/ihaz/Desktop/Project/Processor/TB_Processor.vhd
-- Project Name:  Processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Processor
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_Processor IS
END TB_Processor;
 
ARCHITECTURE behavior OF TB_Processor IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Processor
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         Start : IN  std_logic;
         Done : OUT  std_logic;
         Processor_out : OUT  std_logic_vector(7 downto 0);
         Processor_in : IN  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal Start : std_logic := '0';
   signal Processor_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Done : std_logic;
   signal Processor_out : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Processor PORT MAP (
          clock => clock,
          reset => reset,
          Start => Start,
          Done => Done,
          Processor_out => Processor_out,
          Processor_in => Processor_in
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;
		reset <= '0';
		start <= '1';
		Processor_in <= x"ef";
		

      -- insert stimulus here 

      wait;
   end process;

END;

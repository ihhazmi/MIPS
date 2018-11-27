----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:05:38 02/28/2015 
-- Design Name: 
-- Module Name:    PC_Module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_Module is
	generic(n: natural := 8);
    Port ( clock : in  STD_LOGIC;
			  reset : in STD_LOGIC;
			  branch : in STD_LOGIC;
			  enable : in STD_LOGIC;
			  restore : in STD_LOGIC;
           branch_target : in  STD_LOGIC_VECTOR (n-1 downto 0);
           address_out : out  STD_LOGIC_VECTOR (n-1 downto 0));
end PC_Module;

architecture Behavioral of PC_Module is
	signal PC: std_logic_vector(n-1 downto 0):=(others => '0');
	signal link_register: std_logic_vector(n-1 downto 0);
begin

	process(clock)
		begin
			if rising_edge(clock) then
				if reset = '1' then
					PC <= x"00";
				elsif (branch = '1' and enable = '1') then --Controller has signalled a branch
					PC <= branch_target;
				elsif (branch = '1') then --Controller has signalled a branch
					link_register <= PC+1;
				elsif (restore = '1' and enable = '1') then --Controller signalled return from sub routine
					PC <= link_register;
				elsif (enable = '1') then --Increment to next address
					PC <= PC + 1;
				end if;
			end if;
	end process;
	address_out <= PC;
end Behavioral;


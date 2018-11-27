----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:15:40 02/28/2015 
-- Design Name: 
-- Module Name:    RAM - Behavioral 
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
USE ieee.numeric_std.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
	 generic(	width: integer:= 8;
					depth: integer := 256);
    Port ( clock : in  STD_LOGIC;
           RW : in  STD_LOGIC;
           Addr : in  STD_LOGIC_VECTOR (width-1 downto 0);
           Data_in : in  STD_LOGIC_VECTOR (width-1 downto 0);
           Data_out : out  STD_LOGIC_VECTOR (width-1 downto 0));
end RAM;

architecture Behavioral of RAM is
	--Define temporary internal signals or registers
	type ram_type is array (0 to depth-1) of  std_logic_vector(width-1 downto 0);
	signal ram256: ram_type:= (others => (others => '0'));
begin
	process(clock, RW, Addr, Data_in)
		variable RAM_ADDR_IN: integer range 0 to depth-1; -- to translate address to integer
--		variable STARTUP: boolean :=true; --temporary variable for initialization
		begin
			RAM_ADDR_IN := conv_integer (Addr); -- converts address to integer
			if(clock'event and clock='1') then
				if RW = '1' then  -- write operation to RAM
					ram256(RAM_ADDR_IN) <= Data_in;
				end if;
			end if;
			Data_out <= ram256(RAM_ADDR_IN); --always does read operation
	end process;
end Behavioral;


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:50 02/28/2015 
-- Design Name: 
-- Module Name:    MUX2 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX2 is
    Port ( In_1 : in  STD_LOGIC_VECTOR (7 downto 0);
           In_2 : in  STD_LOGIC_VECTOR (7 downto 0);
           sel : in  STD_LOGIC;
           O : out  STD_LOGIC_VECTOR (7 downto 0));
end MUX2;

architecture Behavioral of MUX2 is

begin

	process(In_1,In_2,sel)
		begin
			case sel is
				when '0' => O <= In_1;
				when '1' => O <= In_2;
				when others => O <= "ZZZZZZZZ";
			end case;
	end process;

end Behavioral;


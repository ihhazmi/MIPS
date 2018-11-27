----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:10:31 02/01/2015 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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
use ieee.std_logic_arith.all;

entity ALU is
	port(	clk: in std_logic;
			rst : in std_logic;
			--input signals
			alu_mode: in std_logic_vector(2 downto 0);
			in1: in std_logic_vector(7 downto 0);
			in2: in std_logic_vector(7 downto 0);
			--output signals
			result: inout std_logic_vector(7 downto 0);
			z_flag: out std_logic;
			n_flag: out std_logic);
end ALU;

architecture behavioural of ALU is
begin
--ALU operations
process(alu_mode, in1, in2, rst)
	begin
			if(rst='1') then
				result <= (others => '0');
			else
				result <= (others => '0');
				case alu_mode is
					when "000" => result <= in2;
					when "100" => result <= conv_std_logic_vector(signed(in1) + signed(in2), 8); -- add (How about signed!)
					when "101" => result <= conv_std_logic_vector(signed(in1) - signed(in2), 8); -- sub
					when "001" => result <= in1 nand in2; -- nand
					when "110" => result <= in1(6 downto 0)& '0' ; -- shift left
					when "111" => result <= '0' & in1(7 downto 1); -- shift RIGHT
					when others => NULL;
				end case;
			end if;
end process;
process(result, alu_mode)
	begin
--	if(clk='1' and clk'event) then
	if (alu_mode /= "000") 	then
		if (result = X"00") 	then z_flag <= '1'; 	else z_flag <= '0'; 	end if;
		if (result(7) = '1') 	then n_flag <= '1'; 	else n_flag <= '0'; 	end if;
	end if;
--	end if;
end process;

end behavioural; 

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

entity RegisterFile is
	port(	clk: in std_logic;
			rst : in std_logic;			
			--read signals
			rd_index1: in std_logic_vector(1 downto 0);
			rd_index2: in std_logic_vector(1 downto 0);
			rd_data1: out std_logic_vector(7 downto 0);
			rd_data2: out std_logic_vector(7 downto 0);
			--write signals
			wr_index: in std_logic_vector(1 downto 0);
			wr_data: in std_logic_vector(7 downto 0);
			wr_enable: in std_logic);
end RegisterFile;

architecture behavioural of RegisterFile is
type reg_array is array (integer range 0 to 3) of std_logic_vector(7 downto 0);

--internals signals
signal reg_file : reg_array:= (others => (others => '0'));
begin
--write operation
process(clk)
	begin
		if(clk='1' and clk'event) then
			if(rst='1') then
				for i in 0 to 3 loop
					reg_file(i)<= (others => '0');
				end loop;
			elsif(wr_enable='1')then
				case wr_index(1 downto 0) is
					when "00" => reg_file(0) <= wr_data;
					when "01" => reg_file(1) <= wr_data;
					when "10" => reg_file(2) <= wr_data;
					when "11" => reg_file(3) <= wr_data;
					when others => NULL;
				end case;
			end if;
		end if;
end process;

--read operation
rd_data1 <= reg_file(0) when	(rd_index1="00") else
				reg_file(1) when	(rd_index1="01") else
				reg_file(2) when	(rd_index1="10") else reg_file(3);
rd_data2 <=	reg_file(0) when	(rd_index2="00") else
				reg_file(1) when	(rd_index2="01") else
				reg_file(2) when	(rd_index2="10") else reg_file(3);
end behavioural; 

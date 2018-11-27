library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port(
--         clk      : in  std_logic;
         addr     : in  std_logic_vector (7 downto 0);
         data     : out std_logic_vector (7 downto 0)
         );
end ROM;

architecture BHV of ROM is

    type ROM_TYPE is array (0 to 255) of std_logic_vector (7 downto 0);

    constant rom_content : ROM_TYPE := (

-- in this program, the loop will be executed 8 times, each time r0 is right shifted and r1 is left shifted
-- first 4 loops, output (add r0, r1), last 4 loops, output (nand r0,r1)
-- 1st loop: out 7F+FE
-- 2nd loop: out 3F+FC
-- 3rd loop: out 1F+F8
-- 4th loop: out 0F+F0
-- 5th loop: out 07 nand E0
-- 6th loop: out 03 nand C0
-- 7th loop: out 01 nand 80
-- 8th loop: out 00 nand 00



	x"00", -- NOP
	x"00", -- NOP
	x"30", -- loadimm	r0,0F		#start#  
	x"0F", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"20", -- store	 r0,add_nand
	x"0F", -- 
	x"30", -- loadimm	r0,7
	x"07", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"20", -- store		r0,counter
	x"0E", -- 
	x"30", -- loadimm 	r0,FF
	x"FF", -- 
	x"34", -- loadimm		r1,FF
	x"FF", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"70", -- shr		r0  		#loop# 
	x"64", -- shl		r1
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"DC", -- mov		r3,r0 	
	x"10", -- load		r0,add_nand !!
	x"0F", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"70", -- shr		r0
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"20", -- store		r0,add_nand
	x"0F", -- 
	x"D3", -- mov		r0,r3	
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"38", -- loadimm		r2,nand
	x"4B", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"96", -- brz		nand:
	x"41", -- add		r0,r1   
	x"38", -- loadimm	r2,out_add_nand
	x"4C", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"92", -- br		out_add_nand
	x"81", -- nand		r0,r1              #nand#
	x"00", -- NOP    			   #out_add_nand# 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"C0", -- out		r0
	x"10", -- load		r0,counter
	x"0E", -- 
	x"D9", -- mov		r2,r1		
	x"34", -- loadimm	r1,1
	x"01", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"51", -- sub		r0,r1
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"20", -- store		r0,counter
	x"0E", -- 
	x"D6", -- mov		r1,r2	
	x"38", -- loadimm		r2,out:
	x"76", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"D3", -- mov		r0,r3	
	x"00", -- NOP
	x"00", -- NOP
	x"9A", -- brn		out
	x"38", -- loadimm		r2,loop
	x"1D", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"92", -- br		loop
	x"38", -- loadimm		r2,start     #out#
	x"02", -- 
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"92", -- br		start
	x"00", -- NOP
	x"00", -- NOP);
	Others => "00000000");
begin

p1:    process (addr)
--	 variable add_in : integer := 0;
    begin
        --if rising_edge(clk) then
--					 add_in := conv_integer(unsigned(addr));
          data <= rom_content(to_integer(unsigned(addr)));
       -- end if;
    end process;
end BHV;


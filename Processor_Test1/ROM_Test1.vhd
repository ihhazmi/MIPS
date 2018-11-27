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

	x"00", -- NOP
	x"00", -- NOP
	x"30", -- #start# LOADIMM r0, 0XFF
	x"FF", -- 0xFF, the immediate value
	x"34", -- LOADIMM r1, 0X0c
	x"0c", -- 0x0C, the immediate value
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"64", -- SHL r1
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"51", -- SUB r0, r1
	x"38", -- LOADIMM r2, 0x03
	x"03", -- 0x03, the immediate value
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"D6", -- MOV r1, r2
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"B8", -- IN r2			-- Set the Input port switches on "0xC0" ("11000000")
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"28", -- STORE r2, 0x70
	x"70", -- Effective Address
	x"49", -- ADD r2, r1
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"88", -- NAND r2, r0
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"C8", -- OUT r2			--At this point R[2] must be "00111100"
	x"10", -- LOAD r0, 0x70
	x"70", -- Effective Address
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"70", -- SHR r0
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"48", -- ADD r2, r0		--At this point negative flag must be set
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"00", -- NOP
	x"C8", -- OUT r2		--At this point R[2] have to be set
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


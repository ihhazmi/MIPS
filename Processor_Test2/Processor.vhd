----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:44:38 02/28/2015 
-- Design Name: 
-- Module Name:    Processor - Behavioral 
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

entity Processor is
    Port ( clock : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  Start : in STD_LOGIC;
			  Done : out  STD_LOGIC;
           Processor_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  Processor_in : in  STD_LOGIC_VECTOR (7 downto 0));
end Processor;

architecture Behavioral of Processor is
	signal IN_Sel, WB_Sel, IMR2_Sel, N_Flag, Z_Flag,RF_Write_En, branch_flag, PC_Enable, LR_Restore, RAM_RW: std_logic;
	signal RF_Index1, RF_Index2,RF_write_Index: std_logic_vector(1 downto 0);
	signal ALU_Mode : std_logic_vector(2 downto 0);
	signal Result: std_logic_vector (7 downto 0);
	signal ROM_addr_in, Control_out_imm, ALU_in1, ALU_in2: std_logic_vector (7 downto 0);
	signal ROM_inst_out, RF_Out2, IN_Mux_Out, ALU_Result, RAM_Out, WB_MUX_Out: std_logic_vector (7 downto 0);
begin
PC_Module: entity work.PC_Module port map(clock,reset, branch_flag, PC_Enable, LR_Restore, RF_Out2, ROM_addr_in);
ROM: entity work.ROM port map(ROM_addr_in, ROM_inst_out);
RegisterFile: entity work.RegisterFile port map(clock, reset,RF_Index1,RF_Index2,ALU_in1,RF_Out2,RF_write_Index,WB_MUX_Out,RF_Write_En);
ALU: entity work.ALU port map(clock, reset,ALU_Mode,ALU_in1,ALU_in2,Result,Z_Flag,N_Flag);
RAM: entity work.RAM port map(clock, RAM_RW, ALU_Result, ALU_in1,RAM_Out);

Controller: entity work.MIPS_FSM port map(clock,reset,Start,Z_Flag,N_Flag,ROM_inst_out,Control_out_imm,ALU_Mode,RF_Index1,RF_Index2,RF_write_Index,PC_Enable,RF_Write_En,RAM_RW,branch_flag,LR_Restore,IN_Sel,IMR2_Sel,WB_Sel,Done);

IN_Mux: entity work.MUX2 port map(Control_out_imm, Processor_in, IN_Sel, IN_Mux_Out); --Date WB into RF is from external or RAM
R2_Mux: entity work.MUX2 port map(RF_Out2,IN_Mux_Out,IMR2_Sel, ALU_in2);--Decide whether ALU_in2 is D2 or immediate from controller
WB_Mux: entity work.MUX2 port map(ALU_Result,RAM_Out,WB_Sel,WB_MUX_Out); --Decide whether write back is from ALU or RAM

Processor_out <= ALU_in1;

process(clock)
	begin
		if(clock='1' and clock'event) then
			ALU_Result <= Result;
		end if;
end process;

end Behavioral;


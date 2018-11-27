----------------------------------------------------------------------------------
-- Company:  UNIVERSITY OF VICTORIA - Dept. of Electrical & Computer Engineering.
-- Engineer: Ibrahim Hazmi - ihaz@ece.uvic.ca
--  
-- Create Date:    16:13:25 10/10/2014 
-- Design Name: 	GCD_Nbit
-- Module Name:    ModNb_Ibr - Behavioral 
-- Project Name:   GCD_Nbit  Implementation.
-- Target Devices: SPARTAN6 - XC6SLX45T
-- Tool versions:  ISE 13.4
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPS_FSM is
	PORT(		clk, Reset, Start, Z_Flag, N_Flag	: IN  	STD_LOGIC;
				Instruction : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				Immediate : out STD_LOGIC_VECTOR(7 downto 0);
				ALU_Mode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
				RF_Index1, RF_Index2, RF_write_Index : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
				E3, E4, E5, S1, S2, S3, S4, S5, Done	: OUT   	STD_LOGIC
			);
end MIPS_FSM;

-- E3 <= PC_en
-- E4 <= RF_en
-- E5 <= RAM_WR
-- S1 <= Br_Sel
-- S2 <= Rt_Sel
-- S3 <= IN_Sel
-- S4 <= IMR2_Sel
-- S5 <= WB_Sel


ARCHITECTURE behav OF MIPS_FSM IS
--Register 1 Instruction
--Register 2 Imm/EA
		
signal inst_reg: std_logic_vector(7 downto 0);
signal Flag_reg: std_logic_vector(1 downto 0);
	
TYPE StateType IS (State0, Fetch, Decode, ALU, Branch, LD_ST, Write_Back, OUT_S);

SIGNAL CurrentState	: StateType; -- C_S
SIGNAL NextState		: StateType; -- N_S
--Signal Sel11, Sel22: std_logic;

BEGIN
	
	C_S: PROCESS (clk, Reset)
	BEGIN
	
	IF (Reset = '1') THEN		
		CurrentState 	<= 	State0;			
		ELSIF (clk'event and clk='1') THEN			
			CurrentState 	<= 	NextState;			
	END IF;
		
	END PROCESS C_S;
	
	
	N_S: PROCESS (CurrentState,  Z_Flag, N_Flag, Flag_reg, Instruction, inst_reg, Start)
--	variable N_var,Z_var: std_logic;	
	BEGIN
		
	ALU_Mode <= "000"; 
	E3 <= '0';
	E4 <= '0';
	E5 <= '0';
	S1 <= '0';
	S2 <= '0';
	S3 <= '0';
	S4 <= '0';
	S5 <= '0';
	Done <= '0';
--	inst_reg <= (Others => '0');
--	Immediate<= (Others => '0');
	
		CASE CurrentState IS
			
			WHEN State0 =>
				IF (Start = '1') THEN					
					E3 <= '1';
					NextState 	<= Fetch;
				ELSE 	
					NextState 	<= State0;
				END IF;				

			WHEN Fetch =>
				E3 <= '0';
				E4 <= '0';
				E5 <= '0';
				S1 <= '0';
				S2 <= '0';
				S3 <= '0';
				S4 <= '0';
				S5 <= '0';
				inst_reg <= Instruction;
				NextState 	<= Decode;
				 

			WHEN Decode =>
				CASE inst_reg (7 DOWNTO 4) IS
					WHEN ("0100" OR "0101" OR "0110" OR "0111" OR "1000" OR "1011" OR "1101") =>
						S3	<= '1';
						NextState 	<= ALU;
					WHEN ("1001") =>
						NextState 	<= Branch;
					WHEN ("1110") => -- return
						E3	<= '1';
						S2	<= '1';
						NextState 	<= Fetch;
					WHEN ("0001" OR "0010" OR "0011") =>
						E3 <= '1';
						NextState 	<= LD_ST;
					WHEN ("0001" ) =>
						E3 <= '1';
						NextState 	<= LD_ST;
					WHEN ("0010") =>
						E3 <= '1';
						NextState 	<= LD_ST;
					WHEN ("0011") =>
						E3 <= '1';
						NextState 	<= LD_ST;
					WHEN ("0000") =>
						E3 <= '1';
						NextState 	<= Fetch;
					WHEN ("1100") => -- return
						NextState 	<= OUT_S;
					WHEN OTHERS => 					
						NextState 	<= ALU;
				END CASE;

			WHEN ALU =>
				Flag_reg(0) <= Z_Flag;
				Flag_reg(1) <= N_Flag;
				CASE inst_reg (7 DOWNTO 4) IS
					WHEN ("0100" OR "0101" OR "0110" OR "0111") =>
						ALU_Mode <= inst_reg (6 DOWNTO 4);
						S3	<= '0';
						S4	<= '0';
					WHEN ("1000") =>
						ALU_Mode <= "001"; -- NAND
						S3	<= '0';
						S4	<= '0';
					WHEN ("1011") =>
						ALU_Mode <= "000"; -- IN
						S3	<= '1';
						S4	<= '1';						
					WHEN ("1101") =>
						ALU_Mode <= "000"; -- MOV
						S3	<= '0';
						S4	<= '0';
					WHEN ("0010") => 					
						ALU_Mode <= "000"; -- Do Nothing For (STORE)
						S3	<= '0';
						S4	<= '1';
						E5 <= '1';
					WHEN ("0001") => 					
						ALU_Mode <= "000"; -- Do Nothing For (LOAD)
						S3	<= '0';
						S4	<= '1';
					WHEN ("0011") => 					
						ALU_Mode <= "000"; -- Do Nothing For (LOADIMM)
						S4	<= '1';
						S3	<= '0';
					WHEN OTHERS => 					
						ALU_Mode <= inst_reg (6 DOWNTO 4); -- Do Nothing For (OUT)
						S3	<= '0';
						S4	<= '0';						
				END CASE;
				NextState 	<= Write_Back;

			WHEN Branch =>
				ALU_Mode <= "000"; --  Do Nothing 
				E3	<= '1';
				CASE inst_reg (3 DOWNTO 2) IS
					WHEN ("01") => -- BRZ
						If (Flag_reg(0) = '1') THEN
							S1	<= '1';
						Else
							S1	<= '0';
					End If;	
					WHEN ("00") => -- BR
						S1	<= '1';						
					WHEN ("10") => -- BRN
						If (Flag_reg(1) = '1') THEN
							S1	<= '1';
						Else
							S1	<= '0';
					End If;	
					WHEN ("11") => -- SUB
						S1	<= '1';						
					WHEN OTHERS => 					
						S1	<= '0';						
				END CASE;
				NextState 	<= Fetch;

			WHEN LD_ST =>
			Immediate <= Instruction;
			S4	<= '1';
			NextState 	<= ALU;

			WHEN Write_Back =>
				E3 <= '1';
				CASE inst_reg (7 DOWNTO 4) IS
					WHEN ("0000") =>
						E4	<= '0';						
					WHEN ("1100") =>
						E4	<= '0';						
					WHEN ("0010") =>
						E4	<= '0';						
					WHEN ("0001") => -- LD
						E4	<= '1';						
						S5	<= '1';
					WHEN OTHERS => 					
						E4	<= '1';						
				END CASE;
				NextState 	<= Fetch;

			WHEN OUT_S =>
				Done <= '1';
				NextState 	<= State0;

		-- Default Case	
			WHEN OTHERS =>
				NextState 		<= State0;	
		END CASE;
		
	END PROCESS N_S;
	RF_write_Index <= inst_reg(3 DOWNTO 2);
	RF_Index1 <= inst_reg(3 downto 2);
	RF_Index2 <= inst_reg(1 downto 0);
END behav;
-- A Mealy machine has outputs that depend on both the state and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per state or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity OutputsControl is
    generic(
        n : positive := 64);
	port(
	    Instruction  : in   std_logic_vector(31 downto 0);
		CLK		     : in	std_logic;
		RST		     : in	std_logic := '0';
		MemWrite	 : out	std_logic;
		MemtoReg     : out  std_logic_vector(2 downto 0);
		IRWrite      : out  std_logic;
		RegDst     	 : out	std_logic;
		RegWrite     : out	std_logic;
		ALUSrcA      : out	std_logic;
		ALUSrcB      : out	std_logic_vector(1 downto 0);
		ALUOp     	 : out	std_logic_vector(3 downto 0);
		PCSrc     	 : out	std_logic_vector(1 downto 0);
		PCWriteCond  : out	std_logic;
		PCWrite      : out	std_logic;
		IorD     	 : out	std_logic;
		SHAMT        : out  std_logic_vector(1 downto 0);
		Load         : out 	std_logic_vector(1 downto 0);
		Count        : out  std_logic;
		mreset       : out  std_logic
	);
	
end entity;

-- < 333 Everything will be okay < 33
architecture Behavioral of OutputsControl is

	-- Build an enumerated type for the state machine
	type state_type is (ss, s0, s1, s2, s3, s4, s5, s6, s7, sb8, s8, s9, s10, s11, s12, s13, s14, s15);
	
	-- Register to hold the current state
	signal state   : state_type;
	signal sss     : std_logic;

begin
	-- Logic to advance to the next state
	process (CLK, RST, Instruction)
	begin
		if RST = '1' then -- reset
			state <= ss;
		elsif (rising_edge(CLK)) then
			case state is
			    when ss =>
			        state <= s0;
			        
				when s0 => -- when instrution fetch next instruction decode/reg fetch
					state <= s1;
			    when s1 => -- when instruction decode/reg fetch next find appropriate state based off instruction
			        if (Instruction(31 downto 26) = "100011" OR Instruction(31 downto 26) = "100001" OR Instruction(31 downto 26) = "100000" OR Instruction(31 downto 26) = "101011") then -- if Opcode is LW or SW then compute mem address
				       state <= s2;
				    elsif (Instruction(31 downto 26) = "000000") then -- if Opcode is R-type then execute instruction function
                       state <= s6;
                    elsif (Instruction(31 downto 26) = "000101") then -- if Opcode BNE then branch completion 
                       state <= sb8;
                    elsif (Instruction(31 downto 26) = "000010") then -- if Opcode Jump then jump completion 
                       state <= s9;
                    elsif(Instruction(31 downto 26) = "001000") then -- if Opcode ADDI then ADDI completion 
                        state <= s10;
                    elsif(Instruction(31 downto 26) = "001101") then -- if Opcode ORI then ORI completion 
                        state <= s11;
                    elsif(Instruction(31 downto 26) = "001010") then -- if Opcode SLTI then SLTI completion 
                        state <= s12;
                    elsif(Instruction(31 downto 26) = "001111") then -- if Opcode LUI then LUI completion 
                        state <= s13;
                    elsif(Instruction(31 downto 26) = "011100") then -- if Opcode CLO then CLO completion 
                        state <= s14;
                    end if;       
				when s2 =>
				   if (Instruction(31 downto 26) = "100011" OR Instruction(31 downto 26) = "100001" OR Instruction(31 downto 26) = "100000") then
				        state <= s3;
				   elsif (Instruction(31 downto 26) = "101011") then
				        state <= s5;
				   end if;
				when s3 =>
				    state <= s4;
				when s4 =>
				    state <= s0;
				when s5 =>
				    state <= s0;
				when s6 =>
				    state <= s7;
				when s7 =>
				    state <= s0;
				when sb8 =>
				    state <= s8;
				when s8 =>
				    state <= s0;
				when s9 =>
				    state <= s0;
				when s10 =>
				    state <= s15;
				when s11 =>
				    state <= s15;
				when s12 =>
				    state <= s15;
				when s13 =>
				    state <= s15;
				when s14 =>
				    state <= s15;
			    when s15 =>
				    state <= s0;
				when OTHERS => state <= s0;
			end case;
		end if;
	end process;
	
    -- Determine the output based only on the current state
	-- and the input (do not wait for a clock edge).
	process (state, Instruction)
	   begin
		  case state is 
		    when ss =>
		      sss <= '1';
		         
			when s0 => -- Instruction Fetch
              PCWriteCond <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';     -- Asserted to get the instruction in the instruction register
              PCSrc       <= "00";    -- Select source to write to PC (ALU result)
              ALUSrcB     <= "01";    -- Select 4 as 2nd input to ALU
              ALUSrcA     <= '0';     -- PC as 1st ALU input 
              RegWrite    <= '0';
              RegDst      <= '0';
              if(sss = '1') then
                PCWrite   <= '0';
                sss       <= '0';
              else
                PCWrite   <= '1';
              end if;
              ALUOp       <= "0100";  -- Add operation for ALU, "01" picks arithmetic unit, "00" picks unsigned ADD op
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
               
			when s1 => -- Instruction Decode/Register Fetch	
			  PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '1';
              PCSrc       <= "00";
              ALUOp       <= "0100";
              ALUSrcB     <= "11";
              ALUSrcA     <= '0';
              RegWrite    <= '0';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
              
			when s2 => -- Memory Address Computation
			  PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0100";
              ALUSrcB     <= "10";
              ALUSrcA     <= '1';
              RegWrite    <= '0';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0'; 
              
			when s3 => -- Load Memory Access
                if (Instruction(31 downto 26) = "100011") then --LW
                  PCWriteCond <= '0';
                  PCWrite     <= '0';
                  IorD        <= '1';
                  MemWrite    <= '0';
                  MemtoReg    <= "000";
                  IRWrite     <= '0';
                  PCSrc       <= "00";
                  ALUOp       <= "0000";
                  ALUSrcB     <= "00";
                  ALUSrcA     <= '0';
                  RegWrite    <= '0';
                  RegDst      <= '0'; 
                  Load        <= "00";
                  Count       <= '0';
                  mreset      <= '0';
                   
                elsif (Instruction(31 downto 26) = "100001") then --LH
                  PCWriteCond <= '0';
                  PCWrite     <= '0';
                  IorD        <= '1';
                  MemWrite    <= '0';
                  MemtoReg    <= "000";
                  IRWrite     <= '0';
                  PCSrc       <= "00";
                  ALUOp       <= "0000";
                  ALUSrcB     <= "00";
                  ALUSrcA     <= '0';
                  RegWrite    <= '0';
                  RegDst      <= '0'; 
                  Load        <= "01";
                  Count       <= '0';
                  mreset      <= '0';
                   
                elsif (Instruction(31 downto 26) = "100000") then --LB
                  PCWriteCond <= '0';
                  PCWrite     <= '0';
                  IorD        <= '1';
                  MemWrite    <= '0';
                  MemtoReg    <= "000";
                  IRWrite     <= '0';
                  PCSrc       <= "00";
                  ALUOp       <= "0000";
                  ALUSrcB     <= "00";
                  ALUSrcA     <= '0';
                  RegWrite    <= '0';
                  RegDst      <= '0'; 
                  Load        <= "10";
                  Count       <= '0';
                  mreset      <= '0';
                  
                 else
                  PCWriteCond <= '0';
                  PCWrite     <= '0';
                  IorD        <= '0';
                  MemWrite    <= '0';
                  MemtoReg    <= "000";
                  IRWrite     <= '0';
                  PCSrc       <= "00";
                  ALUOp       <= "0000";
                  ALUSrcB     <= "00";
                  ALUSrcA     <= '0';
                  RegWrite    <= '0';
                  RegDst      <= '0'; 
                  Load        <= "00";
                  Count       <= '0';
                  mreset      <= '0';
                 end if;
              
			when s4 => -- Memory Read/Completion Stop	
			  PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "001";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0000";
              ALUSrcB     <= "00";
              ALUSrcA     <= '0';
              RegWrite    <= '1';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
               
			when s5 => -- Store Memory Access
			  PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '1';
              MemWrite    <= '1';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0000";
              ALUSrcB     <= "00";
              ALUSrcA     <= '0';
              RegWrite    <= '0';
              RegDst      <= '0'; 
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
              
			when s6 => -- Execution
              --Need if statements implmented for function type
              if (Instruction(5 downto 0) = "100001") then --ADDU
                PCWriteCond <= '0';
                PCWrite     <= '0';
                IorD        <= '0';
                MemWrite    <= '0';
                MemtoReg    <= "000";
                IRWrite     <= '0';
                PCSrc       <= "00";
                ALUOp       <= "0100";
                ALUSrcB     <= "00";
                ALUSrcA     <= '1';
                RegWrite    <= '0';
                RegDst      <= '0';
                Load        <= "00";
                Count       <= '0';
                mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "100100") then --AND
                PCWriteCond <= '0';
                PCWrite     <= '0';
                IorD        <= '0';
                MemWrite    <= '0';
                MemtoReg    <= "000";
                IRWrite     <= '0';
                PCSrc       <= "00";
                ALUOp       <= "0000";
                ALUSrcB     <= "00";
                ALUSrcA     <= '1';
                RegWrite    <= '0';
                RegDst      <= '0';
                Load        <= "00";
                Count       <= '0';
                mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "001000") then --JR
                 PCWriteCond <= '0';
                 PCWrite     <= '1';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "10";
                 ALUOp       <= "0100";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 SHAMT       <= "00";
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "010000") then --MFHI
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "011";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "0000";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 SHAMT       <= "00";
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "001010") then --MFLO
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "010";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "0000";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 SHAMT       <= "00";
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "011001") then --MULTU
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "0000";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0'; 
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '1';
                 
              elsif (Instruction(5 downto 0) = "000000") then --SLL
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "1101";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 SHAMT       <= "00";
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "000100") then --SLLV
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "1101";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 SHAMT       <= "01";
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                 
              elsif (Instruction(5 downto 0) = "000011") then --SRA
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "1111";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 SHAMT       <= "00";
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                        
              elsif (Instruction(5 downto 0) = "100010") then --SUB
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "0110";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0'; 
                 Load        <= "00";
                 Count       <= '0';
                 mreset      <= '0';
                 
               else
                 PCWriteCond <= '0';
                 PCWrite     <= '0';
                 IorD        <= '0';
                 MemWrite    <= '0';
                 MemtoReg    <= "000";
                 IRWrite     <= '0';
                 PCSrc       <= "00";
                 ALUOp       <= "0000";
                 ALUSrcB     <= "00";
                 ALUSrcA     <= '1';
                 RegWrite    <= '0';
                 RegDst      <= '0';
                 Load        <= "00"; 
                 Count       <= '0';
                 mreset      <= '0';
              end if;
              
			when s7 => -- R-type Completion
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0000";
              ALUSrcB     <= "00";
              ALUSrcA     <= '0';
              RegWrite    <= '1';
              RegDst      <= '1';
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
              
            when sb8 => -- Branch Buffer
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0101";
              ALUSrcB     <= "11";
              ALUSrcA     <= '0';
              RegWrite    <= '0';
              RegDst      <= '0';  
              Load        <= "00"; 
              Count       <= '0';
              mreset      <= '0';
              
			when s8 => -- Branch Completion
              PCWriteCond <= '1';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "01";
              ALUOp       <= "0110";
              ALUSrcB     <= "00";
              ALUSrcA     <= '1';
              RegWrite    <= '0';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';  
              mreset      <= '0';
              
			when s9 => -- Jump Completion Computation
              PCWriteCond <= '0';
              PCWrite     <= '1';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "10";
              ALUOp       <= "0000";
              ALUSrcB     <= "00";
              ALUSrcA     <= '0';
              RegWrite    <= '0';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';  
              mreset      <= '0';
              
            when s10 => -- ADDI Execution
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0100"; -- Signed ADD
              ALUSrcB     <= "10"; -- Immediate instead of RegB
              ALUSrcA     <= '1';
              RegWrite    <= '0';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
                           
            when s11 => -- ORI Execution
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0001"; -- Logical OR
              ALUSrcB     <= "10"; -- Immediate instead of RegB
              ALUSrcA     <= '1';
              RegWrite    <= '0';
              RegDst      <= '0'; 
              Load        <= "00";
              Count       <= '0';  
              mreset      <= '0';
              
            when s12 => -- SLTI
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "1010"; -- Compare Less Than
              ALUSrcB     <= "10"; -- Immediate instead of RegB
              ALUSrcA     <= '1';
              RegWrite    <= '0';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0'; 
              mreset      <= '0';
              
            when s13 => -- Load Upper Immediate
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "001";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "1101"; 
              ALUSrcB     <= "11"; -- Immediate instead of RegB
              ALUSrcA     <= '1';
              RegWrite    <= '1';
              RegDst      <= '0';
              SHAMT       <= "10";
              Load        <= "00"; 
              Count       <= '0'; 
              mreset      <= '0';
                 
            when s14 => -- CL
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "111";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0101";
              ALUSrcB     <= "10"; -- Immediate instead of RegB
              ALUSrcA     <= '1';
              RegWrite    <= '0';
              RegDst      <= '0';  
              Load        <= "00";
              Count       <= '1';         
              mreset      <= '0';
              
            when s15 => --Complete I-Type
              PCWriteCond <= '0';
              PCWrite     <= '0';
              IorD        <= '0';
              MemWrite    <= '0';
              MemtoReg    <= "000";
              IRWrite     <= '0';
              PCSrc       <= "00";
              ALUOp       <= "0000";
              ALUSrcB     <= "00";
              ALUSrcA     <= '0';
              RegWrite    <= '1';
              RegDst      <= '0';
              Load        <= "00";
              Count       <= '0';
              mreset      <= '0';
                   
		end case;
	end process;
	
end Behavioral;

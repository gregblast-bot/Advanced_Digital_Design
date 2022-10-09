LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;
use IEEE.math_real.all;

entity RegFile is
    GENERIC(
           n : positive := 32) ;
    Port ( ReadReg1			: in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
		   ReadReg2 		: in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
		   WriteReg 		: in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
		   WriteData		: in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable   : in STD_LOGIC ;
           CLK              : in STD_LOGIC ;
           RST              : in STD_LOGIC ;
           ReadData1        : out STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           ReadData2        : out STD_LOGIC_VECTOR(n-1 DOWNTO 0)) ;
end RegFile ;

architecture Behavioral of RegFile is
	
COMPONENT dec5to32 IS
	PORT (	w  : IN STD_LOGIC_VECTOR(4 DOWNTO 0) ;
			En : IN STD_LOGIC ;
			y  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ) ;
END COMPONENT ;

COMPONENT Reg is
    GENERIC(
           n : positive := 32) ;
    Port ( RegIn           : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable  : in STD_LOGIC ;
           CLK             : in STD_LOGIC ;
           RST             : in STD_LOGIC ;
           RegOut          : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end COMPONENT ;

type RegOuts is array (n-1 downto 0) of std_logic_vector(n-1 downto 0) ;
signal outputs : RegOuts;
signal regIndex : std_logic_vector(n-1 downto 0) ;
signal ReadReg1s, ReadReg2s, WriteRegs : Integer := 0 ;

begin

Dec : dec5to32 port map(
	w => WriteReg,
	En => Control_Enable,
	y => regIndex) ;

Regs : for i in 0 to n-1 generate
	Regi : Reg generic map (n) port map( 
        RegIn => WriteData,
		Control_Enable => regIndex(i),
		CLK => CLK,
		RST => RST,
		RegOut => outputs(i)) ;
end generate Regs;
	
ReadReg1s <= to_integer(unsigned(ReadReg1)) ;
ReadReg2s <= to_integer(unsigned(ReadReg2)) ;
ReadData1 <= outputs(ReadReg1s) ;
ReadData2 <= outputs(ReadReg2s) ;

end Behavioral ;
	
-- Alternative 1
-- begin
--	Regs : for i in 0 to n-1 generate
--		Regi : Reg generic map (n) port map( 
--					  RegIn => WriteData,
--					  Control_Enable => onehot(i),
--					  CLK => CLK,
--					  RST => RST,
--					  RegOut => outputs(i)) ;
--	end generate Regs;

--ReadReg1s <= to_integer(unsigned(ReadReg1)) ;
--ReadReg2s <= to_integer(unsigned(ReadReg2)) ;
--WriteRegs <= to_integer(unsigned(WriteReg));

--decode : process(WriteRegs, Control_Enable) begin
--    regIndex <= (others => '0');
--    regIndex(WriteRegs) <= '1' AND Control_Enable;
--end process decode;
--ReadData1 <= outputs(ReadReg1s) ;
--ReadData2 <= outputs(ReadReg2s) ;

-- Alternative 2 / Forsee clocking issues 

--begin
--process(CLK, RST)	
-- begin
--    if RST = '1' then
--        ReadData1 <= (others => '0');
--        ReadData2 <= (others => '0');
--    elsif rising_edge(CLK) then
--        ReadData1 <= outputs(to_integer(unsigned(ReadReg1)));
--        ReadData2 <= outputs(to_integer(unsigned(ReadReg2)));
--        if (Control_Enable = '1') then
--            outputs(to_integer(unsigned(WriteReg))) <= WriteData;
--        end if;
--    end if;
--end process;     

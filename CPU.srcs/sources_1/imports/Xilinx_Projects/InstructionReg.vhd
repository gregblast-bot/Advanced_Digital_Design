LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

entity InstructionReg is
    GENERIC(
           n : positive := 32) ;
    Port ( RegIn            : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable   : in STD_LOGIC ;
           CLK              : in STD_LOGIC ;
           RST              : in STD_LOGIC ;
           RegOut0          : out STD_LOGIC_VECTOR(5 DOWNTO 0)  := "000000" ;
           RegOut1          : out STD_LOGIC_VECTOR(4 DOWNTO 0)  := "00000" ;
           RegOut2          : out STD_LOGIC_VECTOR(4 DOWNTO 0)  := "00000" ;
           RegOut3          : out STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
           RegOut4          : out STD_LOGIC_VECTOR(25 DOWNTO 0) := "00000000000000000000000000") ;
end InstructionReg ;

architecture Behavioral of InstructionReg is
    begin
           
       CW : process(CLK, RST)
        begin
            if (RST = '1') then
                RegOut0 <= "000000" ;
                RegOut1 <= "00000" ;
                RegOut2 <= "00000" ;
                RegOut3 <= "0000000000000000" ;
                RegOut4 <= "00000000000000000000000000";
            elsif (CLK'EVENT AND CLK = '1') then
                if (Control_Enable = '1') then
                        RegOut0 <= RegIn(31 DOWNTO 26) ;
                        RegOut1 <= RegIn(25 DOWNTO 21) ;
                        RegOut2 <= RegIn(20 DOWNTO 16) ;
                        RegOut3 <= RegIn(15 DOWNTO 0) ;
                        RegOut4 <= RegIn(25 DOWNTO 0) ;
                end if ;
            end if ;
       end process CW ;
          
end Behavioral ;

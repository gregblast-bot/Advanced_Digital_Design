LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

entity PC is
    GENERIC(
           n : positive := 32) ;
    Port ( RegIn           : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable  : in STD_LOGIC ;
           CLK             : in STD_LOGIC ;
           RST             : in STD_LOGIC ;
           RegOut          : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := "00000000000000000000000000000000") ;
end PC ;

architecture Behavioral of PC is
    begin
           
       CW : process(CLK, RST)
        begin
            if (RST = '1') then
                RegOut <= "00000000000000000000000000000000" ;
            elsif (CLK'EVENT AND CLK = '1') then
                if (Control_Enable = '1') then
                        RegOut <= RegIn ;
                end if ;
            end if ;
       end process CW ;
          
end Behavioral ;

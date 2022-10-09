LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

entity Reg is
    GENERIC(
           n : positive := 32) ;
    Port ( RegIn           : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable  : in STD_LOGIC ;
           CLK             : in STD_LOGIC ;
           RST             : in STD_LOGIC ;
           RegOut          : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end Reg ;

architecture Behavioral of Reg is
    begin
           
       CW : process(CLK, RST)
        begin
            if (RST = '1') then
                RegOut <= (others => '0') ;
            elsif (CLK'EVENT AND CLK = '1') then
                if (Control_Enable = '1') then
                        RegOut <= RegIn ;
                end if ;
            end if ;
       end process CW ;
          
end Behavioral ;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

entity PCAppend is
    GENERIC(
           n : positive := 32);
    Port ( DataIn1      : in STD_LOGIC_VECTOR(27 DOWNTO 0) ;
		   DataIn2      : in STD_LOGIC_VECTOR(31 DOWNTO 28) ;
           DataOut      : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end PCAppend ;

architecture Behavioral of PCAppend is
    begin   
       
       DataOut <= DataIn2 & DataIn1 ;
        
end Behavioral ;

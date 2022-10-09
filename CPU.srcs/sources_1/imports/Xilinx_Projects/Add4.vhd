LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity Add4 is
    GENERIC(
           n : positive := 32);
    Port ( DataIn      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           DataOut     : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end Add4 ;

architecture Behavioral of Add4 is
    begin   
       
       DataOut <= DataIn + 4 ;
        
end Behavioral ;

LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
USE ieee.numeric_std.all ;

entity ShiftLeft2 is
    GENERIC(
           n : positive := 32);
    Port ( DataIn      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           DataOut     : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end ShiftLeft2 ;

architecture Behavioral of ShiftLeft2 is
    begin   
       
       DataOut <= DataIn(n-3 downto 0) & "00" ;
        
end Behavioral ;

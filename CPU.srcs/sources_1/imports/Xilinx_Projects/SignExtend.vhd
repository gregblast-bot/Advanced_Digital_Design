LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- if MSB 1 append ones, same for zeros
entity SignExtend is
    Port ( DataIn      : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           DataOut     : out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0'));
end SignExtend;

architecture Behavioral of SignExtend is
    begin     
    
    WITH DataIn(15) SELECT 
       DataOut <= ("0000000000000000" & DataIn) WHEN '0',
				  ("1111111111111111" & DataIn) WHEN '1',
				  ("0000000000000001" & DataIn) WHEN OTHERS;
        
end Behavioral;

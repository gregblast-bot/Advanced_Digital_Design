library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity slicer_up is
  Port ( A : in STD_LOGIC_VECTOR(63 DOWNTO 0);
         B : out STD_LOGIC_VECTOR(31 DOWNTO 0));
end slicer_up;

architecture Behavioral of slicer_up is

begin

    B <= A(63 DOWNTO 32);
    
end Behavioral;
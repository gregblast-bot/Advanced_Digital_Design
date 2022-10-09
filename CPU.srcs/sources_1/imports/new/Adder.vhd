library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;

entity Adder is
    GENERIC(
           n : positive := 64);
    Port ( Multiplicand_out     : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Intermediate_Product : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) := "0000000000000000000000000000000000000000000000000000000000000000";
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Product_out          : out STD_LOGIC_VECTOR(n-1 DOWNTO 0)  := "0000000000000000000000000000000000000000000000000000000000000000");
end Adder;

architecture Behavioral of Adder is
begin

    Product_out <= std_logic_vector(unsigned(Multiplicand_out) + unsigned(Intermediate_Product));
    --Alternatively
    --Product_out <= ((Multiplicand_out XOR Intermediate_Product) XOR '0');
                   
end Behavioral;
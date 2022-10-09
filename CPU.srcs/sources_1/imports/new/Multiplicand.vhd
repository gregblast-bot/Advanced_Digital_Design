LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Multiplicand is
    GENERIC(
           n : positive := 64);
    Port ( Multiplicand_in      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Control_Enable       : in STD_LOGIC;
           Shift_Enable         : in STD_LOGIC;
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Multiplicand_out     : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := "0000000000000000000000000000000000000000000000000000000000000000");
end Multiplicand;

architecture Behavioral of Multiplicand is

signal Shift_L : std_logic_vector(n-1 downto 0);

    begin   
        CE : process(CLK, RST)
         begin
            if (RST = '1') then
                Shift_L <= "0000000000000000000000000000000000000000000000000000000000000000";
            elsif (CLK'EVENT AND CLK = '1') then
                if (Shift_Enable = '1' AND Control_Enable = '0') then
                    Shift_L <= Shift_L(n-2 downto 0) & '0';
                elsif (Control_Enable = '1') then
                    Shift_L <= Multiplicand_in;
                end if;
            end if;
            Multiplicand_out <= Shift_L;
       end process CE;
        
end Behavioral;
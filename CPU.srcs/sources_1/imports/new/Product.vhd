LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Product is
    GENERIC(
           n : positive := 64);
    Port ( Product              : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Control_Enable       : in STD_LOGIC;
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Intermediate_Product : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := "0000000000000000000000000000000000000000000000000000000000000000");
end Product;

architecture Behavioral of Product is
    begin
           
       CW : process(CLK, RST)
        begin
            if (RST = '1') then
                Intermediate_Product <= "0000000000000000000000000000000000000000000000000000000000000000";
            elsif (CLK'EVENT AND CLK = '1') then
                if (Control_Enable = '1') then
                        Intermediate_Product <= Product;
                end if;
            end if;
       end process CW;
       
end Behavioral;

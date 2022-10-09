LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Multiplier is
    GENERIC(
           n : positive := 32);
    Port ( Multiplier_in        : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Control_Enable       : in STD_LOGIC;
           Shift_Enable            : in STD_LOGIC;
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Multiplier_out       : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := "00000000000000000000000000000000");
end Multiplier;

architecture Behavioral of Multiplier is

signal Shift_R : std_logic_vector(n-1 downto 0);

    begin
    
      CE : process(CLK, RST)
         begin
            if (RST = '1') then
                Shift_R <= "00000000000000000000000000000000";
            elsif (CLK'EVENT AND CLK = '1') then
                if (Shift_Enable = '1' AND Control_Enable = '0') then
                    Shift_R <= '0' & Shift_R(n-1 downto 1); 
                elsif (Control_Enable = '1') then
                    Shift_R <= Multiplier_in;
                end if;
            end if;
            Multiplier_out <= Shift_R;
       end process CE;
        
end Behavioral;
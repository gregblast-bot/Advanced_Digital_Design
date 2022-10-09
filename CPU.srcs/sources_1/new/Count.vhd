library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Count is
    port(
    D  : in std_logic_vector(31 downto 0);
    en : in std_logic;
    Q  : out std_logic_vector(31 downto 0)
    );
end Count;


architecture Behavioral of Count is

signal TMP : unsigned(31 downto 0) := (others => '0');

begin

process (D, en)
    begin
      --if(en = '1') then
        for i in 31 downto 0 loop
            if D(i) = '0' then
                TMP <= (others => '0');
                exit;
            else
                TMP <= TMP + 1;
            end if;
        end loop;
      --end if;
        
Q <= std_logic_vector(TMP);

end process;

end Behavioral;
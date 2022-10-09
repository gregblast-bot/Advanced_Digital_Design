-- Created: by - Gregor

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Log_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      B       : IN     std_logic_vector (n-1 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      S       : OUT    std_logic_vector (n-1 DOWNTO 0));
END Log_Unit;

ARCHITECTURE struct OF Log_Unit IS   
BEGIN
     WITH C_op SELECT S <=  A AND B  WHEN "00",
						    A OR B   WHEN "01",
						    A XOR B  WHEN "10",
						    A NOR B  WHEN "11",
						    "00000000000000000000000000000000" WHEN others;
END struct;

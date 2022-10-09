-- Created: by - Gregor

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Comp_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A31      : IN     std_logic;
      B31      : IN     std_logic;
      C_op     : IN     std_logic_vector (1 DOWNTO 0);
      CO       : IN     std_logic;
      ArithR31 : IN     std_logic;
      S        : OUT    std_logic_vector (n-1 DOWNTO 0));
END Comp_Unit;

ARCHITECTURE struct OF Comp_Unit IS   

component Arith_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      B       : IN     std_logic_vector (n-1 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      CO      : OUT    std_logic;
      OFL     : OUT    std_logic;
      S       : OUT    std_logic_vector (n-1 DOWNTO 0);
      Z       : OUT    std_logic);
END component;

signal COS, OFLS, ZS : std_logic;
signal C_opS : std_logic_vector(1 DOWNTO 0);
signal AS, BS, SS : std_logic_vector(n-1 DOWNTO 0);
signal temp : std_logic_vector(5 downto 0); 
 
BEGIN

AU0: Arith_Unit port map(
	A    => AS,
	B    => BS,
	C_op => C_opS,
	CO   => COS,
	OFL  => OFLS,
	S    => SS,
	Z    => ZS);
	
SS(31) <= ArithR31;
COS <= CO;
temp <= (C_op(1) & C_op(0) & A31 & B31 & ArithR31 & CO);

S <=  x"00000000" WHEN std_match(temp, "00----") ELSE
      x"00000000" WHEN std_match(temp, "01----") ELSE
      x"00000000" WHEN std_match(temp, "10000-") ELSE
      x"00000001" WHEN std_match(temp, "10001-") ELSE
      x"00000000" WHEN std_match(temp, "10110-") ELSE
      x"00000001" WHEN std_match(temp, "10111-") ELSE
      x"00000001" WHEN std_match(temp, "1010--") ELSE
      x"00000000" WHEN std_match(temp, "1001--") ELSE
      x"00000000" WHEN std_match(temp, "11---1") ELSE
      x"00000001" WHEN std_match(temp, "11---0") ELSE
      x"11111111";
      

--t <= ((C_op(1) AND C_op(0) AND (NOT COS)) OR (C_op(1) AND (NOT C_op(0)) AND (NOT B31) AND ArithR31)  OR (C_op(1) AND (NOT C_op(0)) AND (NOT B31) AND A31)  OR (C_op(1) AND (NOT C_op(0)) AND A31 AND ArithR31));

--S <= (0 => t, others => '0');

END struct;

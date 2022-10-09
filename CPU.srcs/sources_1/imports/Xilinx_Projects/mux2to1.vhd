LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mux2to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1         : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s              : IN STD_LOGIC ;
		  f              : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END mux2to1 ;

ARCHITECTURE Dataflow OF mux2to1 IS
	BEGIN
	
	WITH s SELECT
		f <= w0  WHEN '0',
			 w1  WHEN OTHERS ;

END Dataflow ;

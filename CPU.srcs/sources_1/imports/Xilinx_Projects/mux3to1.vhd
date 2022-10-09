LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mux3to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1, w2     : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s              : IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		  f              : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END mux3to1 ;

ARCHITECTURE Dataflow OF mux3to1 IS
	BEGIN
	
	WITH s SELECT
		f <= w0  WHEN "00",
			 w1  WHEN "01",
			 w2  WHEN OTHERS ;

END Dataflow ;

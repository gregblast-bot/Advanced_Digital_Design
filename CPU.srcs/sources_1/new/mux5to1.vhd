LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY mux5to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1, w2, w3, w4 : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s                  : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
		  f                  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END mux5to1 ;

ARCHITECTURE Dataflow OF mux5to1 IS
	BEGIN
	
	WITH s SELECT
		f <= w0  WHEN "000",
			 w1  WHEN "001",
			 w2  WHEN "010",
			 w3  WHEN "011",
			 w4  WHEN OTHERS ;

END Dataflow ;

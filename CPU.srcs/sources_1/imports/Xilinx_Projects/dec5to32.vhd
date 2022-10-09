LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY dec5to32 IS
	PORT (	w  : IN STD_LOGIC_VECTOR(4 DOWNTO 0) ;
			En : IN STD_LOGIC ;
			y  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) ) ;
END dec5to32 ;

ARCHITECTURE dataflow OF dec5to32 IS
	SIGNAL Enw : STD_LOGIC_VECTOR(5 DOWNTO 0) ;
	
BEGIN
	Enw <= En & w ;
	
	WITH Enw SELECT
		y <= "00000000000000000000000000000001" WHEN "100000",
			 "00000000000000000000000000000010" WHEN "100001",
			 "00000000000000000000000000000100" WHEN "100010",
			 "00000000000000000000000000001000" WHEN "100011",
			 "00000000000000000000000000010000" WHEN "100100",
			 "00000000000000000000000000100000" WHEN "100101",
			 "00000000000000000000000001000000" WHEN "100110",
			 "00000000000000000000000010000000" WHEN "100111",
			 "00000000000000000000000100000000" WHEN "101000",
			 "00000000000000000000001000000000" WHEN "101001",
			 "00000000000000000000010000000000" WHEN "101010",
			 "00000000000000000000100000000000" WHEN "101011",
			 "00000000000000000001000000000000" WHEN "101100",
			 "00000000000000000010000000000000" WHEN "101101",
			 "00000000000000000100000000000000" WHEN "101110",
			 "00000000000000001000000000000000" WHEN "101111",
			 "00000000000000010000000000000000" WHEN "110000",
			 "00000000000000100000000000000000" WHEN "110001",
			 "00000000000001000000000000000000" WHEN "110010",
			 "00000000000010000000000000000000" WHEN "110011",
			 "00000000000100000000000000000000" WHEN "110100",
			 "00000000001000000000000000000000" WHEN "110101",
			 "00000000010000000000000000000000" WHEN "110110",
			 "00000000100000000000000000000000" WHEN "110111",
			 "00000001000000000000000000000000" WHEN "111000",
			 "00000010000000000000000000000000" WHEN "111001",
			 "00000100000000000000000000000000" WHEN "111010",
			 "00001000000000000000000000000000" WHEN "111011",
			 "00010000000000000000000000000000" WHEN "111100",
			 "00100000000000000000000000000000" WHEN "111101",
			 "01000000000000000000000000000000" WHEN "111110",
			 "10000000000000000000000000000000" WHEN "111111",
			 "00000000000000000000000000000000" WHEN OTHERS ;
			 	 
END dataflow ;
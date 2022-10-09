LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY enableOR IS
	PORT (z, en : IN STD_LOGIC ;
		  o     : OUT STD_LOGIC) ;
END enableOR ;

ARCHITECTURE Dataflow OF enableOR IS
	BEGIN
	
	o <= z OR en;

END Dataflow ;

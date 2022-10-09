LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY zeroAND IS
	PORT (z, en : IN STD_LOGIC ;
		  o     : OUT STD_LOGIC) ;
END zeroAND ;

ARCHITECTURE Dataflow OF zeroAND IS
	BEGIN
	
	o <= NOT(z) AND en;

END Dataflow ;

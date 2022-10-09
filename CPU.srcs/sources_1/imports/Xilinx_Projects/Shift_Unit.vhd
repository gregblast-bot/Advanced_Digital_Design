-- Created: by - Gregor

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY Shift_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      S       : OUT    std_logic_vector (n-1 DOWNTO 0));
END Shift_Unit;

ARCHITECTURE struct OF Shift_Unit IS 

SIGNAL L_0 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL L_1 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL L_2 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL L_3 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL L_4 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL R_0 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL R_1 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL R_2 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL R_3 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL R_4 : std_logic_vector(n-1 DOWNTO 0);
SIGNAL Fill : std_logic_vector(n-1 downto 0);

BEGIN

	-- Left Shift Operations
	L_0 <= (A(30 DOWNTO 0) & '0') WHEN (SHAMT(0) = '1') ELSE (A); 
	L_1 <= (L_0(29 DOWNTO 0) & "00") WHEN (SHAMT(1) = '1') ELSE (L_0); 
	L_2 <= (L_1(27 DOWNTO 0) & "0000") WHEN (SHAMT(2) = '1') ELSE (L_1); 
	L_3 <= (L_2(23 DOWNTO 0) & "00000000") WHEN (SHAMT(3) = '1') ELSE (L_2); 
	L_4 <= (L_3(15 DOWNTO 0) & "0000000000000000") WHEN (SHAMT(4) = '1') ELSE (L_3); 
	
	-- Right Shift Operations
	Fill <= (others => (C_op(0) AND A(31)));
	R_0 <= (Fill(0) & A(31 DOWNTO 1)) WHEN (SHAMT(0) = '1') ELSE (A); 
	R_1 <= (Fill(1 DOWNTO 0) & R_0(31 DOWNTO 2)) WHEN (SHAMT(1) = '1') ELSE (R_0); 
	R_2 <= (Fill(3 DOWNTO 0) & R_1(31 DOWNTO 4)) WHEN (SHAMT(2) = '1') ELSE (R_1); 
	R_3 <= (Fill(7 DOWNTO 0) & R_2(31 DOWNTO 8)) WHEN (SHAMT(3) = '1') ELSE (R_2); 
	R_4 <= (Fill(15 DOWNTO 0) & R_3(31 DOWNTO 16)) WHEN (SHAMT(4) = '1') ELSE (R_3); 
	
	-- Mux for shift select
    WITH C_op SELECT S <=  L_4   WHEN "01",
                           L_4   WHEN "00",
                           R_4   WHEN "11",
						   R_4   WHEN "10",
						   "00000000000000000000000000000000" WHEN others;
						        
END struct;
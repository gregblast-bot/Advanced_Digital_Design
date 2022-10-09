-- Created: by - Gregor

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ALU is
    GENERIC (
		n       : positive := 32);
    Port ( A      : in STD_LOGIC_VECTOR(n-1 downto 0);
           B      : in STD_LOGIC_VECTOR(n-1 downto 0);
           ALUOp    : in STD_LOGIC_VECTOR(3 downto 0);
           SHAMT    : in STD_LOGIC_VECTOR(4 downto 0);
           R        : out STD_LOGIC_VECTOR(n-1 downto 0);
           Zero     : out STD_LOGIC;
           Overflow : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

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
END component ;

component Log_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      B       : IN     std_logic_vector (n-1 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      S       : OUT    std_logic_vector (n-1 DOWNTO 0));
END component;

component Shift_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A       : IN     std_logic_vector (n-1 DOWNTO 0);
      SHAMT   : IN     std_logic_vector (4 DOWNTO 0);
      C_op    : IN     std_logic_vector (1 DOWNTO 0);
      S       : OUT    std_logic_vector (n-1 DOWNTO 0));
END component;

component Comp_Unit IS
   GENERIC (
      n       : positive := 32);
   PORT( 
      A31      : IN     std_logic;
      B31      : IN     std_logic;
      C_op     : IN     std_logic_vector (1 DOWNTO 0);
      CO       : IN     std_logic;
      ArithR31 : IN     std_logic;
      S        : OUT    std_logic_vector (n-1 DOWNTO 0));
END component;

signal R0, R1, R2, R3 : std_logic_vector(n-1 DOWNTO 0);
signal ALUopS, ALUOPSS : std_logic_vector(1 DOWNTO 0);
signal COS, ArithR31S : std_logic;

begin

ALUOpS <= ALUOp(1 DOWNTO 0);
ALUOpSS <= ALUOp(3 DOWNTO 2);

AU0 : Arith_Unit port map(
		A    => A,
		B    => B,
		C_op => ALUOpS,
		CO   => COS,
		OFL  => Overflow,
		S    => R0,
		Z    => Zero);
						
LU0 : Log_Unit port map(
		A    => A,
		B    => B,
		C_op => ALUOpS,
		S    => R1);
							
SU0 : Shift_Unit port map(
		A     => B,
		SHAMT => SHAMT,
		C_op  => ALUOpS,
		S     => R2);
							
CU0 : Comp_Unit port map(
		A31       => A(n-1),
		B31       => B(n-1),
		C_op      => ALUOpS,
		CO        => COS,
		ArithR31  => ArithR31S,
		S         => R3);
						
WITH ALUOpSS SELECT R <= R0 WHEN "01",
	                     R1 WHEN "00",
						 R2 WHEN "11",
						 R3 WHEN "10",
						 "00000000000000000000000000000000" WHEN others;

end Behavioral;

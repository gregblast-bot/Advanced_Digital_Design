LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity DataPath is
    GENERIC(
           n : positive := 32);
    Port ( A              : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           B              : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           clk            : in STD_LOGIC;
           rst            : in STD_LOGIC := '0';
           R              : out STD_LOGIC_VECTOR(63 DOWNTO 0);
           done           : out STD_LOGIC := '0');
end DataPath;

architecture Behavioral of DataPath is

component Multiplicand is
    GENERIC(
           n : positive := 64);
    Port ( Multiplicand_in      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Control_Enable       : in STD_LOGIC;
           Shift_Enable         : in STD_LOGIC;
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Multiplicand_out     : out STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end component;

component Multiplier is
    GENERIC(
           n : positive := 32);
    Port ( Multiplier_in        : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Control_Enable       : in STD_LOGIC;
           Shift_Enable         : in STD_LOGIC;
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Multiplier_out       : out STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end component;

component Adder is
    GENERIC(
           n : positive := 64);
    Port ( Multiplicand_out     : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Intermediate_Product : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Product_out          : out STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end component;

component Product is
    GENERIC(
           n : positive := 64);
    Port ( Product              : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           Control_Enable       : in STD_LOGIC;
           CLK                  : in STD_LOGIC;
           RST                  : in STD_LOGIC;
           Intermediate_Product : out STD_LOGIC_VECTOR(n-1 DOWNTO 0));
end component;

component ControlUnit is
    generic(
        n : positive := 64);
	port(
	    B_LSB        : in   std_logic;
		CLK		     : in	std_logic;
		RST		     : in	std_logic;
		load		 : out	std_logic;
		shift        : out  std_logic;
		add          : out  std_logic;
		done     	 : out	std_logic);
end component;

signal R0, R3, R4, Multiplicands : std_logic_vector(63 DOWNTO 0);
signal R1 : std_logic_vector(31 DOWNTO 0);
signal loads, shifts, adds, dones : std_logic;

begin
Multiplicands <= "00000000000000000000000000000000" & A;
done <= dones;

Multc0 : Multiplicand port map(
            Multiplicand_in  => Multiplicands,
            Control_Enable   => loads,
            Shift_Enable     => shifts,
            CLK              => CLK,
            RST              => RST,
            Multiplicand_out => R0);
            
Multp0 : Multiplier port map(
            Multiplier_in    => B,
            Control_Enable   => loads,
            Shift_Enable     => shifts,
            CLK              => CLK,
            RST              => RST,
            Multiplier_out   => R1);
            
ADD0 : Adder port map(
            Multiplicand_out     => R0,
            Intermediate_Product => R3,
            CLK                  => CLK,
            RST                  => RST,
            Product_out          => R4);
            
P0 : Product port map(
            Product              => R4,
            Control_Enable       => adds,
            CLK                  => CLK,
            RST                  => RST,
            Intermediate_Product => R3);
        
C0 : ControlUnit port map(
           B_LSB          => R1(0), --Change to B(0) and fix CU when you look at this again idiot
           CLK            => CLK,
           RST            => RST,
           load           => loads,
           shift          => shifts,
           add            => adds,
           done           => dones);
            
           WITH dones SELECT R <= R3 WHEN '1',
           "0000000000000000000000000000000000000000000000000000000000000000" WHEN OTHERS;

end Behavioral;

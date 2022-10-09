LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity CPU is
    GENERIC(
           n : positive := 32);
    Port ( Reset              : in STD_LOGIC := '0';
           Clock              : in STD_LOGIC;
           MemoryDataIn       : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           MemoryAddress      : out STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           MemoryDataOut      : out STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           MemWrite           : out STD_LOGIC);
end CPU;

architecture Behavioral of CPU is

component DataPathCPU is
    GENERIC(
           n : positive := 32);
    Port ( Reset : in STD_LOGIC;
           Clock : in STD_LOGIC;
           MemoryDataIn : in STD_LOGIC_VECTOR (31 downto 0);
           MemoryAddress : out STD_LOGIC_VECTOR (31 downto 0);
           MemoryDataOut : out STD_LOGIC_VECTOR (31 downto 0);
           MemWrite : out STD_LOGIC);
end component;

begin

DP : DataPathCPU PORT MAP( 
			Reset         => Reset,
			Clock         => Clock, 
			MemoryDataIn  => MemoryDataIn,
			MemoryAddress => MemoryAddress,
			MemoryDataOut => MemoryDataOut,
			MemWrite      => MemWrite);
						            
end Behavioral;    

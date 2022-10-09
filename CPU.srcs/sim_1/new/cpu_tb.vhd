LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb;

architecture sim of cpu_tb is

component CPU_memory is
   PORT( 
      Clk      : IN     std_logic;
      MemWrite : IN     std_logic;
      addr     : IN     std_logic_vector (31 DOWNTO 0);
      dataIn   : IN     std_logic_vector (31 DOWNTO 0);
      dataOut  : OUT    std_logic_vector (31 DOWNTO 0)
   );
END component ; 

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

--control signals
signal MemWrites : std_logic := '0';
signal clock, reset : std_logic := '0';

--intermediate signals
signal PCmuxs, MO, MI : std_logic_vector(31 downto 0);

begin

U_1 : CPU_memory PORT MAP( 
			Clk      => clock,
			MemWrite => MemWrites, --control
			addr     => PCmuxs, --From PC/mux
			dataIn   => MI,
			dataOut  => MO);
			
U_0 : DataPathCPU PORT MAP( 
			Reset         => reset,
			Clock         => clock, 
			MemoryDataIn  => MO,
			MemoryAddress => PCmuxs,
			MemoryDataOut => MI,
			MemWrite      => MemWrites);
						
--U_1 : CPU_memory PORT MAP( 
--			Clk      => clk,
--			MemWrite => MemWrites, --control
--			addr     => PCmuxs, --From PC/mux
--			dataIn   => MEMDO,
--			dataOut  => MemoryData);
			
--DP : DataPathCPU PORT MAP( 
--			Instruction   => dataOut,
--			clock         => clk, 
--			reset         => reset,
--			MemAddress    => PCmuxs,
--			MEMDO         => dataIn,
--			MW            => MemWrites);
						            
end sim;    


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;
use ieee.std_logic_unsigned.all;

entity RegFile_tb is
end RegFile_tb;

architecture sim of RegFile_tb is

component RegFile is
    GENERIC(
           n : positive := 32) ;
    Port ( ReadReg1			: in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
		   ReadReg2 		: in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
		   WriteReg 		: in STD_LOGIC_VECTOR(4 DOWNTO 0) ;
		   WriteData		: in STD_LOGIC_VECTOR(31 DOWNTO 0) ;
           Control_Enable   : in STD_LOGIC ;
           CLK              : in STD_LOGIC ;
           RST              : in STD_LOGIC ;
           ReadData1        : out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0') ;
           ReadData2        : out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0')) ;
end component ;

constant n : positive := 32;
signal ReadReg1s : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
signal ReadReg2s : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
signal WriteRegs : STD_LOGIC_VECTOR(4 DOWNTO 0) ;
signal WriteDatas : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
signal CLKs : STD_LOGIC := '0';
signal en, RSTs : STD_LOGIC ;
signal ReadData1s : STD_LOGIC_VECTOR(31 DOWNTO 0) ;
signal ReadData2s : STD_LOGIC_VECTOR(31 DOWNTO 0) ;

begin

R0 : RegFile 
    GENERIC MAP(
           n => n
    ) 
    Port MAP ( ReadReg1  => ReadReg1s,
               ReadReg2  => ReadReg2s,
               WriteReg  => WriteRegs,
               WriteData => WriteDatas,
               Control_Enable => en,
               CLK => CLKs,
               RST => RSTs,
               ReadData1 => ReadData1s,
               ReadData2 => ReadData2s
    );

CLKs <= not CLKs after 5ns;	

process
-- seed values for random generator
variable seed1, seed2: positive;
-- random real-number value in range 0 to 1.0
variable rand1, rand2, rand3: real;
-- the range of random values created will be 0 to 2^31-1. 
variable range_of_rand1 : real := real(2**31-1);
variable range_of_rand2 : real := real(2**4-1);

    begin
    
    report "RegFile Test Begin";
        for i in 0 to 31 loop
             -- generate random number
            uniform(seed1, seed2, rand1);
            uniform(seed1, seed2, rand2);
            uniform(seed1, seed2, rand3);
            -- rescale to 0..2^31-1, convert integer part
            wait for 10 ns;
                en <= '1';
                WriteDatas <= std_logic_vector(to_unsigned(integer(rand1*range_of_rand1), n));
                ReadReg1s <= std_logic_vector(to_unsigned(integer(rand1*range_of_rand2), 5));
                ReadReg2s <= std_logic_vector(to_unsigned(integer(rand2*range_of_rand2), 5));
                WriteRegs <= std_logic_vector(to_unsigned(integer(rand3*range_of_rand2), 5));
            wait for 10 ns; 
        end loop;  -- i
    report "RegFile Test FINISHED!";
    
        report "RegFile Reset Test Begin";
        for i in 0 to 31 loop
             -- generate random number
            uniform(seed1, seed2, rand1);
            uniform(seed1, seed2, rand2);
            uniform(seed1, seed2, rand3);
            -- rescale to 0..2^31-1, convert integer part
            wait for 10 ns;
                en <= '1';
                RSTs <= '1';
                WriteDatas <= std_logic_vector(to_unsigned(integer(rand1*range_of_rand1), n));
                ReadReg1s <= std_logic_vector(to_unsigned(integer(rand1*range_of_rand2), 5));
                ReadReg2s <= std_logic_vector(to_unsigned(integer(rand2*range_of_rand2), 5));
                WriteRegs <= std_logic_vector(to_unsigned(integer(rand3*range_of_rand2), 5));
            wait for 10 ns; 
        end loop;  -- i
    report "RegFile Reset Test FINISHED!";

    wait;
end process;
end sim;

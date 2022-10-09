LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity DataPathCPU is
    GENERIC(
           n : positive := 32);
    Port ( Reset : in STD_LOGIC;
           Clock : in STD_LOGIC;
           MemoryDataIn : in STD_LOGIC_VECTOR (31 downto 0);
           MemoryAddress : out STD_LOGIC_VECTOR (31 downto 0);
           MemoryDataOut : out STD_LOGIC_VECTOR (31 downto 0);
           MemWrite : out STD_LOGIC);
end DataPathCPU;

architecture Behavioral of DataPathCPU is

component InstructionReg is
    GENERIC(
           n : positive := 32) ;
    Port ( RegIn            : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable   : in STD_LOGIC ;
           CLK              : in STD_LOGIC ;
           RST              : in STD_LOGIC ;
           RegOut0          : out STD_LOGIC_VECTOR(5 DOWNTO 0)  := "000000" ;
           RegOut1          : out STD_LOGIC_VECTOR(4 DOWNTO 0)  := "00000" ;
           RegOut2          : out STD_LOGIC_VECTOR(4 DOWNTO 0)  := "00000" ;
           RegOut3          : out STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000" ;
           RegOut4          : out STD_LOGIC_VECTOR(25 DOWNTO 0) := "00000000000000000000000000") ;
end component ;

component Reg is
    GENERIC(
           n : positive := 32) ;
    Port ( RegIn           : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           Control_Enable  : in STD_LOGIC ;
           CLK             : in STD_LOGIC ;
           RST             : in STD_LOGIC ;
           RegOut          : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end component ;

component mux2to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1         : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s              : IN STD_LOGIC ;
		  f              : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END component ;

component RegFile is
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

component SignExtend is
    Port ( DataIn      : in STD_LOGIC_VECTOR(15 DOWNTO 0);
           DataOut     : out STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0'));
end component;

component ShiftLeft2 is
    GENERIC(
           n : positive := 32);
    Port ( DataIn      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           DataOut     : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end component ;

component mux4to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1, w2, w3 : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s              : IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		  f              : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END component ;

component ALU is
    GENERIC (
		n       : positive := 32);
    Port ( A        : in STD_LOGIC_VECTOR(n-1 downto 0);
           B        : in STD_LOGIC_VECTOR(n-1 downto 0);
           ALUOp    : in STD_LOGIC_VECTOR(3 downto 0);
           SHAMT    : in STD_LOGIC_VECTOR(4 downto 0);
           R        : out STD_LOGIC_VECTOR(n-1 downto 0);
           Zero     : out STD_LOGIC;
           Overflow : out STD_LOGIC);
end component;

component ShiftLeft2Extend is
    GENERIC(
           n : positive := 26);
    Port ( DataIn      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
           DataOut     : out STD_LOGIC_VECTOR(n+1 DOWNTO 0) := (others => '0')) ;
end component ;

component PCAppend is
    GENERIC(
           n : positive := 32);
    Port ( DataIn1      : in STD_LOGIC_VECTOR(27 DOWNTO 0) ;
		   DataIn2      : in STD_LOGIC_VECTOR(31 DOWNTO 28) ;
           DataOut      : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
end component ;

component mux3to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1, w2     : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s              : IN STD_LOGIC_VECTOR(1 DOWNTO 0) ;
		  f              : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END component ;

--component Add4 is
--    GENERIC(
--           n : positive := 32);
--    Port ( DataIn      : in STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
--           DataOut     : out STD_LOGIC_VECTOR(n-1 DOWNTO 0) := (others => '0')) ;
--end component ;

component zeroAND IS
	PORT (z, en : IN STD_LOGIC ;
		  o     : OUT STD_LOGIC) ;
END component ;

component enableOR IS
	PORT (z, en : IN STD_LOGIC ;
		  o     : OUT STD_LOGIC) ;
END component ;

component OutputsControl is
    generic(
        n : positive := 64);
	port(
	    Instruction  : in   std_logic_vector(31 downto 0);
		CLK		     : in	std_logic;
		RST		     : in	std_logic := '0';
		MemWrite	 : out	std_logic;
		MemtoReg     : out  std_logic_vector(2 downto 0);
		IRWrite      : out  std_logic;
		RegDst     	 : out	std_logic;
		RegWrite     : out	std_logic;
		ALUSrcA      : out	std_logic;
		ALUSrcB      : out	std_logic_vector(1 downto 0);
		ALUOp     	 : out	std_logic_vector(3 downto 0);
		PCSrc     	 : out	std_logic_vector(1 downto 0);
		PCWriteCond  : out	std_logic;
		PCWrite      : out	std_logic;
		IorD     	 : out	std_logic;
		SHAMT        : out  std_logic_vector(1 downto 0);
		Load         : out 	std_logic_vector(1 downto 0);
		Count        : out  std_logic;
		mreset       : out  std_logic);
end component;

component DataPath is
    GENERIC(
           n : positive := 32);
    Port ( A              : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           B              : in STD_LOGIC_VECTOR(n-1 DOWNTO 0);
           clk            : in STD_LOGIC;
           rst            : in STD_LOGIC := '0';
           R              : out STD_LOGIC_VECTOR(63 DOWNTO 0);
           done           : out STD_LOGIC := '0');
end component;

component Count is
    port(
    D  : in std_logic_vector(31 downto 0);
    en : in std_logic;
    Q  : out std_logic_vector(31 downto 0)
    );
end component;

component mux5to1 IS
	GENERIC(
		n : positive := 32) ;
	PORT (w0, w1, w2, w3, w4 : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0) ;
		  s                  : IN STD_LOGIC_VECTOR(2 DOWNTO 0) ;
		  f                  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) ) ;
END component ;

--control signals
signal MemWrites, IRWrites, RegDsts, RegWrites, branch, ALUens, dones, Counts : std_logic;
signal ALUSrcAs, Zeros, Overflows, PCWriteConds, PCWrites, PCen, IorDs, mresets : std_logic;
signal ALUSrcBs, PCSources, Loads, SHAMTs : std_logic_vector(1 downto 0);
signal MemtoRegs : std_logic_vector(2 downto 0); 
signal ALUOps : std_logic_vector(3 downto 0);
--signal SHAMTs : std_logic_vector(4 downto 0);
signal Rs : std_logic_vector(31 downto 0);

--intermediate signals
signal RM : std_logic_vector(63 downto 0);
signal RMH, RML : std_logic_vector(31 downto 0);
signal PCmuxs, M1, WD, RD1, RD2 : std_logic_vector(31 downto 0);
--signal RD1O, RD2O : std_logic_vector(31 downto 0);
--signal M0 : std_logic_vector(31 downto 0);
signal SEs, SLs, A, B, Results, PCins, PCAs : std_logic_vector(31 downto 0);
signal PCs, MemoryDataIns, LW, LH, LB, CountOut : std_logic_vector(31 downto 0);
signal I0 : std_logic_vector(5 downto 0);
signal I1, I2, WR, SA : std_logic_vector(4 downto 0);
signal I3 : std_logic_vector(15 downto 0);
signal I4 : std_logic_vector(25 downto 0);
signal SLEs : std_logic_vector(27 downto 0);


begin

LW <= MemoryDataIn;
LH <= (("00000000000000001111111111111111") AND MemoryDataIn);
LB <= (("00000000000000000000000011111111") AND MemoryDataIn);
muxLoads : mux3to1 PORT MAP( 
			w0     => LW,
			w1     => LH,
			w2     => LB,
			s      => Loads, --control
			f      => MemoryDataIns); 

Countthing : Count PORT MAP(
             D  => MemoryDataIn,
             en => Counts,
             Q  => CountOut);
    						
MDReg : Reg PORT MAP( 
			RegIn          => MemoryDataIns,
			Control_Enable => '1', --control always
			CLK            => Clock,
			RST            => Reset,
			RegOut         => M1);

IReg : InstructionReg PORT MAP( 
			RegIn  			=> MemoryDataIns,       
            Control_Enable  => IRWrites, --control
            CLK             => Clock,
            RST             => Reset,
			RegOut0         => I0,
            RegOut1         => I1,
            RegOut2         => I2,
            RegOut3			=> I3,
            RegOut4         => I4);
            
mux0 : mux2to1 
	GENERIC MAP (5)
	PORT MAP( 
			w0     => I2,
			w1     => I3(15 downto 11),
			s      => RegDsts, --control
			f      => WR);
			
--mux1 : mux2to1 PORT MAP( 
--			w0     => Results,
--			w1     => M1,
--			s      => MemtoRegs, --control
--			f      => WD);
		
--mux1 : mux4to1 PORT MAP( 
--			w0     => Results,
--			w1     => M1,
--			w2     => RMH,
--			w3     => RML,
--			s      => MemtoRegs, --control
--			f      => WD);  

mux1 : mux5to1 PORT MAP( 
			w0     => Results,
			w1     => M1,
			w2     => RMH,
			w3     => RML,
			w4     => CountOut,
			s      => MemtoRegs, --control
			f      => WD);   

						
RF : RegFile PORT MAP( 			
			ReadReg1        => I1,		
            ReadReg2 	    => I2,
		    WriteReg        => WR,
            WriteData	    => WD,
            Control_Enable  => RegWrites, --control
            CLK             => Clock,
            RST             => Reset,
            ReadData1       => RD1,
            ReadData2       => RD2);
    
SE : SignExtend PORT MAP( 
			DataIn     => I3,
			DataOut     => SEs);    

SL : ShiftLeft2 PORT MAP( 
			DataIn     => SEs,
			DataOut     => SLs); 

--AReg : Reg PORT MAP( 
--			RegIn          => RD1,
--			Control_Enable => '1', --control always
--			CLK            => Clock,
--			RST            => Reset,
--			RegOut         => RD1O);
			
--BReg : Reg PORT MAP( 
--			RegIn          => RD2,
--			Control_Enable => '1', --control always
--			CLK            => Clock,
--			RST            => Reset,
--			RegOut         => RD2);
			    
mux3 : mux2to1 PORT MAP( 
			w0     => PCs,
			w1     => RD1,
			s      => ALUSrcAs, --control
			f      => A);    
    
mux4 : mux4to1 PORT MAP( 
			w0     => RD2,
			w1     => "00000000000000000000000000000100",
			w2     => SEs,
			w3     => SLs,
			s      => ALUSrcBs, --control
			f      => B);    
    
SLE : ShiftLeft2Extend PORT MAP( 
			DataIn      => I4,
			DataOut     => SLEs);  
						
PCA : PCAppend PORT MAP( 
			DataIn1     => SLEs,
			DataIn2     => PCs(31 downto 28),
			DataOut     => PCAs);    

--muxSHAMT : mux2to1 
--	GENERIC MAP (5)
--	PORT MAP( 
--			w0     => I3(10 downto 6),
--			w1     => RD2(4 downto 0),
--			s      => SHAMTs, --control
--			f      => SA);

muxSHAMT : mux3to1 
    GENERIC MAP (5)
    PORT MAP( 
			w0     => I3(10 downto 6),
			w1     => RD2(4 downto 0),
			w2     => "10000",
			s      => SHAMTs, --control
			f      => SA); 
						  
ALU0 : ALU PORT MAP(
		A         => A,   
        B         => B,
        ALUOp     => ALUOps, --control
        SHAMT     => SA, --shift
        R         => Rs,     
        Zero      => Zeros,  
        Overflow  => Overflows); 
 
MULTU : DataPath PORT MAP(
        A         => A,
        B         => B,
        clk       => Clock,
        rst       => mresets,
        R         => RM,
        done      => dones);
        
ALUReg : Reg PORT MAP( 
			RegIn          => Rs,
			Control_Enable => '1', --control
			CLK            => Clock,
			RST            => Reset,
			RegOut         => Results);  --tie to MemDataOut  

MultHReg : Reg PORT MAP( 
			RegIn          => RM(63 downto 32),
			Control_Enable => dones, --control
			CLK            => Clock,
			RST            => Reset,
			RegOut         => RMH); 
			
MultLReg : Reg PORT MAP( 
			RegIn          => RM(31 downto 0),
			Control_Enable => '1', --control
			CLK            => Clock,
			RST            => Reset,
			RegOut         => RML); 
						
mux5 : mux3to1 PORT MAP( 
			w0     => Rs,
			w1     => Results,
			w2     => PCAs,
			s      => PCSources, --control
			f      => PCins); 
						
--A4 : Add4 PORT MAP( 
--			DataIn      => Results,
--			DataOut     => Finals); 
			
ZA : zeroAND PORT MAP( 
			z     => Zeros,
			en    => PCWriteConds,
			o     => branch); 

EO : enableOR PORT MAP( 
			z     => branch,
			en    => PCWrites,
			o     => PCen); 	

PCReg : Reg PORT MAP( 
			RegIn          => PCins,
			Control_Enable => PCen, --control
			CLK            => Clock,
			RST            => Reset,
			RegOut         => PCs);   

mux6 : mux2to1 PORT MAP( 
			w0     => PCs,
			w1     => Results,
			s      => IorDs, --control
			f      => PCmuxs); --tie to MemoryAddress

OC : OutputsControl PORT MAP(
	    Instruction => MemoryDataIn, 
		CLK		    => Clock,
		RST		    => Reset, 
		MemWrite	=> MemWrites, --tie to MemWrite
		MemtoReg    => MemtoRegs, 
		IRWrite     => IRWrites, 
		RegDst     	=> RegDsts, 
		RegWrite    => RegWrites, 
		ALUSrcA     => ALUSrcAs,
		ALUSrcB     => ALUSrcBs,
		ALUOp     	=> ALUops, 
		PCSrc     	=> PCSources, 
		PCWriteCond => PCWriteConds, 
		PCWrite     => PCWrites, 
		IorD     	=> IorDs,
		SHAMT       => SHAMTs,
		Load        => Loads,
		Count       => Counts,
		mreset      => mresets);	

MemoryAddress <= PCmuxs;
MemoryDataOut <= RD2; --RD2
MemWrite <= MemWrites;

end Behavioral;

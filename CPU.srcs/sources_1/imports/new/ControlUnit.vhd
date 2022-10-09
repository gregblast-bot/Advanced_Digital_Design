-- A Moore machine's outputs are dependent only on the current state.
-- The output is written only when the state changes.  (State
-- transitions are synchronous.)

library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ControlUnit is
    generic(
        n : positive := 64);
	port(
	    B_LSB        : in   std_logic;
		CLK		     : in	std_logic;
		RST		     : in	std_logic := '0';
		load		 : out	std_logic;
		shift        : out  std_logic;
		add          : out  std_logic;
		done     	 : out	std_logic
	);
	
end entity;

architecture Behavioral of ControlUnit is

	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4);
	
	-- Register to hold the current state
	signal state   : state_type;
	signal counter : std_logic_vector(4 downto 0);

begin
	-- Logic to advance to the next state
	process (CLK, RST)
	begin
		if RST = '1' then -- reset
			state <= s0;
		elsif (rising_edge(CLK)) then
			case state is
				when s0 => -- when start next check LSB
						state <= s1;
				when s1 =>
				    if (counter = "11111") then -- if counter = 32, done
						state <= s2;
			        else
                        if (B_LSB = '1') then -- when LSB of multiplier 1, next add 
                            state <= s2; --add
                        else -- when LSB of multiplier 0, next shift 
                            state <= s3;
                        end if;
                    end if;
			    when s2 => -- when add, next shift
			      if (counter = "11111") then -- if counter = 32, done
						state <= s4;
				  else
				        state <= s3;
				  end if;
				when s3 => -- when shift, check counter
					 -- when counter != 32, check LSB 
						state <= s1;		
				when s4 =>
				    if (RST = '1') then
				        state <= s0;
				    else
				        state <= s4;
				    end if;
				when OTHERS => state <= s0;
			end case;
		end if;
	end process;
	
	-- Output depends solely on the current state
	process (state)
	begin
	
		case state is
			when s0 => -- start
			    counter <= "00000";
                done  <= '0';
                load  <= '1';
                add   <= '0';
                shift <= '0';
			when s1 => -- check LSB
                done  <= '0';
                load  <= '0';
                add   <= '0';
                shift <= '0';
			when s2 => -- add
                done  <= '0';
                load  <= '0';
                add   <= '1';
                shift <= '0';
			when s3 => -- shift
			    counter <= counter + 1;
                done  <= '0';
                load  <= '0';
                add   <= '0';
                shift <= '1';
			when s4 => -- done
                done  <= '1';
                load  <= '0';
                add   <= '0';
                shift <= '0';
				
		end case;
	end process;
	
end Behavioral;
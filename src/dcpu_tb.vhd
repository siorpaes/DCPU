-- DCPU Test Bench
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dcpu_tb is
end entity dcpu_tb;

architecture behaviour of dcpu_tb is

signal clock : std_logic := '0';
signal reset : std_logic := '1';

begin

  -- Instantiate DCPU Top
	DCPUTOP: entity work.dcpu_top
	port map(
	clock => clock,
	reset => reset
	);
	
	-- Drive clock
	process  
	begin    
	  loop
	    clock <= '0';
	    WAIT FOR 10 ns;
	    clock <= '1';
	    WAIT FOR 10 ns;
	  end loop;
	end process;

	-- Drive reset
	process
	begin
		reset <= '1';
		wait for 5us;
		reset <= '0';
		wait for 6us;
		reset <= '1';
		wait;
	end process;	
	
end architecture behaviour;

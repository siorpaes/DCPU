-- DCPU Top
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dcpu_top is
generic (CLK_DIVISOR :  POSITIVE := 10000);
port(
	clock    : in std_logic;
	reset    : in std_logic;
	outport  : out std_logic_vector(7 downto 0)
);
end entity dcpu_top;

architecture behaviour of dcpu_top is

  signal r_data_in  : std_logic_vector (7 downto 0) := (others => '0');
  signal r_data_out : std_logic_vector (7 downto 0) := (others => '0');
  signal r_addr     : std_logic_vector (5 downto 0) := (others => '0');
  signal r_we       : std_logic := '0';
  signal r_clock    : std_logic := '0';
  signal r_reset    : std_logic := '0';
  signal r_outport  : std_logic_vector(7 downto 0);
begin
  -- Instantiate DCPU
  DCPU: entity work.dcpu
  port map(
  clock     => r_clock,
  reset     => r_reset,
  data_out  => r_data_out,
  data_in   => r_data_in,
  addr      => r_addr,
  we        => r_we,
  outport   => r_outport
  );

  -- Instantiate SRAM
  SRAM: entity work.ssram
  port map(
  clock     => r_clock,
  addr      => r_addr,
  data_in   => r_data_out, -- DCPU data_out is SRAM data_in
  data_out  => r_data_in,  -- DCPU data_in is SRAM data_out
  we        => r_we
  );

  r_reset <= reset;
  r_clock <= clock;
  outport <= r_outport;

end architecture behaviour;

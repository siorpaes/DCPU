-- Simple SRAM implementation
-- See iCEcube2_userguide.pdf for Lattice details

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ssram is
port(
  clk       : in  std_logic;                     -- Clock
  addr      : in  std_logic_vector(5 downto 0);  -- Address
  data_out  : out std_logic_vector(7 downto 0);   -- Data Out 
  data_in   : in  std_logic_vector(7 downto 0);  -- Data In
  we        : in  std_logic                     -- Write Enable, active high
);
end ssram;

architecture Behavioral of ssram is

type memory_array is array(0 to 63) of std_logic_vector(7 downto 0);
signal memory : memory_array := (
  x"3e",x"7f",x"bb",x"c1",x"3e",x"7a",x"7f",x"ba",x"39",x"bc",x"c0",x"c0",x"00",x"00",x"00",x"00", -- blinky
--  x"3e",x"7f",x"bc",x"c1",x"c0",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00", -- gpio
--  x"3e",x"46",x"7e",x"86",x"c0",x"c5",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00", -- rwloop
--  x"0a",x"0b",x"88",x"0d",x"0e",x"c0",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00", -- STA test
  x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
  x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
  x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"fe",x"00",x"00",x"00",x"00",x"ff",x"01"
);

-- Infer Block RAM for iCE40 Lattice FPGA
attribute syn_ramstyle : string;
attribute syn_ramstyle of memory : signal is "block_ram";
--attribute syn_ramstyle: string;
--attribute syn_ramstyle of memory: signal is "no_rw_check";

--Infer Block RAM for Xilinx FPGA                   
attribute ram_style : string;
attribute ram_style of memory : signal is "block";
--attribute ram_style of memory : signal is "distributed";

begin

process(clk)
begin
  if rising_edge(clk) then
	  -- Write memory
	  if(we = '1') then
      memory(to_integer(unsigned(addr))) <= data_in;
    end if;
	
	  -- Synchronous Read
    data_out <= memory(to_integer(unsigned(addr)));
	end if;
end process;

end Behavioral;
-- Simple SRAM implementation
-- See iCEcube2_userguide.pdf for Lattice details

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ssram is
port(
  clock     : in  std_logic;                     -- Clock
  addr      : in  std_logic_vector(5 downto 0);  -- Address
  data_out  : out std_logic_vector(7 downto 0);  -- Data Out 
  data_in   : in  std_logic_vector(7 downto 0);  -- Data In
  we        : in  std_logic                      -- Write Enable, active high
);
end ssram;

architecture Behavioral of ssram is

type memory_array is array(0 to 63) of std_logic_vector(7 downto 0);
signal memory : memory_array := (
  -- Low memory. Contains program
  x"e1",x"e1",x"e0",x"00",x"e0",x"01",x"66",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
  x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
  -- Hi memory. Contains data
  x"da",x"ba",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",
  x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"fe",x"00",x"00",x"00",x"00",x"00",x"00"
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

process(clock)
begin
  if rising_edge(clock) then
	  -- Write memory
	  if(we = '1') then
      memory(to_integer(unsigned(addr))) <= data_in;
    end if;
	
	  -- Synchronous Read
    data_out <= memory(to_integer(unsigned(addr)));
	end if;
end process;

end Behavioral;

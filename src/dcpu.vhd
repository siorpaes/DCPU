-- Dumb CPU
-- david.siorpaes@gmail.com

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dcpu is
port(
  reset     : in   std_logic;                     -- Reset
  clock     : in   std_logic;                     -- Clock
  addr      : out  std_logic_vector(5 downto 0);  -- Address
  data_out  : out  std_logic_vector(7 downto 0);  -- Data Out 
  data_in   : in   std_logic_vector(7 downto 0);  -- Data In
  we        : out  std_logic                      -- Write Enable, active high
);
end dcpu;

architecture Behavioral of dcpu is

--DCPU internal signals
signal accu     : std_logic_vector(8 downto 0) := (others => '0');
signal pc       : std_logic_vector(4 downto 0) := (others => '0');
signal prg_data : std_logic := '1'; -- Selects whether instruction or data are being fetched: 1 program, 0 data

-- DCPU State Machine
type state is (IDLE, RST, EXEC, BLOAD, LOAD, BSTORE, STORE);
signal dcpustate : state := IDLE;

begin
  process(clock)
  begin
    if rising_edge(clock) then
      if(reset = '0') then
        dcpustate <= RST;
        addr      <= (others => '0');
        data_out  <= (others => '0');
        accu      <= (others => '0');
        pc        <= (others => '0');
        we        <= '0';
        prg_data  <= '1'; --fetching instructions
      else
        -- DCPU implementation
        case dcpustate is
          when RST =>
            dcpustate <= EXEC;
            pc <= pc + 1;
            prg_data <= '1';
            we <= '0';
          when EXEC =>
            -- Instruction decoding and execution
            case data_in(7 downto 5) is
              when "000" => -- LDA
                prg_data <= '0';
                we <= '0';
                dcpustate <= BLOAD;
              when "001" => -- STA
                prg_data <= '0';
                data_out <= accu(7 downto 0);
                we <= '1';
                dcpustate <= STORE;
              when "010" => -- LDX
              when "011" => -- JMP
                prg_data <= '1';
                pc <= data_in(4 downto 0);
                dcpustate <= EXEC;
                we <= '0';
              when "100" => -- BEQ
              when "101" => -- BNE
              when "110" => -- TBD
              -- All other instructions not needing address
              when "111" =>
                prg_data <= '1';
                dcpustate <= EXEC;
                pc <= pc + 1;
                accu <= accu + 1;
                we <= '0';
              end case;
        end case;
      end if;
    end if;
  end process;

  -- address line is assigned program counter if dealing with instruction
  -- address line is assigned input data if dealing with loads/stores
  addr <= '0' & pc      when (prg_data = '1') else
          '1' & data_in; 
end Behavioral;

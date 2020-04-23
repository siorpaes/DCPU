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
  we        : out  std_logic;                     -- Write Enable, active high
  outport   : out  std_logic_vector(7 downto 0)   -- Data Output port
);
end dcpu;

architecture Behavioral of dcpu is

--DCPU internal signals
signal accu      : std_logic_vector(7 downto 0) := (others => '0');
signal xreg      : std_logic_vector(7 downto 0) := (others => '0');
signal pc        : std_logic_vector(4 downto 0) := (others => '0');
signal data_addr : std_logic_vector(4 downto 0) := (others => '0');  -- load/store address argument
signal prg_data  : std_logic := '1'; -- Selects whether instruction or data are being fetched: 1 program, 0 data
signal lda_ldx   : std_logic := '1'; -- Selects whether Accumulator or X register are being loaded

-- DCPU State Machine
type state is (IDLE, RST, EXEC, BLOAD, LOAD, STORE, BUBBLE);
signal dcpustate : state := IDLE;

begin
  process(clock)
  begin
    if rising_edge(clock) then
      if(reset = '0') then
        dcpustate <= RST;
        data_out  <= (others => '0');
        accu      <= (others => '0');
        xreg      <= (others => '0');
        lda_ldx   <= '1';
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
              when "000" | "010" => -- LDA, LDX
                data_addr <= data_in(4 downto 0); -- Take data address
                prg_data <= '0';
                we <= '0';
                -- LDA or LDX
                if data_in(7 downto 5) = "000" then
                    lda_ldx <= '1';
                else
                    lda_ldx <= '0';
                end if;
                dcpustate <= BLOAD;
              when "001" => -- STA
                data_addr <= data_in(4 downto 0); -- Take data address
                prg_data <= '0';
                data_out <= accu;
                we <= '1';
                dcpustate <= STORE;
              when "011" => -- JMP
                prg_data <= '1';
                pc <= data_in(4 downto 0);
                dcpustate <= BUBBLE;
                we <= '0';
              when "100" => -- BNE
                prg_data <= '1';
                if(accu /= xreg) then
                    pc <= data_in(4 downto 0);
                    dcpustate <= BUBBLE;
                else
                    pc <= pc + 1;
                    dcpustate <= EXEC;
                end if;
              when "101" => -- BEQ
                prg_data <= '1';
                if(accu = xreg) then
                    pc <= data_in(4 downto 0);
                    dcpustate <= BUBBLE;
                else
                    pc <= pc + 1;
                    dcpustate <= EXEC;
                end if;
              when "110" => -- TBD

              -- All other instructions *not* needing address
              when "111" =>
                prg_data <= '1';
                pc <= pc + 1;
                we <= '0';
                dcpustate <= EXEC;
                case data_in(4 downto 0) is
                  when "00000" => -- ZEA
                    accu <= (others => '0');
                  when "00001" => -- INC
                    accu <= accu + 1;
                  when "00010" => -- DTO
                    outport <= accu;
                  when others =>
                    dcpustate <= IDLE;
                  end case;
              when others =>
                dcpustate <= IDLE;
              end case;

          -- Bubble Load
          when BLOAD =>
            prg_data <= '1'; -- Put back addr to PC
            dcpustate <= LOAD;

          -- Load Accumulator or X register with input data
          when LOAD =>
            if lda_ldx = '1' then
                accu <= data_in;
            else
                xreg <= data_in;
            end if;
            prg_data <= '1';
            pc <= pc + 1;
            dcpustate <= EXEC;

          when BUBBLE =>
            pc <= pc + 1;
            dcpustate <= EXEC;

          when STORE =>
            prg_data <= '1';
            we <= '0';
            dcpustate <= BUBBLE;

          when others =>
            dcpustate <= IDLE;
        end case;
      end if;
    end if;
  end process;

  -- Address line is assigned to program counter in low memory if dealing with instruction
  -- Address line is assigned to data address in hi memory if dealing with loads/stores
  addr <= ('0' & pc)      when (prg_data = '1') else
          ('1' & data_addr(4 downto 0));
end Behavioral;

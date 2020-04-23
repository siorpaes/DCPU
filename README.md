# Dumb CPU #

Dumb CPU, written in VHDL, is just meant for educational and experimental purposes.
DCPU has a data bus width of 8 bits and address space width of 6 bits, thus addressing 64 bytes only.
The lower 32 bytes of the address space are devoted to instructions whereas the upper 32 bytes are devoted to data.
DCPU has an accumulator and a X register. There's no status register as all branching instructions are based on accumulator vs X register comparison.


## Instruction decoding ##
Higher three bits (7,6,5) of each instructions are dedicated to instruction opcode. The remaining five bits contain the target address for instructions that deal with a target address (loads, stores, branches) and contain additional opcode space for instructions that do not require a target address.

#### Instructions with target address ####

| High opcode | Mnemonic |                         Purpose                     |
|-------------|:--------:|:---------------------------------------------------:|
|     000     |    LDA   | LoaD Accumulator                                    |
|     001     |    STA   | STore Accumulator                                   |
|     010     |    LDX   | LoaD X register                                     |
|     011     |    JMP   | JuMP to address                                     |
|     100     |    BNE   | Branch if accumulator is Not Equal to X register    |
|     101     |    BEQ   | Branch if accumulator is EQual to X register        |
|     110     |    TBD   |                                                     |
|     111     |    xxx   | Other instructions decoding                         |

#### Instructions without target address ####

| Low opcode | Mnemonic |                         Purpose                     |
|------------|:--------:|:---------------------------------------------------:|
|   00000    |   ZEA    | Zero Accumulator                                    |
|   00001    |   INC    | INCrement accumulator                               |
|   00010    |   DTO    | DaTa Out                                            |
|   .....    |   xxx    | To be defined                                       |

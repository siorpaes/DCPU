** Dumb CPU **

Dumb CPU just meant for didactic and experimental purposes.
DCPU has a data bus width of 8 bits and address space width of 6 bits, thus addressing 64 bytes only.
The lower 32 bytes of the address space are devoted to instructions whereas the upper 32 bytes are devoted to data.
DCPU has an accumulator and a X register.


*** Instruction decoding ***
Bits 5,6,7 of each instructions are dedicated to instruction opcode. The remaining five bits are the target address of the
instruction for instructions that deal with addresses whereas represent additional opcode space for instructions that do not
need a target address.

000   LDA   LoaD Accumulator
001   STA   STore Accumulator
010   LDX   LoaD X register
011   JMP   JuMP to address
100   BNE   Branch if accumulator is Not Equal to X register
101   BEQ   Branch if accumulator is EQual to X register
110   TBD
111   Other instructions code

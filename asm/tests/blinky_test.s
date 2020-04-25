# Two nested loops are cycled before output data is incremented.
# Loop count is the same for both loops and is stored in 0x00
# Inner loop just uses accumulator, outer loop uses 0x01 for storing loop counter
# External non conditional loop incremets value in 0x02 and emits it with DTO
LDX 0
ZEA
STA 1
ZEA
INC
BNE 4
LDA 1
INC
STA 1
BNE 3
LDA 2
INC
STA 2
DTO
JMP 1

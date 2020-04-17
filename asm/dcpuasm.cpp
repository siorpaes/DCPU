/** \file dcpuasm.cpp
 * david.siorpaes@gmail.com
 * Dumb assembler for dumb CPU
 */
#include <fstream>
#include <string>
#include <sstream>
#include <bits/stdc++.h>

using namespace std;

int main(int argc, char** argv)
{
  if(argc < 2){
    cerr << "Usage: " << argv[0] << " <sourcefile.s>" << endl;
    exit(-1);
  }

  /* Associative array containing all instructions */
  map<string, uint8_t> instructions
  {
    {"LDA", 0b00000000}, {"STA", 0b00100000}, {"LDX", 0b01000000}, {"JMP", 0b01100000},
    {"BNE", 0b10000000}, {"BEQ", 0b10100000},
    {"ZEA", 0b11100000}, {"INC", 0b11100001}
  };

  cout << "Available Instructions" << endl;
  map<string, uint8_t>::iterator i;
  for(i = instructions.begin(); i != instructions.end(); i++){
    cout << i->first << " 0x" << hex << (int)i->second << endl;
  }

  /* Parse all lines and emit instructions accordingly */
  ifstream infile(argv[1]);
  string line, mnemonic, address;
  while(getline(infile, line)){
    uint8_t instruction;
    istringstream iss(line);
    iss >> mnemonic >> address;
    try{
      instruction = instructions.at(mnemonic);
    }
    catch(exception& e){
      cerr << "Unrecognised mnemonic: " << mnemonic << endl;
      exit(-1);
    }

    if((instruction & 0b11100000) != 0xb11100000){
      instruction |= strtoul(address.c_str(), NULL, 16);
    }

    cout << mnemonic << " " << address << " --> 0x" << hex << (int)instruction << endl;
  }

  return 0;
}

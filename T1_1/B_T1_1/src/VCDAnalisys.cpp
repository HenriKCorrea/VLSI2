#include "VCDFile.hpp"
#include "VCDFileParser.hpp"


#include <vector>
#include <iostream>

int main()
{
    VCDFileParser parser;
    VCDFile* trace = parser.parse_file("./aes_new.vcd");    //To remove: this is a temporary file for test purposes

    if(trace != nullptr)   
    {
        std::vector<VCDScope*> scope = *trace->get_scopes();
        std::cout << (int)(scope.size()) << " " << scope[0]->name << std::endl;
    }
}
#include "VCDFile.hpp"
#include "VCDFileParser.hpp"


#include <vector>
#include <iostream>


int main(int argc, char const *argv[])
{
    if (argc != 2) {
        //print help message
        std::cout << "Usage: " << argv[0] << " <file.vcd>" << std::endl;
        return 1;
    }
    
    //Parse VCD file
    VCDFileParser parser;
    VCDFile* trace = parser.parse_file(argv[1]);    

    //Check if VCD file has been parsed successfully
    if(trace == nullptr)   
    {   
        std::cout << "Error during attempt to parse file " << argv[1] << std::endl;
        return 2;
    }

    //Iterate over signals
    for(VCDScope* scope : *trace->get_scopes()) 
    {
        std::cout << "Block " << scope->name << ": Number of signals: " << scope->signals.size() << std::endl;
        
        for(VCDSignal * signal : scope -> signals) 
        {
            std::cout << "\tSignal " << signal->reference << 
                ": Switching activity: " << (*trace->get_signal_values(signal->hash)).size() << 
                std::endl;
        }

        //TODO: Calculate clock frequency
        //TODO: Calculate signal with highest activity (Shall not consider clock)
        //TODO: Calculate signal with lowest activity (Shall not consider reset)

        std::cout << std::endl;
    }
    
    return 0;
}
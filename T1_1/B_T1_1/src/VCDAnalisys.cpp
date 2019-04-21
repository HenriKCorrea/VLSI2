#include "VCDFile.hpp"
#include "VCDFileParser.hpp"


#include <vector>
#include <iostream>
#include <string>
#include <limits>

//Get the Hash (symbol) of a signal by its reference (name)
VCDSignalHash getSignalHash(VCDFile* pTrace, std::string reference)
{
    //flag to stop search
    bool foundSignal = false;

    //Vector of signals to search
    std::vector<VCDSignal* > signals = *pTrace->get_signals();

    //Hash to be returned
    VCDSignalHash hash("");

    //Search signal
    for(size_t i = 0; ((i < signals.size()) && (foundSignal == false)); i++)
    {
        if(signals[i]->reference == reference)
        {
            hash = signals[i]->hash;
            foundSignal = true;
        }
    }
    
    return hash;
}

//Get the clock frequency in string (Assumes time resolution is 1 ns)
std::string getFrequency(VCDFile* pTrace, VCDSignalHash& clk_hash)
{
    //Value to be returned
    std::string retValue("");

    //Time placeholders
    VCDTime time1, time2, time3 = 0.0;

    //Values placeholders
    VCDBit value1, value2, value3 = VCDBit::VCD_X;

    //Define a state machine to validate clock transitions
    enum freqStates
    {
        STEP_1,
        STEP_2,
        STEP_3,
        STEP_RESTART
    }states = STEP_1;

    //Flag to Finish validation process
    bool canStop = false;

    //Get all clock value transitions
    VCDSignalValues clkValues = *pTrace->get_signal_values(clk_hash);
    
    //Validate and store clock period
    for(size_t i = 0; (i < clkValues.size()) && (canStop == false); i++)
    {
        switch (states)
        {
            case STEP_1:
                //Check if clock bit value is valid
                value1 = clkValues[i]->value->get_value_bit();
                if ((value1 == VCDBit::VCD_1) || (value1 == VCDBit::VCD_0)) 
                {
                    //Get time and go to next state
                    time1 = clkValues[i]->time;
                    states = STEP_2;
                }
                else
                {
                    //Invalid: restart to initial state
                    states = STEP_RESTART;
                }
                break;

            case STEP_2:
                //Check if clock bit value is valid
                value2 = clkValues[i]->value->get_value_bit();

                if ((value1 == VCDBit::VCD_1) && 
                    (value2 == VCDBit::VCD_0)) 
                {
                    //Get time and go to next state
                    time2 = clkValues[i]->time;
                    states = STEP_3;
                }
                else if ((value1 == VCDBit::VCD_0) && 
                    (value2 == VCDBit::VCD_1)) 
                {
                    //Get time and go to next state
                    time2 = clkValues[i]->time;
                    states = STEP_3;
                }                
                else
                {
                    //Invalid: restart to initial state
                    states = STEP_RESTART;
                }
                break;                

            case STEP_3:
                //Check if clock bit value is valid
                value3 = clkValues[i]->value->get_value_bit();

                if ((value1 == VCDBit::VCD_1) && 
                    (value2 == VCDBit::VCD_0) &&
                    (value3 == VCDBit::VCD_1)) 
                {
                    //Get time and check if fetched times are a period
                    time3 = clkValues[i]->time;

                    canStop = true;
                }
                else if ((value1 == VCDBit::VCD_0) && 
                    (value2 == VCDBit::VCD_1) &&
                    (value3 == VCDBit::VCD_0)) 
                {
                    //Get time and stop validation
                    time3 = clkValues[i]->time;
                    canStop = true;
                }                
                else
                {
                    //Invalid: restart to initial state
                    states = STEP_RESTART;
                }
                break;                                
        
            default:
                if (!canStop) {
                    //Invalid: restart to initial state
                    states = STEP_RESTART;            
                }
                break;
        }

        //If validation fail, reset variables
        if (states == STEP_RESTART) {
            value1, value2, value3 = VCDBit::VCD_X;
            time1, time2, time3 = 0.0;
            states = STEP_1;
        }
        
    }   //End for..
        
    //If validation has been performed successfully, calculate clock frequency
    if (canStop) 
    {
        //Get perid
        VCDTime period = (time2 - time1) + (time3 - time2);

        //Convert time to frequency (assumes resolution is 1 ns)
        const VCDTime resolution = 1e-9;
        double frequency = 1.0 / (period * resolution);
        
        if (frequency > 0.0) 
        {
            if (frequency < 1e3) 
            {
                retValue = std::to_string(frequency) + " Hz";
            }
            else if (frequency < 1e6)  
            {
                retValue = std::to_string(frequency / 1e3) + " MHz";
            }
            else if (frequency < 1e9)  
            {
                retValue = std::to_string(frequency / 1e6) + " GHz";
            }
        }
        
    }
    
    return retValue;
}

//Get signal with highest switch activity (Not including clock)
VCDSignal* getHighestSwitchActivity(VCDFile* pTrace, std::vector<VCDSignal*>& signals, VCDSignalHash& clk_hash)
{
    //Highest Switch activity
    size_t switchActivity = std::numeric_limits<size_t>::min();

    //Signal to be returned
    VCDSignal* retValue = nullptr;

    //Search highest switch activity signal
    for(VCDSignal* signal : signals) 
    {
        if ((signal->hash != clk_hash) &&
            (pTrace->get_signal_values(signal->hash)->size() > switchActivity)) 
        {
            retValue = signal;
            switchActivity = pTrace->get_signal_values(retValue->hash)->size();
        }
    }

    return retValue;
}

//Get signal with lowest switch activity (Not including reset)
VCDSignal* getLowestSwitchActivity(VCDFile* pTrace, std::vector<VCDSignal*>& signals, VCDSignalHash& reset_hash)
{
    //Lowest Switch activity
    size_t switchActivity = std::numeric_limits<size_t>::max();

    //Signal to be returned
    VCDSignal* retValue = nullptr;

    //Search highest switch activity signal
    for(VCDSignal* signal : signals) 
    {
        if ((signal->hash != reset_hash) &&
            (pTrace->get_signal_values(signal->hash)->size() < switchActivity)) 
        {
            retValue = signal;
            switchActivity = pTrace->get_signal_values(retValue->hash)->size();
        }
    }

    return retValue;
}

int main(int argc, char const *argv[])
{
    if (argc != 2) 
    {
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

    //Get clock hash
    VCDSignalHash clk_hash = getSignalHash(trace, "clk");

    //Get reset hash
    VCDSignalHash reset_hash = getSignalHash(trace, "reset");

    //Iterate over signals
    for(VCDScope* scope : *trace->get_scopes()) 
    {
        std::cout << "Block " << scope->name << ": Number of signals: " << scope->signals.size() << std::endl;

        //Get highest switch activity
        VCDSignal* highestSwitchActivity = nullptr;
        highestSwitchActivity = getHighestSwitchActivity(trace, scope->signals, clk_hash);
        if (highestSwitchActivity != nullptr) {
            std::cout << "Signal with Highest switch activity: " << highestSwitchActivity->reference << ": " 
                << (*trace->get_signal_values(highestSwitchActivity->hash)).size() << std::endl;
        }
        else
        {
            std::cout << "Fail to get highest switch activity." << std::endl;
        }
        

        //Placeholder for lowest switch activity
        VCDSignal* lowestSwitchActivity = nullptr;  
        lowestSwitchActivity = getLowestSwitchActivity(trace, scope->signals, reset_hash);
        if (lowestSwitchActivity != nullptr) {
            std::cout << "Signal with Lowest switch activity: " << lowestSwitchActivity->reference << ": " 
                << (*trace->get_signal_values(lowestSwitchActivity->hash)).size() << std::endl;
        }
        else
        {
            std::cout << "Fail to get Lowest switch activity." << std::endl;
        }              
        
        for(VCDSignal * signal : scope->signals) 
        {
            std::cout << "\tSignal " << signal->reference << 
                ": Switching activity: " << (*trace->get_signal_values(signal->hash)).size() << 
                std::endl;
        }

        std::cout << std::endl;
    }

    //Get design clock frequency
    std::string clkFrequency = getFrequency(trace, clk_hash);
    if (!clkFrequency.empty()) {
        std::cout << "Design clock frequency: " << clkFrequency << std::endl;
    }
    else
    {
        std::cout << "Fail to retrieve design clock frequeny." << std::endl;
    }
    
    return 0;
}
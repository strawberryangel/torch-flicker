#include "torch-flicker/lib/constants.lsl"

// This listens for messages on TORCH_CONTROL_CHANNEL
// and relays them as link messages. 
//
// This allows all torches to be configured across the sim at once. 

default
{
    state_entry()
    {
        llListen(TORCH_CONTROL_CHANNEL, "", NULL_KEY, "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        llMessageLinked(LINK_SET, TORCH_CONTROL_CHANNEL, message, NULL_KEY);
    }
}

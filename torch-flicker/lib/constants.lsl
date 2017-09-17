// Torch control 
#define TORCH_CONTROL_CHANNEL -1599855053
#define TORCH_COMMAND_START "start"
#define TORCH_COMMAND_STOP  "stop"
#define TORCH_COMMAND_CONFIGURE "config"
#define TORCH_COMMAND_RESET "reset"

////////////////////////////////////////////////////////////////////////////////
// Torch defaults
////////////////////////////////////////////////////////////////////////////////

#define DEFAULT_BASE_INTENSITY  0.500000

#define DEFAULT_FLAME_OFF_COLOR <0.70000, 0.30000, 0.00000>
#define DEFAULT_FLAME_ON_COLOR <1.00000, 0.80000, 0.67000>
#define DEFAULT_FLAME_FALLOFF 1.000000
#define DEFAULT_FLAME_RADIUS 12.000000

// "Base" is the minimum amount of time that the state will rest in. 
// "Rand" is the maximum amount of random time that will be added
//  to the resting time. 
#define DEFAULT_FLICKER_OFF_BASE 0.500000
#define DEFAULT_FLICKER_OFF_RAND 2.000000
#define DEFAULT_FLICKER_ON_BASE 0.100000
#define DEFAULT_FLICKER_ON_RAND 0.500000

// The time between steps.
#define DEFAULT_FLICKER_TRANSITION_TIME 0.050000

// The step size for our traveling to.
#define DEFAULT_INTENSITY_DELTA 0.025000

// How drastic is a flicker change. 
#define DEFAULT_INTENSITY_RANGE 0.300000

// What is the percent chance that the flicker intensity will increase? 
#define DEFAULT_INTENSITY_UP_CHANCE 60.0

// The percent chance that the flicker will end, 
// returning all the way to the minimum intensity, 
// rather than just changing intensity a little. 
#define DEFAULT_PERCENT_CHANCE_TO_END_FLICKER 30.000000


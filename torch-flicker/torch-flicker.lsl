#include "lib/strings.lsl"
#include "torch-flicker/lib/constants.lsl"
#include "torch-flicker/lib/config.lsl"
// This tries to simulate a flickering flame. 
// Instead of just blinking on and off, this is a state machine
// that allows for a flicker to jump around before ending. 

integer link_number;
integer is_running = TRUE;

////////////////////////////////////////////////////////////////////////////////
//
// Flame settings.
//
////////////////////////////////////////////////////////////////////////////////

vector flame_off_color = DEFAULT_FLAME_OFF_COLOR;
vector flame_on_color = DEFAULT_FLAME_ON_COLOR;
// Use the intensity to create a flame color.
vector color(float intensity)
{
    float r_delta = flame_on_color.x - flame_off_color.x;
    float g_delta = flame_on_color.y - flame_off_color.y;
    float b_delta = flame_on_color.z - flame_off_color.z;
    return <
        flame_off_color.x + r_delta * intensity,
        flame_off_color.y + g_delta * intensity,
        flame_off_color.z + b_delta * intensity
    >;
}

float flame_radius = DEFAULT_FLAME_RADIUS;
float flame_falloff = DEFAULT_FLAME_FALLOFF;
// This actually changes the prim. 
set_flame_from_intensity(float intensity)
{
    llSetLinkPrimitiveParamsFast(link_number, [
        PRIM_POINT_LIGHT,
        TRUE,
        color(intensity),
        intensity,
        flame_radius,
        flame_falloff
    ]);
}

// Turn off the light.
torch_off()
{
    llSetLinkPrimitiveParamsFast(link_number, [
        PRIM_POINT_LIGHT,
        FALSE,
        <0,0,0>,
        0,
        flame_radius,
        flame_falloff
    ]);
}

////////////////////////////////////////////////////////////////////////////////
//
// Flicker "on" state 
//
////////////////////////////////////////////////////////////////////////////////

// The percent chance that the flicker will end, 
// returning all the way to the minimum intensity, 
// rather than just changing intensity a little. 
float percent_chance_to_end_flicker = DEFAULT_PERCENT_CHANCE_TO_END_FLICKER;

// These are used to determine the duration of the "on" state of
// a flicker.
float flicker_on_base = DEFAULT_FLICKER_ON_BASE;
float flicker_on_rand = DEFAULT_FLICKER_ON_RAND;

float flicker_on_duration()
{
    return llFrand(flicker_on_rand) + flicker_on_base;
}

////////////////////////////////////////////////////////////////////////////////
//
// Flicker "off" state 
//
////////////////////////////////////////////////////////////////////////////////

// These are used to determine the duration of the "off" state of
// a flicker.
float flicker_off_base = DEFAULT_FLICKER_OFF_BASE;
float flicker_off_rand = DEFAULT_FLICKER_OFF_RAND;

float flicker_off_duration()
{
    return llFrand(flicker_off_rand) + flicker_off_base;
}

////////////////////////////////////////////////////////////////////////////////
//
// Flicker transition states (up/down)
//
////////////////////////////////////////////////////////////////////////////////

// The time between steps.
float flicker_transition_time = DEFAULT_FLICKER_TRANSITION_TIME;
// The step size for our traveling to.
float intensity_delta = DEFAULT_INTENSITY_DELTA;

////////////////////////////////////////////////////////////////////////////////
//
// Intensity state tools.
//
////////////////////////////////////////////////////////////////////////////////

#define MAX_INTENSITY 1.0
#define MIN_INTENSITY 0.0
// This is the non-flickering state.
float base_intensity = DEFAULT_BASE_INTENSITY;
// Current intensity value.
float intensity = DEFAULT_BASE_INTENSITY;
// Intensity that we're traveling to. 
float target_intensity = DEFAULT_BASE_INTENSITY;

// How drastic is a flicker change. 
float intensity_range = DEFAULT_INTENSITY_RANGE;
// What is the percent chance that the flicker intensity will increase? 
float intensity_up_chance = DEFAULT_INTENSITY_UP_CHANCE;
float new_intenisty()
{
    float delta = llFrand(intensity_range);
    if(llFrand(100) > intensity_up_chance)
        delta = -delta;
    float new = intensity + delta;
    
    // If this will push the intensity out of the range of min...max intensity,
    // Go the other direction. 
    if(new < MIN_INTENSITY || new > MAX_INTENSITY)
        new = intensity - 2*delta;
        
    //llOwnerSay("new_intenisty" + (string)new + " current " + (string)intensity);
    return new;
}

default
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(num != TORCH_CONTROL_CHANNEL) return;
        
        if(str == TORCH_COMMAND_START)
        {
            is_running = TRUE;
            state flicker_off;
        }
        
        if(str == TORCH_COMMAND_STOP)
            is_running = FALSE;
            
        if(is_command(TORCH_COMMAND_CONFIGURE, str))
        {
            is_running = FALSE;
            string config = strip_command(TORCH_COMMAND_CONFIGURE, str, TRUE);
            configure(config);
        }

        if(str == TORCH_COMMAND_RESET)
            llResetScript();
    }

    state_entry()
    {
        //llOwnerSay("default");
        link_number = llGetLinkNumber();
        if(is_running)
            state flicker_off;
        else
            torch_off();
    }
}

state flicker_off
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(num == TORCH_CONTROL_CHANNEL && str == TORCH_COMMAND_STOP)
        {
            is_running = FALSE;
            state default;
        }
    }
    
    state_entry()
    {
        //llOwnerSay("flicker_off");
        intensity = base_intensity;
        set_flame_from_intensity(base_intensity);
        
        if(is_running)
            llSetTimerEvent(flicker_off_duration());
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
    }
    
    timer()
    {
        target_intensity = new_intenisty();
        if(target_intensity > intensity)
            state flicker_up;
        else
            state flicker_down;
    }
}

// In the process of turning up the intensity bit by bit. 
state flicker_up
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(num == TORCH_CONTROL_CHANNEL && str == TORCH_COMMAND_STOP)
        {
            is_running = FALSE;
            state default;
        }
    }
    
    state_entry()
    {
        //llOwnerSay("flicker_up");
        llSetTimerEvent(flicker_transition_time);
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
    }
    
    timer()
    {
        // Bring the intensity up a little more until it reaches the target.
        intensity += intensity_delta;
        set_flame_from_intensity(intensity);
        if(intensity < target_intensity)
            return;
        
        // Have we returned to the "off" state or are we still "on?"
        if(target_intensity == base_intensity)
            state flicker_off;
        else
            state flicker_on;
    }
}

// In the process of turning down the intensity bit by bit. 
state flicker_down
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(num == TORCH_CONTROL_CHANNEL && str == TORCH_COMMAND_STOP)
        {
            is_running = FALSE;
            state default;
        }
    }
    
    state_entry()
    {
        //llOwnerSay("flicker_down");
        llSetTimerEvent(flicker_transition_time);
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
    }
    
    timer()
    {
        intensity -= intensity_delta;
        set_flame_from_intensity(intensity);
        if(intensity > target_intensity)
            return;

        // Have we returned to the "off" state or are we still "on?"
        if(target_intensity == base_intensity)
            state flicker_off;
        else
            state flicker_on;
    }
}

// The flicker has reached its full intensity. 
// Hang around for a bit, then either change intensity again or
// end the flicker (returning to base_intensity).
state flicker_on
{
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(num == TORCH_CONTROL_CHANNEL && str == TORCH_COMMAND_STOP)
        {
            is_running = FALSE;
            state default;
        }
    }
    
    state_entry()
    {
        //llOwnerSay("flicker_on");
        llSetTimerEvent(flicker_on_duration());
    }
    
    state_exit()
    {
        llSetTimerEvent(0);
    }
    
    timer()
    {
        // End flicker?
        if(llFrand(100) < percent_chance_to_end_flicker)
            target_intensity = base_intensity;
        else
            target_intensity = new_intenisty();
        
        if(target_intensity > intensity)
            state flicker_up;
        else
            state flicker_down;
    }
}


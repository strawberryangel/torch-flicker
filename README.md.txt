# Torch Flicker

This script simulates torch flicker.

The script itself is pretty small and straightforward. 
It spends most of its time sleeping and does not heavy processing,
so it should be low lag. 
In its current form it appears to be consuming 10-14μS. 

# Control

The script accepts link messages for control.
It listens only for messages that have a number 
that matches `TORCH_CONTROL_CHANNEL`.

The commands that it accepts are: 

## Command `stop`

This stops the flicker state machine and extinguishes the light. 
The script can be configured in this state. 
The script cannot be configured while the state machine is running. 

## Command `start`

This starts the flicker state machine. 
The only command that the state machine accepts is `stop`.

## Command `reset`

This performs an actual script reset.
This sets the parameters to their default values. 
And customized parameters are lost. 

## Command `config` *configuration string*

The script will parse the configuration string
and make changes to the parameters in the string.

See the **Configuration** section below. 

# State Machine

To understand the configuration parameters, 
a brief description of the state machine is needed. 

The state machine controls an *intensity* value, 
which is used to control the color and intensity of the light.
(Color is a function of intensity.)

## State `flicker_off`

This is the base resting state. 
The intensity is set to the `base_intensity`.

This state sets a timer and sleeps. 
When the timer expires, 
it's time to start a flicker. 

A target intensity is selected randomly.
If the target intensity is less than the base intensity, 
it goes to the `flicker_down` state. 
Otherwise it goes to the `flicker_up` state.

## State `flicker_up` and `flicker_down`

These are transitional states. 
They incrementally change intensity and sleep until the target intensity 
is reached. 

## State `flicker_on`

This is similar to the base `flicker_off` state
where it sets the light to the target intensity and sleeps. 

There is a chance it will end the flicker or continue it.
If it ends the flicker, it sets the target intensity to 
the base intensity and switches to the appropriate 
`flicker_up` or `flicker_down` state to make the transition. 

If it continues the flicker, 
it chooses a new target intensity and 
switches to the appropriate 
`flicker_up` or `flicker_down` state to make the transition. 

# Configuration

*   All parameters are configurable.
*   The configuration string should have no spaces in it. 
*   Each parameter is of the form `key=value`.
*   Join multiple parameters together with a back tick (`). 

**Example:**

The sending the following link message to the script will
change the minimum amount of time it remains in the base state
and changes the full intensity color to a light orange

```
config flicker_off_base=0.75`flame_on_color=<1.0,0.7,0.2>
```

## Parameter `base_intensity`

This is the resting intensity level. 

It is a float of the range [0..1].

## Parameter `flame_off_color`

Tis is the color of the flame at zero intensity. 

This is a color vector. 

## Parameter `flame_on_color`

Tis is the color of the flame at full (1.0) intensity. 

This is a color vector. 

## Parameter `flame_falloff`

This is the LSL `PRIM_POINT_LIGHT` falloff value. 

## Parameter `flame_radius`

This is the LSL `PRIM_POINT_LIGHT` radius value. 

## Parameter `flicker_off_base`

This is the minimum amount of time the state machine will rest 
in the `flicker_off` state. 

This is a float, in seconds. 

## Parameter `flicker_off_rand`

This is the maximum random value that will be added to 
the amount of time the state machine will rest 
in the flicker_off` state. 

This is a float, in seconds. 

## Parameter `flicker_on_base`

This is the minimum amount of time the state machine will rest 
in the `flicker_on` state. 

This is a float, in seconds. 

## Parameter `flicker_on_rand`

This is the maximum random value that will be added to 
the amount of time the state machine will rest 
in the `flicker_on` state. 

This is a float, in seconds. 

## Parameter `flicker_transition_time`

This is the amount of sleep time for each step in the flicker up/down 
states. 

This is a float, in seconds. 

## Parameter `intensity_delta`

This is the intensity step size for each iteration of the flicker up/down 
states.

This is a small positive float. 

## Parameter `intensity_range`

This is the maximum amount of intensity jump that a flicker will produce.

This is a small positive float.

## Parameter `intensity_up_chance`

When starting or continuing a flicker, 
this sets the percent chance for the flicker going brighter
rather than dimmer. 

This is a float in the range [0..100] percent. 

## Parameter `percent_chance_to_end_flicker`

At the end of a flicker iteration, 
this sets the percent chance for the flicker to end 
and return to the base state. 

This is a float in the range [0..100] percent. 

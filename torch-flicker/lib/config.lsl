////////////////////////////////////////////////////////////////////////////////
// Configuration Strings
////////////////////////////////////////////////////////////////////////////////

#define CONFIG_BASE_INTENSITY "base_intensity"
#define CONFIG_FLAME_OFF_COLOR "flame_off_color"
#define CONFIG_FLAME_ON_COLOR "flame_on_color"
#define CONFIG_FLAME_FALLOFF "flame_falloff"
#define CONFIG_FLAME_RADIUS "flame_radius"
#define CONFIG_FLICKER_OFF_BASE "flicker_off_base"
#define CONFIG_FLICKER_OFF_RAND "flicker_off_rand"
#define CONFIG_FLICKER_ON_BASE "flicker_on_base"
#define CONFIG_FLICKER_ON_RAND "flicker_on_rand"
#define CONFIG_FLICKER_TRANSITION_TIME "flicker_transition_time"
#define CONFIG_INTENSITY_DELTA "intensity_delta"
#define CONFIG_INTENSITY_RANGE "intensity_range"
#define CONFIG_INTENSITY_UP_CHANCE "intensity_up_chance"
#define CONFIG_PERCENT_CHANCE_TO_END_FLICKER "percent_chance_to_end_flicker"

configure(string configuration)
{
    list items = llParseString2List(configuration, ["`"], []);
    integer count = llGetListLength(items);
    
    while(count-- > 0)
    {
        list setting = llParseString2List(llList2String(items, count), ["="], []);
        string key_ = llList2String(setting, 0);
        string value = llList2String(setting, 1);
        
        if(key_ == CONFIG_BASE_INTENSITY)
            base_intensity = str_to_float_default(
                value, DEFAULT_BASE_INTENSITY
        );
            
        if(key_ == CONFIG_FLAME_OFF_COLOR)
            flame_off_color = str_to_vector_default(
                value, DEFAULT_FLAME_OFF_COLOR
        );
            
        if(key_ == CONFIG_FLAME_ON_COLOR)
            flame_on_color = str_to_vector_default(
                value, DEFAULT_FLAME_ON_COLOR
        );
            
        if(key_ == CONFIG_FLAME_FALLOFF)
            flame_falloff = str_to_float_default(
                value, DEFAULT_FLAME_FALLOFF
        );
            
        if(key_ == CONFIG_FLAME_RADIUS)
            flame_radius = str_to_float_default(
                value, DEFAULT_FLAME_RADIUS
        );
            
        if(key_ == CONFIG_FLICKER_OFF_BASE)
            flicker_off_base = str_to_float_default(
                value, DEFAULT_FLICKER_OFF_BASE
        );
            
        if(key_ == CONFIG_FLICKER_OFF_RAND)
            flicker_off_rand = str_to_float_default(
                value, DEFAULT_FLICKER_OFF_RAND
        );
            
        if(key_ == CONFIG_FLICKER_ON_BASE)
            flicker_on_base = str_to_float_default(
                value, DEFAULT_FLICKER_ON_BASE
        );
            
        if(key_ == CONFIG_FLICKER_ON_RAND)
            flicker_on_rand = str_to_float_default(
                value, DEFAULT_FLICKER_ON_RAND
        );
            
        if(key_ == CONFIG_FLICKER_TRANSITION_TIME)
            flicker_transition_time = str_to_float_default(
                value, DEFAULT_FLICKER_TRANSITION_TIME
        );
            
        if(key_ == CONFIG_INTENSITY_DELTA)
            intensity_delta = str_to_float_default(
                value, DEFAULT_INTENSITY_DELTA
        );
            
        if(key_ == CONFIG_INTENSITY_RANGE)
            intensity_range = str_to_float_default(
                value, DEFAULT_INTENSITY_RANGE
        );
            
        if(key_ == CONFIG_INTENSITY_UP_CHANCE)
            intensity_up_chance = str_to_float_default(
                value, DEFAULT_INTENSITY_UP_CHANCE
        );
            
        if(key_ == CONFIG_PERCENT_CHANCE_TO_END_FLICKER)
            percent_chance_to_end_flicker = str_to_float_default(
                value, DEFAULT_PERCENT_CHANCE_TO_END_FLICKER
        );
            
        intensity = base_intensity;
        target_intensity = base_intensity;
    }
    
    report_configuration();
}

report_configuration()
{
    llWhisper(PUBLIC_CHANNEL, "Configuration for " + llGetScriptName());
    llWhisper(PUBLIC_CHANNEL, " ");
    llWhisper(PUBLIC_CHANNEL, CONFIG_BASE_INTENSITY + " " + (string)base_intensity);
    llWhisper(PUBLIC_CHANNEL, " ");
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLAME_OFF_COLOR + " " + (string)flame_off_color);
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLAME_ON_COLOR + " " + (string)flame_on_color);
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLAME_FALLOFF + " " + (string)flame_falloff);
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLAME_RADIUS + " " + (string)flame_radius);
    llWhisper(PUBLIC_CHANNEL, " ");
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLICKER_OFF_BASE + " " + (string)flicker_off_base);
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLICKER_OFF_RAND + " " + (string)flicker_off_rand);
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLICKER_ON_BASE + " " + (string)flicker_on_base);
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLICKER_ON_RAND + " " + (string)flicker_on_rand);
    llWhisper(PUBLIC_CHANNEL, " ");
    llWhisper(PUBLIC_CHANNEL, CONFIG_FLICKER_TRANSITION_TIME + " " + (string)flicker_transition_time);
    llWhisper(PUBLIC_CHANNEL, CONFIG_INTENSITY_DELTA + " " + (string)intensity_delta);
    llWhisper(PUBLIC_CHANNEL, CONFIG_INTENSITY_RANGE + " " + (string)intensity_range);
    llWhisper(PUBLIC_CHANNEL, CONFIG_INTENSITY_UP_CHANCE + " " + (string)intensity_up_chance);
    llWhisper(PUBLIC_CHANNEL, CONFIG_PERCENT_CHANCE_TO_END_FLICKER + " " + (string)percent_chance_to_end_flicker);
}

float str_to_float_default(string value, float default_value)
{
    // Attempt to catch atcual zero values, since an invalid string 
    // returns zero. 
    if(value == "0" || value == "0.0")
        return 0;
        
    float new = (float)value;
    if((string)new == "Infinity" || (string)new == "NaN")
        return default_value;

    if(new != 0) // successful conversion
        return new;
    else
        return default_value;
}

vector str_to_vector_default(string value, vector default_value)
{
    // Attempt to catch atcual zero values, since an invalid string 
    // returns ZERO_VECTOR.
    if(
        value == "<0,0,0>" || value == "<0.0,0.0,0.0>" ||
        value == "<0, 0, 0>" || value == "<0.0, 0.0, 0.0>"
    )
        return ZERO_VECTOR;
        
    vector new = (vector)value;
    if(new != ZERO_VECTOR) // successful conversion
        return new;
    else
        return default_value;
}


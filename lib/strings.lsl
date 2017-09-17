integer is_command(string command, string message)
{
    string search_for = command + " ";
    integer index = llSubStringIndex(message, search_for);
    return index == 0;
}

string strip_command(string command, string message, integer trim)
{
    string search_for = command + " ";
    integer index = llSubStringIndex(message, search_for);
    if(index != 0) return message; 

    string result = llGetSubString(message, llStringLength(command) + 1, -1);
    if(trim)
        result = llStringTrim(result, STRING_TRIM);

    return result;
}




BEGIN{printf "/* Automatically generated - do not edit */\n#ifndef __AUTOCONFIG_H__\n#define __AUTOCONFIG_H__\n\n"}  
{printf "%s %-40s %s\n", $1,$2,$3}  
END{printf "\n#endif //#ifndef __AUTOCONFIG_H__"}

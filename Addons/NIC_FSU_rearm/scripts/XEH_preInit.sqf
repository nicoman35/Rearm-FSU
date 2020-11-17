[
	"NIC_FSU_REARM_ALLOWED", 																		// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
    "CHECKBOX",																						// setting type
	[format[localize "STR_NIC_FSU_REARM"], format[localize "STR_NIC_FSU_REARM_TIP"]],				// [setting name, tooltip]
	format[localize "STR_NIC_FSU_REARM_CATEGORY"], 													// pretty name of the category where the setting can be found. Can be stringtable entry.
	true,																							// default value of setting
    true																							// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;
[
	"NIC_FSU_REARM_SEARCH_RANGE",																	// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"SLIDER",   																					// setting type
	[format[localize "STR_NIC_FSU_SEARCH_RANGE"], format[localize "STR_NIC_FSU_SEARCH_RANGE_TIP"]], // [setting name, tooltip]
	format[localize "STR_NIC_FSU_REARM_CATEGORY"], 													// pretty name of the category where the setting can be found. Can be stringtable entry.
	[10, 200, 125, 0],																				// [_min, _max, _default, _trailingDecimals]
    true																							// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
	// {(round (NIC_FSU_REARM_SEARCH_RANGE * 10)) / 10}
] call CBA_fnc_addSetting;
[
	"NIC_FSU_REARM_TIME_PER_ROUND_AND_METER",														// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"SLIDER",   																					// setting type
	[format[localize "STR_NIC_FSU_TIME_PER"], format[localize "STR_NIC_FSU_TIME_PER_TIP"]],			// [setting name, tooltip]
	format[localize "STR_NIC_FSU_REARM_CATEGORY"], 													// pretty name of the category where the setting can be found. Can be stringtable entry.
	[0.2, 5, 1, 1],																					// [_min, _max, _default, _trailingDecimals]
    true																							// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;
[
	"NIC_FSU_REARM_AI_UNITS",																		// internal setting name, should always contain a tag! This will be the global variable which takes the value of the setting.
	"SLIDER",   																					// setting type
	[format[localize "STR_NIC_FSU_AI_UNITS"], format[localize "STR_NIC_FSU_AI_UNITS_TIP"]],					// [setting name, tooltip]
	format[localize "STR_NIC_FSU_REARM_CATEGORY"], 													// pretty name of the category where the setting can be found. Can be stringtable entry.
	[0, 3, 0, 0],																					// [_min, _max, _default, _trailingDecimals]
    true																							// "_isGlobal" flag. Set this to true to always have this setting synchronized between all clients in multiplayer
] call CBA_fnc_addSetting;

NIC_FSU_REARM_SOURCES = [																				// ammo rearm sources for fire support units
	"B_Slingload_01_Ammo_F",
	"B_Truck_01_ammo_F",
	"B_T_Truck_01_ammo_F",
	"O_Truck_02_Ammo_F",
	"O_Truck_03_ammo_F",
	"O_T_Truck_03_ammo_ghex_F",
	"O_T_Truck_02_Ammo_F",
	"I_Truck_02_ammo_F",
	"I_E_Truck_02_Ammo_F",
	"B_APC_Tracked_01_CRV_F",
	"B_T_APC_Tracked_01_CRV_F"
];

if (isNil{NIC_FSU_REARM_ALLOWED}) then {NIC_FSU_REARM_ALLOWED = true};									// on/off switch for rearming fire support units
if (isNil{NIC_FSU_REARM_SEARCH_RANGE}) then {NIC_FSU_REARM_SEARCH_RANGE = 125};							// search range for ammo sources in meters around fire support unit
if (isNil{NIC_FSU_REARM_TIME_PER_ROUND_AND_METER}) then {NIC_FSU_REARM_TIME_PER_ROUND_AND_METER = 1};	// rearm time per round and meter distance from fire support unit to ammo source
if (isNil{NIC_FSU_REARM_AI_UNITS}) then {NIC_FSU_REARM_AI_UNITS = 0};									// needed number of AI units for rearming fire support units (have to be in NIC_FSU_REARM_SEARCH_RANGE around unit)
class CfgPatches {
	class NIC_FSU_rearm {
		units[]				= {};
		weapons[]= {};
		requiredVersion		= 1;
		requiredAddons[]	= {};
		magazines[]= {};
	};
};
class CfgFunctions {
	class NIC {
		class base {
			class InitRearmFSU {
				preInit = 1;
				file	= "\NIC_FSU_rearm\scripts\init.sqf";
			};
		};
	};
};
class Extended_PreInit_EventHandlers {
	class NIC_FSU_rearm {
		init = "call compile preprocessFileLineNumbers '\NIC_FSU_rearm\scripts\XEH_preInit.sqf'"; 	// CBA_a3 integration
	};
};
class Extended_Fired_Eventhandlers {
    class B_SAM_System_03_F {																		// MIM-145 Defender SAM rocket launcher
		fired = "_this execVM '\NIC_FSU_rearm\scripts\rearm.sqf';";
	};
	class B_MBT_01_mlrs_F : B_SAM_System_03_F {};													// Seara multiple rocket launcher
    class B_MBT_01_arty_F : B_SAM_System_03_F {}; 													// Sholef artillery
	class RHS_M119_WD : B_SAM_System_03_F {}; 														// RHS M119 howitzer
	class RHS_M119_W : B_SAM_System_03_F {}; 														// RHS M119 howitzer
};
class Extended_Reloaded_Eventhandlers {
    class B_SAM_System_03_F {																		// MIM-145 Defender SAM rocket launcher
		Reloaded = "_this execVM '\NIC_FSU_rearm\scripts\rearm.sqf';";
	};
	class B_MBT_01_mlrs_F : B_SAM_System_03_F {};													// Seara multiple rocket launcher
    class B_MBT_01_arty_F : B_SAM_System_03_F {}; 													// Sholef artillery
    class RHS_M119_WD : B_SAM_System_03_F {}; 														// RHS M119 howitzer
	class RHS_M119_W : B_SAM_System_03_F {}; 														// RHS M119 howitzer
};
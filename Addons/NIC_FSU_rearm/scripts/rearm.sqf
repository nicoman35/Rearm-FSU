NIC_FN_GetTurretsWeapons = {
	private ["_result", "_getAnyMagazines", "_findRecurse", "_class"];
	_result = [];
	_getAnyMagazines = {
		private ["_weapon", "_mags"];
		_weapon = configFile >> "CfgWeapons" >> _this;
		_mags = [];
		{
			_mags = _mags + getArray (
				(if (_x == "this") then { _weapon } else { _weapon >> _x }) >> "magazines"
			)
		} forEach getArray (_weapon >> "muzzles");
		_mags
	};
	_findRecurse = {
		private ["_root", "_class", "_path", "_currentPath"];
		_root = (_this select 0);
		_path = +(_this select 1);
		for "_i" from 0 to count _root -1 do {
			_class = _root select _i;
			if (isClass _class) then {
				_currentPath = _path + [_i];
				{
					_result set [count _result, [_x, _x call _getAnyMagazines, _currentPath, str _class]];
				} forEach getArray (_class >> "weapons");
				_class = _class >> "turrets";
				if (isClass _class) then {
					[_class, _currentPath] call _findRecurse;
				};
			};
		};
	};
	_class = (
		configFile >> "CfgVehicles" >> (
			switch (typeName _this) do {
				case "STRING" : {_this};
				case "OBJECT" : {typeOf _this};
				default {nil}
			}
		) >> "turrets"
	);
	[_class, []] call _findRecurse;
	_result;
};	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

NIC_FN_CheckGunnerPlayer = {
	params ["_unit", ["_gunnerWasPlayer", false]];
	private ["_index"];
	private _gunner = objNull;
	if (unitIsUAV _unit) then {
		// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  NIC_FN_CheckGunnerPlayer		UAVControl _unit: ", UAVControl _unit];
		_index = -1;
		{
			// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  NIC_FN_CheckGunnerPlayer		_x: ", _x];
			if (typeName _x == "STRING") then {
				if (_x == "GUNNER") then {_index = _foreachindex - 1};
			};
			if (_index > -1) exitWith {};
		} forEach UAVControl _unit;
		if (_index > -1) then {_gunner = UAVControl _unit select _index};	
	} else {
		_gunner = gunner _unit;
	};
	if (alive _gunner && _gunner == player) exitWith {true};
	if (_gunnerWasPlayer) then {hintsilent ""};
	// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  NIC_FN_CheckGunnerPlayer		_gunnerIsPlayer: ", _gunnerIsPlayer];
	false
};	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

NIC_FN_CheckRearmTeam = {
	params ["_unit", ["_gunnerIsPlayer", false], ["_displayName", ""]];
	private _countRearmTeam = 0;
	if (NIC_FSU_REARM_AI_UNITS > 0) then {
		_countRearmTeam = count (crew _unit select {_x getUnitTrait "Engineer"});											// if we need engineers for rearming, check if any engineers are available among unit's crew
		if (_countRearmTeam >= NIC_FSU_REARM_AI_UNITS) exitWith {};
		_countRearmTeam = _countRearmTeam + count (nearestObjects [_unit, ["CAManBase"], NIC_FSU_REARM_SEARCH_RANGE] select {_x getUnitTrait "Engineer" && alive _x});
	};
	if (_countRearmTeam < NIC_FSU_REARM_AI_UNITS) exitWith {
		if (_gunnerIsPlayer) then {
			hint formatText ["%1%2%3%4%5%6%7", format[localize "STR_NIC_FSU_NEG_1"], _displayName, format[localize "STR_NIC_FSU_NEG_2"], lineBreak, format[localize "STR_NIC_FSU_NEG_3"], str(NIC_FSU_REARM_SEARCH_RANGE), " m."];
		};
		false
	};
	true
};	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

NIC_FN_RearmRequirements = {
	params ["_unit", ["_gunnerIsPlayer", false], ["_displayName", ""], "_weapponMainTurret"];
	// diag_log formatText ["%1%2%3%4%5%6%7%8%9", time, "s  (NIC_FN_RearmRequirements) _unit: ", _unit, ", _gunnerIsPlayer: ", _gunnerIsPlayer, ", _displayName: ", _displayName, ", _weapponMainTurret: ", _weapponMainTurret];
	private _ammoSources = [];
	if !(alive _unit) exitWith {_ammoSources};
	if !([_unit, _weapponMainTurret] call NIC_FN_RearmNecessary) exitWith {_ammoSources};
	if !([_unit, _gunnerIsPlayer, _displayName] call NIC_FN_CheckRearmTeam) exitWith {_ammoSources};
	_ammoSources = (_unit nearObjects (round NIC_FSU_REARM_SEARCH_RANGE)) select {(typeof _x) in NIC_FSU_REARM_SOURCES && alive _x};	// Search for all available ammo sources within given range	
	if (count _ammoSources == 0) exitWith {
		if (_gunnerIsPlayer) then {
			hint formatText ["%1%2%3%4%5%6%7", format[localize "STR_NIC_FSU_NEG_1"], _displayName, format[localize "STR_NIC_FSU_NEG_2"], lineBreak, format[localize "STR_NIC_FSU_NEG_4"], str(NIC_FSU_REARM_SEARCH_RANGE), " m."];
		};
		_ammoSources
	};
	_ammoSources
};	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

NIC_FN_RearmNecessary = {
	params ["_unit", "_weapponMainTurret"];
	_magazineClass = currentMagazine _unit;
	_magazineDefaultRoundCount = getNumber (configFile >> "CfgMagazines" >> _magazineClass >> "count");	  // recheck is necessary, as magazine may have been changed during waiting period
	_magazineCurrentRoundCount = _unit ammo _weapponMainTurret;
	if (_magazineDefaultRoundCount == _magazineCurrentRoundCount) exitWith {false};
	true
};	// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

if (!NIC_FSU_REARM_ALLOWED) exitWith {};																					// leave, if rearm not allowed
private	_unit = _this select 0;
if (_unit getVariable "NIC_Rearm_unit_Mutex") exitWith {};																	// leave, if loop already running on this unit
_unit setVariable ["NIC_Rearm_unit_Mutex", true];																			// set mutex to prevent multiple rearm loops

if (!isServer && (player != player)) then {
	waitUntil {player == player};
	waitUntil {time > 5};
};

private [
	"_ammoSources", 
	"_nearestSource", 
	"_waitTime", 
	"_future", 
	"_magazineCurrentRoundCount"
];

if !(isNil{FOB_typename}) then {
	if (NIC_FSU_REARM_SOURCES find FOB_typename < 0) then {NIC_FSU_REARM_SOURCES pushBack FOB_typename}; 					// if KP Liberation is played, add FOB type name to rearm sources
};

private _weapponMainTurret = (_unit call NIC_FN_GetTurretsWeapons) select 0 select 0;
private _magazineClass = currentMagazine _unit;
private _displayName = getText (configfile >> "CfgVehicles" >> typeOf _unit >> "displayName");
private _gunnerIsPlayer = false;

while {NIC_FSU_REARM_ALLOWED && alive _unit} do {
	_gunnerIsPlayer = [_unit] call NIC_FN_CheckGunnerPlayer;
	_ammoSources = [_unit, _gunnerIsPlayer, _displayName, _weapponMainTurret] call NIC_FN_RearmRequirements;
	if (count _ammoSources == 0) exitWith {};		// leave, if there are no ammo sources nearby
	_ammoSources = _ammoSources apply {[_x distance _unit, _x]};
	_ammoSources sort true;																									// sort ammo sources by distance
	_nearestSource = _ammoSources select 0 select 1;																		// get nearest ammo source
	_waitTime = (ceil ((_unit distance _nearestSource) * NIC_FSU_REARM_TIME_PER_ROUND_AND_METER)) + 10;  					// calculate wait time until rearm
	// diag_log formatText ["%1%2%3%4%5", time, "s  (NIC_Rearm) _waitTime: ", _waitTime];
	_future = time + _waitTime;
	waitUntil {
		sleep 1;
		_gunnerIsPlayer = [_unit, _gunnerIsPlayer] call NIC_FN_CheckGunnerPlayer;
		// diag_log formatText ["%1%2%3%4%5%6%7", time, "s  (NIC_Rearm)		_gunnerIsPlayer: ", _gunnerIsPlayer];
		if (_gunnerIsPlayer && ceil(_future - time) > 0) then {
            hintsilent formatText ["%1%2%3%4%5%6%7", "Auto rearming ", _displayName, " in progress", lineBreak, "Time until next round: ", str (ceil(_future - time)), " s"];
        };
		if (ceil(_future - time) > 0 && {(ceil(_future - time) % 5) isEqualTo 0}) then {
            // diag_log formatText ["%1%2%3%4%5%6%7", time, "s  (NIC_Rearm)	performing rearm requirements check, _gunnerIsPlayer: ", _gunnerIsPlayer];
			if (count ([_unit, _gunnerIsPlayer, _displayName, _weapponMainTurret] call NIC_FN_RearmRequirements) == 0) exitWith {
				_future = time;
			};
        };
		time > _future
	};
	if (count ([_unit, _gunnerIsPlayer, _displayName, _weapponMainTurret] call NIC_FN_RearmRequirements) == 0) exitWith {};		// leave, if there are no ammo sources nearby
	_unit setAmmo [_weapponMainTurret, (_magazineCurrentRoundCount + 1)];	// raise round number of current magazine by one
};

if (_gunnerIsPlayer) then {
	sleep 5;
	hintsilent "";
};

_unit setVariable ["NIC_Rearm_unit_Mutex", nil];																			// lower mutex flag
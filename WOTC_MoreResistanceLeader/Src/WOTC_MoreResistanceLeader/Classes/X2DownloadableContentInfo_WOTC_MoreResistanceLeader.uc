class X2DownloadableContentInfo_WOTC_MoreResistanceLeader extends X2DownloadableContentInfo;

struct RescueClassData
{
	var name CharacterTemplateName;
	var name ClassName;
	var int Limit;
	var ECombatIntelligence MinComInt;

	structdefaultproperties
	{
		CharacterTemplateName = "Soldier";
		MinComInt = eComInt_Standard;
	}
};

var config (MRL) array<RescueClassData> RescueClasses;

static function RescueClassData GetConfigEntry()
{
	local RescueClassData RescueClass, BlankEntry;
	local XComGameState_Unit Unit;
	local StateObjectReference UnitRef;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2SoldierClassTemplateManager SCMan;
	local int iCount;

	XComHQ = `XCOMHQ;
	foreach default.RescueClasses(RescueClass)
	{
		// Validate the soldier class, just in case the mod that introduces the class is not enabled
		SCMan = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
		if (SCMan.FindSoldierClassTemplate(RescueClass.ClassName) == none) continue;

		iCount = 0; // Init
		foreach XComHQ.Crew(UnitRef)
		{
			Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
			if (Unit != none && Unit.IsSoldier() && Unit.GetSoldierClassTemplate().DataName == RescueClass.ClassName)
			{
				iCount++;
			}
		}

		if (iCount < RescueClass.Limit)
		{
			return RescueClass;
		}
	}

	return BlankEntry;
}

// No longer used. Replaced by GetConfigEntry
static function name DetermineSoldierClass()
{
	local RescueClassData RescueClass;
	local XComGameState_Unit Unit;
	local StateObjectReference UnitRef;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2SoldierClassTemplateManager SCMan;
	local int iCount;

	XComHQ = `XCOMHQ;
	foreach default.RescueClasses(RescueClass)
	{
		// Validate the soldier class, just in case the mod that introduces the class is not enabled
		SCMan = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
		if (SCMan.FindSoldierClassTemplate(RescueClass.ClassName) == none) continue;

		iCount = 0; // Init
		foreach XComHQ.Crew(UnitRef)
		{
			Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
			if (Unit != none && Unit.IsSoldier() && Unit.GetSoldierClassTemplate().DataName == RescueClass.ClassName)
			{
				iCount++;
			}
		}

		if (iCount < RescueClass.Limit)
		{
			return RescueClass.ClassName;
		}
	}

	return '';
}

static function ECombatIntelligence GetMinComInt(name SoldierClassName)
{
	local int i;

	i = default.RescueClasses.Find('ClassName', SoldierClassName);

	if (i != INDEX_NONE)
	{
		return default.RescueClasses[i].MinComInt;
	}

	return eComInt_Standard;
}
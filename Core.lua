--[=[
HealersHaveToDie World of Warcraft Add-on
Copyright (c) 2009-2010 by John Wellesz (Archarodim@teaser.fr)
All rights reserved

Version @project-version@

This is a very simple and light add-on that rings when you hover or target a
unit of the opposite faction who healed someone during the last 60 seconds (can
be configured).
Now you can spot those nasty healers instantly and help them to accomplish their destiny!

This add-on uses the Ace3 framework.

type /hhtd to get a list of existing options.

-----
    Core.lua
-----


--]=]

--========= NAMING Convention ==========
--      VARIABLES AND FUNCTIONS (upvalues excluded)
-- global variable                == _NAME_WORD2 (underscore + full uppercase)
-- semi-global (file locals)      == NAME_WORD2 (full uppercase)
-- locals to closures or members  == NameWord2
-- locals to functions            == nameWord2
--
--      TABLES
--  globals                       == NAME__WORD2
--  locals                        == name_word2
--  members                       == Name_Word2

-- Debug templates
local ERROR     = 1;
local WARNING   = 2;
local INFO      = 3;
local INFO2     = 4;

local ADDON_NAME, T = ...;

local _, _, _, tocversion = GetBuildInfo();
T._tocversion = tocversion;

-- === Add-on basics and variable declarations {{{
T.Healers_Have_To_Die = LibStub("AceAddon-3.0"):NewAddon("Healers Have To Die", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0");
local HHTD = T.Healers_Have_To_Die;

--@debug@
_HHTD_DEBUG = HHTD;
--@end-debug@

HHTD.Localized_Text = LibStub("AceLocale-3.0"):GetLocale("HealersHaveToDie", true);

local L = HHTD.Localized_Text;

HHTD.Constants = {};
local HHTD_C = HHTD.Constants;

HHTD_C.Healing_Classes = {
    ["PRIEST"]  = true,
    ["PALADIN"] = true,
    ["DRUID"]   = true,
    ["SHAMAN"]  = true,
};

-- The header for HHTD key bindings
BINDING_HEADER_HHTD = "Healers Have To Die";
BINDING_NAME_HHTDP = L["OPT_POST_ANNOUNCE_ENABLE"];


HHTD.Enemy_Healers = {};
HHTD.Enemy_Healers_By_Name = {};
HHTD.Enemy_Healers_By_Name_Blacklist = {};
HHTD.Enemy_Total_Heal_By_Name = {};

HHTD.Friendly_Healers = {};
HHTD.Friendly_Healers_By_Name = {};
HHTD.Friendly_Healers_By_Name_Blacklist = {}; -- nothing to fill it for now
HHTD.Friendly_Total_Heal_By_Name = {};

HHTD.Friendly_Healers_Attacked_by_GUID = {};

HHTD.LOG = {};
HHTD.LOG.Healers_Accusation_Proofs = {};
HHTD.LOG.Healers_Details = {};

HHTD.Healer_Registry = {
    [true] = {
        ["Healers"] = HHTD.Friendly_Healers,
        ["Healers_By_Name"] = HHTD.Friendly_Healers_By_Name,
        ["Healers_By_Name_Blacklist"] = HHTD.Friendly_Healers_By_Name_Blacklist,
        ["Total_Heal_By_Name"] = HHTD.Friendly_Total_Heal_By_Name,
    },
    [false] = {
        ["Healers"] = HHTD.Enemy_Healers,
        ["Healers_By_Name"] = HHTD.Enemy_Healers_By_Name,
        ["Healers_By_Name_Blacklist"] = HHTD.Enemy_Healers_By_Name_Blacklist,
        ["Total_Heal_By_Name"] = HHTD.Enemy_Total_Heal_By_Name,
    }
}

-- local function REGISTER_HEALERS_ONLY_SPELLS_ONCE () -- {{{
local function REGISTER_HEALERS_ONLY_SPELLS_ONCE ()

    if HHTD_C.Healers_Only_Spells_ByName then
        return;
    end

    local Healers_Only_Spells_ByID = {

        -- Priests
        [47540] = "PRIEST", -- Penance
        [88625] = "PRIEST", -- Holy Word: Chastise
        [88684] = "PRIEST", -- Holy Word: Serenity
        [88685] = "PRIEST", -- Holy Word: Sanctuary
        [89485] = "PRIEST", -- Inner Focus
        [10060] = "PRIEST", -- Power Infusion
        [33206] = "PRIEST", -- Pain Suppression
        [62618] = "PRIEST", -- Power Word: Barrier
        [724]   = "PRIEST",   -- Lightwell
        [14751] = "PRIEST", -- Chakra
        [34861] = "PRIEST", -- Circle of Healing
        [47788] = "PRIEST", -- Guardian Spirit

        -- Druids
        [18562] = "DRUID", -- Swiftmend
        [17116] = "DRUID", -- Nature's Swiftness
        [48438] = "DRUID", -- Wild Growth
        [33891] = "DRUID", -- Tree of Life

        -- Shamans
        [974]   = "SHAMAN", -- Earth Shield
        [17116] = "SHAMAN", -- Nature's Swiftness
        [16190] = "SHAMAN", -- Mana Tide Totem
        [61295] = "SHAMAN", -- Riptide

        -- Paladins
        [20473] = "PALADIN", -- Holy Shock
        [31842] = "PALADIN", -- Divine Favor
        [53563] = "PALADIN", -- Beacon of Light
        [31821] = "PALADIN", -- Aura Mastery
        [85222] = "PALADIN", -- Light of Dawn
    };

    HHTD_C.Healers_Only_Spells_ByName = {};

    for spellID, class in pairs(Healers_Only_Spells_ByID) do

        if (GetSpellInfo(spellID)) then
            HHTD_C.Healers_Only_Spells_ByName[(GetSpellInfo(spellID))] = class;
        else
            HHTD:Debug(ERROR, "Missing spell:", spellID);
        end

    end

    HHTD:Debug(INFO, "Spells registered!");
end -- }}}

-- Modules standards configurations {{{

-- Configure default libraries for modules
HHTD:SetDefaultModuleLibraries( "AceConsole-3.0", "AceEvent-3.0")

-- Set the default prototype for modules
HHTD:SetDefaultModulePrototype( {
    OnEnable = function(self) self:Debug(INFO, "prototype OnEnable called!") end,

    OnDisable = function(self) self:Debug(INFO, "prototype OnDisable called!") end,

    OnInitialize = function(self)
        self:Debug(INFO, "prototype OnInitialize called!");
    end,

    Debug = function(self, ...) HHTD.Debug(self, ...) end,

    Error = function(self, m) HHTD.Error (self, m) end,

} )

-- Set modules' default state to "false"
HHTD:SetDefaultModuleState( false )
-- }}}

-- upvalues {{{
local UnitIsPlayer      = _G.UnitIsPlayer;
local UnitIsDead        = _G.UnitIsDead;
local UnitFactionGroup  = _G.UnitFactionGroup;
local UnitGUID          = _G.UnitGUID;
local UnitIsUnit        = _G.UnitIsUnit;
local UnitSex           = _G.UnitSex;
local UnitClass         = _G.UnitClass;
local UnitName          = _G.UnitName;
local GetTime           = _G.GetTime;
local PlaySoundFile     = _G.PlaySoundFile;
local pairs             = _G.pairs;
local ipairs             = _G.ipairs;
-- }}}

-- }}}

-- modules handling functions {{{

function HHTD:SetModulesStates ()
    for moduleName, module in self:IterateModules() do
        module:SetEnabledState(self.db.global.Modules[moduleName].Enabled);
    end
end

-- }}}

-- 03 Ghosts I

-- == Options and defaults {{{
do

    local function GetCoreOptions() -- {{{
    return {
        type = 'group',
        get = function (info) return HHTD.db.global[info[#info]]; end,
        set = function (info, value) HHTD:SetHandler(HHTD, info, value) end,
        disabled = function () return not HHTD:IsEnabled(); end,
        childGroups = 'tab',
        name = "Healers Have To Die",
        args = {
            Description = {
                type = 'description',
                name = L["DESCRIPTION"],
                order = 0,
            },
            On = {
                type = 'toggle',
                name = L["OPT_ON"],
                desc = L["OPT_ON_DESC"],
                set = function(info) HHTD.db.global.Enabled = HHTD:Enable(); return HHTD.db.global.Enabled; end,
                get = function(info) return HHTD:IsEnabled(); end,
                hidden = function() return HHTD:IsEnabled(); end, 

                disabled = false,
                order = 1,
            },
            Off = {
                type = 'toggle',
                name = L["OPT_OFF"],
                desc = L["OPT_OFF_DESC"],
                set = function(info) HHTD.db.global.Enabled = not HHTD:Disable(); return not HHTD.db.global.Enabled; end,
                get = function(info) return not HHTD:IsEnabled(); end,
                guiHidden = true,
                hidden = function() return not HHTD:IsEnabled(); end, 
                order = -1,
            },
            Debug = {
                type = 'toggle',
                name = L["OPT_DEBUG"],
                desc = L["OPT_DEBUG_DESC"],
                guiHidden = true,
                disabled = false,
                order = -2,
            },
            
            Version = {
                type = 'execute',
                name = L["OPT_VERSION"],
                desc = L["OPT_VERSION_DESC"],
                guiHidden = true,
                func = function () HHTD:Print(L["VERSION"], '@project-version@,', L["RELEASE_DATE"], '@project-date-iso@') end,
                order = -5,
            },
            core = {
                type = 'group',
                name =  L["OPT_CORE_OPTIONS"],
                order = 1,
                args = {
                    Info_Header = {
                        type = 'header',
                        name = L["VERSION"] .. ' @project-version@ -- ' .. L["RELEASE_DATE"] .. ' @project-date-iso@',
                        order = 1,
                    },
                    Pve = {
                        type = 'toggle',
                        name = L["OPT_PVE"],
                        desc = L["OPT_PVE_DESC"],
                        order = 200,
                    },
                    PvpHSpecsOnly = {
                        type = 'toggle',
                        name = L["OPT_PVPHEALERSSPECSONLY"],
                        desc = L["OPT_PVPHEALERSSPECSONLY_DESC"],
                        order = 300,
                    },
                    Modules = {
                        type = 'group',
                        name = L["OPT_MODULES"],
                        inline = true,
                        handler = {
                            ["hidden"]   = function () return not HHTD:IsEnabled(); end,
                            ["disabled"] = function () return not HHTD:IsEnabled(); end,

                            ["get"] = function (handler, info) return (HHTD:GetModule(info[#info])):IsEnabled(); end,
                            ["set"] = function (handler, info, value) 

                                HHTD.db.global.Modules[info[#info]].Enabled = value;
                                local result;

                                if value then
                                    result = HHTD:EnableModule(info[#info]);
                                    if result then
                                        HHTD:Print(info[#info], HHTD:ColorText(L["OPT_ON"], "FF00FF00"));
                                    end
                                else
                                    result = HHTD:DisableModule(info[#info]);
                                    if result then
                                        HHTD:Print(info[#info], HHTD:ColorText(L["OPT_OFF"], "FFFF0000"));
                                    end
                                end

                                return result;
                            end,
                        },
                        -- Enable-modules-check-boxes (filled by modules)
                        args = {},
                        order = 900,
                    },
                    Header1 = {
                        type = 'header',
                        name = '',
                        order = 400,
                    },
                    HFT = {
                        type = "range",
                        name = L["OPT_HEALER_FORGET_TIMER"],
                        desc = L["OPT_HEALER_FORGET_TIMER_DESC"],
                        min = 10,
                        max = 60 * 10,
                        step = 1,
                        bigStep = 5,
                        order = 500,
                    },
                    UHMHAP = {
                        type = "toggle",
                        name = L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT"],
                        desc = L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT_DESC"],
                        order = 600,
                    },
                    HMHAP = {
                        type = "range",
                        disabled = function() return not HHTD.db.global.UHMHAP or not HHTD:IsEnabled(); end,
                        name = function() return (L["OPT_HEALER_MINIMUM_HEAL_AMOUNT"]):format(HHTD:UpdateHealThreshold()) end,
                        desc = L["OPT_HEALER_MINIMUM_HEAL_AMOUNT_DESC"],
                        min = 0.01,
                        max = 3,
                        softMax = 1,
                        step = 0.01,
                        bigStep = 0.03,
                        order = 650,
                        isPercent = true,

                        set = function (info, value)
                            HHTD:SetHandler(HHTD, info, value);
                            HHTD:UpdateHealThreshold();
                        end,
                    },
                    SetFriendlyHealersRole = {
                        type = 'toggle',
                        name = L["OPT_SET_FRIENDLY_HEALERS_ROLE"],
                        desc = L["OPT_SET_FRIENDLY_HEALERS_ROLE_DESC"],
                        order = 660,
                    },
                    Log = {
                        type = 'toggle',
                        name = L["OPT_LOG"],
                        desc = L["OPT_LOG_DESC"],
                        disabled = false,
                        order = 700,
                        disabled = function()
                            return HHTD.Announcer and HHTD.Announcer.db.global.PostToChat or false;
                        end,
                    },
                    Header1000 = {
                        type = 'header',
                        name = '',
                        order = 999,
                    },
                },
            },
            Logs = {
                type = 'group',
                name =  L["OPT_LOGS"],
                desc = L["OPT_LOGS_DESC"],
                order = -1,
                hidden = function() return not HHTD.db.global.Log end,
                args = {
                    clear = {
                        type = 'execute',
                        name = L["OPT_CLEAR_LOGS"],
                        confirm = true,
                        func = function () 
                            HHTD.LOG = {};
                            HHTD.LOG.Healers_Accusation_Proofs = {};
                            HHTD.LOG.Healers_Details = {};
                        end,
                        order = 0,

                    },
                    AccusationFacts = { -- {{{
                        type = 'description',
                        name = function() 
                            local tmp = {};
                            local i = 1;

                            for healer, spells in pairs(HHTD.LOG.Healers_Accusation_Proofs) do

                                local isFriend = HHTD.LOG.Healers_Details[healer].isFriend;
                                local totalHeal = HHTD.LOG.Healers_Details[healer].totalHeal;
                                local firstName = healer:match("^[^-]+");
                                local isActive = HHTD.Healer_Registry[isFriend].Healers_By_Name[firstName]

                                local spellsStats = {}
                                local j = 1;

                                for spell, spellcount in pairs(spells) do
                                    spellsStats[j] = ("    %s (|cFFAA0000%d|r)"):format(spell, spellcount);
                                    j = j + 1;
                                end

                                tmp[i] = ("%s (|cff00dd00%s|r) [|cffbbbbbb%s|r]:  %s\n%s\n"):format(
                                    (HHTD:ColorText("#|r %q", isFriend and "FF00FF00" or "FFFF0000")):format(HHTD:ColorText(healer, HHTD.LOG.Healers_Details[healer].class and HHTD:GetClassHexColor( HHTD.LOG.Healers_Details[healer].class) or "FFAAAAAA" )),
                                    tostring(totalHeal > 0 and totalHeal or L["NO_DATA"]),
                                    HHTD.LOG.Healers_Details[healer].isHuman and L["HUMAN"] or L["NPC"],
                                    HHTD:ColorText(isActive and "Active!" or "Idle", isActive and "FF00EE00" or "FFEE0000"),
                                    table.concat(spellsStats, '\n')
                                );

                                i = i + 1;

                            end

                            return table.concat(tmp, '\n');
                        
                        end,
                        order = 1,
                    }, -- }}}
                },
            },
        },
    };
    end -- }}}

    -- Used in Ace3 option table to get feedback when setting options through command line
    function HHTD:SetHandler (module, info, value)

        module.db.global[info[#info]] = value;

        if info["uiType"] == "cmd" then

            if value == true then
                value = L["OPT_ON"];
            elseif value == false then
                value = L["OPT_OFF"];
            end

            self:Print(HHTD:ColorText(HHTD:GetOPtionPath(info), "FF00DD00"), "=>", HHTD:ColorText(value, "FF3399EE"));
        end
    end
    

    local Enable_Module_CheckBox = {
        type = 'toggle',
        name = function (info) return L[info[#info]] end, -- it should be the localized module name
        desc = function (info) return L[info[#info] .. "_DESC"] end, 
        get = "get",
        set = "set",
        disabled = "disabled",
    };

    -- get the option tables feeding it with the core options and adding modules options
    function HHTD.GetOptions()
        local options = GetCoreOptions();

        -- Add modules enable/disable checkboxes
        for moduleName, module in HHTD:IterateModules() do
            if not options.args.core.args.Modules.args[moduleName] then
                options.args.core.args.Modules.args[moduleName] = Enable_Module_CheckBox;
            else
                error("HHTD: module name collision!");
            end
            -- Add modules specific options
            if module.GetOptions then
                if module:IsEnabled() then
                    if not options.plugins then options.plugins = {} end;
                    options.plugins[moduleName] = module:GetOptions();
                end
            end
        end

        return options;
    end
end


local DEFAULT__CONFIGURATION = {
    global = {
        Modules = {
            ['**'] = {
                Enabled = true, -- Modules are enabled by default
            },
        },
        HFT = 60,
        Enabled = true,
        Debug = false,
        Log = false,
        Pve = true,
        PvpHSpecsOnly = true,
        UHMHAP = true,
        HMHAP = 0.05,
        SetFriendlyHealersRole = true,
    },
};
-- }}}

-- = Add-on Management functions {{{
function HHTD:OnInitialize()

    self.db = LibStub("AceDB-3.0"):New("Healers_Have_To_Die", DEFAULT__CONFIGURATION);

    LibStub("AceConfig-3.0"):RegisterOptionsTable(tostring(self), self.GetOptions, {"HealersHaveToDie", "hhtd"});
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions(tostring(self));
    
    self:RegisterChatCommand('hhtdg', function() LibStub("AceConfigDialog-3.0"):Open(tostring(self)) end, true);


    self:CreateClassColorTables();

    self:SetEnabledState(self.db.global.Enabled);

end

local PLAYER_FACTION = "";
function HHTD:OnEnable()

    REGISTER_HEALERS_ONLY_SPELLS_ONCE ();

    self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
    self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "TestUnit");
    self:RegisterEvent("PLAYER_TARGET_CHANGED", "TestUnit");
    self:RegisterEvent("PLAYER_ALIVE"); -- talents SHOULD be available
    -- self:RegisterEvent("PARTY_MEMBER_DISABLE"); -- useless event, no argument...
    

    self:Print(L["ENABLED"]);

    self:SetModulesStates();

    PLAYER_FACTION = UnitFactionGroup("player");

    self:ScheduleRepeatingTimer(self.Undertaker,          10, self);
    self:ScheduleRepeatingTimer(self.UpdateHealThreshold, 50, self);

end

function HHTD:PLAYER_ALIVE()
    self:Debug("PLAYER_ALIVE");

    PLAYER_FACTION = UnitFactionGroup("player");

    self:UnregisterEvent("PLAYER_ALIVE");
end

function HHTD:PARTY_MEMBER_DISABLE(e, unit)
    self:Debug(INFO2, "PARTY_MEMBER_DISABLE:", unit);
end

function HHTD:OnDisable()

    self:Print(L["DISABLED"]);

end
-- }}}

HHTD.HealThreshold = 0;
function HHTD:UpdateHealThreshold()
    if not self.db.global.UHMHAP then return 0 end

    self.HealThreshold = math.ceil(self.db.global.HMHAP * UnitHealthMax('player'));

    return self.HealThreshold;
end


-- MouseOver and Target trigger {{{
do
    local LastDetectedGUID = "";
    function HHTD:TestUnit(eventName)

        local unit="";
        local pve = HHTD.db.global.Pve;

        if eventName=="UPDATE_MOUSEOVER_UNIT" then
            unit = "mouseover";
        elseif eventName=="PLAYER_TARGET_CHANGED" then
            unit = "target";
        else
            self:Print("called on invalid event");
            return;
        end

        local unitGuid = UnitGUID(unit);

        if not unitGuid then
            --self:Debug(WARNING, "No unit GUID");
            return;
        end

        local unitFirstName, unitRealm =  UnitName(unit);

        if not pve and not UnitIsPlayer(unit) or UnitIsDead(unit) then
            self:SendMessage("HHTD_DROP_HEALER", unitFirstName)
            --self:Debug("not pve and not UnitIsPlayer(unit) or UnitIsDead(unit)"); -- XXX
            return;
        end

        if UnitFactionGroup(unit) == PLAYER_FACTION then
            self:SendMessage("HHTD_DROP_HEALER", unitFirstName)
            --self:Debug("UnitFactionGroup(unit) == PLAYER_FACTION"); -- XXX
            return;
        end

        if UnitIsUnit("mouseover", "target") then
            --self:Debug("UnitIsUnit(\"mouseover\", \"target\")"); -- XXX

            if self.Enemy_Healers[unitGuid] then
                self:SendMessage("HHTD_MOUSE_OVER_OR_TARGET", unit, unitGuid, unitFirstName);
            end

            return;
        elseif LastDetectedGUID == unitGuid and unit == "target" then
            self:SendMessage("HHTD_TARGET_LOCKED", unit, unitGuid, unitFirstName)
            --self:Debug("LastDetectedGUID == unitGuid and unit == \"target\""); -- XXX

            return;
        end

        local localizedUnitClass, unitClass = UnitClass(unit);

        if not unitClass then
            self:SendMessage("HHTD_DROP_HEALER", unitFirstName)
            self:Debug(WARNING, "No unit Class");
            return;
        end

        -- Is the unit class able to heal?
        if HHTD_C.Healing_Classes[unitClass] then

            -- Has the unit healed recently?
            if HHTD.Enemy_Healers[unitGuid] then
                -- Is this sitill true?
                if (GetTime() - HHTD.Enemy_Healers[unitGuid]) > HHTD.db.global.HFT then
                    -- else CLEANING

                    self:Debug(INFO2, self:UnitName(unit), " did not heal for more than", HHTD.db.global.HFT, ", removed.");

                    HHTD.Enemy_Healers[unitGuid] = nil;
                    HHTD.Enemy_Healers_By_Name[unitFirstName] = nil;

                    self:SendMessage("HHTD_DROP_HEALER", unitFirstName, unitGuid);
                else
                    self:SendMessage("HHTD_HEALER_UNDER_MOUSE", unit, unitGuid, unitFirstName, LastDetectedGUID);
                    --self:Debug("HHTD_HEALER_UNDER_MOUSE"); -- XXX
                    LastDetectedGUID = unitGuid;
                end
            else
                --self:Debug(INFO2, "did not heal");
                self:SendMessage("HHTD_MOUSE_OVER_OR_TARGET", unit, unitGuid, unitFirstName);
            end
        else
            -- self:Debug(WARNING, "Bad unit Class"); -- XXX
            self:SendMessage("HHTD_DROP_HEALER", unitFirstName, unitGuid);
            HHTD.Enemy_Healers_By_Name_Blacklist[unitFirstName] = GetTime();
        end
    end
end -- }}}


-- Combat Event Listener (Main Healer Detection) {{{
do

    local bit           = _G.bit;
    local band          = _G.bit.band;
    local bor           = _G.bit.bor;
    local UnitGUID      = _G.UnitGUID;
    local UnitInRaid    = _G.UnitInRaid;
    local UnitInParty   = _G.UnitInParty;
    local UnitSetRole   = _G.UnitSetRole;
    local UnitGroupRolesAssigned   = _G.UnitGroupRolesAssigned;
    local CheckInteractDistance    = _G.CheckInteractDistance;
    local sub           = _G.string.sub;
    local GetTime       = _G.GetTime;
    local str_match     = _G.string.match;

    local FirstName = "";
    local time = 0;

    local NPC                   = COMBATLOG_OBJECT_CONTROL_NPC;
    local PET                   = COMBATLOG_OBJECT_TYPE_PET;
    local PLAYER                = COMBATLOG_OBJECT_TYPE_PLAYER;

--    local OUTSIDER              = COMBATLOG_OBJECT_AFFILIATION_OUTSIDER;
    local HOSTILE_OUTSIDER      = bit.bor (COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_REACTION_HOSTILE);
--    local FRIENDLY_TARGET       = bit.bor (COMBATLOG_OBJECT_TARGET, COMBATLOG_OBJECT_REACTION_FRIENDLY);

    local HOSTILE_OUTSIDER_NPC      = bit.bor (HOSTILE_OUTSIDER                     , COMBATLOG_OBJECT_TYPE_NPC);
    local FRIENDLY_NPC              = bit.bor (COMBATLOG_OBJECT_REACTION_FRIENDLY   , COMBATLOG_OBJECT_TYPE_NPC);
    local HOSTILE_OUTSIDER_PLAYER   = bit.bor (HOSTILE_OUTSIDER                     , COMBATLOG_OBJECT_TYPE_PLAYER);
    local FRIENDLY_PLAYER           = bit.bor (COMBATLOG_OBJECT_REACTION_FRIENDLY   , COMBATLOG_OBJECT_TYPE_PLAYER);

    local ACCEPTABLE_TARGETS = bit.bor (PLAYER, NPC);

    local Source_Is_NPC = false;
    local Source_Is_Human = false;
    local Source_Is_Friendly = false;

    local isHealSpell = false;

    local Healer_Registry = HHTD.Healer_Registry;

    local TOC = T._tocversion;

    local compatibilityPatchApplyed = false

    -- http://www.wowpedia.org/API_COMBAT_LOG_EVENT
    function HHTD:COMBAT_LOG_EVENT_UNFILTERED(e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, arg10, arg11 --[[ spellName --]], arg12, arg13 --[[ amount --]], ...)
        
        
        -- Pre 4.1 compatibility layer {{{
        if TOC ~= 40100 then
            if not compatibilityPatchApplyed then
                if TOC < 40100 then
                    -- call again inserting a fake hideCaster event
                    compatibilityPatchApplyed = true;
                    return self:COMBAT_LOG_EVENT_UNFILTERED(e, timestamp, event, false, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, arg10, arg11, arg12, arg13, ...);
                else -- > 40100
                    compatibilityPatchApplyed = true;
                    -- call again skipping sourceRaidFlags and destRaidFlags
                    return self:COMBAT_LOG_EVENT_UNFILTERED(e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, --[[destGUID,--]] destName, destFlags, arg10, --[[arg11,--]] arg12, arg13, ...);
                end
            end
            compatibilityPatchApplyed = false;
        end -- }}}

        --@debug@
        if hideCaster then
            --self:Debug(event, hideCaster, sourceGUID, sourceName, sourceFlags, type(sourceFlags), destGUID, destName, destFlags, type(destFlags), arg10, arg11, arg12, arg13, ...);
        end
        --@end-debug@
        

        -- escape if no source {{{
        -- untraceable events are useless
        if not sourceGUID or hideCaster then return end
        -- }}}

        local configRef = self.db.global; -- config shortcut

        -- Escape if bad target (not human nor npc) {{{
        -- Healers are only those caring for other players or NPC
        if band(destFlags, ACCEPTABLE_TARGETS) == 0 then
            --@debug@
            --[[
            if self.db.global.Debug and event:sub(-5) == "_HEAL" and sourceGUID ~= destGUID then
                self:Debug(INFO2, "Bad target", sourceName, destName);
            end
            --]]
            --@end-debug@
            return;
        end -- }}}

        Source_Is_NPC = false;
        Source_Is_Human = false;
        Source_Is_Friendly = false;

        if band(sourceFlags, HOSTILE_OUTSIDER_NPC) == HOSTILE_OUTSIDER_NPC then
            Source_Is_NPC = true;
        elseif band (sourceFlags, HOSTILE_OUTSIDER_PLAYER) == HOSTILE_OUTSIDER_PLAYER then
            Source_Is_Human = true;
        elseif band (sourceFlags, FRIENDLY_PLAYER) == FRIENDLY_PLAYER then
            Source_Is_Human = true;
            Source_Is_Friendly = true;
        elseif band (sourceFlags, FRIENDLY_NPC) == FRIENDLY_NPC then
            Source_Is_NPC = true;
            Source_Is_Friendly = true;
        end

        --@debug@
        --@end-debug@

        -- check if a healer is under attack - broadcast the event and return {{{
        -- if the source is hostile AND if its target is a registered friendly healer
        if (not Source_Is_Friendly) and Healer_Registry[true].Healers[destGUID] then

            if not self.Friendly_Healers_Attacked_by_GUID[destGUID] then
                if ( CheckInteractDistance(destName, 1)) then

                    self:SendMessage("HHTD_HEALER_UNDER_ATTACK", sourceName, sourceGUID, destName, destGUID);

                    self.Friendly_Healers_Attacked_by_GUID[destGUID] = GetTime();

                else
                    self:Error("Healer too far" .. tostring(CheckInteractDistance(destName, 1)));
                end
            end

            -- it's certainly not a heal so no use to continue past this point.
            return;
        end -- }}}

        -- Escape if bad source {{{
        -- if the source is not a player and if while pve, the source is not an npc, then we don't care about this event
        -- ie we care if the source is a human player or pve is enaled and the source is an npc.
        --      not (a or (b and c)) ==  !a and (not b or not c)
        if not ( Source_Is_Human or (configRef.Pve and Source_Is_NPC)) then
        --if not ( Source_Is_Hostile_Human or (configRef.Pve and Source_Is_Hostile_NPC)) then


            --@debug@
            --[[
            if  self.db.global.Debug then
                if  event:sub(-5) == "_HEAL" and sourceGUID ~= destGUID then
                    self:Debug(INFO2, "Bad heal source:", sourceName, "Dest:", destName, "pve:", configRef.Pve,
                    "HOSTILE_OUTSIDER_PLAYER:", band (sourceFlags, HOSTILE_OUTSIDER_PLAYER) == HOSTILE_OUTSIDER_PLAYER,
                    "HOSTILE_OUTSIDER_NPC:", band(sourceFlags, HOSTILE_OUTSIDER_NPC) == HOSTILE_OUTSIDER_NPC);
                end

                self:Debug(INFO2, "Bad source", sourceName, "Dest:", destName, "pve:", configRef.Pve,
                "HOSTILE_OUTSIDER_PLAYER:", band (sourceFlags, HOSTILE_OUTSIDER_PLAYER) == HOSTILE_OUTSIDER_PLAYER,
                "HOSTILE_OUTSIDER_NPC:", band(sourceFlags, HOSTILE_OUTSIDER_NPC) == HOSTILE_OUTSIDER_NPC);
            end
            --]]
            --@end-debug@

            return;
        end -- }}}

        -- Escape if Source_Is_Human and scanning for pure healing specs and the spell doesn't match {{{
        if Source_Is_Human and configRef.PvpHSpecsOnly and not HHTD_C.Healers_Only_Spells_ByName[arg11] then
            --@debug@
            --self:Debug(INFO2, "Spell", arg11, "is not a healer' spell");
            --@end-debug@
            return;
        end -- }}}

        if event:sub(-5) == "_HEAL" and sourceGUID ~= destGUID then
            isHealSpell = true;
        else
            isHealSpell = false;
        end

         -- Escape if not a heal spell and (not checking for spec's spells or source is a NPC) {{{
         -- we look for healing spells directed to others
         if not isHealSpell and (not configRef.PvpHSpecsOnly or Source_Is_NPC) then
             return false;
         end -- }}}

         -- if we are still here it means that this is a HEAL toward another
         -- player or an ability available to specialized healers only

         -- get source name
         if sourceName then
             FirstName = str_match(sourceName, "^[^-]+"); -- sourceName may be nil?? -- we need to use FirstName because of the name plates...
         else
             self:Debug(WARNING, "NO NAME for GUID:", sourceGUID);
             return;
         end


        -- Escape if player got blacklisted has not healer {{{
        -- Only if the unit class can heal - not post-blacklisted
        if Healer_Registry[Source_Is_Friendly].Healers_By_Name_Blacklist[FirstName] then
            self:Debug(INFO2, FirstName, " was blacklisted");
            return;
        end -- }}}


        -- Create a log entry for this healer
        if configRef.Log and not HHTD.LOG.Healers_Accusation_Proofs[sourceName] then
            HHTD.LOG.Healers_Accusation_Proofs[sourceName] = {};
            HHTD.LOG.Healers_Details[sourceName] = {};
            HHTD.LOG.Healers_Details[sourceName].isFriend = Source_Is_Friendly;
            HHTD.LOG.Healers_Details[sourceName].isHuman = Source_Is_Human;
            HHTD.LOG.Healers_Details[sourceName].totalHeal = 0;

            if HHTD_C.Healers_Only_Spells_ByName[arg11] then
                HHTD.LOG.Healers_Details[sourceName].class = HHTD_C.Healers_Only_Spells_ByName[arg11];
            end
        end

        -- If checking for minimum heal amount
        if configRef.UHMHAP then
            if isHealSpell then
                -- store Heal score
                if not Healer_Registry[Source_Is_Friendly].Total_Heal_By_Name[FirstName] then
                    Healer_Registry[Source_Is_Friendly].Total_Heal_By_Name[FirstName] = 0;
                end
                Healer_Registry[Source_Is_Friendly].Total_Heal_By_Name[FirstName] = Healer_Registry[Source_Is_Friendly].Total_Heal_By_Name[FirstName] + arg13;

                if configRef.Log then
                    HHTD.LOG.Healers_Details[sourceName].totalHeal = HHTD.LOG.Healers_Details[sourceName].totalHeal + arg13;
                end

                -- Escape if below minimum healing {{{
                if Healer_Registry[Source_Is_Friendly].Total_Heal_By_Name[FirstName] < HHTD.HealThreshold then
                    self:Debug(INFO2, FirstName, "is below minimum healing amount:", Healer_Registry[Source_Is_Friendly].Total_Heal_By_Name[FirstName]);
                    return;
                end -- }}}
            else
                -- Escape if not a heal spell and using UHMHAP {{{
                return; -- }}}
            end
        end

         time = GetTime();


         -- if logging and specs only
         if configRef.Log and HHTD_C.Healers_Only_Spells_ByName[arg11] then

             if not HHTD.LOG.Healers_Accusation_Proofs[sourceName][arg11] then
                 HHTD.LOG.Healers_Accusation_Proofs[sourceName][arg11] = 1;
             else
                 HHTD.LOG.Healers_Accusation_Proofs[sourceName][arg11] = HHTD.LOG.Healers_Accusation_Proofs[sourceName][arg11] + 1;
             end
         end


         -- useless to continue past this point if we just saw the healer
         if Healer_Registry[Source_Is_Friendly].Healers[sourceGUID] and time - Healer_Registry[Source_Is_Friendly].Healers[sourceGUID] < 5 then
             --self:Debug(INFO2, "Throtelling heal events for", FirstName);
             return
         end


         -- by GUID
         Healer_Registry[Source_Is_Friendly].Healers[sourceGUID] = time;
         -- by Name
         Healer_Registry[Source_Is_Friendly].Healers_By_Name[FirstName] = Healer_Registry[Source_Is_Friendly].Healers[sourceGUID];
         -- if the player is human and friendly and is part of our group, set his/her role to HEALER
         if configRef.SetFriendlyHealersRole and Source_Is_Friendly and Source_Is_Human and (UnitInRaid(sourceName) or UnitInParty(sourceName)) and UnitGroupRolesAssigned(sourceName) == 'NONE' then
             if (select(2, GetRaidRosterInfo(UnitInRaid("player")))) > 0 then
                 self:Debug(INFO, "Setting role to HEALER for", sourceName);
                 UnitSetRole(sourceName, 'HEALER');
             end
         end


         -- Dispatch the news
         self:Debug(INFO, "Healer detected:", FirstName);
         self:SendMessage("HHTD_HEALER_DETECTED", FirstName, sourceGUID, Source_Is_Friendly);

         -- TODO for GEHR: make activity light blink

     end
 end -- }}}

 -- Undertaker {{{
 local LastCleaned = 0;
 local LastBlackListCleaned = 0;
 local Time = 0;
 -- The Undertaker will garbage collect healers who have not been healing recently (whatever the reason...)
 function HHTD:Undertaker()

     Time = GetTime();

     local Healer_Registry = HHTD.Healer_Registry;
     --@debug@
     --self:Debug(INFO2, "cleaning...");
     --@end-debug@

     -- clean Healer_Registry table {{{
     for i, Friendly in ipairs({true, false}) do
         --@debug@
         --self:Debug(INFO2, "cleaning " .. (Friendly and "|cff00ff00friends|r..." or "|cffff0000enemies|r..."));
         --@end-debug@
         -- clean healers GUID
         for guid, lastHeal in pairs(Healer_Registry[Friendly].Healers) do
             if (Time - lastHeal) > self.db.global.HFT then
                 Healer_Registry[Friendly].Healers[guid] = nil;

                 self:Debug(INFO2, guid, "removed");
             end
         end

         -- clean healers Name
         for healerName, lastHeal in pairs(Healer_Registry[Friendly].Healers_By_Name) do
             if (Time - lastHeal) > self.db.global.HFT then
                 Healer_Registry[Friendly].Healers_By_Name[healerName] = nil;
                 Healer_Registry[Friendly].Total_Heal_By_Name[healerName] = nil;

                 self:SendMessage("HHTD_DROP_HEALER", healerName, nil, Friendly)

                 self:Debug(INFO2, healerName, "removed");
             end
         end
     end
     -- }}}

     LastCleaned = Time;

     -- clean player class blacklist {{{
     if (Time - LastBlackListCleaned) > 3600 then
         for i, Friendly in ipairs({true, false}) do
             --self:Debug(INFO2, "cleaning blacklisted " .. (Friendly and "|cff00ff00friends|r..." or "|cffff0000enemies|r..."));
             for Name, LastSeen in pairs(Healer_Registry[Friendly].Healers_By_Name_Blacklist) do

                 if (Time - LastSeen) > self.db.global.HFT then
                     Healer_Registry[Friendly].Healers_By_Name_Blacklist[Name] = nil;
                     self:Debug(INFO2, Name, "removed from class blacklist");
                 end

             end
         end
         LastBlackListCleaned = Time;
     end -- }}}

     -- clean attacked healers {{{
     -- also cleaned when such healer dies or leave combat XXX
     for guid, lastAttack in pairs(self.Friendly_Healers_Attacked_by_GUID) do
         -- if more than 30s elapsed since the last attack or if it's no longer a registered healer
         if Time - lastAttack > 30 or not Healer_Registry[true].Healers[guid] then
             self.Friendly_Healers_Attacked_by_GUID[guid] = nil;
             self:Debug(INFO2, "removed healer from attack table", guid);
         end
     end -- }}}

 end -- }}}

 --[=[
 (post by zalgorr on HHTD curse.com' comments page (2011-01-24)


 =============For priests:

 -Penance : HEAL : http://www.wowhead.com/spell=47540
 -Holy Word: Chastise -- http://www.wowhead.com/spell=88625  (damage spell)
 -Holy Word: Serenity -- HEAL : http://www.wowhead.com/spell=88684
 -Holy Word: Sanctuary -- MASS HEAL : http://www.wowhead.com/spell=88685
 -Inner Focus -- (not heal but increases heal) : http://www.wowhead.com/spell=89485
 -Power Infusion -- target enhancer : http://www.wowhead.com/spell=10060
 -Pain Suppression -- target enhancer : http://www.wowhead.com/spell=33206
 -Power Word: Barrier -- mass target enhancer : http://www.wowhead.com/spell=62618
 -Lightwell -- mass target enhancer : http://www.wowhead.com/spell=724
 -Chakra -- heal increase : http://www.wowhead.com/spell=14751
 -Circle of Healing -- mass heal : http://www.wowhead.com/spell=34861
 -Guardian Spirit -- target heal enhancer : http://www.wowhead.com/spell=47788

 =================For a druid:
 -Swiftmend           : HEAL : http://www.wowhead.com/spell=18562
 -Nature's Swiftness  : HEAL : http://www.wowhead.com/spell=17116
 -Wild Growth         : MASS HEAL : http://www.wowhead.com/spell=48438
 -Tree of Life        : not an actual spell (shape shift) : http://www.wowhead.com/spell=33891

 ====================Shaman:
 Earth Shield : enhancer, heals on target actions : http://www.wowhead.com/spell=974
 Nature's Swiftness : healer helper : http://www.wowhead.com/spell=17116
 Mana Tide Totem : healer helper (spirit) : http://www.wowhead.com/spell=16190
 Riptide : HEAL : http://www.wowhead.com/spell=61295

 ====================Paladin:
 Holy Shock : HEAL/DAMMAGE : http://www.wowhead.com/spell=20473
 Divine Favor : healer helper : http://www.wowhead.com/spell=31842
 Beacon of Light : heal : http://www.wowhead.com/spell=53563
 Aura Mastery : friends enhancer : http://www.wowhead.com/spell=31821
 Light of Dawn : mass heal : http://www.wowhead.com/spell=85222


 --]=]

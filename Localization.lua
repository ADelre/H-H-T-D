--[=[
H.H.T.D. World of Warcraft Add-on
Copyright (c) 2009-2017 by John Wellesz (Archarodim@teaser.fr)
All rights reserved

Version @project-version@

In World of Warcraft healers have to die. This is a cruel truth that you're
taught very early in the game. This add-on helps you influence this unfortunate
destiny in a way or another depending on the healer's side...

More information: https://www.wowace.com/projects/h-h-t-d

-----
    Localization.lua
-----


--]=]


--[=[
--                      YOUR ATTENTION PLEASE
--
--         !!!!!!! TRANSLATORS TRANSLATORS TRANSLATORS !!!!!!!
--
--    Thank you very much for your interest in translating H.H.T.D.
--    Do not edit this file. Use the localization interface available at the following address:
--
--      ##########################################################################
--      #     http://www.wowace.com/addons/h-h-t-d/localization/     #
--      ##########################################################################
--
--    Your translations made using this interface will be automatically included in the next release.
--
--]=]


do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "enUS", true, true);

    if L then
        --@localization(locale="enUS", format="lua_additive_table")@

        --@do-not-package@
        ---[==[
        -- Used for testing the addon without the packager
        L["ACTIVE"] = "Active!"
        L["Announcer"] = "Announcer"
        L["Announcer_DESC"] = "This module allows you to manage chat and sound alerts"
        L["CHAT_POST_ANNOUNCE_FEATURE_NOT_CONFIGURED"] = "The announce to raid messages are not configured. Type /HHTDG"
        L["CHAT_POST_ANNOUNCE_TOO_SOON_WAIT"] = "It's too soon (see the announce throttle setting)."
        L["CHAT_POST_NO_HEALERS"] = "No healers on either sides :/ (yet)"
        L["DESCRIPTION"] = "In World of Warcraft healers have to die. This is a cruel truth that you're taught very early in the game. This add-on helps you influence this unfortunate destiny in a way or another depending on the healer's side..."
        L["DISABLED"] = [=[hhtd has been disabled!
        Type '/hhtd on' to re-enable it.]=]
        L["ENABLED"] = "enabled! Type /HHTDG for a list of options"
        L["HEALER_UNDER_ATTACK"] = "Healer friend %s is being attacked by %s"
        L["HUMAN"] = "Human"
        L["IDLE"] = "Idle"
        L["IS_A_HEALER"] = "%s is a healer!"
        L["NO_DATA"] = "No data"
        L["NPC"] = "NPC"
        L["NPH"] = "Nameplate Hooker"
        L["NPH_DESC"] = "This module adds a red cross to enemy healers' nameplates"
        L["OPT_ANNOUNCE"] = "Show messages"
        L["OPT_ANNOUNCE_DESC"] = "HHTD will display messages when you target or mouse-over an enemy healer."
        L["OPT_CLEAR_LOGS"] = "Clear logs"
        L["OPT_CORE_OPTIONS"] = "Core options"
        L["OPT_DEBUGLEVEL_DESC"] = "debug level: 1=all, 2=warnings, 3=errors"
        L["OPT_DEBUGLEVEL"] = "debugging level"
        L["OPT_DEBUG"] = "debugging logs"
        L["OPT_DEBUG_DESC"] = "Enables / disables debugging"
        L["OPT_ENABLE_GEHR"] = "Enable Graphical Reporter"
        L["OPT_ENABLE_GEHR_DESC"] = "Displays a graphical list of detected enemy healers with various features"
        L["OPT_HEADER_GLOBAL_ENEMY_HEALER_OPTIONS"] = "Global enemy healers settings"
        L["OPT_HEADER_GLOBAL_FRIENDLY_HEALER_OPTIONS"] = "Global friendly healers settings"
        L["OPT_HEALER_FORGET_TIMER"] = "Healer Forget Timer"
        L["OPT_HEALER_FORGET_TIMER_DESC"] = "Set the Healer Forget Timer (the time in seconds an enemy will remain considered has a healer)"
        L["OPT_HEALER_MINIMUM_HEAL_AMOUNT"] = "Heal amount (|cff00dd00%u|r) threshold"
        L["OPT_HEALER_MINIMUM_HEAL_AMOUNT_DESC"] = "Healers won't be detected until they reach this cumulative amount of healing based on a percentage of your own maximum health."
        L["OPT_HEALER_UNDER_ATTACK_ALERTS"] = "Protect friendly healers"
        L["OPT_HEALER_UNDER_ATTACK_ALERTS_DESC"] = "Display an alert when a nearby friendly healers is attacked for more than |cffdd0000%u|r damage"
        L["OPT_PROTECT_HEALER_MINIMUM_DAMAGE_AMOUNT"] = "Damage amount (|cffdd0000%u|r) threshold"
        L["OPT_PROTECT_HEALER_MINIMUM_DAMAGE_AMOUNT_DESC"] = "Friendly attacked healers won't be detected until they reach this cumulative amount of damage based on a percentage of your own maximum health."
        L["OPT_LOG"] = "Logging"
        L["OPT_LOGS"] = "Logs"
        L["OPT_LOGS_DESC"] = "Display HHTD detected healers and statistics"
        L["OPT_LOG_DESC"] = "Enables logging and adds a new 'Logs' tab to HHTD's option panel"
        L["OPT_MODULES"] = "Modules"
        L["OPT_NPH_WARNING1"] = [=[WARNING: *Enemies*' nameplates are currently disabled. HHTD cannot add its symbol on enemies.
        You can enable nameplates display through the WoW UI's options or by using the assigned key-stroke.]=]
        L["OPT_NPH_WARNING2"] = [=[WARNING: *Allies*' nameplates are currently disabled. HHTD cannot add its symbol on allies.
        You can enable nameplates display through the WoW UI's options or by using the assigned key-stroke.]=]
        L["OPT_OFF"] = "off"
        L["OPT_OFF_DESC"] = "Disables HHTD"
        L["OPT_ON"] = "on"
        L["OPT_ON_DESC"] = "Enables HHTD"
        L["OPT_POST_ANNOUNCE_CHANNEL"] = "Post channel"
        L["OPT_POST_ANNOUNCE_CHANNEL_DESC"] = "Decide where your announce will be posted.\nNote: unless you want to use 'say' or 'yell' you should leave this to automatic."
        L["OPT_POST_ANNOUNCE_DESCRIPTION"] = [=[|cFFFF0000IMPORTANT:|r Type |cff40ff40/hhtdp|r or bind a key to announce friendly healers to protect and enemy healers to focus.

        (see World of Warcraft escape menu binding interface to bind a key)
        ]=]
        L["OPT_POST_ANNOUNCE_ENABLE"] = "Chat announces"
        L["OPT_POST_ANNOUNCE_ENABLE_DESC"] = "Enable announce to raid features."
        L["OPT_POST_ANNOUNCE_HUMAMNS_ONLY"] = "Humans only"
        L["OPT_POST_ANNOUNCE_HUMAMNS_ONLY_DESC"] = "Do not include NPCs in the announce."
        L["OPT_POST_ANNOUNCE_KILL_MESSAGE"] = "Text for enemy healers"
        L["OPT_POST_ANNOUNCE_KILL_MESSAGE_DESC"] = [=[Type a message inciting your team to focus enemy healers.

        You must use the [HEALERS] keyword somewhere which will be automatically replaced by the names of the currently active healers.]=]
        L["OPT_POST_ANNOUNCE_MESSAGES_EQUAL"] = "There is one message for friends and one for foes, they cannot be the same."
        L["OPT_POST_ANNOUNCE_MESSAGE_TOO_SHORT"] = "Your message is too short!"
        L["OPT_POST_ANNOUNCE_MISSING_KEYWORD"] = "The [HEALERS] keyword is missing!"
        L["OPT_POST_ANNOUNCE_NUMBER"] = "Healers number"
        L["OPT_POST_ANNOUNCE_NUMBER_DESC"] = "Set how many healers to include in each announce."
        L["OPT_POST_ANNOUNCE_POST_MESSAGE_ISSUE"] = "There is something wrong with one of the announce text."
        L["OPT_POST_ANNOUNCE_PROTECT_MESSAGE"] = "Text for friendly healers"
        L["OPT_POST_ANNOUNCE_PROTECT_MESSAGE_DESC"] = [=[Type a message inciting your team to protect their healers.

        You must use the [HEALERS] keyword somewhere which will be automatically replaced by the names of the currently active healers.]=]
        L["OPT_POST_ANNOUNCE_SETTINGS"] = "Announce to raid settings"
        L["OPT_POST_ANNOUNCE_THROTTLE"] = "Announce throttle"
        L["OPT_POST_ANNOUNCE_THROTTLE_DESC"] = "Set the minimum time in seconds between each possible announce."
        L["OPT_PVE"] = "Enable for PVE"
        L["OPT_PVE_DESC"] = "HHTD will also work for NPCs."
        L["OPT_PVPHEALERSSPECSONLY"] = "Healer specialization detection"
        L["OPT_PVPHEALERSSPECSONLY_DESC"] = "Only detect players specialized in healing."
        L["OPT_SET_FRIENDLY_HEALERS_ROLE"] = "Set friendly healers role"
        L["OPT_SET_FRIENDLY_HEALERS_ROLE_DESC"] = "Will automatically set the raid HEALER role to friendly healers upon detection (if possible)"
        L["OPT_SOUNDS"] = "Sound alerts"
        L["OPT_SOUNDS_DESC"] = "HHTD will play a specific sound when you hover or target an enemy healer"
        L["OPT_STRICTGUIDPVE"] = "Accurate PVE detection"
        L["OPT_STRICTGUIDPVE_DESC"] = "When several NPCs share the same name, HHTD will only add a cross over those who actually healed instead of adding a cross to all of them."
        L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT"] = "Use minimum heal amount filter"
        L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT_DESC"] = "Healers will have to heal for a specified amount before being tagged as such."
        L["OPT_VERSION"] = "version"
        L["OPT_VERSION_DESC"] = "Display version and release date"

        L["OPT_GUI_DESC"] = "Open the graphical configuration panel"
        L["OPT_GUI"]      = "Open GUI"

        L["PARTY"] = "Party"
        L["AUTO_RAID_PARTY_INSTANCE"] = "Auto: Raid Warning / Raid / Instance / Party"
        L["RELEASE_DATE"] = "Release Date:"
        L["SAY"] = "Say"
        L["VERSION"] = "version:"
        L["YELL"] = "Yell"
        L["YOU_GOT_HER"] = "You got %sher|r!"
        L["YOU_GOT_HIM"] = "You got %shim|r!"
        L["YOU_GOT_IT"] = "You got %sit|r!"
        
        L["OPT_TESTONTARGET"] = "Test HHTD's behavior on current target"
        L["OPT_TESTONTARGET_DESC"] = "Will mark your current target as a healer so you can test what happens."
        L["OPT_TESTONTARGET_ENOTARGET"] = "You need to target something"

        L["LOG_BELOW_THRESHOLD"] = " (below threshold)"
        L["LOG_ACTIVE"] = "Active!"
        L["LOG_IDLE"] = "Idle"


        L["OPT_NPH_MARKER_HIDDEN_WOW_SETTINGS"] = "Hidden WoW settings"
        L["OPT_NPH_MARKER_WOW_SETTINGS"] = "WoW settings"
        L["OPT_CM_FNPC_NAMEPLATE"] = "Friendly NPC nameplates"
        L["OPT_CM_FNPC_NAMEPLATE_DESC"] = "Show nameplates on friendly NPCs\nThis is necessary for markers to be shown on these units."

        L["OPT_NPH_ENEMY_NAMEPLATE"] = "Enemy nameplates"
        L["OPT_NPH_FRIENDLY_NAMEPLATE"] = "Friendly nameplates"

        L["OPT_A_HEALER_PROTECTION"] = "Healer protection settings"
        L["OPT_A_HUD_WARNING"] = "HUD Warning"
        L["OPT_A_HUD_WARNING_DESC"] = "Display a heads-up warning when a friendly healer is under attack"
        L["OPT_A_CHAT_WARNING"] = "Chat Warning"
        L["OPT_A_CHAT_WARNING_DESC"] = "Display a chat warning when a friendly healer is under attack"


        L["OPT_NPH_MARKER_SETTINGS"]         = "Markers' settings"

        L["OPT_NPH_MARKER_SCALE"]           = "Markers' scaling"
        L["OPT_NPH_MARKER_SCALE_DESC"]      = "Multiply markers' size by # i.e. 1 = normal size, 0.5 = half size, 2 = double size, etc..."
        L["OPT_NPH_MARKER_X_OFFSET"]        = "Horizontal offset"
        L["OPT_NPH_MARKER_X_OFFSET_DESC"]   = "Move markers horizontally"
        L["OPT_NPH_MARKER_Y_OFFSET"]        = "Vertical offset"
        L["OPT_NPH_MARKER_Y_OFFSET_DESC"]   = "Move markers vertically"

        L["OPT_SWAPSYMBOLS"]        = "Swap friends/foes symbols"
        L["OPT_SWAPSYMBOLS_DESC"]   = "The symbols used for friends and foes are swapped"
        
        L["INSTANCE_CHAT"]                  = "Instance chat"

        L["CM"] = "Custom Marks"
        L["CM_DESC"] = "Enable this module to set permanent custom marks on NPC and Player units' nameplates."

        L["OPT_CM_DESCRIPTION"] = "Here you can target a unit and apply a custom mark only you will see, these marks will persist accross sessions."
        L["OPT_CM_SELECT_MARKER"]           = "Marker"
        L["OPT_CM_SELECT_MARKER_DESC"]      = "Select a marker to apply to your target"
        L["OPT_CM_SETTARGETMARKER"]         = "Mark target"
        L["OPT_CM_SETTARGETMARKER_DESC"]    = "Mark the selected target with the selected marker"
        L["OPT_CM_CLEARTARGETMARKER"]       = "Clear target"
        L["OPT_CM_CLEARTARGETMARKER_DESC"]  = "Remove the marker from your target"

        L["OPT_CM_MARKER_MANAGEMENT"] = "Marker management"
        L["OPT_CM_EXISTINGASSOC"] = "Existing name-marker associations"
        L["OPT_CM_EXISTINGASSOC_DESC"] = "Select a name in this list to use with the other buttons of this section"
        L["OPT_CM_CHANGEMARK"] = "Change to %s"
        L["OPT_CM_CHANGEMARK_DESC"] = "Change the mark to the one selected in the '%s' selector"
        L["OPT_CM_CLEARASSOC"] = "Clear"
        L["OPT_CM_CLEARASSOC_DESC"] = "Clear the selected name from its mark"



        L["OPT_CM_MARKER_CUSTOMIZATION"] = "Marker customization"

        L["OPT_CM_VCr"]       = "Red Shading"
        L["OPT_CM_VCr_DESC"]  = "Change texture's red component shading"
        L["OPT_CM_VCg"]       = "Green Shading"
        L["OPT_CM_VCg_DESC"]  = "Change texture's Green component shading"
        L["OPT_CM_VCb"]       = "Blue Shading"
        L["OPT_CM_VCb_DESC"]  = "Change texture's Blue component shading"
        L["OPT_CM_VCa"]       = "Alpha Shading"
        L["OPT_CM_VCa_DESC"]  = "Change texture's Alpha component shading"
        --]==]
        --@end-do-not-package@

    end

end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "frFR");

    if L then
        --@localization(locale="frFR", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "deDE");

    if L then
        --@localization(locale="deDE", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "esES");

    if L then
        --@localization(locale="esES", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "esMX");

    if L then
        --@localization(locale="esMX", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "koKR");

    if L then
        --@localization(locale="koKR", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "zhCN");

    if L then
        --@localization(locale="zhCN", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "zhTW");

    if L then
        --@localization(locale="zhTW", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "ruRU");

    if L then
        --@localization(locale="ruRU", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("H.H.T.D.", "itIT");

    if L then
        --@localization(locale="itIT", format="lua_additive_table")@
    end
end

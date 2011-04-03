--[=[
HealersHaveToDie World of Warcraft Add-on
Copyright (c) 2009-2011 by John Wellesz (Archarodim@teaser.fr)
All rights reserved

Version @project-version@

This is a very simple and light add-on that rings when you hover or target a
unit of the opposite faction who healed someone during the last 60 seconds (can
be configured).
Now you can spot those nasty healers instantly and help them to accomplish their destiny!

This add-on uses the Ace3 framework.

type /hhtd to get a list of existing options.

-----
    Localization.lua
-----


--]=]


--[=[
--                      YOUR ATTENTION PLEASE
--
--         !!!!!!! TRANSLATORS TRANSLATORS TRANSLATORS !!!!!!!
--
--    Thank you very much for your interest in translating Healers Have To Die.
--    Do not edit this file. Use the localization interface available at the following address:
--
--      ##########################################################################
--      #  http://wow.curseforge.com/projects/healers-have-to-die/localization/  #
--      ##########################################################################
--
--    Your translations made using this interface will be automatically included in the next release.
--
--]=]


do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "enUS", true, true);

    if L then
        --@localization(locale="enUS", format="lua_additive_table")@

    --@do-not-package@
    ---[==[
    -- Used for testing the addon without the packager
    L["Announcer"] = "Announcer"
    L["Announcer_DESC"] = "This module allows you to manage chat and sound alerts"
    L["DESCRIPTION"] = "Spot those bloody healers instantly and help them accomplish their destiny! (PVP and PVE)"
    L["DISABLED"] = [=[hhtd has been disabled!
    Type /hhtd enable to re-enable it.]=]
    L["ENABLED"] = "enabled! Type /hhtd for a list of options"
    L["IS_A_HEALER"] = "%s is a healer!"
    L["NPH"] = "Name Plate Hooker"
    L["NPH_DESC"] = "This module adds a red cross to enemy healers' name plates"
    L["OPT_ANNOUNCE"] = "Show messages"
    L["OPT_ANNOUNCE_DESC"] = "HHTD will display messages when you target or mouse-over an enemy healer."
    L["OPT_CORE_OPTIONS"] = "Core options"
    L["OPT_DEBUG"] = "debug"
    L["OPT_DEBUG_DESC"] = "Enables / disables debugging"
    L["OPT_ENABLE_GEHR"] = "Enable Graphical Reporter"
    L["OPT_ENABLE_GEHR_DESC"] = "Displays a graphical list of detected enemy healers with various features"
    L["OPT_HEALER_FORGET_TIMER"] = "Healer Forget Timer"
    L["OPT_HEALER_FORGET_TIMER_DESC"] = "Set the Healer Forget Timer (the time in seconds an enemy will remain considered has a healer)"
    L["OPT_HEALER_MINIMUM_HEAL_AMOUNT"] = "Heal amount (|cff00dd00%u|r) threshold"
    L["OPT_HEALER_MINIMUM_HEAL_AMOUNT_DESC"] = "Healers won't be detected until they reach this cumulative amount of healing based on a percentage of your own maximum health. (has no effect in PVP when \\\"Healer specialization detection\\\" is checked)"
    L["OPT_MODULES"] = "Modules"
    L["OPT_OFF"] = "off"
    L["OPT_OFF_DESC"] = "Disables HHTD"
    L["OPT_ON"] = "on"
    L["OPT_ON_DESC"] = "Enables HHTD"
    L["OPT_PVE"] = "Enable for PVE"
    L["OPT_PVE_DESC"] = "HHTD will also work for NPCs."
    L["OPT_PVPHEALERSSPECSONLY"] = "Healer specialization detection"
    L["OPT_PVPHEALERSSPECSONLY_DESC"] = "Only detect players specialized in healing. (this disables minimum heal amount filter for PVP)"
    L["OPT_SOUNDS"] = "Sound alerts"
    L["OPT_SOUNDS_DESC"] = "HHTD will play a specific sound when you hover or target an enemy healer"
    L["OPT_STRICTGUIDPVE"] = "Accurate PVE detection"
    L["OPT_STRICTGUIDPVE_DESC"] = "When several NPCs share the same name, HHTD will only add a cross over those who actually healed instead of adding a cross to all of them. Note that most of the time, you'll need to target or mouse-over the unit for the cross to appear."
    L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT"] = "Use minimum heal amount filter"
    L["OPT_USE_HEALER_MINIMUM_HEAL_AMOUNT_DESC"] = "Healers will have to heal for a specified amount before being tagged as such."
    L["OPT_VERSION"] = "version"
    L["OPT_VERSION_DESC"] = "Display version and release date"
    L["RELEASE_DATE"] = "Release Date:"
    L["VERSION"] = "version:"
    L["YOU_GOT_HER"] = "You got %sher|r!"
    L["YOU_GOT_HIM"] = "You got %shim|r!"
    L["YOU_GOT_IT"] = "You got %sit|r!"

    L["OPT_NPH_WARNING1"] = "WARNING: Enemies' name-plates are currently disabled. HHTD cannot add its red cross symbol.\nYou can enable name-plates display through the WoW UI's options or by using the assigned key-stroke."
    L["OPT_NPH_WARNING2"] = "WARNING: Allies' name-plates are currently disabled. HHTD cannot add its green cross symbol.\nYou can enable name-plates display through the WoW UI's options or by using the assigned key-stroke."

    L["OPT_LOG"] = "Logging";
    L["OPT_LOG_DESC"] = "Enable logging and adds a new 'Logs' tab to HHTD's option panel";
    L["OPT_LOGS"] = "Logs";
    L["OPT_LOGS_DESC"] = "Display HHTD detected healers and statistics";
    L["OPT_CLEAR_LOGS"] = "Clear logs";

    L["NO_DATA"] = "No data";
    L["HUMAN"] = "Human player";
    L["NPC"] = "NPC";

    L["ACTIVE"] = "Active!";
    L["IDLE"] = "Idle";
    --]==]
    --@end-do-not-package@

    end

end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "frFR");

    if L then
        --@localization(locale="frFR", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "deDE");

    if L then
        --@localization(locale="deDE", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "esES");

    if L then
        --@localization(locale="esES", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "esMX");

    if L then
        --@localization(locale="esMX", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "koKR");

    if L then
        --@localization(locale="koKR", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "zhCN");

    if L then
        --@localization(locale="zhCN", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "zhTW");

    if L then
        --@localization(locale="zhTW", format="lua_additive_table")@
    end
end

do
    local L = LibStub("AceLocale-3.0"):NewLocale("HealersHaveToDie", "ruRU");

    if L then
        --@localization(locale="ruRU", format="lua_additive_table")@
    end
end



local _, addon = ...

local changelog = {
    [35] = [=[
# 2.2.9
- Fix for collected module checking invalid items like currencies from vendors.
    ]=],
    [34] = [=[
# 2.2.8
- Fix spellId for Skyreach teleport. WoW is using the old ID rather than the new one.
    ]=],
    [33] = [=[
# 2.2.7
- Fixed an error when importing builds to a specialization that hasn't been activated yet.
    ]=],
    [32] = [=[
# 2.2.6
- Update TOC for 12.0.5
    ]=],
    [31] = [=[
# 2.2.5
- Minor settings fix to accomidate the random option.
    ]=],
    [30] = [=[
# 2.2.4
- Random Hearthstone now features settings to enable or disable specific toys.
    ]=],
    [29] = [=[
# 2.2.3
- Travel frames can now also be closed by pressing ESC.
- Travel frame now defaults to Hearthstone item if no option is selected, and warns the user if item is missing.
    ]=],
    [28] = [=[
# 2.2.2
- New option for Random Hearthstone toy. Will pick from any of your known toys.
    ]=],
    [27] = [=[
# 2.2.1
- Updated VehicleHUD to respect recent hotfix for secret values.
- Added new affix to Vaultprogress infopanel.
    ]=],
    [26] = [=[
# 2.2.0
- Changelog improvements.
- Added 3 new hearthstone toys.
    ]=],
    [25] = [=[
# 2.1.12
- Fix for VechileHUD padding when only one ability exist.
    ]=],
    [24] = [=[
# 2.1.11
- Pause autogossip while dialog window is open to avoid endless loop.
    ]=],
    [23] = [=[
# 2.1.10
- Add new mage teleport/portal.
- Add verified entries for Midnight airdrop whitelist.
- New module: Autogossip
    ]=],
    [22] = [=[
# 2.1.9
- Fix an issue with the travelframe hiding too early.
    ]=],
    [21] = [=[
# 2.1.8
- Use the timer text for LossOfControl icon.
- Ignore chat message if it contains a secret value.
- Fix drinkmacro settings.
    ]=],
    [20] = [=[
# 2.1.7
- Added changelog ingame.
    ]=],
    [19] = [=[
# 2.1.6
- If using Plumber, add its housing macro to the travelframe.
    ]=],
    [18] = [=[
# 2.1.5
- Removed renown tracking.
- Updated upgrade currencyID's.
- Added new wormhole toy.
- Added Arcantina toy.
- Updated current category for midnight season 1.
    ]=],
    [17] = [=[
# 2.1.4
- (Fix) Travel settings loaded before data was finished proccessing.
- Attempt to catch weekly reset earlier in the init.
- Update TOC
    ]=],
    [16] = [=[
# 2.1.3 (Re-release)
- Added ES_Travel as a module
    ]=],
    [15] = [=[
# 2.1.2
- Added ES_Talents as a module
    ]=],
    [14] = [=[
# 2.1.1
- Minor fixes
    ]=],
    [13] = [=[
# 2.1.0
- Prepatch update
    ]=],
    [12] = [=[
# 2.0.10
- Collected: Properly hide while looking at the buyback tab
- Button Art: Respect combat during enable/disable
- Small core fixes.
    ]=],
    [11] = [=[
# 2.0.9
- Button Art: Adjust Blizzards padding values. Should now reflect the cleaner sizes when both ExtraActionButton1 and ZoneAbility are displayed at the same time.
    ]=],
    [10] = [=[
# 2.0.8
- Efficiency update. Stop using looptimers.
    ]=],
    [9] = [=[
# 2.0.7.a
- New module: VehicleHUD
- (a) Fixed a filepath error
    ]=],
    [8] = [=[
# 2.0.7
- New module: VehicleHUD
    ]=],
    [7] = [=[
# 2.0.6
- Changed artwork for button borders
- Minor tooltip cleanup for settings
    ]=],
    [6] = [=[
# 2.0.5
- Update TOC
    ]=],
    [5] = [=[
# 2.0.4
- Fix ZoneAbility border
    ]=],
    [4] = [=[
# 2.0.3
- Cleaned up some text spacing in the vaultprogress display.
- Fixed a case of nil data on when initiating affix info.
- New module: ExtraActionButton art tweak
- New module: LossOfControl art tweak
    ]=],
    [3] = [=[
# 2.0.2
- Fixed a wrong reference in currencies init.
    ]=],
    [2] = [=[
# 2.0.1
- Removed the use of libraries.
    ]=],
    [1] = [=[
# 2.0.0
- Initial migration to GitHub.
- Structure all features into modules (this includes new modules that previously were stand-alone addons).
- Settings available in ESC -> Options -> AddOns.
    ]=],
}

addon.changelog = function(showall,frame)
    local log = "Changelog:\n\n"
    local last = showall and 1 or ESUTIL_DB.readChangeLog + 1
    local show = false
    for i=#changelog,last,-1 do
        if not changelog[i] then break end
        log = log .. changelog[i] .. "\n"
        show = true
    end
    if show then
        frame:SetAlpha(1)
    else
        frame:SetAlpha(0)
    end
    return show and log or ""
end

addon.markAsRead = function()
    ESUTIL_DB.readChangeLog = #changelog
end
local _, addon = ...

addon.changelog = [=[
Changelog:

# 2.1.9
- Fix an issue with the travelframe hiding too early.

# 2.1.8
- Use the timer text for LossOfControl icon.
- Ignore chat message if it contains a secret value.
- Fix drinkmacro settings.

# 2.1.7
- Added changelog ingame.

# 2.1.6
- If using Plumber, add its housing macro to the travelframe.

# 2.1.5
- Removed renown tracking.
- Updated upgrade currencyID's.
- Added new wormhole toy.
- Added Arcantina toy.
- Updated current category for midnight season 1.

# 2.1.4
- (Fix) Travel settings loaded before data was finished proccessing.
- Attempt to catch weekly reset earlier in the init.
- Update TOC

# 2.1.3 (Re-release)
- Added ES_Travel as a module

# 2.1.2
- Added ES_Talents as a module

# 2.1.1
- Minor fixes

# 2.1.0
- Prepatch update

# 2.0.10
- Collected: Properly hide while looking at the buyback tab
- Button Art: Respect combat during enable/disable
- Small core fixes.

# 2.0.9
- Button Art: Adjust Blizzards padding values. Should now reflect the cleaner sizes when both ExtraActionButton1 and ZoneAbility are displayed at the same time.

# 2.0.8
- Efficiency update. Stop using looptimers.

# 2.0.7.a
- New module: VehicleHUD
- (a) Fixed a filepath error

# 2.0.7
- New module: VehicleHUD

# 2.0.6
- Changed artwork for button borders
- Minor tooltip cleanup for settings

# 2.0.5
- Update TOC

# 2.0.4
- Fix ZoneAbility border

# 2.0.3
- Cleaned up some text spacing in the vaultprogress display.
- Fixed a case of nil data on when initiating affix info.
- New module: ExtraActionButton art tweak
- New module: LossOfControl art tweak

# 2.0.2
- Fixed a wrong reference in currencies init.

# 2.0.1
- Removed the use of libraries.

# 2.0.0
- Initial migration to GitHub.
- Structure all features into modules (this includes new modules that previously were stand-alone addons).
- Settings available in ESC -> Options -> AddOns.

]=]


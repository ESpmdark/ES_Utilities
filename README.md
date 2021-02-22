# ES_Utilities

Disclamer:
Personal tiny addon that is made for me and my friends.
It has a very niche usage, that won't be needed for the general public.

Hosting it here so they can more easily get updates if I make any alterations.

---
---

## Public functions:

### ESUtil_GetUnit(GUID)
- For situations where you only have the GUID, but would like to lookup the unitId (etc)
! Only has lookup for units in your group/raid. Or when solo, yourself and pet.


Usage:

GUID = "PLAYERS"

returns only players in your group.

GUID = "PETS"

returns only pets in your group.

GUID = GUID

returns that unit, if it exists.


Example:

    [GUID] = {
       ["uid"] = unitId,
       ["role"] = "TANK",
       ["name"] = "Classcolored UnitName"
    }

local unit = ESUtil_GetUnit(GUID).uid



### ESUtil_GetRole(ROLE)

returns a table of unitId's that match your argument

    for unit,_ in pairs(ESUtil_GetRole("DAMAGER")) do
       -- Do whatever you want with it
    end

Roles = TANK, HEALER, DAMAGER, NONE



### ESUtil_GetCovenant(unit)

returns that unit's covenant, aslong as it exist in the database.

ES_Utilities will pick up any usage of covenant abilities (and signature abilities) around you, and store this for future lookup.

If a player has changed covenant (or stored for the first time) and does not match stored data, a weakaura event will trigger as we update the info.

NB: Event only triggers if the unit is in your own group.

> Eventname: "ESUTILITIES_WA_COVENANTUPDATE"

[Example WeakAura](https://wago.io/asOal1H-H)

Displaying a covenant symbol on partyframes (and raidframes, if enabled in custom options), if the unit is tracked by this addon.

No symbol if missing. Will however trigger an update in the weakaura once the unit has used a trackable spell, determining its covenant.



### Generic Event:

Throttled event to use for WeakAuras where you dont want to create an internal timer, and dont want to run the code on "Every Frame".

Event fires every 2 seconds.

> Eventname: "ESUTILITIES_WA_EVENT"

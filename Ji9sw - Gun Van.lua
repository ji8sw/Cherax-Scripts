----------------------- FUNCTIONS ------------------------ 

function SetGlobalInt(Index, Value)
    ScriptGlobal.SetInt(Index, Value)
end

function GetGlobalInt(Index)
    return ScriptGlobal.GetInt(Index)
end

function PLAYER_PED_ID()
    return Natives.InvokeInt(0xD80958FC74E988A6)
end

function SET_ENTITY_COORDS(Entity, X, Y, Z, InvertX, InvertY, InvertZ, ClearArea)
    return Natives.InvokeVoid(0x06843DA7060A026B, Entity, X, Y, Z, InvertX or false, InvertY or false, InvertZ or false, ClearArea or false)
end

function GET_CURRENT_PED_WEAPON(Ped, AllocatedInt)
    return Natives.InvokeBool(0x3A87E44BB9A01D54, Ped, AllocatedInt, true)
end

function NETWORK_IS_SESSION_STARTED()
    return Natives.InvokeBool(0x9DE624D2FC4B603F)
end

function NETWORK_IS_SESSION_ACTIVE()
    return Natives.InvokeBool(0xD83C2B94E7508980)
end

function SET_NEW_WAYPOINT(X, Y)
    return Natives.InvokeVoid(0xFE43368D2AA4F2FC, X, Y)
end

function SET_PED_INTO_VEHICLE(Ped, Veh, Seat)
    return Natives.InvokeVoid(0xF75B0D629E1C063D, Ped, Veh, Seat)
end

function GET_ENTITY_MODEL(Entity)
    return Natives.InvokeInt(0x9F47B058362C84B5, Entity)
end

function REVERSE_SCRIPTED_VEHICLE_EFFECTS(GunVanHandle) -- Reverses the effects created by the gunvan script when the vehicle is spawned, which stops the player from driving it
    Natives.InvokeInt(0x3910051CCECDB00C, GunVanHandle, false) -- SET_ENTITY_SHOULD_FREEZE_WAITING_ON_COLLISION
    Natives.InvokeInt(0x428CA6DBD1094446, GunVanHandle, false) -- FREEZE_ENTITY_POSITION
    Natives.InvokeInt(0xDBC631F109350B8C, GunVanHandle, false) -- SET_DONT_ALLOW_PLAYER_TO_ENTER_VEHICLE_IF_LOCKED_FOR_PLAYER
    Natives.InvokeInt(0x2311DD7159F00582, GunVanHandle, false) -- SET_VEHICLE_RESPECTS_LOCKS_WHEN_HAS_DRIVER
    Natives.InvokeInt(0xB664292EAECF7FA6, GunVanHandle, 1) -- SET_VEHICLE_DOORS_LOCKED (1 = VEHICLELOCK_UNLOCKED)
end

function REVERSE_SCRIPTED_PED_EFFECTS(SellerHandle) -- Reverses the effects created by the gunvan script when the gun van seller ped is spawned, which stops the player from shooting him
    Natives.InvokeInt(0x1A9205C1B9EE827F, SellerHandle, true, true) -- SET_ENTITY_COLLISION
    Natives.InvokeInt(0x428CA6DBD1094446, SellerHandle, false) -- FREEZE_ENTITY_POSITION
    Natives.InvokeInt(0x3882114BDE571AD4, SellerHandle, false, false) -- SET_ENTITY_INVINCIBLE

    for Index = 0, 17 do
        Natives.InvokeInt(0xD86D101FCFD00A4B, SellerHandle, Index) -- CLEAR_RAGDOLL_BLOCKING_FLAGS
    end

    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 128, true) -- SET_PED_CONFIG_FLAG, CanBeAgitated
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 179, false) -- SET_PED_CONFIG_FLAG, IgnoreAnimInterupts
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 208, false) -- SET_PED_CONFIG_FLAG, DisableExplosionReactions
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 294, false) -- SET_PED_CONFIG_FLAG, DisableShockingEvents
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 430, true) -- SET_PED_CONFIG_FLAG, IgnoreBeingOnFire
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 118, true) -- SET_PED_CONFIG_FLAG, RunFromFiresAndExplosions
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 116, false) -- SET_PED_CONFIG_FLAG, GetOutBurningVehicle
    Natives.InvokeInt(0x1913FE4CBF41C463, SellerHandle, 461, true) -- SET_PED_CONFIG_FLAG, Unknown

    Natives.InvokeInt(0xFAEE099C6F890BB8, SellerHandle, false, false, false, false, false, false, false, false) -- SET_ENTITY_PROOFS
    Natives.InvokeInt(0x9F8AA94D6D97DBF4, SellerHandle, false) -- SET_BLOCKING_OF_NON_TEMPORARY_EVENTS
    Natives.InvokeInt(0x1760FFA8AB074D66, SellerHandle, true) -- SET_ENTITY_CAN_BE_DAMAGED
    Natives.InvokeInt(0x0F62619393661D6E, SellerHandle, false, false) -- SET_PED_TREATED_AS_FRIENDLY, FYI: PARAM 1: PedIndex, PARAM 2: Enable, PARAM 3: IsLocal
    Natives.InvokeInt(0x63F58F7C80513AAD, SellerHandle, true) -- SET_PED_CAN_BE_TARGETTED

    Natives.InvokeInt(0xB6BA2444AB393DA2, SellerHandle, Utils.Joaat("SHOPKEEPER_GUN_VAN")) -- REMOVE_RELATIONSHIP_GROUP
end

function ADD_BLIP_FOR_COORD(X, Y, Z)
    return Natives.InvokeInt(0x5A039BB0BCA604B6, X, Y, Z)
end

function SET_BLIP_SPRITE(Blip, SpriteID)
    return Natives.InvokeVoid(0xDF735600A4696DAF, Blip, SpriteID)
end

function SET_BLIP_SCALE(Blip, Scale)
    return Natives.InvokeVoid(0xD38744167B2FA257, Blip, Scale)
end

----------------------- VARIABLES ------------------------

local Globals = {}

if Cherax.GetEdition() == "EE" then -- Enhanced Globals
    Globals = 
    {
        Position = 2652571 + 2706, -- Line 3962 (int func_14())
        WeaponSlots = 262145 + 33775, -- Line 33556
        WeaponDiscount = 262145 + 33786, -- Line 34648
        ThrowableSlots = 262145 + 33295, -- Line 34662
        ThrowableDiscount = 262145 + 33299, -- Line 18117
        ArmourDiscount = 262145 + 33303 -- Line 34676
    }
else -- Legacy Globals
    Globals = 
    {
        Position = 2652568 + 2706, -- Line 3962 (int func_14())
        WeaponSlots = 262145 + 33273, -- Line 33556
        WeaponDiscount = 262145 + 33284, -- Line 34648
        ThrowableSlots = 262145 + 33295, -- Line 34662
        ThrowableDiscount = 262145 + 33299, -- Line 18117
        ArmourDiscount = 262145 + 33303 -- Line 34676
    }
end

local SelectedSlot = 1
local SelectedSlot_Throwables = 1
local WasOffline = true
Script.QueueJob(function()
    local CurrentPosition = GetGlobalInt(Globals.Position) + 1
    local DefaultGuns = { GetGlobalInt(Globals.WeaponSlots + 1), GetGlobalInt(Globals.WeaponSlots + 2), GetGlobalInt(Globals.WeaponSlots + 3), GetGlobalInt(Globals.WeaponSlots + 4), GetGlobalInt(Globals.WeaponSlots + 5), GetGlobalInt(Globals.WeaponSlots + 6), GetGlobalInt(Globals.WeaponSlots + 7), GetGlobalInt(Globals.WeaponSlots + 8), GetGlobalInt(Globals.WeaponSlots + 9), GetGlobalInt(Globals.WeaponSlots + 10)  }
    local DefaultThrowables = { GetGlobalInt(Globals.ThrowableSlots + 1), GetGlobalInt(Globals.ThrowableSlots + 2) }
end)
local GunVanCoords = { {-29.532, 6435.136, 31.162}, {1705.214, 4819.167, 41.75}, {1795.522, 3899.753, 33.869}, {1335.536, 2758.746, 51.099}, {795.583, 1210.78, 338.962}, {-3192.67, 1077.205, 20.594}, {-789.719, 5400.921, 33.915}, {-24.384, 3048.167, 40.703}, {2666.786, 1469.324, 24.237}, {-1454.966, 2667.503, 3.2}, {2340.418, 3054.188, 47.888}, {1509.183, -2146.795, 76.853}, {1137.404, -1358.654, 34.322}, {-57.208, -2658.793, 5.737}, {1905.017, 565.222, 175.558}, {974.484, -1718.798, 30.296}, {779.077, -3266.297, 5.719}, {-587.728, -1637.208, 19.611}, {733.99, -736.803, 26.165}, {-1694.632, -454.082, 40.712}, {-1330.726, -1163.948, 4.313}, {-496.618, 40.231, 52.316}, {275.527, 66.509, 94.108}, {260.928, -763.35, 30.559}, {-478.025, -741.45, 30.299}, {894.94, 3603.911, 32.56}, {-2166.511, 4289.503, 48.733}, {1465.633, 6553.67, 13.771}, {1101.032, -335.172, 66.944}, {149.683, -1655.674, 29.028} }

 --------------------- GUN VAN OPTIONS [WEAPONS] ---------------------

FeatureMgr.AddFeature(Utils.Joaat("LUA_CHOOSE_GUNVAN_SLOT"), "1. Choose Gun Van Slot", eFeatureType.SliderInt, "Choose the gun van slot to modify from 1-10", function()
	SelectedSlot = FeatureMgr.GetFeature(Utils.Joaat("LUA_CHOOSE_GUNVAN_SLOT")):GetIntValue() - 1
end):SetLimitValues(1, 9):SetIntValue(1)

FeatureMgr.AddFeature(Utils.Joaat("LUA_MODIFY_GUNVAN_SLOT"), "2. Choose Weapon", eFeatureType.InputText, "Choose what the selected gun van slot will contain, from one of the weapon ID's found at: https://wiki.rage.mp/index.php?title=Weapons", function()   
end):SetStringValue("weapon_raypistol")

FeatureMgr.AddFeature(Utils.Joaat("LUA_EXECUTE_MODIFY_GUNVAN_SLOT"), "3. Modify Slot", eFeatureType.Button, "Apply the weapon ID to the selected slot", function()
    SetGlobalInt(Globals.WeaponSlots + SelectedSlot, Utils.Joaat(FeatureMgr.GetFeature(Utils.Joaat("LUA_MODIFY_GUNVAN_SLOT")):GetStringValue()))
    GUI.AddToast("Slot Modified", "This weapon is now in the gun van in slot #" .. SelectedSlot .. ".", 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_SET_TO_CURRENT_WEAPON"), "Set To Current Weapon", eFeatureType.Button, "Set the current selected slot to the current weapon you are holding", function()
    local WeaponHash = Memory.AllocInt()
    local HasWeapon = GET_CURRENT_PED_WEAPON(PLAYER_PED_ID(), WeaponHash, true)

    if not HasWeapon then
        GUI.AddToast("No Weapon", "No Current Weapon.", 3000)
        return
    end

    local Value, Success = Memory.ReadInt(WeaponHash)
    SetGlobalInt(Globals.WeaponSlots + SelectedSlot, Value)
    GUI.AddToast("Applied Weapon To Slot", "Applied current weapon to slot #" .. SelectedSlot, 3000)
end)

 --------------------- GUN VAN OPTIONS [THROWABLES] ---------------------

 FeatureMgr.AddFeature(Utils.Joaat("LUA_THROWABLES_CHOOSE_GUNVAN_SLOT"), "1. Choose Gun Van Slot", eFeatureType.SliderInt, "Choose the gun van slot to modify from 1-3", function()
	SelectedSlot_Throwables = FeatureMgr.GetFeature(Utils.Joaat("LUA_THROWABLES_CHOOSE_GUNVAN_SLOT")):GetIntValue()
	GUI.AddToast("Step Completed", "Slot #" .. SelectedSlot_Throwables .. " selected, proceed to step #2.", 3000)
end):SetLimitValues(1, 3):SetIntValue(1)

FeatureMgr.AddFeature(Utils.Joaat("LUA_THROWABLES_MODIFY_GUNVAN_SLOT"), "2. Choose Throwable", eFeatureType.InputText, "Choose what the selected gun van slot will contain, from one of the throwable ID's found at: https://wiki.rage.mp/index.php?title=Weapons", function()   
	GUI.AddToast("Step Completed", "Throwable ID selected, proceed to step #3.", 3000)
end):SetStringValue("weapon_stickybomb")

FeatureMgr.AddFeature(Utils.Joaat("LUA_THROWABLES_EXECUTE_MODIFY_GUNVAN_SLOT"), "3. Modify Slot", eFeatureType.Button, "Apply the throwable ID to the selected slot", function()
    SetGlobalInt(Globals.ThrowableSlots + SelectedSlot_Throwables, Utils.Joaat(FeatureMgr.GetFeature(Utils.Joaat("LUA_THROWABLES_MODIFY_GUNVAN_SLOT")):GetStringValue()))
    GUI.AddToast("Slot Modified", "This throwable is now in the gun van in slot #" .. SelectedSlot_Throwables .. ".", 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_THROWABLES_README"), "Read Me", eFeatureType.Button, "Please note that the Throwables tab can only contain throwables like grenades", function()
    GUI.AddToast("Read Me", "Please note that the Throwables tab can only contain throwables like grenades" .. SelectedSlot, 10000)
end)

 --------------------- GUN VAN OPTIONS [MISCELLANEOUS] ---------------------

 FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_DISCOUNTS"), "Gun Van Discounts", eFeatureType.Button, "Adds a nice 10% discount to all items in the gun van", function()
    SetGlobalInt(Globals.WeaponDiscount, 10) -- Weapons
    SetGlobalInt(Globals.ThrowableDiscount, 10) -- Throwables 
    SetGlobalInt(Globals.ArmourDiscount, 10) -- Armour
	GUI.AddToast("Discounts Applied", "Discounts have been applied!", 3000)
end) -- 10% is the limit, from my testing it can't go backwards i think

FeatureMgr.AddFeature(Utils.Joaat("LUA_OPTIMAL_GUNVAN_SLOTS"), "Optimal Gun Van Slots", eFeatureType.Button, "Adds a few cool weapons like the navy revolver automatically", function()
    SetGlobalInt(Globals.WeaponSlots + 1, Utils.Joaat("weapon_navyrevolver"))
    SetGlobalInt(Globals.WeaponSlots + 2, Utils.Joaat("weapon_gadgetpistol"))
    SetGlobalInt(Globals.WeaponSlots + 3, Utils.Joaat("weapon_stungun_mp"))
    SetGlobalInt(Globals.WeaponSlots + 4, Utils.Joaat("weapon_doubleaction"))
    SetGlobalInt(Globals.WeaponSlots + 5, Utils.Joaat("weapon_railgunxm3"))
    SetGlobalInt(Globals.WeaponSlots + 6, Utils.Joaat("weapon_minigun"))
    SetGlobalInt(Globals.WeaponSlots + 7, Utils.Joaat("weapon_heavysniper_mk2"))
    SetGlobalInt(Globals.WeaponSlots + 8, Utils.Joaat("weapon_combatmg_mk2"))
    SetGlobalInt(Globals.WeaponSlots + 9, Utils.Joaat("weapon_tacticalrifle"))
    SetGlobalInt(Globals.WeaponSlots + 10, Utils.Joaat("weapon_specialcarbine_mk2"))

    SetGlobalInt(Globals.ThrowableSlots + 1, Utils.Joaat("weapon_stickybomb"))
    SetGlobalInt(Globals.ThrowableSlots + 2, Utils.Joaat("weapon_molotov"))
    SetGlobalInt(Globals.ThrowableSlots + 3, Utils.Joaat("weapon_pipebomb"))

	GUI.AddToast("Optimal Weapons Applied", "Better weapons are now in the gun van", 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_TP_GUNVAN"), "Teleport To Gun Van", eFeatureType.Button, "Teleport yourself to wherever the gun van is", function()
    Script.QueueJob(function()
        CurrentPosition = GetGlobalInt(Globals.Position) + 1
        local PlayerPed = PLAYER_PED_ID()
        local Coord = GunVanCoords[CurrentPosition]
        SET_ENTITY_COORDS(PlayerPed, Coord[1], Coord[2], Coord[3])
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_SET_GUNVAN_POS"), "Choose Gun Van Position", eFeatureType.SliderInt, "Chooses a location for the Gun Van to be teleported to", function()
    CurrentPosition = FeatureMgr.GetFeature(Utils.Joaat("LUA_SET_GUNVAN_POS")):GetIntValue()
end)
:SetLimitValues(1, 10):SetIntValue(CurrentPosition)

FeatureMgr.AddFeature(Utils.Joaat("LUA_EXECUTE_SET_GUNVAN_POS"), "Teleport To Position", eFeatureType.Button, "Moves the gun van to the previously chosen location", function()
    Script.QueueJob(function()
        SetGlobalInt(Globals.Position, CurrentPosition - 1)
        GUI.AddToast("Gun Van Moved", "The Gun Van has been moved.", 3000)
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_RESET_GUNVAN"), "Reset Gun Van Slots", eFeatureType.Button, "Reset the gun van slots to the state they were in when the script was started", function()
    for SlotID = 1, 10 do
        SetGlobalInt(Globals.WeaponSlots + SlotID, DefaultGuns[SlotID])
    end

    for SlotID = 1, 3 do
        SetGlobalInt(Globals.ThrowableSlots + SlotID, DefaultThrowables[SlotID])
    end

    GUI.AddToast("Gun Van Reset", "The Gun Van has been restored.", 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_SET_WP"), "Set Waypoint", eFeatureType.Button, "Sets your waypoint to the location of the gun van", function()
    Script.QueueJob(function()
        CurrentPosition = GetGlobalInt(Globals.Position) + 1
        local Coord = GunVanCoords[CurrentPosition]
        SET_NEW_WAYPOINT(Coord[1], Coord[2])
        GUI.AddToast("Waypoint Set", "Your waypoint has been set to the gun van.", 10000)
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_UNLOCK"), "Unlock Gun Van", eFeatureType.Button, "Unlocks the gun van doors, allowing you to drive it", function()
    Script.QueueJob(function()
        for Index = 0, PoolMgr.GetCurrentVehicleCount() do 
            local Veh = PoolMgr.GetVehicle(Index)
            if GET_ENTITY_MODEL(Veh) == Utils.Joaat("Speedo4") then
                REVERSE_SCRIPTED_VEHICLE_EFFECTS(Veh)
            end
        end
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_DRIVE"), "Drive Gun Van", eFeatureType.Button, "Does the same as unlock but puts you in the drivers seat too", function()
    local PlayerPed = PLAYER_PED_ID()
    
    Script.QueueJob(function()       
        for Index = 0, PoolMgr.GetCurrentVehicleCount() do 
            local Veh = PoolMgr.GetVehicle(Index)
            if GET_ENTITY_MODEL(Veh) == Utils.Joaat("Speedo4") then
                REVERSE_SCRIPTED_VEHICLE_EFFECTS(Veh)
                SET_PED_INTO_VEHICLE(PlayerPed, Veh, -1)
            end
        end
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_SELLER_RESET"), "Seller Shootable", eFeatureType.Button, "Allows the gun van seller to be shootable, allowing you to kill him.", function()
    Script.QueueJob(function()       
        for Index = 0, PoolMgr.GetCurrentPedCount() do
            local Ped = PoolMgr.GetPed(Index)
            if GET_ENTITY_MODEL(Ped) == Utils.Joaat("IG_GunVanSeller") then
                REVERSE_SCRIPTED_PED_EFFECTS(Ped)
            end
        end
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_MARK_ON_MAP"), "Mark On Map", eFeatureType.Button, "Places a gun van blip on the map no matter how far away you are", function()
    Script.QueueJob(function()       
        CurrentPosition = GetGlobalInt(Globals.Position) + 1
        local Coord = GunVanCoords[CurrentPosition]
        local Blip = ADD_BLIP_FOR_COORD(Coord[1], Coord[2], Coord[3])
        SET_BLIP_SPRITE(Blip, 844) -- radar_gun_van
        SET_BLIP_SCALE(Blip, 1.2) -- radar_gun_van
        GUI.AddToast("Gun Van Marked", "You can now find the gun van on the map.", 10000)
    end)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GUNVAN_README"), "Read Me", eFeatureType.Button, "Please note that some weapons cannot be bought from the Gun Van, such as the candy cane or other limited time collectables, also note that the Weapons tab can only contain weapons and not things like grenades. If you experience issues (e.g: this event is inactive) try restarting the script.", function()
    GUI.AddToast("Read Me", "Please note that some weapons cannot be bought from the Gun Van, such as the candy cane or other limited time collectables, also note that the Weapons tab can only contain weapons and not things like grenades. If you experience issues (e.g: this event is inactive) try restarting the script." .. SelectedSlot, 10000)
end)

 --------------------- GUI RENDERING ---------------------

local function CreateMenu()
    if not NETWORK_IS_SESSION_STARTED() and not NETWORK_IS_SESSION_ACTIVE() then
        if ClickGUI.BeginCustomChildWindow("Not Online") then
            ImGui.Text("This script requires you to be in a session.")
            WasOffline = true
            ClickGUI.EndCustomChildWindow()
        end
        return
    end

    if WasOffline then
        WasOffline = false
        
        Script.QueueJob(function()
            CurrentPosition = GetGlobalInt(Globals.Position) + 1
            
            DefaultGuns = {}
            DefaultThrowables = {}
            local Index = 1
            while Index <= 10 do
                table.insert(DefaultGuns, GetGlobalInt(Globals.WeaponSlots + Index))
                Index = Index + 1
            end

            Index = Index
            while Index <= 2 do
                table.insert(DefaultThrowables, GetGlobalInt(Globals.ThrowableSlots + Index))
                Index = Index + 1
            end
        end)
    end

	if ClickGUI.BeginCustomChildWindow("Weapons") then
        ClickGUI.RenderFeature(Utils.Joaat("LUA_CHOOSE_GUNVAN_SLOT"))
        ImGui.Text("2. Choose Weapon")
        ClickGUI.RenderFeature(Utils.Joaat("LUA_MODIFY_GUNVAN_SLOT"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_EXECUTE_MODIFY_GUNVAN_SLOT"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_SETGUNVAN_SLOT"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_SET_TO_CURRENT_WEAPON"))
        ClickGUI.EndCustomChildWindow()
    end
    if ClickGUI.BeginCustomChildWindow("Throwables") then
        ClickGUI.RenderFeature(Utils.Joaat("LUA_THROWABLES_CHOOSE_GUNVAN_SLOT"))
        ImGui.Text("2. Choose Throwable")
        ClickGUI.RenderFeature(Utils.Joaat("LUA_THROWABLES_MODIFY_GUNVAN_SLOT"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_THROWABLES_EXECUTE_MODIFY_GUNVAN_SLOT"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_THROWABLES_README"))
        ClickGUI.EndCustomChildWindow()
    end
    if ClickGUI.BeginCustomChildWindow("Miscellaneous") then
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_DISCOUNTS"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_OPTIMAL_GUNVAN_SLOTS"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_TP_GUNVAN"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_SET_GUNVAN_POS"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_EXECUTE_SET_GUNVAN_POS"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_RESET_GUNVAN"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_SET_WP"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_UNLOCK"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_DRIVE"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_SELLER_RESET"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_MARK_ON_MAP"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GUNVAN_README"))
        ClickGUI.EndCustomChildWindow()
    end
end

ClickGUI.AddTab("Ji9sw - Gun Van", CreateMenu)

--[[ Commits / Credits : 

ji9sw: Original Author, Various Language Translations, Ported from Stand to Cherax
Global Source: gunclub_shop.c [https://github.com/root-cause/v-decompiled-scripts/blob/master/gunclub_shop.c]
parci0_0: Updated for game version 1.69-3258
frog_e123: Original Korean Translation
Prisuhm: Help with approval and fixing issues
Bravado: Providing nessessary info to update for Enhanced

-- Commits / Credits ]]

--[[ Notes

    The voicelines for the gun van seller are played from function "func_1362" (if (ENTITY::DOES_ENTITY_EXIST(iParam0) && !ENTITY::IS_ENTITY_DEAD(iParam0, false)))
    I want to be able to control this but its a bit overcomplicated.

-- Notes ]]
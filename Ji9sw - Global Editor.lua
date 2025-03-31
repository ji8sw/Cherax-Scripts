----------------------- VARIABLES ------------------------

local LastGlobalValue = "N/A"
local GlobalType = 0
local GlobalIndex = 0
local GlobalSubIndex = 0

local LastLocalValue = "N/A"
local LocalType = 0
local LocalScriptHash = 0
local LocalIndex = 0

local GlobalRangeType = 0
local GlobalRangeStart = 0
local GlobalRangeEnd = 100

--------------------- SCRIPT GLOBALS ---------------------

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_TYPE"), "Global Type", eFeatureType.Combo)
    :SetList({"Boolean", "Floating Point", "Integer", "String/Text"})

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_INDEX"), "Index", eFeatureType.InputInt)
    :SetLimitValues(0, 3000000)
    :SetStepSize(1)
    :SetFastStepSize(10) -- TODO: whats the max/min values  for a global index?

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_SUB_INDEX"), "Array/Sub Index", eFeatureType.InputInt)
    :SetLimitValues(0, 3000000)
    :SetStepSize(1)
    :SetFastStepSize(10) -- TODO: whats the max/min values  for a sub index?

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_GET_VALUE"), "Get Value", eFeatureType.Button, "", function()
    if GlobalType == 0 then -- Bool
        LastGlobalValue = ScriptGlobal.GetBool(GlobalIndex + GlobalSubIndex)
        if LastGlobalValue then GUI.AddToast("Global Value", "Value: True", 3000) else GUI.AddToast("Global Value", "Value: False", 3000) end
        return
    elseif GlobalType == 1 then -- Float
        LastGlobalValue = ScriptGlobal.GetFloat(GlobalIndex + GlobalSubIndex)
    elseif GlobalType == 2 then -- Int
        LastGlobalValue = ScriptGlobal.GetInt(GlobalIndex + GlobalSubIndex)
    elseif GlobalType == 3 then -- String
        LastGlobalValue = ScriptGlobal.GetString(GlobalIndex + GlobalSubIndex)
    end

    GUI.AddToast("Global Value", "Value: " .. LastGlobalValue, 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_BOOL"), "New Value", eFeatureType.Toggle, "", function()  
	ScriptGlobal.SetBool(GlobalIndex + GlobalSubIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_BOOL")):GetBoolValue())
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_FLOAT"), "New Value", eFeatureType.InputFloat, "", function()  
	ScriptGlobal.SetFloat(GlobalIndex + GlobalSubIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_FLOAT")):GetFloatValue())
end):SetFloatValue(3.14)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_INT"), "New Value", eFeatureType.InputInt, "", function()  
	ScriptGlobal.SetInt(GlobalIndex + GlobalSubIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_INT")):GetIntValue())
end):SetIntValue(123)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_STRING"), "New Value", eFeatureType.InputText, "", function()  
	ScriptGlobal.SetString(GlobalIndex + GlobalSubIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_STRING")):GetStringValue())
end):SetStringValue("Hello World!")

--------------------- SCRIPT LOCALS ---------------------

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_TYPE"), "Local Type", eFeatureType.Combo)
:SetList({"Boolean", "Floating Point", "Integer", "Pointer", "String/Text"})

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_SCRIPTHASH"), "Index", eFeatureType.InputInt)
    :SetLimitValues(0, 3000000)
    :SetStepSize(1)
    :SetFastStepSize(10) -- TODO: whats the max/min values  for a global index?

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_INDEX"), "Local Index", eFeatureType.InputInt)
    :SetLimitValues(0, 3000000)
    :SetStepSize(1)
    :SetFastStepSize(10) -- TODO: whats the max/min values  for a sub index?

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_GET_VALUE"), "Get Value", eFeatureType.Button, "", function()
    if LocalType == 0 then -- Bool
        LastLocalValue = ScriptLocal.GetBool(LocalScriptHash, LocalIndex)
        if LastLocalValue then GUI.AddToast("Local Value", "Value: True", 3000) else GUI.AddToast("Local Value", "Value: False", 3000) end
        return
    elseif LocalType == 1 then -- Float
        LastLocalValue = ScriptLocal.GetFloat(LocalScriptHash, LocalIndex)
    elseif LocalType == 2 then -- Int
        LastLocalValue = ScriptLocal.GetInt(LocalScriptHash, LocalIndex)
    elseif LocalType == 3 then -- Pointer
        LastLocalValue = ScriptLocal.GetPtr(LocalScriptHash, LocalIndex)
    elseif LocalType == 4 then -- String
        LastLocalValue = ScriptLocal.GetString(LocalScriptHash, LocalIndex)
    end

    GUI.AddToast("Local Value", "Value: " .. LastLocalValue, 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_BOOL"), "New Value", eFeatureType.Toggle, "", function()  
	ScriptLocal.SetBool(LocalScriptHash + LocalIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_BOOL")):GetBoolValue())
end)

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_FLOAT"), "New Value", eFeatureType.InputFloat, "", function()  
	ScriScriptLocalptGlobal.SetFloat(LocalScriptHash + LocalIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_FLOAT")):GetFloatValue())
end):SetFloatValue(3.14)

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_INT"), "New Value", eFeatureType.InputInt, "", function()  
	ScriptLocal.SetInt(LocalScriptHash + LocalIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_INT")):GetIntValue())
end):SetIntValue(123)

FeatureMgr.AddFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_STRING"), "New Value", eFeatureType.InputText, "", function()  
	ScriptLocal.SetString(LocalScriptHash + LocalIndex, FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_STRING")):GetStringValue())
end):SetStringValue("Hello World!")

--------------------- SCRIPT GLOBAL RANGES ---------------------

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_RANGE_TYPE"), "Range Globals Type", eFeatureType.Combo, "When we get the value, what should we interpret it as?")
:SetList({"Boolean", "Floating Point", "Integer", "String/Text"})

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_RANGE_START"), "Range Start", eFeatureType.InputInt, "Where should we begin looping from?")
    :SetLimitValues(0, 3000000)
    :SetStepSize(1)
    :SetFastStepSize(10)

FeatureMgr.AddFeature(Utils.Joaat("LUA_GLOBAL_RANGE_END"), "Range End", eFeatureType.InputInt, "When should we stop looping?")
    :SetLimitValues(0, 3000000)
    :SetStepSize(1)
    :SetFastStepSize(10)

FeatureMgr.AddFeature(Utils.Joaat("LUA_RANGE_GET_VALUES"), "Find Values", eFeatureType.Button, "Loop over the range and find values that aren't empty based on the current selected type", function()
    for Index = GlobalRangeStart, GlobalRangeEnd do
        local Value = "N/A"

        if GlobalRangeType == 0 then -- Bool
            Value = ScriptLocal.GetBool(Index)
            if Value then GUI.AddToast("Found Global Info", "Location: " .. Index .. "\nValue: True", 3000) else GUI.AddToast("Local Value", "Value: False", 3000) end
        elseif GlobalRangeType == 1 then -- Float
            Value = ScriptLocal.GetFloat(Index)
            if Value ~= 0.0 then GUI.AddToast("Found Global Info", "Location: " .. Index .. "\nValue: " .. Value, 3000) end
        elseif GlobalRangeType == 2 then -- Int
            Value = ScriptLocal.GetInt(Index)
            if Value ~= 0 then GUI.AddToast("Found Global Info", "Location: " .. Index .. "\nValue: " .. Value, 3000) end
        elseif GlobalRangeType == 3 then -- String
            Value = ScriptLocal.GetString(Index)
            if Value ~= "???" and Value ~= "" then GUI.AddToast("Found Global Info", "Location: " .. Index .. "\nValue: " .. Value, 3000) end
        end
    end
end)

--------------------- GUI RENDERING ---------------------

local function CreateMenu()
	if ClickGUI.BeginCustomChildWindow("Script Globals") then
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_TYPE"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_INDEX"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_SUB_INDEX"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_GET_VALUE"))

        GlobalType = FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_TYPE")):GetListIndex()
        GlobalIndex = FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_INDEX")):GetIntValue()
        GlobalSubIndex = FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_SUB_INDEX")):GetIntValue()

        if GlobalType == 0 then -- Bool
            ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_BOOL"))
        elseif GlobalType == 1 then -- Float
            ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_FLOAT"))
        elseif GlobalType == 2 then -- Int
            ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_INT"))
        elseif GlobalType == 3 then -- String
            ImGui.Text("New Value")
            ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_SET_VALUE_STRING"))
        end

        ClickGUI.EndCustomChildWindow()
    end
    if ClickGUI.BeginCustomChildWindow("Script Locals") then
        ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_TYPE"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_SCRIPTHASH"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_INDEX"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_GET_VALUE"))

        LocalType = FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_TYPE")):GetListIndex()
        LocalScriptHash = FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_SCRIPTHASH")):GetIntValue()
        LocalIndex = FeatureMgr.GetFeature(Utils.Joaat("LUA_LOCAL_INDEX")):GetIntValue()

        if LocalType == 0 then -- Bool
            ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_BOOL"))
        elseif LocalType == 1 then -- Float
            ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_FLOAT"))
        elseif LocalType == 2 then -- Int
            ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_INT"))
        elseif LocalType == 3 then -- Pointer
            ImGui.Text("Can't Modify Pointer Locals")
        elseif LocalType == 4 then -- String
            ImGui.Text("New Value")
            ClickGUI.RenderFeature(Utils.Joaat("LUA_LOCAL_SET_VALUE_STRING"))
        end

        ClickGUI.EndCustomChildWindow()
    end
    if ClickGUI.BeginCustomChildWindow("Script Globals In Range") then
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_RANGE_TYPE"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_RANGE_START"))
        ClickGUI.RenderFeature(Utils.Joaat("LUA_GLOBAL_RANGE_END"))

        ClickGUI.RenderFeature(Utils.Joaat("LUA_RANGE_GET_VALUES"))

        GlobalRangeType = FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_RANGE_TYPE")):GetListIndex()
        GlobalRangeStart = FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_RANGE_START")):GetIntValue()
        GlobalRangeEnd = FeatureMgr.GetFeature(Utils.Joaat("LUA_GLOBAL_RANGE_END")):GetIntValue()

        ClickGUI.EndCustomChildWindow()
    end
end

ClickGUI.AddTab("Ji9sw - Global Editor", CreateMenu)
-- NATIVES / FUNCTIONS / VARIABLES --

function GetEntityPosition(Entity)
    local X, Y, Z = Natives.InvokeV3(0x3FEF770D40960D5A, Entity, true) -- GET_ENTITY_COORDS
    return V3.New(X, Y, Z)
end

function GetEntitySpeed(Entity)
    return Natives.InvokeFloat(0xD5037BA82E12416F, Entity) -- GET_ENTITY_SPEED
end

function GetEntityHeading(Entity)
    return Natives.InvokeFloat(0xE83D4F9BA2A38914, Entity) -- GET_ENTITY_HEADING
end

function GetMyVehicle()
    local MyPed = Natives.InvokeInt(0xD80958FC74E988A6) -- PLAYER_PED_ID
    return Natives.InvokeInt(0x6094AD011A2EA87D, MyPed) -- GET_VEHICLE_PED_IS_USING
end

function SetMyCarPosition(Position)
    local Veh = GetMyVehicle()
    if Veh == 0 then return end
    Natives.InvokeVoid(0x06843DA7060A026B, Veh, Position.x, Position.y, Position.z) -- SET_ENTITY_COORDS
end

function SetMyCarVelocity(Velocity)
    local Veh = GetMyVehicle()
    if Veh == 0 then return end
    Natives.InvokeVoid(0x1C99BB7B6E96D16F, Veh, Velocity.x, Velocity.y, Velocity.z) -- SET_ENTITY_VELOCITY
end

function GetEntityVelocity(Entity)
    local X, Y, Z = Natives.InvokeV3(0x4805D2B1D8CF94A9, Entity) -- GET_ENTITY_VELOCITY
    return V3.New(X, Y, Z)
end

function SetMyCarHeading(Heading)
    local Veh = GetMyVehicle()
    if Veh == 0 then return end
    Natives.InvokeVoid(0x8E2530AA8ADA980E, Veh, Heading) -- SET_ENTITY_HEADING
end

function DrawPoly(Corner1, Corner2, Corner3, R, G, B, A)
    return Natives.InvokeVoid(0xAC26716048436851, Corner1.x, Corner1.y, Corner1.z, Corner2.x, Corner2.y, Corner2.z, Corner3.x, Corner3.y, Corner3.z, R, G, B, A) -- DRAW_POLY
end

function DrawLine(Pos1, Pos2, R, G, B, A)
    return Natives.InvokeVoid(0x6B7256074AE34680, Pos1.x, Pos1.y, Pos1.z, Pos2.x, Pos2.y, Pos2.z, R, G, B, A) -- DRAW_LINE
end

function CrossProduct(V1, V2)
    return V3.New
    (
        V1.y * V2.z - V1.z * V2.y,
        V1.z * V2.x - V1.x * V2.z,
        V1.x * V2.y - V1.y * V2.x
    )
end

function VectorMagnitude(Vec)
    return math.sqrt(Vec.x * Vec.x + Vec.y * Vec.y + Vec.z * Vec.z)
end

function VectorDistance(V1, V2)
    return VectorMagnitude(V3.Subtract(V1, V2))
end

function DivVec(Vec, Value)
    return V3.New(Vec.x / Value, Vec.y / Value, Vec.z / Value)
end

local Changed = false
local LastPointTime = nil
local PointTimeMax = 150 -- Milliseconds
local MaxPoints = 500
local Points = {}
local LineWidth = 0.2
local SpeedScale = 10.0
local KeepSpeed = true
local SelectedPoint = 1
local MinDistance = 1.0
local PrevPointPosition = V3.New(0, 0, 0)
local BlackSpeed = 50

-- SCRIPT FEATURES --

FeatureMgr.AddFeature(Utils.Joaat("RecordingLoop"), "Recording", eFeatureType.Toggle, "", function(This)
    Script.QueueJob(function()   
        local IsToggled = This:IsToggled()
        local CurrentTime = Time.GetEpocheMs()
        local Vehicle = GetMyVehicle()
    
        if Changed ~= IsToggled then
            Changed = IsToggled
            if IsToggled then -- On Started Recording
                if Vehicle == 0 then
                    GUI.AddToast("No Vehicle", "You need a vehicle to use this...", 3000)
                    This:SetBoolValue(false)
                    return
                end
    
                GUI.AddToast("Begun Recording", "Drive around to record your racing line...", 3000)
                PrevPointPosition = GetEntityPosition(Vehicle)
            else -- On Stopped Recording
    
            end
        end
    
        if IsToggled then -- During Recording
            if LastPointTime == nil or (CurrentTime - LastPointTime) > PointTimeMax then -- Place New Point
                local NewPoint = {}
                NewPoint.Position = GetEntityPosition(Vehicle)

                if VectorDistance(NewPoint.Position, PrevPointPosition) > MinDistance then
                    NewPoint.Speed = GetEntitySpeed(Vehicle) * SpeedScale
                    NewPoint.Heading = GetEntityHeading(Vehicle)
                    NewPoint.Velocity = GetEntityVelocity(Vehicle)
                    local RVal = math.min(255, math.ceil(NewPoint.Speed))  -- Red increases as speed increases
                    local GVal = math.max(0, 255 - RVal)  -- Green decreases as red increases
                    if (NewPoint.Speed <= BlackSpeed) then RVal = 0 GVal = 0 end
                    
                    NewPoint.Colour = 
                    {
                        R = GVal,
                        G = RVal,
                        B = 0,
                        A = 255
                    }
                    
                    LastPointTime = CurrentTime
                    Points[#Points + 1] = NewPoint
        
                    while #Points >= MaxPoints do
                        table.remove(Points, 1)
                    end
        
                    FeatureMgr.GetFeature(Utils.Joaat("PointSlider")):SetLimitValues(1, #Points)
                    PrevPointPosition = NewPoint.Position
                end
            end
        end
    end)
end)
:RegisterCallbackTrigger(eCallbackTrigger.OnTick)
:SetNoCallbackOnPress(true)
:SetSaveable(false)
:Reset()

FeatureMgr.AddFeature(Utils.Joaat("DrawLine"), "Draw Line", eFeatureType.Toggle, "", function(This)
    Script.QueueJob(function() 
        local IsToggled = This:IsToggled()
    
        if IsToggled then -- Draw Lines
            local PrevPoint = Points[1]
            if PrevPoint == nil then return end
            for Index = 2, #Points do
                local Point = Points[Index]
                if Point ~= nil then
                    local PrevPos = PrevPoint.Position
                    local PrevSpeed = PrevPoint.Speed
    
                    local CurrPos = Point.Position
                    local CurrSpeed = Point.Speed
                    local CurrCol = Point.Colour
                    
                    local VecDiff = V3.Subtract(PrevPos, CurrPos)
                    local VecB = V3.New(VecDiff.x, VecDiff.y, 0)
                    local VecCross = CrossProduct(VecDiff, VecB)
                    VecCross = DivVec(VecCross, VectorMagnitude(VecCross))
                    VecCross = V3.Multiply(VecCross, LineWidth * 0.5)

                    local Corners = 
                    {
                        V3.Add(PrevPos, VecCross),
                        V3.Subtract(PrevPos, VecCross),
                        V3.Add(CurrPos, VecCross),
                        V3.Subtract(CurrPos, VecCross),
                    }
    
                    DrawPoly(Corners[2], Corners[4], Corners[3], CurrCol.R, CurrCol.G, CurrCol.B, CurrCol.A)
                    DrawPoly(Corners[1], Corners[2], Corners[3], CurrCol.R, CurrCol.G, CurrCol.B, CurrCol.A)
                    DrawPoly(Corners[3], Corners[4], Corners[2], CurrCol.R, CurrCol.G, CurrCol.B, CurrCol.A)
                    DrawPoly(Corners[3], Corners[2], Corners[1], CurrCol.R, CurrCol.G, CurrCol.B, CurrCol.A)
                    --DrawLine(Corners[1], Corners[3], CurrCol.R, CurrCol.G, CurrCol.B, CurrCol.A)
                    PrevPoint = Point
                end
            end
        end
    end)
end)
:RegisterCallbackTrigger(eCallbackTrigger.OnTick)
:SetNoCallbackOnPress(true)
:SetSaveable(false)
:Reset()

FeatureMgr.AddFeature(Utils.Joaat("ClearLine"), "Clear Line", eFeatureType.Button, "", function()
    Points = {}
    local PointSlider = FeatureMgr.GetFeature(Utils.Joaat("PointSlider"))
    PointSlider:SetIntValue(1)
    PointSlider:SetLimitValues(1, 1)
    GUI.AddToast("Cleared Line", "All points have been cleared, ready for a new line", 3000)
end)

FeatureMgr.AddFeature(Utils.Joaat("LineWidth"), "Line Width", eFeatureType.SliderFloat, "", function(This)
    LineWidth = This:GetFloatValue()
end):SetLimitValues(0.01, 1.0):SetFloatValue(LineWidth)

FeatureMgr.AddFeature(Utils.Joaat("SpeedScale"), "Speed Scale", eFeatureType.SliderFloat, "The amount of speed it takes for the line to be green", function(This)
    SpeedScale = This:GetFloatValue()
end):SetLimitValues(1.0, 50.0):SetFloatValue(SpeedScale)

FeatureMgr.AddFeature(Utils.Joaat("UpdateFrequency"), "Update Frequency", eFeatureType.SliderInt, "The frequency (in milliseconds) at which new points are created in your line\nHigher = Better looking\nLower = Better performance", function(This)
    PointTimeMax = This:GetIntValue()
end):SetLimitValues(50, 500):SetIntValue(PointTimeMax)

FeatureMgr.AddFeature(Utils.Joaat("MaxPoints"), "Max Points", eFeatureType.SliderInt, "The amount of points in your line that the script will remember\nHigher = Longer line\nLower = Better performance", function(This)
    MaxPoints = This:GetIntValue()
end):SetLimitValues(100, 1000):SetIntValue(MaxPoints)

FeatureMgr.AddFeature(Utils.Joaat("MinDistance"), "Min Distance", eFeatureType.SliderFloat, "The distance it takes before a new point is added to your line\nThis way when your car is stopped no points are added\nHigher = Better performance\nLower = Better quality lines", function(This)
    MinDistance = This:GetFloatValue()
end):SetLimitValues(0.1, 10.0):SetFloatValue(MinDistance)

FeatureMgr.AddFeature(Utils.Joaat("BlackSpeed"), "Black Speed", eFeatureType.SliderInt, "The speed at which the line turns black\nBlack indicates you've stopped, or if you want, indicates you're going extremely slow\nHigher = Black occurs at higher speeds", function(This)
    BlackSpeed = This:GetIntValue()
end):SetLimitValues(1, 1000):SetIntValue(BlackSpeed)

FeatureMgr.AddFeature(Utils.Joaat("GoToStart"), "Go To Start", eFeatureType.Button, "", function(This)
    local Start = Points[1]

    if Start ~= nil then
        Script.QueueJob(function() 
            SetMyCarPosition(Start.Position)
            SetMyCarHeading(Start.Heading)
            if KeepSpeed then
                SetMyCarVelocity(Start.Velocity)
            end
        end)
    end
end)

FeatureMgr.AddFeature(Utils.Joaat("PointSlider"), "Point", eFeatureType.SliderInt, "", function(This)
    SelectedPoint = This:GetIntValue()
    if SelectedPoint >= #Points then SelectedPoint = #Points end
end):SetLimitValues(1, 1):SetIntValue(SelectedPoint)

FeatureMgr.AddFeature(Utils.Joaat("GoToPoint"), "Go To Point", eFeatureType.Button, "", function(This)
    local Point = Points[SelectedPoint]

    if Point ~= nil then
        Script.QueueJob(function() 
            SetMyCarPosition(Point.Position)
            SetMyCarHeading(Point.Heading)
            if KeepSpeed then
                SetMyCarVelocity(Point.Velocity)
            end
        end)
    end
end)

FeatureMgr.AddFeature(Utils.Joaat("DelPoint"), "Delete Point", eFeatureType.Button, "", function(This)
    if SelectedPoint >= #Points then SelectedPoint = #Points end
    table.remove(Points, SelectedPoint)
    PointSlider = FeatureMgr.GetFeature(Utils.Joaat("PointSlider"))
    PointSlider:SetLimitValues(1, #Points)
    if SelectedPoint >= #Points then SelectedPoint = #Points end
    PointSlider:SetIntValue(SelectedPoint)
end)

FeatureMgr.AddFeature(Utils.Joaat("KeepSpeed"), "Keep Speed", eFeatureType.Toggle, "When you teleport to a point (like Go To Start) should your vehicle keep moving like it was when you where first at that point?", function(This)
    KeepSpeed = This:GetBoolValue()
end):SetBoolValue(KeepSpeed)

-- SCRIPT UI --

ClickGUI.AddTab("Ji9sw - Racing Lines", function()
    if ClickGUI.BeginCustomChildWindow("Lines") then
        ClickGUI.RenderFeature(Utils.Joaat("RecordingLoop"))  
        ClickGUI.RenderFeature(Utils.Joaat("DrawLine")) 
        ClickGUI.RenderFeature(Utils.Joaat("ClearLine"))
        ClickGUI.RenderFeature(Utils.Joaat("GoToStart"))
        ClickGUI.RenderFeature(Utils.Joaat("PointSlider"))
        ClickGUI.RenderFeature(Utils.Joaat("GoToPoint"))
        ClickGUI.RenderFeature(Utils.Joaat("DelPoint"))

        ClickGUI.EndCustomChildWindow()
    end

    if ClickGUI.BeginCustomChildWindow("Customization") then
        ClickGUI.RenderFeature(Utils.Joaat("LineWidth"))
        ClickGUI.RenderFeature(Utils.Joaat("SpeedScale"))
        ClickGUI.RenderFeature(Utils.Joaat("UpdateFrequency"))
        ClickGUI.RenderFeature(Utils.Joaat("MaxPoints"))
        ClickGUI.RenderFeature(Utils.Joaat("KeepSpeed"))
        ClickGUI.RenderFeature(Utils.Joaat("MinDistance"))
        ClickGUI.RenderFeature(Utils.Joaat("BlackSpeed"))

        ClickGUI.EndCustomChildWindow()
    end
end)
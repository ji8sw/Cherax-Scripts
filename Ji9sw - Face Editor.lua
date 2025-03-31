-- NATIVES / FUNCTIONS / VARIABLES --

function PLAYER_PED_ID()
    return Natives.InvokeInt(0xD80958FC74E988A6)
end

function SET_PED_MICRO_MORPH(Ped, Index, Scale)
    Natives.InvokeVoid(0x71A5C1DBA060049E, Ped, Index, Scale)
end

local Labels = 
{
    "Nose Width (Thin/Wide)", "Nose Peak (Up/Down)", "Nose Length (Long/Short)",
    "Nose Bone Curveness (Crooked/Curved)", "Nose Tip (Up/Down)", "Nose Bone Twist (Left/Right)",
    "Eyebrow (Up/Down)", "Eyebrow (In/Out)", "Cheek Bones (Up/Down)",
    "Cheek Sideways Bone Size (In/Out)", "Cheek Bones Width (Puffed/Gaunt)",
    "Eye Opening (Both) (Wide/Squinted)", "Lip Thickness (Both) (Fat/Thin)",
    "Jaw Bone Width (Narrow/Wide)", "Jaw Bone Shape (Round/Square)", "Chin Bone (Up/Down)",
    "Chin Bone Length (In/Out or Backward/Forward)", "Chin Bone Shape (Pointed/Square)",
    "Chin Hole (Chin Bum)", "Neck Thickness (Thin/Thick)"
 }

-- SCRIPT FEATURES --

for Index, Label in ipairs(Labels) do
    FeatureMgr.AddFeature(Utils.Joaat("FaceMorph" .. Index), Label, eFeatureType.SliderFloat, "", function(Feature)
        SET_PED_MICRO_MORPH(PLAYER_PED_ID(), Index - 1, Feature:GetFloatValue())
    end):SetLimitValues(-100.0, 100.0)
end

FeatureMgr.AddFeature(Utils.Joaat("FaceMorphReadMe"), "Read Me", eFeatureType.Button, "These features require you to be an online character, as story mode characters do not support facial morphing like the customizable online characters.", function(Feature)
    GUI.AddToast("Read Me", "These features require you to be an online character, as story mode characters do not support facial morphing like the customizable online characters.", 10000)
end)

-- SCRIPT UI --

ClickGUI.AddTab("Face Editor", function()
    if ClickGUI.BeginCustomChildWindow("Face Editor") then
        for Index, Label in ipairs(Labels) do
            ClickGUI.RenderFeature(Utils.Joaat("FaceMorph" .. Index))
        end

        ClickGUI.RenderFeature(Utils.Joaat("FaceMorphReadMe"))

        ClickGUI.EndCustomChildWindow()
    end
end)
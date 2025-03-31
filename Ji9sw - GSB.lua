-- VARIABLES --

local SendToChat = true -- Currently disabled due to Cherax having no function to send text messages
local Networked = false
local SeeWhatYouSend = false
local PickupLines = 
{
	"I wish I was Lester so you would call me all the time",
	"I'll never skip the cutscenes of your conversations",
	"I'll wait for you like I wait for Steam sales",
	"Mind if I follow you home? Cause my parents always told me to follow my dreams",
	"LOVE ME",
	"I would like to make Sexy Time with your Mother - In - Law.",
	"Are you 90 degrees? Cause you looking right",
	"Hi, I'm Fahrenheit.",
	"If you were a flower, I'd pick you.",
	"hey, lets go bowling!",
	"You must be a Geography student, because I'm really India",
	"Roses are red, Violets are blue, I have a gun, Get in the van.",
	"Hi",
	"i would like to flirt with you, but i rather lure you in with my mysteriousness and akwardness",
	"If you were a flower, I'd pick you.",
}

local OutragiousLines = 
{
	"can i stroke ur pussy",
    "Yea I got a dick.",
    "I'm a registered sex offender in all states and territories, now shut up and get in the van.",
    "Nice character. wanna fuck?",
    "Can I read your tshirt in braille?",
	"That's a nice dress, it'd look even better on the floor of my windowless van",
	"It's hard for me to concentrate around you because all the blood from my brain has immediately gone to my boner",
	"I wish we playing COD so you could teabag me",
	"We can go two ways babe, if you go with it, we'll have a 'struggle snuggle' and if you resist we play 'tape her and rape her'",
	"There will only be 7 planets left after I destroy Uranus",
	"Did you buy your clothes on sale? At my house they'd be 100% off",
	"Mental health issues? I take the 'the' out of PSYCHOTHERAPIST",
	"*CRRRRRR* (sound of duct tape being stretched)",
	"Hey honey, wanna play house? You can be the door and I'll slam ya.",
	"Your ass is so nice that it is a shame that you have to sit on it.	",
	"Damn girl, you sh*t with that ass?",
	"Cum with me if you want to live.",
	"I'd like to put my genitalia in and around your mouth",
	"Hey baby, ever had sex with a one legged, one armed man with a 15 inch penis? no? Then I'm about to seriously disappoint you",
	"I'm from your dreams.",
	"are you a squirrel? cuz' I need someone to help bury my nuts!",
	"Hey girl, what's the difference between jam and jelly? That i can't jelly my cock down your throat!",
	"Why don't we do a little zoo role-play? You be the hungry tiger and I'll feed you some meat.",
	"I like my women like I like my medicine. Three times a day, orally.",
	"I would like to make Sexy Time with your mother in law.",
	"Damn girl, are you sittin on an f5 key ? Cuz that ass is refreshing",
	"bitch, is your body on the McDonalds menu ? cuz I'm lovin it!",
	"bitch, I wish you were my pinky toe so I could bang you on every piece of furniture in the house!",
}

-- NATIVES / FUNCTIONS --

function GET_ENTITY_MODEL(Entity)
    return Natives.InvokeInt(0x9F47B058362C84B5, Entity)
end

function GET_PLAYER_PED(PID)
    return Natives.InvokeInt(0x43A66C31C68491C0, PID)
end

function PLAYER_ID()
    return Natives.InvokeInt(0x4F8644AF03D0E0D6)
end

local function IsPlayerFemale(PID)
    return GET_ENTITY_MODEL(GET_PLAYER_PED(PID)) == Utils.sJoaat("mp_f_freemode_01")
end

function SendRandomLine(PID, IsOutragious)
    local Lines = PickupLines
    if (IsOutragious) then
        Lines = OutragiousLines
    end
    local Line = Lines[math.random(1, #Lines)]

    if SendToChat then
        if Networked then
            GTA.SendChatMessageToEveryone(Line, false)
            GTA.AddChatMessageToPool(PLAYER_ID(), Line, false)
        else
            GTA.SendChatMessageToPlayer(PID, Line, true)
            GTA.AddChatMessageToPool(PLAYER_ID(), Line, true)
        end
    else
        --players.send_sms(PID, Line)
        --if SeeWhatYouSend then util.toast("Sent Line: " .. Line) end
    end
end

-- MENU OPTIONS --

FeatureMgr.AddPlayerFeature(Utils.Joaat("GetGender"), "Get Gender", eFeatureType.Button, "", function(feature)
    if IsPlayerFemale(Utils.GetSelectedPlayer()) then
        GUI.AddToast("Get Gender", "This player is female!", 5000)
    else
        GUI.AddToast("Get Gender", "This player is male!", 5000)
    end
end, true)

FeatureMgr.AddPlayerFeature(Utils.Joaat("SeeWhatYouSend"), "See What You Send?", eFeatureType.Toggle, "See what you send when you send an SMS", function(feature)
    SeeWhatYouSend = feature:IsToggled()
end, true)

FeatureMgr.AddPlayerFeature(Utils.Joaat("SendToChat"), "Send To Chat?", eFeatureType.Toggle, "Do these options send messages to their phone (off) or in the chat (on)", function(feature)
    SendToChat = feature:IsToggled()
end, true)

FeatureMgr.AddPlayerFeature(Utils.Joaat("IsNetworked"), "Chat Messages Networked", eFeatureType.Toggle, "Do the lines appear for other people besides your target in the chat", function(feature)
    Networked = feature:IsToggled()
end, true)

FeatureMgr.AddPlayerFeature(Utils.Joaat("SendGood"), "Send Good Pick-Up Line", eFeatureType.Button, "Do the lines appear for other people besides your target in the chat", function(feature)
    SendRandomLine(Utils.GetSelectedPlayer(), false)
end, true)

FeatureMgr.AddPlayerFeature(Utils.Joaat("SendBad"), "Send Good Pick-Up Line", eFeatureType.Button, "Sends a pickup line from a random selection", function(feature)
    SendRandomLine(Utils.GetSelectedPlayer(), true)
end, true)

ClickGUI.AddPlayerTab("Get Some Bitches", function()
    local PID = Utils.GetSelectedPlayer()
    if ClickGUI.BeginCustomChildWindow("General") then
        ClickGUI.RenderFeature(Utils.Joaat("GetGender"), PID)
        ClickGUI.RenderFeature(Utils.Joaat("SendGood"), PID)
        ClickGUI.RenderFeature(Utils.Joaat("SendBad"), PID)
        ClickGUI.EndCustomChildWindow()
    end

    if ClickGUI.BeginCustomChildWindow("Settings") then
        --ClickGUI.RenderFeature(Utils.Joaat("SeeWhatYouSend"), PID)
        --ClickGUI.RenderFeature(Utils.Joaat("SendToChat"), PID)
        ClickGUI.RenderFeature(Utils.Joaat("IsNetworked"), PID)
        ClickGUI.EndCustomChildWindow()
    end
end)
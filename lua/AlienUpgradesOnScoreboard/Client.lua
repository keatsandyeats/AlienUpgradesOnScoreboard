local function OnLoadComplete()
    Script.Load("lua/AlienUpgradesOnScoreboard/GUIScoreboard.lua")
end

Event.Hook("LoadComplete", OnLoadComplete)
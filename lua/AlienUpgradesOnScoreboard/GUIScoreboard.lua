Script.Load("lua/AlienUpgradesOnScoreboard/Elixer_Utility.lua")
Elixer.UseVersion(1.8)

-- The size of the IconTable before we modify it. In vanilla this is 
-- currently 3, but vanilla or mods may change this value.
local iconTableOrigSize

local originalCreatePlayerItem
originalCreatePlayerItem = Class_ReplaceMethod("GUIScoreboard", "CreatePlayerItem",
function(self)
    local result = originalCreatePlayerItem(self)
    local playerItem = result.Background
    local iconTable = result.IconTable
    
    -- We only assign iconTableOrigSize once, assuming IconTable is the same size for each player.
    -- If that's false, something will probably break.
    if not iconTableOrigSize then
        iconTableOrigSize = 0
        -- Using # here would pass the size by reference, which would update this value after we add the new items below.
        -- So we get the size in a roundabout way.
        for _,_ in ipairs(iconTable) do
            iconTableOrigSize = iconTableOrigSize + 1
        end
    end
        
    local kPlayerVoiceChatIconSize = GetUpValue(GUIScoreboard.CreatePlayerItem, "kPlayerVoiceChatIconSize", {LocateRecurse = true})
    
    -- Alien upgrade images
    for i = 1,3 do -- TODO: find a replacement for magic 3
        local alienUpgradeImage = GUIManager:CreateGraphicItem()
        alienUpgradeImage:SetSize(Vector(kPlayerVoiceChatIconSize, kPlayerVoiceChatIconSize, 0) * GUIScoreboard.kScalingFactor)
        alienUpgradeImage:SetAnchor(GUIItem.Left, GUIItem.Center)
        alienUpgradeImage:SetIsVisible(false)
        alienUpgradeImage:SetStencilFunc(GUIItem.NotEqual)
        playerItem:AddChild(alienUpgradeImage)
        table.insert(iconTable, alienUpgradeImage)
    end
    
    return result
end)

local originalUpdateTeam
originalUpdateTeam = Class_ReplaceMethod("GUIScoreboard", "UpdateTeam",
function(self, updateTeam)
    originalUpdateTeam(self, updateTeam)
    
    local kPlayerBadgeRightPadding = GetUpValue(GUIScoreboard.UpdateTeam, "kPlayerBadgeRightPadding", {LocateRecurse = true})
    local GetIsVisibleTeam = GetUpValue(GUIScoreboard.UpdateTeam, "GetIsVisibleTeam", {LocateRecurse = true})
    
    local playerList = updateTeam["PlayerList"]
    local teamScores = updateTeam["GetScores"]()
    local teamNumber = updateTeam["TeamNumber"]
    local isVisibleTeam = GetIsVisibleTeam(teamNumber)
    
    local currentPlayerIndex = 1
    
    for index, player in ipairs(playerList) do
        local playerRecord = teamScores[currentPlayerIndex]
        local iconTable = player["IconTable"]
    
        -- if ns2+ is active, use its options menu. if not, just enable the display.
        local showAlienUpgrades = true
        if CHUDGetOption then showAlienUpgrades = CHUDGetOption("alienupgradesscoreboard") end
        
        if isVisibleTeam and teamNumber == kTeam2Index and showAlienUpgrades then
            local currentTech = GetTechIdsFromBitMask(playerRecord.Tech)
            for i = 1, 3 do
                if #currentTech >= i then -- TODO: sets texture every frame :( do this only on change somehow
                    iconTable[i+iconTableOrigSize]:SetTexture("ui/buildmenu.dds")
                    iconTable[i+iconTableOrigSize]:SetTexturePixelCoordinates(unpack(GetTextureCoordinatesForIcon(tonumber(currentTech[i]))))
                    iconTable[i+iconTableOrigSize]:SetColor(Color(1, 0.792, 0.227))
                    iconTable[i+iconTableOrigSize]:SetIsVisible(true)
                else
                    iconTable[i+iconTableOrigSize]:SetIsVisible(false) -- we're both on aliens but he doesn't have the upgrade anymore
                end
            end
        else
            for i = 1,3 do
                iconTable[i+iconTableOrigSize]:SetIsVisible(false) -- if one of us was previously on aliens, this needs to be hidden again
            end
        end
        
        currentPlayerIndex = currentPlayerIndex + 1
        
        -- this code is for when icons appear/disappear (friends, mute, etc)
        local statusPos = ConditionalValue(GUIScoreboard.screenWidth < 1280, GUIScoreboard.kPlayerItemWidth + 30, (self:GetTeamItemWidth() - GUIScoreboard.kTeamColumnSpacingX * 10) + 60)
        local pos = (statusPos - kPlayerBadgeRightPadding) * GUIScoreboard.kScalingFactor
        for _, icon in ipairs(player["IconTable"]) do
            if icon:GetIsVisible() then
                local iconSize = icon:GetSize()
                pos = pos - iconSize.x
                icon:SetPosition(Vector(pos, (-iconSize.y/2), 0))
            end
        end
    end
end)
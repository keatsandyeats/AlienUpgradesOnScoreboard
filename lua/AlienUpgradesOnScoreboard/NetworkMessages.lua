local alienUpgradeScoreboardMessage = {
    hasCrushUpgrade = "boolean",
    hasCarapaceUpgrade = "boolean",
    hasRegenerationUpgrade = "boolean",
    
    hasAuraUpgrade = "boolean",
    hasFocusUpgrade = "boolean",
    hasVampirismUpgrade = "boolean",
    
    hasSilenceUpgrade = "boolean",
    hasCelerityUpgrade = "boolean",
    hasAdrenalineUpgrade = "boolean",
}

-- 1 crush, 2 cara, 3 regen, 4 silence, 5 vamp, 6 aura, 7 cele, 8 adren
-- for i=1,8 do
    -- alienUpgradeScoreboardMessage[i] = 'boolean'
-- end

Shared.RegisterNetworkMessage("AlienUpgradeScoreboard", alienUpgradeScoreboardMessage)
local function OnAlienUpgradeScoreboard(upgradeMessage)
    for k,v in pairs(upgradeMessage) do
        Log("%s : %s  -----------------------------", k, v)
    end
end

Client.HookNetworkMessage("AlienUpgradeScoreboard", OnAlienUpgradeScoreboard)
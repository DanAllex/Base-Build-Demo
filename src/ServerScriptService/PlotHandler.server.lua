local players = game:GetService("Players")
local plots = workspace.Plots

local function FindPlot(plr)
	local plotChildren = plots:GetChildren()
	
	for i, plt in pairs(plotChildren) do
		if plt then
			if plt.Data.Owner.Value ~= "" then
			else
				local pltNm = plt.Name
				game.ReplicatedStorage.Events.ClientPlot:FireClient(plr, pltNm)
				plt.Data.Owner.Value = plr.Name
				break
			end
		end
	end
end

players.PlayerAdded:Connect(FindPlot)
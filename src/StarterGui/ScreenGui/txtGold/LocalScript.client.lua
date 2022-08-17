local plr = game.Players.LocalPlayer
script.Parent.Text = "Gold: " .. game.ReplicatedStorage.StatFile:WaitForChild(plr.Name).Stats.Gold.Value
game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Changed:Connect(function()
	script.Parent.Text = "Gold: " .. game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value
end)
local player = game.Players.LocalPlayer

local function moveChar(Char, X, Y, Z)
	repeat wait() until Char.PrimaryPart
	Char:SetPrimaryPartCFrame(CFrame.new(X, Y, Z))
	
end

player.CharacterAdded:Connect(function(char)
	for i, plt in pairs(workspace.Plots:GetChildren()) do
		if plt then
			if plt.Data.Owner.Value == player.Name then
				moveChar(char, plt.Plot.CFrame.X, plt.Plot.CFrame.Y + 70, plt.Plot.CFrame.Z)
				break
			end
		end
	end
end)
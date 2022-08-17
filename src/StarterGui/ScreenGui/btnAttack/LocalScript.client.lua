local players = game.Players

local function addPlayer(plr)
	local newButton = script.Parent.frmPlayers.btnTemplate:Clone()
	newButton.Parent = script.Parent.frmPlayers
	newButton.Visible = true
	newButton.Name = plr.Name
	newButton.Text = plr.Name
end

script.Parent.MouseButton1Click:Connect(function()
	
	for i,v in pairs(script.Parent.frmPlayers:GetChildren()) do
		if v.Name ~= "UIGridLayout" and v.Name ~= "btnTemplate" then
			v:Destroy()
		end
	end
	
	for i,v in pairs(players:GetChildren()) do
		if workspace:FindFirstChild(v.Name) then
			if v.Character:FindFirstChild("HumanoidRootPart") and v.Name ~= players.LocalPlayer.Name then
				if players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					if (players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude < 65 then
						addPlayer(v)
					end
				end
			end
		end
	end
end)
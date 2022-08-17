script.Parent.MouseButton1Click:Connect(function()
	if game.Players:FindFirstChild(script.Parent.Text) then
		game.ReplicatedStorage.Events.attackPlayer:FireServer(game.Players[script.Parent.Name])
	end
	
	for i,v in pairs(script.Parent.Parent:GetChildren()) do
		if v.Name ~= "btnTemplate" and v.Name ~= script.Parent.Name and v.Name ~= "UIGridLayout" then
			v:Destroy()
		end
	end
	
	script.Parent:Destroy()
end)
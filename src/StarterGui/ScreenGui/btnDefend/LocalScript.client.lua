local players = game.Players

script.Parent.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.Events.Defend:FireServer()
	if script.Parent.Defending.Value == false then
		script.Parent.Defending.Value = true
		script.Parent.BackgroundColor3 = Color3.new(0, 1, 127/255)
	else
		script.Parent.Defending.Value = false
		script.Parent.BackgroundColor3 = Color3.new(1, 1, 1)
	end
end)
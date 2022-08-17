local placementModule = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PlacementModuleV3"))
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local plot
local button = script.Parent.version1
local isHolding = false
local isWall = true
local origMouse
local origPos
local changeX = 0
local changeZ = 0
local changeDebounce = false
local remote = game.ReplicatedStorage.Events.PlaceObj
local shadow

game.ReplicatedStorage.Events.ClientPlot.OnClientEvent:Connect(function(pltNm)
	plot = workspace.Plots:FindFirstChild(pltNm)
	print(plot.Parent)
end)

button.MouseButton1Click:Connect(function()
	placementModule:new("test", game.ReplicatedStorage.Models, plot.Plot, plot.PlacedObjects, false, false, isWall)
	while shadow == nil do
		for i, v in pairs(plot.PlacedObjects:GetChildren()) do
			if v:FindFirstChild("Shadow") then
				shadow = v
			end
		end
	end
end)

--mouse.Move:connect(function()
--	if isHolding and origMouse ~= nil and origPos ~= nil and not changeDebounce then
	--	changeDebounce = true
	--	changeX = mouse.Hit.X - origMouse.X
	--	changeZ = mouse.Hit.Z - origMouse.Z
		--if math.abs(changeX) > math.abs(changeZ) and shadow then
		--	for i, v in pairs(shadow:GetChildren()) do
			--	if v.Name ~= "Shadow" then
			--	--v.Size = Vector3.new(math.ceil(math.abs(changeX)) - math.ceil(changeX) % 2, v.Size.Y, 2)
			--	v.Position = Vector3.new(origPos.X, v.Position.Y, origPos.Z)
			--	print(changeX)
			--	end
		--	end
	--	else if math.abs(changeX) <= math.abs(changeZ) and shadow then
	--		for i, v in pairs(shadow:GetChildren()) do
	--			if v.Name ~= "Shadow" then
				--v.Size = Vector3.new(2, v.Size.Y, math.ceil(math.abs(changeZ)) - math.ceil(changeZ) % 2)
	--			v.Position = Vector3.new(origPos.X, v.Position.Y, origPos.Z)
			--	print(changeZ)
--	---			end
--			end
--		end
--	end
--	changeDebounce = false
--	end
--end)

mouse.Button1Down:Connect(function()
	if not isWall then
		placementModule:Finish(remote)
	else
		isHolding = true
		origMouse = mouse.Hit
		placementModule:updateData(origMouse)
		repeat wait() until shadow
		origPos = 0
		repeat wait() until isHolding == false
			placementModule:Drag(remote, origMouse, origPos)
			shadow = nil
			changeX = 0
			changeZ = 0
			origPos = nil
			origMouse = nil
	end
	
end)

mouse.Button1Up:Connect(function()
	isHolding = false
end)
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local placementModule = require(replicatedStorage.Modules:WaitForChild("PlacementModuleV3"))
local plot

local isHolding = false
local startHit

game.ReplicatedStorage.Events.ClientPlot.OnClientEvent:Connect(function(pltNm)
	plot = workspace.Plots:FindFirstChild(pltNm)
	print(plot.Parent)
end)

local placement = placementModule.new(
	2,
	replicatedStorage.Assets.placementItems,
	Enum.KeyCode.R, Enum.KeyCode.X, Enum.KeyCode.U, Enum.KeyCode.L
)


local player = players.LocalPlayer
local mouse = player:GetMouse()

local remote = replicatedStorage.Events:WaitForChild("PlaceObj")

local placing = script.Parent.Placing

placing.Changed:Connect(function()
	if placing.Value ~= "" then
		placement:terminate()
		placement:activate(placing.Value, plot.PlacedObjects, plot.Plot, false, false)
	else
		placement:terminate()
	end
end)

mouse.Button1Down:Connect(function()
	if placing.Value ~= "" then
		if game.ReplicatedStorage.StatFile[player.Name].Stats.Gold.Value >= game.ReplicatedStorage.Assets.placementItems[placing.Value].Data.Price.Value then
			if game.ReplicatedStorage.Assets.placementItems[placing.Value].Data.isDraggable.Value == false then
				placement:requestPlacement(remote)
			else
				if isHolding == false then
					isHolding = true
					startHit = mouse.Hit
					placement:beginDrag(startHit)
					repeat wait() until isHolding == false
					placement:requestDrag(remote, startHit)
				end
			end
		end
	end
end)

mouse.Button1Up:Connect(function()
	isHolding = false
end)
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")


local FOLLOW_RADIUS = 12
local DEFENSE_RADIUS = 3

repeat wait() until script.Parent.Parent.Parent == workspace

local statusVar = script.Parent.Status
local npcFolder = script.Parent.Characters:GetChildren()
local playerName = string.sub(script.Parent.Parent.Name, 1, string.len(script.Parent.Parent.Name) - 4)
local plr = players:WaitForChild(playerName)
repeat wait() until plr.Character
local playerHumanoidRootPart = plr.Character:WaitForChild("HumanoidRootPart")
local previousPosition
local defendOrFollow = ""
local enemy
local raid
local raiding = false

statusVar.Changed:Connect(function(newValue)
	
	if raiding then
		uninitRaid()
		raiding  = false
	end
	
	if newValue == "followPlayer" then
		followPlayer()
	elseif newValue == "defendPlayer" then
		defendPlayer()
	elseif newValue == "attackPlayer" then
		attackPlayer()
	elseif newValue == "raidBase" then
		raidBase()
		raiding = true
	end
	
end)

-- This is for following the player in a circle

function followPlayer()
	initializeFollowDisplacements(FOLLOW_RADIUS)
	while (statusVar.Value == "followPlayer") do
		wait(0.01)
				
		if #script.Parent.Characters:GetChildren() ~= #npcFolder then
			npcFolder = script.Parent.Characters:GetChildren()
			initializeFollowDisplacements(FOLLOW_RADIUS)
		end
		
		for i, npc in pairs(npcFolder) do
			local newVal = playerHumanoidRootPart.Position + npc.Displacement.Value + playerHumanoidRootPart.Velocity / 100
			npc.Destination.Value = newVal
		end
	end
end

function getDistanceBetween(plr1, plr2)
	return (plr1.Character.HumanoidRootPart.Position - plr2.Character.HumanoidRootPart.Position).Magnitude
end

-- Move towards target you declare as an enemy
function attackPlayer()
	
	--repeat wait() until enemy or not(statusVar.Value == "attackPlayer")
	
	while (statusVar.Value == "attackPlayer" and enemy.Character and plr.Character and getDistanceBetween(plr, enemy) < 75) do
		wait(0.01)
		
		for i, npc in pairs(npcFolder) do
			npc.Destination.Value = enemy.Character.HumanoidRootPart.Position
		end
		
	end
	
	statusVar.Value = defendOrFollow
	
end

-- Starts the raid of the base
function raidBase()
	-- Prep for raid
	initRaid()
	local generators = {}
	for i, v in pairs(raid.PlacedObjects:GetChildren()) do
		if v.Data.Type.Value == "Generator" then
			generators[#generators + 1]	= v	
		end
	end
	-- raid
	while (statusVar.Value == "raidBase") do
		wait(0.01)
	end
	-- end of raid
	statusVar.Value = defendOrFollow
	
end

-- Called whenever a raid starts.
function initRaid()
	for i, npc in pairs(npcFolder) do
		npc.AttackParts = true
	end
end

-- Called whenever a raid ends. Cleans up after the raid.
function uninitRaid()
	for i, npc in pairs(npcFolder) do
		npc.AttackParts = false
	end
end



-- Moves into defensive mode.  Player slows down as a result
function defendPlayer()
	-- Slow down player
	plr.Character.Humanoid.WalkSpeed = 4
	
	initializeFollowDisplacements(DEFENSE_RADIUS)
	while (statusVar.Value == "defendPlayer") do
		wait(0.01)
				
		if #script.Parent.Characters:GetChildren() ~= #npcFolder then
			npcFolder = script.Parent.Characters:GetChildren()
			initializeFollowDisplacements(DEFENSE_RADIUS)
		end
		
		for i, npc in pairs(npcFolder) do
			local newVal = playerHumanoidRootPart.Position + npc.Displacement.Value + playerHumanoidRootPart.Velocity / 100
			npc.Destination.Value = newVal
		end
	end
	
	plr.Character.Humanoid.WalkSpeed = 16
end

function initializeFollowDisplacements(radius)
	
	local angleDelta = 2 * math.pi / #npcFolder
	for i, npc in pairs(npcFolder) do
		npc.Displacement.Value = Vector3.new(radius * math.sin(angleDelta * i), 0, radius * math.cos(angleDelta * i))
	end
end

-- Connecting to some events
replicatedStorage.Events.Defend.onServerEvent:Connect(function(player)
	-- Conditions for ignoring this event
	if player.Name ~= plr.Name then
		return
	elseif  ( statusVar.Value ~= "defendPlayer"
		 and  statusVar.Value ~= "followPlayer"
		 and  statusVar.Value ~= "attackPlayer"
		 and  statusVar.Value ~= "") then
		return
	end
	
	-- Correctly switching mode
	if defendOrFollow == "followPlayer" then
		statusVar.Value = "defendPlayer"
	elseif defendOrFollow == "defendPlayer" then
		statusVar.Value = "followPlayer"
	end
	
	defendOrFollow = statusVar.Value
end)

replicatedStorage.Events.Follow.onServerEvent:Connect(function(player)
	if player.Name ~= plr.Name then
		return
	end
	
	statusVar.Value = "followPlayer"
	defendOrFollow = "followPlayer"
	
end)

replicatedStorage.Events.attackPlayer.onServerEvent:Connect(function(player1, player2)
	if player1.Name ~= plr.Name then
		return
	end
	
	if defendOrFollow ~= "" then
		enemy = player2
		statusVar.Value = "attackPlayer"
	end
	
end)

replicatedStorage.Events.StartRaid.Event:Connect(function(player, baseFolder)
	if player.Name ~= plr.Name then
		return
	end
	
	if defendOrFollow ~= "" then
		raid = baseFolder
		statusVar.Value = "raidBase"
	end
	
end)

-- temporary code {REMOVE WHEN THE QUEUE WORKS}
statusVar.Value = "followPlayer"
defendOrFollow = "followPlayer"


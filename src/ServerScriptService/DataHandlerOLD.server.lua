local DS = game:GetService("DataStoreService"):GetDataStore("Player_Data")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local StatFile = ReplicatedStorage:WaitForChild("StatFile")
local ServerScriptService = game:GetService("ServerScriptService")

local Banned = {}
local Unbanned = {"10cannonbolt", "MisterTwister23", "iHypered"}

game.Players.PlayerAdded:connect(function(player)
	local playerFolder = Instance.new("Folder")
	playerFolder.Name = player.Name
	playerFolder.Parent = StatFile

	local RelationsFolder = Instance.new("Folder")
	RelationsFolder.Name = "Relations"
	RelationsFolder.Parent = playerFolder
	for i,v in pairs(game.Players:GetPlayers()) do
		if v.Name ~= player.Name then
			local SubValue = Instance.new("IntValue")
			SubValue.Name = v.Name
			SubValue.Parent = RelationsFolder
		end
	end
	
	for i,v in pairs(StatFile:GetChildren()) do
		if v.Name ~= player.Name then
			local SubValue = Instance.new("IntValue")
			SubValue.Name = player.Name
			SubValue.Parent = v:WaitForChild("Relations")
		end
	end
	
	local ServerNumbers = Instance.new("Folder")
	ServerNumbers.Name = "ServerNumbers"
	ServerNumbers.Parent = playerFolder
	
	local powerPoints = Instance.new("IntValue")
	powerPoints.Name = "PowerPoints"
	powerPoints.Parent = ServerNumbers
	
	local statNumbers = Instance.new("Folder")
	statNumbers.Name = "statNumbers"
	statNumbers.Parent = playerFolder
	
	-- [Stats]
	
		-- Kills
			local kills = Instance.new("IntValue")
			kills.Name = "Kills"
			kills.Parent = statNumbers
			
		-- Reputation
			local Reputation = Instance.new("IntValue")
			Reputation.Name = "Reputation"
			Reputation.Parent = statNumbers
			
		-- Banned
			local banned = Instance.new("BoolValue")
			banned.Name = "Banned"
			banned.Parent = statNumbers
	
	-- [Data]
	
		-- Coins
			local coins = Instance.new("IntValue")
			coins.Name = "Coins"
			coins.Parent = statNumbers
			
		-- Diamonds
			local diamonds = Instance.new("IntValue")
			diamonds.Name = "Diamonds"
			diamonds.Parent = statNumbers
			
			-- Level
			local level = Instance.new("IntValue")
			level.Name = "Level"
			level.Parent = statNumbers
			
			-- Level
			local EXP = Instance.new("IntValue")
			EXP.Name = "EXP"
			EXP.Parent = statNumbers
	
	-- [Weapons]
	
		-- Diamond Sword
			local DiamondSword = Instance.new("BoolValue")
			DiamondSword.Name = "DiamondSword"
			DiamondSword.Parent = statNumbers
	
	-- [Blocks]

		-- Wood
			local Wood = Instance.new("IntValue")
			Wood.Name = "1"
			Wood.Parent = statNumbers
	
	-- Load Data
	local SavedStuff = DS:GetAsync(player.userId)
	if SavedStuff then
		print("data takes up "..game:GetService("HttpService"):JSONEncode(SavedStuff):len().."/260,000")
		if SavedStuff[1] ~= "" then
		for i,v in pairs(SavedStuff[1]) do
			print(i,v)
			if i % 2 == 0 then
				StatFile[player.Name].statNumbers:FindFirstChild(SavedStuff[1][i-1]).Value = v
				end
				end
			end
		end
	
	if banned.Value == true then
		local canceled = false
		for i,v in pairs(Unbanned) do
			if v == player.Name then
				canceled = true
			end
		end
		if canceled == false then
		player:Kick("Banned | Reason: Exploiting")
		end
	else
		for i,v in pairs(Banned) do
			if v == player.Name then
				player:Kick("Banned | Reason: "..i)
			end
		end
	end
if Reputation.Value == 0 then
		Reputation.Value = 1
end
if level.Value == 0 then
		level.Value = 1
end

if powerPoints.Value == 0 then
		level.Value = 1
end
		
	local copyscript = ServerStorage.DataScripts.EXP:Clone()
	copyscript.Name = player.Name
	copyscript.Parent = ServerScriptService
	local expirescript = ServerStorage.DataScripts.ExpireCooldowns:Clone()
	expirescript.Name = player.Name
	expirescript.Parent = ServerScriptService
end)

local function saveValues(player)
	local Stats = {}
	local RelationData = {}
	for i,v in pairs(StatFile:FindFirstChild(player.Name).Relations:GetChildren()) do
		if v.Value == 1 or v.Value == 2 then
			RelationData[v.Name] = v.Value
		end
	end
	for i,v in pairs(StatFile[player.Name].statNumbers:GetChildren()) do
		Stats[#Stats + 1] = v.Name
		Stats[#Stats + 1] = v.Value
	end
	local savedData = {Stats, RelationData}
	DS:SetAsync(player.userId, savedData)
end

game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		saveValues(player)
	end
end)

game.Players.PlayerRemoving:connect(function(player)
	saveValues(player)
end)
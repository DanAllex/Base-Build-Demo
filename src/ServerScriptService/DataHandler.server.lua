local players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local DataStore = DataStoreService:GetDataStore("PlayerDataV3")
local sendMsg = game.ReplicatedStorage.Events.sendMsg

local plot

local function getPlot(plr)
	for i, plt in pairs(workspace.Plots:GetChildren()) do
		if plt then
			if plt.Data.Owner.Value == plr.Name then
				plot = plt
				break
			end
		end
	end
end

local function Save(plr)	
	local key = "plr-"..plr.UserId
	local save = {
				  ["Base_Main"] = {},
				  ["Base_Colony"] = {},
		  		  ["Base_Claimed1"] = {},
		 		  ["Base_Claimed2"] = {},
		 		  ["Weapons"] = {},
		 		  ["Items"] = {},
		  		  ["Stats"] = {}
	}
	
	if game.ReplicatedStorage.StatFile:FindFirstChild(plr.Name) then
		print("Found player folder")
		for i,v in pairs(game.ReplicatedStorage.StatFile[plr.Name].Stats:GetChildren()) do
			save.Stats[v.Name] = v.Value
			print("saving "..tostring(v.Value))
		end
		
		for i,v in pairs(game.ReplicatedStorage.StatFile[plr.Name].Weapons:GetChildren()) do
			table.insert(save.Weapons, v.Name)
			print("saving "..v.Name)
		end
		
		for i,v in pairs(game.ReplicatedStorage.StatFile[plr.Name].Items:GetChildren()) do
			save.Items[v.Name] = v.Value
			print("saving "..v.Value .. " "..v.Name.."s")
		end
	end
	
	for i,obj in pairs(plot.PlacedObjects:GetChildren()) do
		if obj then
			table.insert(save.Base_Main, {
				["Name"] = obj.Name,
				["CFS"] = {
					["X"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).X;
					["Y"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Y;
					["Z"] = plot.Plot.CFrame:ToObjectSpace(CFrame.new(obj.PrimaryPart.CFrame.p)).Z;
					["R"] = obj.PrimaryPart.Orientation.Y
				}
			})
		end
	end
	
	local success, err = pcall(function()
		DataStore:SetAsync(key, save)
	end)
	
	if not success then
		warn("Failed to overwrite data "..tostring(err))
		return
	end
end

function autoSave()
	while true do
		wait(300)
		   	for _, plr in ipairs(game.Players:GetPlayers()) do
			 if game.ReplicatedStorage.StatFile:FindFirstChild(plr.Name) then
				if game.ReplicatedStorage.StatFile[plr.Name].Cooldowns.saveCooldown.Value == 0 then
					game.ReplicatedStorage.StatFile[plr.Name].Cooldowns.saveCooldown.Value = 60
					Save(plr)
            		wait(5)
				end
			end
        end
	end
end

local function Leave(plr)
	if game.ReplicatedStorage.StatFile:FindFirstChild(plr.Name) then
		Save(plr)
		game.ReplicatedStorage.StatFile[plr.Name]:Destroy()
	end
end

local function Load(plr)
	wait(0.1)
	getPlot(plr)
	local key = "plr-"..plr.UserId
	
	local savedData
	
	local success, err = pcall(function()
		savedData = DataStore:GetAsync(key)
	end)
	
	if not success then
		warn("Failed to read data "..tostring(err))
		return
	end
	
	local playerFolder = Instance.new("Folder")
	playerFolder.Name = plr.Name
	playerFolder.Parent = game.ReplicatedStorage.StatFile
	
	local stats = Instance.new("Folder")
	stats.Name = "Stats"
	stats.Parent = playerFolder
	
		local gold = Instance.new("IntValue")
		gold.Name = "Gold"
		gold.Parent = stats
		gold.Value = 1000000
	
		local diamonds = Instance.new("IntValue")
		diamonds.Name = "Diamonds"
		diamonds.Parent = stats
	
		local level = Instance.new("IntValue")
		level.Name = "Level"
		level.Parent = stats
		level.Value = 1
	
		local exp = Instance.new("IntValue")
		exp.Name = "EXP"
		exp.Parent = stats
	
		local tutorial = Instance.new("BoolValue")
		tutorial.Name = "tutorial"
		tutorial.Parent = stats
	
	
	local weapons = Instance.new("Folder")
	weapons.Name = "Weapons"
	weapons.Parent = playerFolder
	
		local basicSword = Instance.new("Folder")
		basicSword.Name = "Basic Sword"
		basicSword.Parent = weapons
	
		local basicPickaxe = Instance.new("Folder")
		basicPickaxe.Name = "Basic Pickaxe"
		basicPickaxe.Parent = weapons
	
		local basicBow = Instance.new("Folder")
		basicBow.Name = "Basic Bow"
		basicBow.Parent = weapons
	
	local items = Instance.new("Folder")
	items.Name = "Items"
	items.Parent = playerFolder
	
	local tempStats = Instance.new("Folder")
	tempStats.Name = "tempStats"
	tempStats.Parent = playerFolder
	
	local floorEditing = Instance.new("IntValue")
	floorEditing.Name = "floorEditing"
	floorEditing.Parent = tempStats
	floorEditing.Value = -1
	
	local cooldowns = Instance.new("Folder")
	cooldowns.Name = "Cooldowns"
	cooldowns.Parent = playerFolder
	
	local saveCooldown = Instance.new("IntValue")
	saveCooldown.Name = "saveCooldown"
	saveCooldown.Parent = cooldowns
	saveCooldown.Value = 60
	
	local cooldownScriptClone = game.ServerStorage.portableScripts.cooldownScript:Clone()
	cooldownScriptClone.Parent = saveCooldown
	
	
if savedData then
	if savedData.Stats then
		print("Stats exists..")
		for i,v in pairs(savedData.Stats) do
			if stats:FindFirstChild(i) then
				stats:FindFirstChild(i).Value = v
				print("Loaded some stats")
			end
		end
	end
	
	if savedData.Weapons then
		print("Weapons exists..")
		for i,v in pairs(savedData.Weapons) do
			if v ~= "Basic Sword" and v ~= "Basic Pickaxe" and v ~= "Basic Bow" then
				local weaponEntry = Instance.new("Folder")
				weaponEntry.Name = v
				weaponEntry.Parent = weapons
				print("Loaded some weapons")
			end
		end
	end
	
	if savedData.Items then
		print("Items exists..")
		for i,v in pairs(savedData.Items) do
			local itemEntry = Instance.new("IntValue")
			itemEntry.Name = i
			itemEntry.Value = v
			itemEntry.Parent = items
			print("Loaded some items")
		end
	end
	
	if savedData.Base_Main then
		for i,v in pairs(savedData.Base_Main) do
			if v then
				local serializedModel = game.ReplicatedStorage.Assets.placementItems:FindFirstChild(v.Name)
				if serializedModel then
					local clone = serializedModel:Clone()
					clone.PrimaryPart.Transparency = 1
					clone:SetPrimaryPartCFrame(plot.Plot.CFrame * CFrame.new(v.CFS.X, v.CFS.Y, v.CFS.Z) * CFrame.Angles(0, math.rad(v.CFS.R), 0))
					clone.Parent = plot.PlacedObjects
				end
			end
		end
	else
		Save(plr)
		end
	end
end


game.ReplicatedStorage.Events.Save.OnServerEvent:Connect(function(plr)
	if game.ReplicatedStorage.StatFile[plr.Name].Cooldowns.saveCooldown.Value == 0 then
		game.ReplicatedStorage.StatFile[plr.Name].Cooldowns.saveCooldown.Value = 60
		Save(plr)
	else
		sendMsg:FireClient(plr, "Warning", "You must wait ")
	end
end)

players.PlayerAdded:Connect(Load)
players.PlayerRemoving:Connect(Leave)

game:BindToClose(function()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        coroutine.wrap(Leave)(plr)
    end
end)

spawn(autoSave)
local tool = script.Parent
local clickEvent = tool.REClick
local clickEventConnection
local MineDamage = 5
local SwordDamage = 20
local Player = script.Parent.Parent.Parent.Name
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StatFile = ReplicatedStorage.StatFile
local PlayerFolder = StatFile:WaitForChild(Player)
local ServerNumbers = PlayerFolder:WaitForChild("ServerNumbers")
local statNumbers = PlayerFolder:WaitForChild("statNumbers")
local Relations = PlayerFolder:WaitForChild("Relations")



 
local function killaward(name)
	local LevelBonus = 100 * statNumbers.Level.Value
	local EXPBonus = 200 * statNumbers.Level.Value
	local KilledPlayerFolder = StatFile:WaitForChild(name)
	local KilledStatNumbers = StatFile:WaitForChild(name):WaitForChild("statNumbers")
	local KilledServerNumbers = StatFile:WaitForChild(name):WaitForChild("ServerNumbers")
	local RelationMultiplier
	local RelationStatus = Relations:FindFirstChild(name)
	local RelationBonus
	if RelationStatus then
		if RelationStatus.Value == 0 then
			print(1)
			RelationBonus = .75
		elseif RelationStatus.Value == 1 then
			print(2)
				RelationBonus = 0
		elseif RelationStatus.Value == 2 then
			print(3)
				RelationBonus = 1
			end
	statNumbers.Kills.Value = statNumbers.Kills.Value + 1
	ServerNumbers.PowerPoints.Value = ServerNumbers.PowerPoints.Value + 1
	if KilledServerNumbers.PowerPoints.Value > 1 then
	KilledServerNumbers.PowerPoints.Value = KilledServerNumbers.PowerPoints.Value - 1
	end
	statNumbers.Reputation.Value = (math.floor(statNumbers.Reputation.Value + (((KilledStatNumbers.Level.Value / statNumbers.Level.Value) + (KilledServerNumbers.PowerPoints.Value / ServerNumbers.PowerPoints.Value)) / 2)))
	print(statNumbers.Reputation.Value)
	local BonusLevel = (((KilledStatNumbers.Level.Value / statNumbers.Level.Value) + (KilledServerNumbers.PowerPoints.Value / ServerNumbers.PowerPoints.Value)) / 2) * (statNumbers.Reputation.Value / statNumbers.Kills.Value) * LevelBonus * RelationBonus
	print(BonusLevel)
	local BonusEXP = (((KilledStatNumbers.Level.Value / statNumbers.Level.Value) + (KilledServerNumbers.PowerPoints.Value / ServerNumbers.PowerPoints.Value)) / 2) * (statNumbers.Reputation.Value / statNumbers.Kills.Value) * EXPBonus * RelationBonus
	print(BonusEXP)
	statNumbers.Coins.Value = statNumbers.Coins.Value + BonusLevel
	statNumbers.EXP.Value = statNumbers.EXP.Value + BonusEXP
	print("done")
			end
		end

local function Mine(targetBlock, value)
	if value == true then
	if targetBlock:FindFirstChild("intHitpoints") then
		targetBlock.intHitpoints.Value = targetBlock.intHitpoints.Value - MineDamage
	elseif targetBlock.Parent:FindFirstChild("intHitpoints") then
		targetBlock.intHitpoints.Value = targetBlock.intHitpoints.Value - MineDamage
		end
	end
end

local function Slash(intTime)
print("slash started")
local con
local cancel = false
local hit = false
local hitplayer
con = script.Parent.Blade.Touched:Connect(function(p)
if (p.Parent and p.Parent:FindFirstChild("Humanoid")) or (p.Parent and p.Parent.Parent and p.Parent.Parent:FindFirstChild("Humanoid")) or (p.Parent and p.Parent.Parent and p.Parent.Parent.Parent and p.Parent.Parent.Parent:FindFirstChild("Humanoid")) then
	print(p.Name, "is part of a player!")
con:Disconnect()
hit = true
hitplayer = p
end
end)


repeat wait() until tick() - intTime > .9 or hit == true
if hit == true then
	local humanoid = hitplayer.Parent:FindFirstChild("Humanoid")
	if not humanoid then
		humanoid = hitplayer.Parent.Parent:FindFirstChild("Humanoid")
		if not humanoid then
			humanoid = hitplayer.Parent.Parent.Parent:FindFirstChild("Humanoid")
		if not humanoid then
			cancel = true
		end
		end
	end
	if cancel == false and Relations[humanoid.Parent.Name].Value ~= 1 and humanoid.Health > 0 then
	humanoid:TakeDamage(SwordDamage)
	print(humanoid.Parent.Name, "was damaged")
	if humanoid.Health <= 0 then
		killaward(humanoid.Parent.Name)
	end
	else
		print(hitplayer.Name, "was not a player!")
	end
end
end

 
local function onClick(player, target, value)
	print("clicked (server)")
	Slash(tick())
	Mine(target, value)
end
 
local function onEquip()
	clickEventConnection = clickEvent.OnServerEvent:connect(onClick)
end
 
local function onUnequip()
	clickEventConnection:disconnect()
end
 
tool.Equipped:connect(onEquip)
tool.Unequipped:connect(onUnequip)

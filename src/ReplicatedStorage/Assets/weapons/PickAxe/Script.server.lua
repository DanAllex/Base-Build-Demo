local tool = script.Parent
local clickEvent = tool.REClick
local clickEventConnection
local MineDamage = 5
 
local function Mine(targetBlock)
	if targetBlock:FindFirstChild("intHitpoints") then
		targetBlock.intHitpoints.Value = targetBlock.intHitpoints.Value - MineDamage
	elseif targetBlock.Parent:FindFirstChild("intHitpoints") then
		targetBlock.intHitpoints.Value = targetBlock.intHitpoints.Value - MineDamage
	end
end
 
local function onClick(player, target)
	print("mined")
	Mine(target)
end
 
local function onEquip()
	clickEventConnection = clickEvent.OnServerEvent:connect(onClick)
end
 
local function onUnequip()
	clickEventConnection:disconnect()
end
 
tool.Equipped:connect(onEquip)
tool.Unequipped:connect(onUnequip)
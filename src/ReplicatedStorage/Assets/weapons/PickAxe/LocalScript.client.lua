local tool = script.Parent
local player = game.Players.LocalPlayer
local MineAnim = script.Parent:WaitForChild("MineAnim")
repeat wait() until player.Character
local char = player.Character
local MineDistance = 10
local mouse = player:GetMouse()
local clickEvent = tool.REClick
local playerGui = script.Parent.Parent.Parent.PlayerGui
local changed = 0
local target = nil
local playAnim
mouse.TargetFilter = char

repeat wait() until player.Character
 
script.Parent.Equipped:connect(function()
	playerGui.toolEquipped.Value = true
end)

local function loop()
	changed = time()
while true do
	wait()
	if time() - changed > 2 and changed ~= 0  then
		print("time elapsed: "..tick() - changed)
		changed = time()
		for i = 0, 1, .1 do
			wait(.1)
			target.Hitpoints.Back.BackgroundTransparency = i
			target.Hitpoints.Back.Health.BackgroundTransparency = i
			end
	target.Hitpoints.Back.BackgroundTransparency = 0
	target.Hitpoints.Back.Health.BackgroundTransparency = 0
	target.Hitpoints.Back.Visible = false
		break
	end
end
end

local playedAnim = false

local function onActivate()
	print("clicked")
	if playedAnim == false then
		print("debounce")
		playedAnim = true
		playAnim = player.Character:WaitForChild("Humanoid"):LoadAnimation(MineAnim)
		playAnim:Play()
		target = mouse.Target
		print(target)
		if mouse.Target then
			print("is a target")
		if mouse.Target.Parent then
			print("target has a parent")
			print("target has a owner")
			if (mouse.Hit.p - char.UpperTorso.Position).magnitude <= MineDistance then
				print("player is close enough to block")
			clickEvent:FireServer(target)
			print("telling server")
			spawn(loop)
			end
			end
		elseif (mouse.Hit.p - char.UpperTorso.Position).magnitude <= MineDistance then
				clickEvent:FireServer(target)
				spawn(loop)
		end
		wait(.4)
		script.Parent.Handle.audSwing:Play()
		wait(.6)
	playedAnim = false
	end
	end
tool.Activated:connect(onActivate)

script.Parent.Unequipped:connect(function()
	playerGui.toolEquipped.Value = false
	playAnim:Stop()
end)
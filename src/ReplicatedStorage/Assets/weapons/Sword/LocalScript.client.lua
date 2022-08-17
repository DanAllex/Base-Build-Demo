local tool = script.Parent
local player = game.Players.LocalPlayer
local MineAnim = script.Parent:WaitForChild("Slash")
repeat wait() until player.Character
local char = player.Character
local MineDistance = 10
local mouse = player:GetMouse()
local clickEvent = tool.REClick
local playerGui = script.Parent.Parent.Parent.PlayerGui
local playAnim
mouse.TargetFilter = char

repeat wait() until player.Character
 
script.Parent.Equipped:connect(function()
	playerGui.toolEquipped.Value = true
end)

local playedAnim = false

local function onActivate()
	if playedAnim == false then
local paramvalue = false
local paramtarget = nil
		print("clicked (client)")
		playedAnim = true
		playAnim = player.Character:WaitForChild("Humanoid"):LoadAnimation(MineAnim)
		playAnim:Play()
		local target = mouse.Target
		if mouse.Target then
		if mouse.Target.Parent then
		if target:FindFirstChild("Owner") ~= nil or mouse.target.Parent:FindFirstChild("Owner") ~= nil then
			if (target.Owner.Value ~= player.Name or mouse.target.Parent.Owner.Value ~= player.Name) and (mouse.Hit.p - char.UpperTorso.Position).magnitude <= MineDistance then
			paramtarget = target
			paramvalue = true
			end
		elseif (mouse.Hit.p - char.UpperTorso.Position).magnitude <= MineDistance then
				paramtarget = target
				paramvalue = true
		end
		end
		end
		clickEvent:FireServer(nil, false)
		wait(.4)
		script.Parent.Handle.audSlash:Play()
		wait(.6)
	playedAnim = false
	end
end
 
tool.Activated:connect(onActivate)

script.Parent.Unequipped:connect(function()
	playerGui.toolEquipped.Value = false
	playAnim:Stop()
end)
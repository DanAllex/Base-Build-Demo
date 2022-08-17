local tool = script.Parent
local player = game.Players.LocalPlayer
local audHold = tool:WaitForChild("Handle"):WaitForChild("audHold")
local AimAnim = script.Parent:WaitForChild("AimingAnim")
local ShootAnim = script.Parent:WaitForChild("ShootAnim")
local HoldAnim = script.Parent:WaitForChild("HoldAnim")
repeat wait() until player.Character
local char = player.Character
local mouse = player:GetMouse()
local clickEvent = tool.REClick
mouse.TargetFilter = char
local playAnim = nil
local playAnim2 = nil
playAnim3 = nil
local current = 0
local equipped = false
local playerGui = script.Parent.Parent.Parent.PlayerGui
repeat wait() until playerGui:WaitForChild("GUI_MAIN").frmBow.Back.Fill
local Gui = playerGui:FindFirstChild("GUI_MAIN").frmBow
local Fill = Gui:WaitForChild("Back"):WaitForChild("Fill")
local orig = 0
local debounce = false
repeat wait() until player.Character
 
local playedAnim = false

local function attack()
script.Parent.Equipped:connect(function()
	playerGui.toolEquipped.Value = true
	equipped = true
	Gui.Visible = true
	mouse.Button1Down:connect(function()
	if playedAnim == false and equipped == true and tick() - orig >= 3 then
		playedAnim = true
		playAnim = player.Character:WaitForChild("Humanoid"):LoadAnimation(AimAnim)
		playAnim:Play()
		current = tick()
		game:GetService("RunService").RenderStepped:wait(1)
		playAnim:Stop()
		playAnim3 = player.Character:WaitForChild("Humanoid"):LoadAnimation(HoldAnim)
		playAnim3:Play()
	end
end)

mouse.Button1Up:connect(function()
	if equipped == true and tick() - orig >= 3 and playedAnim == true then
		orig = tick() + tick()
		playedAnim = false
		local held = tick() - current
		print(held)
		playAnim3:Stop()
		playAnim2 = player.Character:WaitForChild("Humanoid"):LoadAnimation(ShootAnim)
		playAnim2:Play()
		local delta = tick()
		repeat wait() until tick() - delta >= 0.5
		clickEvent:FireServer(held, mouse.Hit)
		orig = tick()
		end
end)
end)
end

script.Parent.Unequipped:connect(function()
	playerGui.toolEquipped.Value = false
	Gui.Visible = false
	playedAnim = false
	equipped = false
	playAnim:Stop()
	playAnim2:Stop()
	playAnim3:Stop()
end)

local function gainpower()
while true do
	wait()
repeat wait() until playedAnim == true and debounce == false
audHold:Play()
debounce = true
Fill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", .7, true)
end
end


spawn(attack)
spawn(gainpower)



while true do
wait()
repeat wait() until playedAnim == false and debounce == true
debounce = false
audHold:Stop()
Fill:TweenSize(UDim2.new(0, 0, 1, 0), "InOut", "Linear", 0.5, true)
for i = 0,1,0.05 do
		wait()
		Fill.BackgroundColor3 = Fill.BackgroundColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.A.ImageColor3 = Fill.A.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.B.ImageColor3 = Fill.B.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.C.ImageColor3 = Fill.C.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.D.ImageColor3 = Fill.D.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.E.ImageColor3 = Fill.E.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.F.ImageColor3 = Fill.F.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.G.ImageColor3 = Fill.G.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
		Fill.H.ImageColor3 = Fill.H.ImageColor3:lerp(Color3.new(189/255, 189/255, 189/255), i)
end
Fill:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Linear", 2, true)
wait(2)
Fill:TweenSize(UDim2.new(0, 0, 1, 0), "InOut", "Linear", 0.5, true)
wait(.5)
for i = 0,1,0.05 do
		wait()
		Fill.BackgroundColor3 = Fill.BackgroundColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.A.ImageColor3 = Fill.A.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.B.ImageColor3 = Fill.B.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.C.ImageColor3 = Fill.C.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.D.ImageColor3 = Fill.D.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.E.ImageColor3 = Fill.E.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.F.ImageColor3 = Fill.F.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.G.ImageColor3 = Fill.G.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
		Fill.H.ImageColor3 = Fill.H.ImageColor3:lerp(Color3.new(255/255, 152/255, 0/255), i)
end
end


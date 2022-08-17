local Player = game.Players.LocalPlayer
local RotateGui = script.Parent.Background

local Replicated_Storage = game:GetService("ReplicatedStorage")
local Folder = Replicated_Storage:WaitForChild("Objects"):GetChildren()
local ViewportFrame = Replicated_Storage:WaitForChild("ViewportFrame")
print(#Folder)

for i = 1, #Folder do -- loops through all children of Folder
	local Clone = Folder[i]:Clone() -- clones the child
	local PrimaryPart = Clone.PrimaryPart -- the clones primary part
	local Offset =  CFrame.new(0, 0, Clone:GetExtentsSize().z * 8)
	-- cloning and setting up the viewportframe
	local ViewportClone = ViewportFrame:Clone()
	local Camera = Instance.new("Camera", ViewportFrame)
	ViewportClone.CurrentCamera = Camera
	ViewportClone.Position = UDim2.new(0, i * 300, 0, 0)
	Clone.Parent = ViewportClone
	ViewportClone.Parent = RotateGui
	
	spawn(function()
		while true do
			for i = 1, 360 do
				Camera.CFrame = PrimaryPart.CFrame * CFrame.Angles(0,math.rad(i),0) * Offset
				wait()
			end
		end
	end)
end
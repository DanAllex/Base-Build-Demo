local Player = game.Players.LocalPlayer
local RotateGui = script.Parent.Parent

local Replicated_Storage = game:GetService("ReplicatedStorage")
local ViewportFrame = script.Parent
local obj = script.Parent.obj

repeat wait() until obj.Value ~= nil

local Clone = obj.Value:Clone() -- clones the child
local PrimaryPart = Clone.PrimaryPart -- the clones primary part
local Offset =  CFrame.new(0, 0, math.max(Clone:GetExtentsSize().x, Clone:GetExtentsSize().y, Clone:GetExtentsSize().z) * 0.75)
-- cloning and setting up the viewportframe
local Camera = Instance.new("Camera", ViewportFrame)
ViewportFrame.CurrentCamera = Camera
Clone.Parent = ViewportFrame

Camera.CFrame = PrimaryPart.CFrame * CFrame.Angles(0,math.rad(180),0) * Offset

--spawn(function()
	--while true do
--		for i = 1, 360 do
--			Camera.CFrame = PrimaryPart.CFrame * CFrame.Angles(0,math.rad(i),0) * Offset
--			wait()
--		end
--	end
--end)
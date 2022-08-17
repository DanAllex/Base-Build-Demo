--[[

Written by zblox164. Released on 2020-05-22

Change log:

2020-05-22 V1 - Details:
	The module has been released.

2020-05-24 V1.1 - Details:
	- Fixed bugs
	- Improved snapping
	- Added Placement cooldowns
2020-05-26 V1.2 Details:
	- Fixed bugs
2020-06-15
	- Released YouTube tutorial

Welcome to zblox's NEW revamped placement module. No massive walls to keep the model in
	the bounds of the plot, no snapping isssues and my personal favorite addition,
	IT'S NOW OOP FRIENDLY, the way placement modules should be! If you do end up using this
	module, you don't need to give credit, but it is definitely appreciated if given.

FAQ (based on my previous module):

	Q. It is broken. How do I fix this? A. The most likely reason for this, is that you have incorrectly
	setup the module. You will have to fix your code to fix this 95% of the time.
	
	Q. How do I save/load data. This module does NOT handle any other tycoon features than
	the placement system itself. I do have a tutorial series that does include that feature
	which you can view below:
	https://www.youtube.com/watch?v=jVLGBP-OFjk&list=PLR9RLF7-52bSg0BcGfV2zyvFyFMJwztTt
	
	Q. How do I create an inventory system? A. Again, this is NOT included in the module itself.
	You will have to research this topic and implement this feature on your own.

If you want to learn to use this module you will have to do the following:

 * Copy the code below and adapt it for your game
 * Wait for the developer forum tutorial
 * Watch my YouTube tutorial - https://www.youtube.com/watch?v=OD553c2raho

CODE:

-- Client --

local itemPlacement = require(game.ReplicatedStorage.location.PlacementModuleV3)

local remote = game.ReplicatedStorage.location.requestPlacement

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

local plot = plotLocation

local button = buttonLocation

itemPlacement.new(
	2,
	game.ReplicatedStorage.location,
	Enum.KeyCode.R, Enum.KeyCode.X, Enum.KeyCode.U, Enum.KeyCode.L
)

button.MouseButton1Click:Connect(function()
	itemPlacement:activate("Wall", plot.PlacedObjectsLocation, plot.PlotLocation, true, true)
end)

mouse.Button1Down:Connect(function()
	itemPlacement:requestPlacement(remote)
end)

-- Server --

--Ignore the top two functions

local function checkHitbox(character, object)
	if object then
		local collided = false
		
		local collisionPoint = object.PrimaryPart.Touched:Connect(function() end)
		local collisionPoints = object.PrimaryPart:GetTouchingParts()
		
		for i = 1, #collisionPoints do
			if not collisionPoints[i]:IsDescendantOf(object) and not collisionPoints[i]:IsDescendantOf(character) then
				collided = true
				
				break
			end
		end
		
		collisionPoint:Disconnect()
		
		return collided
	end
end

local function ChangeTransparency(item, c)
	for i, o in next, item:GetDescendants() do
		if o then
			if o:IsA("Part") or o:IsA("UnionOperation") or o:IsA("MeshPart") then
				o.Transparency = c
			end
		end
	end
end

--Ignore above

local function place(plr, name, location, prefabs, cframe, c)
	local item = prefabs:FindFirstChild(name):Clone()
	item.PrimaryPart.CanCollide = false
	item:SetPrimaryPartCFrame(cframe)
	
	ChangeTransparency(item, 1)
	
	item.Parent = location
	
	if c then
		if not checkHitbox(plr.Character, item) then
			ChangeTransparency(item, 0)
			
			item.PrimaryPart.Transparency = 1
			
			return true
		else
			item:Destroy()
			
			return false
		end
	else
		ChangeTransparency(item, 0)
			
		item.PrimaryPart.Transparency = 1
			
		return true
	end
end

game.ReplicatedStorage.location.requestPlacement.OnServerInvoke = place

API:

MODULE.new(
	int grid,  = MODULE.new(
	obj objectLocation,
	Enum rotateKey, Enum terminateKey, Enum raiseKey, Enum lowerKey
)

local placementFunctions
								int grid, 
								obj objectLocation,
								Enum rotateKey, Enum terminateKey, Enum raiseKey, Enum lowerKey
							)

placementFunctions:terminate() -- terminates the current placement
placementFunctions:activate(string objectName, obj location where the model will be placed, obj plane/plot, bool stackable, bool smart rotation)  -- activates placement
placementFunctions:requestPlacement(obj RemoteFunction)

]]--
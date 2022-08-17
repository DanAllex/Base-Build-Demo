--[[

Written by zblox164. Released on 2020-05-22

Change log:

2020-05-22 V1 - Details:
	- The module has been released.
	
2020-05-24 V1.1 - Details:
	- Fixed bugs
	- Improved snapping
	- Added Placement cooldowns
2020-05-26 V1.2 Details:
	- Fixed bugs
2020-06-15
	- Released YouTube tutorial
	
For API and FAQ go to the extras script.

]]--

-- SETTINGS

-- Bools
local interpolation = true -- Toggles interpolation (smoothing)
local moveByGrid = true -- Toggles grid system
local collisions = true -- Toggles collisions
local buildModePlacement = true -- Toggles "build mode" placement
local displayGridTexture = true -- Toggles the grid texture to be shown when placing
local smartDisplay = false -- Toggles smart display for the grid. If true, it will rescale the grid texture to match your gridsize
local enableFloors = true -- Toggles if the raise and lower keys will be enabled
local transparentModel = true -- Toggles if the model itself will be transparent

-- Color3
local collisionColor = Color3.fromRGB(255, 75, 75) -- Color of the hitbox when colliding
local hitboxColor = Color3.fromRGB(75, 255, 75) -- Color of the hitbox while not colliding

-- Integers
local maxHeight = 100 -- Max height you can place objects (in studs)
local floorStep = 15 -- The step (in studs) that the object will be raised or lowered
local rotationStep = 90 -- Rotation step

-- Numbers
local hitboxTransparency = 0.8 -- Hitbox transparency when placing
local transparencyDelta = 0.6 -- Transparency of the model itself (transparentModel must equal true)
local lerpSpeed = 0.7 -- speed of interpolation. 0 = no interpolation, 0.9 = major interpolation
local placementCooldown = 0.5 -- How quickly the user can place down objects (in seconds)

-- Other
local gridTexture = "rbxassetid://13786085"

-- DO NOT EDIT PAST THIS POINT UNLESS YOU KNOW WHAT YOUR DOING.

local placement = {}

placement.__index = placement

-- Essentials
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()	

-- math/cframe functions
local clamp = math.clamp
local floor = math.floor
local abs = math.abs
local max = math.max
local pi = math.pi

local cframe = CFrame.new
local anglesXYZ = CFrame.fromEulerAnglesXYZ

-- Constructor variables
local grid
local itemLocation
local rotateKey
local terminateKey
local raiseKey
local lowerKey

-- Activation vatiables
local plot
local object

-- bools
local canPlace
local isColliding
local stackable
local smartRot
local canActivate = true
local currentRot = false

-- values used for calculations
local speed

local posX
local posY
local posZ
local rot
local x, z
local cx, cz

local lowerXBound
local upperXBound

local lowerZBound
local upperZBound

local initialY

-- collision variables
local collisionPoints
local collisionPoint
local collided

-- states
local states = {
	"movement",
	"placing",
	"colliding",
	"in-active"
}

local currentState = 4
local lastState = 4

-- other
local placedObjects
local loc
local primary
local lastPlacement = {}
local humanoid = character:WaitForChild("Humanoid")

-- dragging
local dragOrigin
local originSet = false
local currentShadows = {}
local lastDir = Vector3.new(0, 0, 0)


local function setCurrentState(state)
	currentState = clamp(state, 1, 4)
	lastState = currentState
end

-- Changes the color of the hitbox depending on the current state
local function editHitboxColor(obj)
	if currentState == 3 then
		if obj then
			if obj.PrimaryPart then
				obj.PrimaryPart.Color = collisionColor
			end
		end
	else
		if obj then
			if obj.PrimaryPart then
				obj.PrimaryPart.Color = hitboxColor
			end
		end
	end
end

-- Checks for collisions on the hitbox
local function checkHitbox(obj)
	if obj and collisions then
		setCurrentState(1)
		
		collisionPoint = obj.PrimaryPart.Touched:Connect(function() end)
		collisionPoints = obj.PrimaryPart:GetTouchingParts()
		
		for i = 1, #collisionPoints do
			if not collisionPoints[i]:IsDescendantOf(obj) and not collisionPoints[i]:IsDescendantOf(character) then
				setCurrentState(3)
				
				break
			end
		end
		
		collisionPoint:Disconnect()
		
		return collided
	end
end

-- switches the floor depending on the value given
local function editFloor(f)
	if enableFloors and not stackable then
		if f == 1  then
			posY = posY + floor(abs(floorStep))
		else
			posY = posY - floor(abs(floorStep))
		end
	end
end

-- handles the grid texture
local function displayGrid()
	if displayGridTexture then	
		local gridTex = Instance.new("Texture")
		
		gridTex.Name = "GridTexture"
		gridTex.Texture = gridTexture
		gridTex.Parent = plot
		gridTex.Face = Enum.NormalId.Top
		
		gridTex.StudsPerTileU = 2
		gridTex.StudsPerTileV = 2
		
		if smartDisplay then
			gridTex.StudsPerTileU = grid
			gridTex.StudsPerTileV = grid	
		end
	end
end

local function rotate()
	if smartRot then
		if currentRot then
			rot = rot + rotationStep
		else 
			rot = rot - rotationStep
		end
	else
		rot = rot + rotationStep
	end
	
	currentRot = not currentRot
end

local function round(n)
	if (n - (n % 0.1)) - (n - (n % 1)) < 0.5 then
		n = n - (n % 1)
	else
    	n = (n - (n % 1)) + 1
	end
	
	return n
end

local function calculateYPos(tp, ts, o)
	return (tp + ts / 2) + o / 2
end

local function bounds()
	if currentRot then
		lowerXBound = plot.Position.X - (plot.Size.X / 2) 
		upperXBound = plot.Position.X + (plot.Size.X / 2) - primary.Size.X
		
		lowerZBound = plot.Position.Z - (plot.Size.Z / 2)	
		upperZBound = plot.Position.Z + (plot.Size.Z / 2) - primary.Size.Z
	else
		lowerXBound = plot.Position.X - (plot.Size.X / 2) 
		upperXBound = plot.Position.X + (plot.Size.X / 2) - primary.Size.Z
		
		lowerZBound = plot.Position.Z - (plot.Size.Z / 2)	
		upperZBound = plot.Position.Z + (plot.Size.Z / 2) - primary.Size.X
	end
	
	posX = clamp(posX, lowerXBound, upperXBound)
	posZ = clamp(posZ, lowerZBound, upperZBound)
end

function mouseHit(distance) 
	local ray = Ray.new(mouse.UnitRay.Origin, mouse.UnitRay.Direction * distance) --as you can see, here creating a ray with the same origin (which is the camera of course) and the same direction BUT longer, whatever the distance parameter is
	local _, position = workspace:FindPartOnRay(ray)
	
	return position 
end

-- Calculates the position of the object
local function calculateItemLocation(hit, increment)
	
	x, z = hit.X + increment.X, hit.Z + increment.Z
	
	if moveByGrid then
		if x % grid < grid / 2 then
			posX = round(x - (x % grid))
		else
			posX = round(x + (grid - (x % grid)))
		end
		
		if z % grid < grid / 2 then
			posZ = round(z - (z % grid))
		else
			posZ = round(z + (grid - (z % grid)))
		end
		
		if currentRot then
			cx = primary.Size.X / 2
			cz = primary.Size.Z / 2
		else
			cx = primary.Size.Z / 2
			cz = primary.Size.X / 2
		end
	else
		posX = x
		posZ = z
	end
	
	if stackable and mouse.Target then
		posY = calculateYPos(mouse.Target.Position.Y, mouse.Target.Size.Y, primary.Size.Y)
	end

	posY = clamp(posY, initialY, maxHeight + initialY)
	
	bounds()
end

local function getFinalCFrame()
	return cframe(posX, posY, posZ) * cframe(cx, 0, cz) * anglesXYZ(0, rot * pi / 180, 0)
end

-- Sets the position of the object
local function translateObj()
	if currentState ~= 4 and dragOrigin == nil then
		calculateItemLocation(mouse.Hit, Vector3.new(0,0,0))
		checkHitbox(object)
		editHitboxColor(object)
		
		object:SetPrimaryPartCFrame(primary.CFrame:Lerp(cframe(posX, posY, posZ) * cframe(cx, 0, cz) * anglesXYZ(0, rot * pi / 180, 0), speed))
	end
end

local function dragObj()
	if currentState ~= 4 and dragOrigin ~= nil then
		if originSet == false then
			originSet = true
			calculateItemLocation(dragOrigin, Vector3.new(0,0,0))
			local cf = getFinalCFrame()
			checkHitbox(object)
			editHitboxColor(object)
			object:SetPrimaryPartCFrame(cf)
		end
		local endLoc
		local unitVector
		
		if math.abs(mouse.Hit.X - dragOrigin.X) > math.abs(mouse.Hit.Z - dragOrigin.Z) then
			endLoc = mouse.Hit.X - dragOrigin.X
			if endLoc < 0 then
				unitVector = Vector3.new(-1, 0 , 0)
			else
				unitVector = Vector3.new(1, 0 , 0)
			end
		else
			endLoc = mouse.Hit.Z - dragOrigin.Z
			if endLoc < 0 then
				unitVector = Vector3.new(0, 0 , -1)
			else
				unitVector = Vector3.new(0, 0 , 1)
			end
		end
		if unitVector ~= lastDir then
			lastDir = unitVector
			for i = 1, #currentShadows do
				currentShadows[i]:Destroy()
			end	
			currentShadows = {}
		end
		
		local start
		local increment
		local ending
		if lastDir.X == 1 or lastDir.Z == 1 then
			start = math.ceil(endLoc) - math.ceil(endLoc) % 2
			increment = 2
			ending = 1
		else
			start = math.floor(endLoc) - math.floor(endLoc) % 2
			increment = -2
			ending = -1
		end
		
		if #currentShadows > math.abs(start) / 2 then
			local copy = {}
			for i = 1, #currentShadows do
				table.insert(copy, currentShadows[i])
			end
			print("The number of current shadows (" .. #currentShadows .. ") is greater than the amount we just dragged (" .. start / 2 .. ")")
			for i = math.abs(start) / 2, #copy do
				print("DESTROYED")
				copy[i]:Destroy()
				copy[i] = nil
			end
			currentShadows = {}
			for i = 1, #copy do
				if copy[i] ~= nil then
					table.insert(currentShadows, copy[i])
				end
			end
		end
		
		for i = ending, start, increment do
			if math.abs(i) / 2 > #currentShadows then
				if unitVector.X == 0 then
					unitVector = Vector3.new(0,0,i)
				else
					unitVector = Vector3.new(i,0,0)
				end
				calculateItemLocation(dragOrigin, unitVector)
				local cf = getFinalCFrame()
				local tempShadow = object:Clone()
				tempShadow.Name = "Shadow"
				tempShadow.Parent = plot.Parent.PlacedObjects
				checkHitbox(tempShadow)
				tempShadow:SetPrimaryPartCFrame(cf)
				table.insert(currentShadows, tempShadow)
			end
		end
	end
end

-- handles user input
local function getInput(input, gpe)
	if currentState ~= 4 then
		if input.KeyCode == raiseKey then
			editFloor(1)
		elseif input.KeyCode == lowerKey then
			editFloor(2)
		elseif input.KeyCode == terminateKey then
			placement:terminate()
		elseif input.KeyCode == rotateKey then
			rotate()
		end
	end
end

local function coolDown(plr, cd)
	if lastPlacement[plr.UserId] == nil then
		lastPlacement[plr.UserId] = os.time()
		
		return true
	else
		if os.time() - lastPlacement[plr.UserId] >= cd then
			lastPlacement[plr.UserId] = os.time()
			
			return true
		else
			return false
		end
	end
end

-- Verifys that the plane which the object is going to be placed upon is the correct size
local function verifyPlane()	
	if plot.Size.X % grid == 0 and plot.Size.Z % grid == 0 then
		return true
	else
		return false
	end
end

-- Checks if there are any problems with the users setup
local function approveActivation()
	if not verifyPlane() then
		warn("The object that the model is moving on is not scaled correctly. Consider changing it.")
	end
	
	if grid > max(plot.Size.X, plot.Size.Z) then 
		error("Grid size is larger than the plot size. To fix this, try lowering the grid size.")
	end
end

-- Sets up placement
function placement.new(g, objs, r, t, u, l)
	local data = {}
	local metaData = setmetatable(data, placement)
	
	grid = abs(tonumber(g))
	itemLocation = objs
	rotateKey = r
	terminateKey = t
	raiseKey = u
	lowerKey = l
	
	data.gridsize = grid
	data.items = objs
	data.rotate = rotateKey
	data.cancel = terminateKey
	data.raise = raiseKey
	data.lower = lowerKey
	
	return data 
end

function placement:getCurrentState()
	return states[currentState]
end

function placement:pauseCurrentState()
	lastState = currentState
	
	if object then
		currentState = states[4]
	end
end

function placement:resume()
	if object then
		setCurrentState(lastState)
	end
end

-- Terminates placement
function placement:terminate()
	stackable = nil
	canPlace = nil
	smartRot = nil
	
	if object then
		object:Destroy()
		object = nil
	end
	
	if displayGridTexture and plot then
		for i, v in next, plot:GetChildren() do
			if v then
				if v.Name == "GridTexture" and v:IsA("Texture") then
					v:Destroy()
				end
			end
		end
	end
	
	setCurrentState(4)
	canActivate = true
	
	return
end

-- Requests to place down the object
function placement:requestPlacement(func)
	if currentState ~= 4 or currentState ~= 3 and object then
		local cf
		
		calculateItemLocation(mouse.Hit, Vector3.new(0,0,0))
		
		if coolDown(player, placementCooldown) then
			if buildModePlacement then
				cf = getFinalCFrame()
				
				checkHitbox(object)
				setCurrentState(2)
				
				if currentState == 2 then
					func:InvokeServer(object.Name, placedObjects, loc, cf, collisions)
					
					setCurrentState(1)
				end
			else
				cf = getFinalCFrame()
				
				checkHitbox(object)
				setCurrentState(2)
				
				if currentState == 2 then
					if func:InvokeServer(object.Name, placedObjects, loc, cf, collisions) then
						placement:terminate()
					end
				end
			end
		end
	end
end

-- floor is ceil for negatives

function placement:requestDrag(func, startPos)
	if currentState ~= 4 or currentState ~= 3 and object then
		local cf
		local endLoc
		local unitVector
		
		dragOrigin = nil
		originSet = false
		lastDir = Vector3.new(0, 0, 0)
		for i = 1, #currentShadows do
			currentShadows[i]:Destroy()
		end	
		currentShadows = {}
		
		if math.abs(mouse.Hit.X - startPos.X) > math.abs(mouse.Hit.Z - startPos.Z) then
			endLoc = mouse.Hit.X - startPos.X
			if endLoc < 0 then
				unitVector = Vector3.new(-1, 0 , 0)
			else
				unitVector = Vector3.new(1, 0 , 0)
			end
		else
			endLoc = mouse.Hit.Z - startPos.Z
			if endLoc < 0 then
				unitVector = Vector3.new(0, 0 , -1)
			else
				unitVector = Vector3.new(0, 0 , 1)
			end
		end
		
		--calculateItemLocation(startPos, Vector3.new(0,0,0))
		if coolDown(player, placementCooldown) then
			local start
			local increment
			local ending
			if unitVector.X == 1 or unitVector.Z == 1 then
				start = math.ceil(endLoc) - math.ceil(endLoc) % 2
				ending = 1
				increment = 2
			else
				start = math.floor(endLoc) - math.floor(endLoc) % 2
				ending = -1
				increment = -2
			end
				
			calculateItemLocation(startPos, Vector3.new(0,0,0))
			cf = getFinalCFrame()
			checkHitbox(object)
			setCurrentState(2)
			if currentState == 2 then
				func:InvokeServer(object.Name, placedObjects, loc, cf, collisions)
				setCurrentState(1)
			end
				
			for i = ending, start, increment do
				local tempShadow = object:Clone()
					
				for i,v in pairs(tempShadow:GetChildren()) do
					if not v:IsA("Folder") then
						v.Transparency = 1
					end
				end
					
				tempShadow.Parent = workspace
					
				if unitVector.X == 0 then
					unitVector = Vector3.new(0,0,i)
				else
					unitVector = Vector3.new(i,0,0)
				end
				calculateItemLocation(startPos, unitVector)
				cf = getFinalCFrame()
				tempShadow:SetPrimaryPartCFrame(cf)
				checkHitbox(tempShadow)
				editHitboxColor(tempShadow)
				setCurrentState(2)
				if currentState == 2 then
					func:InvokeServer(object.Name, placedObjects, loc, cf, collisions)
				
					setCurrentState(1)
				end
				tempShadow:Destroy()
				tempShadow = nil 
			end
		end
	end
end

function placement:beginDrag(orig)
	dragOrigin = orig
end

-- Activates placement
function placement:activate(id, pobj, plt, stk, r)
	if object then
		object:Destroy()
		object = nil
	end
	
	plot = plt
	object = itemLocation:FindFirstChild(tostring(id))
	placedObjects = pobj
	loc = itemLocation
	
	approveActivation()
	
	object = itemLocation:FindFirstChild(id):Clone()
	
	for i, o in next, object:GetDescendants() do
		if o then
			if o:IsA("Part") or o:IsA("UnionOperation") or o:IsA("MeshPart") then
				o.CanCollide = false
				
				if transparentModel then
					o.Transparency = o.Transparency + transparencyDelta
				end
			end
		end
	end
	
	object.PrimaryPart.Transparency = hitboxTransparency
	
	stackable = stk
	smartRot = r
	
	if not stk then
		mouse.TargetFilter = placedObjects
	else
		mouse.TargetFilter = object
	end
	
	if buildModePlacement then
		canActivate = true
	else
		canActivate = false
	end
	
	initialY = calculateYPos(plt.Position.Y, plt.Size.Y, object.PrimaryPart.Size.Y)
	posY = initialY
	
	speed = 0
	rot = 0
	currentRot = true
	
	translateObj()
	displayGrid()
	editHitboxColor(object)
	
	if interpolation then
		speed = clamp(abs(tonumber(1 - lerpSpeed)), 0, 0.9)
	else
		speed = 1
	end
	
	primary = object.PrimaryPart
	object.Parent = pobj
	
	setCurrentState(1)
end

runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, translateObj)
runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, dragObj)
userInputService.InputBegan:Connect(getInput)

return placement
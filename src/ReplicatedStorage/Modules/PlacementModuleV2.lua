-- To learn how to use this module watch my video on YouTube.

-- The API (not a tutorial)

--[[
		MODULE:new(string name, obj model location, obj plot, obj placed objs location, bool stackable objs, bool rot type)
		MODULE:Finish(obj Remote event)
--]]

-- Settings

-- Grid
local dragging = false
local MoveByGrid = true -- If you wan't the model to move by grid specified units.
local GridSize = 2 -- In studs.
local DisplayGrid = true -- If you wan't to display a grid.
local SmartDisplay = true -- If you want the module to try and autoscale the texture to match your grid (may alter resolution of texture).
local GridTexture = "rbxassetid://13786085" -- Texture used when grid is displayed.

 -- Linear Interpolation (smoothing)

local Interpolate = true -- Enable smoothing (Interpolation)
local InterpolateSpeed = 0.7 -- Speed of movement (0 = instant, 1 = no movement. Defualt = 0.7)

-- Basic Settings - Start

local RotationStep = 90 -- In degrees.
local FloorStep = 15 -- In studs.
local MaxHeight = 30 -- In studs.
local CollisionCheckCooldown = 0.3 -- In seconds

-- Bools (true or false values)

local DetectCollisions = true -- If you wan't to have a collision system.
local IgnoreItems = true -- If you want the mouse to ignore the items currently placed down.
local BuildModeEnabled = true -- If you want continual placement.
local EnableFloors = true -- If you want a floor system.
local TransparentModels = true -- if you want the models to be transparent while placing

-- Basic Settings - End

-- Advanced Settings - Start

local CollisionColor = Color3.fromRGB(255, 55, 55) -- The RGB value for when collision is detected.
local PlacingColor = Color3.fromRGB(55, 255, 55) -- The RGB value for when collision is not detected.

-- Keybinds

local KeyCodeCancel = Enum.KeyCode.X -- Key used to cancel placement.
local KeyCodeRotate = Enum.KeyCode.R -- Key used to rotate the model being placed.
local KeyCodeRaiseFloor = Enum.KeyCode.U -- Key used to raise the floor.
local KeyCodeLowerFloor = Enum.KeyCode.L -- Key used to lower the floor.

-- Advanced Settings - End

local transparentDelta = 0.6
local hitboxTransparency = 0.8
local step = 1.1

-- DO NOT EDIT PAST THIS POINT UNLESS YOU KNOW WHAT YOUR DOING!

local PlacementModuleV2 = {}

local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local mouse = player:GetMouse()	

local posX
local posY
local posZ
local startingY
local currentRot = true
local smartRot = false

local lastY
local rot = 0
local c = 0

local modelInfo = {}
local cframe
local origPosition
local grid = math.abs(tonumber(GridSize))

local model
local plot
local objs
local collisionPoints
local collisionPoint

local placingMode
local canPlace
local placing
local colliding
local stacking
local canStart = true
local currentMouse
local xP = {}
local xN = {}
local zP = {}
local zN = {}
local currentIndex = Vector3.new(0, 0, 0)


wait(0.1) -- DO NOT REMOVE (It will error if you remove)

local humanoid = character:FindFirstChild("Humanoid")

local function EditColor()
	if PlacementModuleV2:GetCurrentState() == "Collision" and model then
		model.PrimaryPart.Color = CollisionColor
	elseif PlacementModuleV2:GetCurrentState() ~= "Collision" and model then
		model.PrimaryPart.Color = PlacingColor
	end
end

local function CheckHitbox()
	if model then
		colliding = false
		
		collisionPoint = model.PrimaryPart.Touched:Connect(function()
		end)
		collisionPoints = model.PrimaryPart:GetTouchingParts()
		
		for i = 1, #collisionPoints do
			--print(collisionPoints[i].Parent:FindFirstChild("Shadow"))
			if not collisionPoints[i]:IsDescendantOf(model) and not collisionPoints[i]:IsDescendantOf(character) and not collisionPoints[i].Parent:FindFirstChild("Shadow") then
				colliding = true
			--	print("yah collided with " .. collisionPoints[i].Name)
				
				break
			end
		end
		
		collisionPoint:Disconnect()
		
		if colliding == false then
			if (model.primary.Orientation.Y ~= 90 and model.primary.Orientation.Y ~= -90) then
				if (plot.Position.X + 0.5 * plot.Size.X < model.primary.Position.X + 0.5 * model.primary.Size.X) or (model.primary.Position.X - 0.5 * model.primary.Size.X < plot.Position.X - 0.5 * plot.Size.X) or (plot.Position.Z + 0.5 * plot.Size.Z < model.primary.Position.Z + 0.5 * model.primary.Size.Z) or (model.primary.Position.Z - 0.5 * model.primary.Size.Z < plot.Position.Z - 0.5 * plot.Size.Z) then
					colliding = true
				end
			else
				if (plot.Position.X + 0.5 * plot.Size.X < model.primary.Position.X + 0.5 * model.primary.Size.Z) or (model.primary.Position.X - 0.5 * model.primary.Size.Z < plot.Position.X - 0.5 * plot.Size.X) or (plot.Position.Z + 0.5 * plot.Size.Z < model.primary.Position.Z + 0.5 * model.primary.Size.X) or (model.primary.Position.Z - 0.5 * model.primary.Size.X < plot.Position.Z - 0.5 * plot.Size.Z) then
					colliding = true
				end
			
			end
		end
		
		return colliding
	end
end

local function CalcualateNewPosition()
	--if not dragging then
	if MoveByGrid then
		posX = math.floor((mouse.Hit.X / grid) + 0.5) * grid
		posZ = math.floor((mouse.Hit.Z / grid) + 0.5) * grid
	else
		posX = mouse.Hit.X
		posZ = mouse.Hit.Z
	end
	
	if EnableFloors and not stacking then
		if posY > MaxHeight then
			posY = MaxHeight
		elseif posY < startingY then
			posY = startingY
		else
		end
	end
	
	if stacking then
		posY = math.floor(mouse.Hit.Y) + step
				
		if posY > MaxHeight then
			posY = MaxHeight
		elseif posY < startingY then
			posY = startingY
		end
	end
	--end
end


local function CalcualateNewPositionMod(orig, i)
	if MoveByGrid then
		posX = math.floor(((orig.X + i.X * 2) / grid) + 0.5) * grid
		posZ = math.floor(((orig.Z + i.Z * 2) / grid) + 0.5) * grid
	else
		posX = orig.X
		posZ = orig.Z
	end
	
	if EnableFloors and not stacking then
		if posY > MaxHeight then
			posY = MaxHeight
		elseif posY < startingY then
			posY = startingY
		else
		end
	end
	
end

local function CalcualateNewPositionClone(orig, i)
	local tempX
	local tempZ
	if MoveByGrid then
		tempX = math.floor(((orig.X + i.X * 2) / grid) + 0.5) * grid
		tempZ = math.floor(((orig.Z + i.Z * 2) / grid) + 0.5) * grid
	else
		tempX = orig.X
		tempZ = orig.Z
	end
	
	if EnableFloors and not stacking then
		if posY > MaxHeight then
			posY = MaxHeight
		elseif posY < startingY then
			posY = startingY
		else
		end
	end
	--print(tempX .. " and " .. tempZ)
	return Vector3.new(tempX, posY, tempZ)
end

local function CalcFinalCFrame()
	if currentRot then
		cframe = CFrame.new(posX, posY, posZ) * CFrame.new(model.PrimaryPart.Size.X / 2, 0, model.PrimaryPart.Size.Z / 2)
	else
		cframe = CFrame.new(posX, posY, posZ) * CFrame.new(model.PrimaryPart.Size.Z / 2, 0, model.PrimaryPart.Size.X / 2)
	end
end

local function Calc(tf)
	--if not dragging then
	if currentRot then
		if Interpolate then
			model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame:Lerp(CFrame.new(posX, posY, posZ) * CFrame.new(model.PrimaryPart.Size.X / 2, 0, model.PrimaryPart.Size.Z / 2) * CFrame.Angles(0, math.rad(rot), 0), 1 - InterpolateSpeed))
		else
			model:SetPrimaryPartCFrame(CFrame.new(posX, posY, posZ) * CFrame.new(model.PrimaryPart.Size.X / 2, 0, model.PrimaryPart.Size.Z / 2) * CFrame.Angles(0, math.rad(rot), 0))
		end
	else
		if Interpolate then
			model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame:Lerp(CFrame.new(posX, posY, posZ) * CFrame.new(model.PrimaryPart.Size.Z / 2, 0, model.PrimaryPart.Size.X / 2) * CFrame.Angles(0, math.rad(rot), 0), 1 - InterpolateSpeed))
		else
			model:SetPrimaryPartCFrame((CFrame.new(posX, posY, posZ) * CFrame.new(model.PrimaryPart.Size.Z / 2, 0, model.PrimaryPart.Size.X / 2)) * CFrame.Angles(0, math.rad(rot), 0))
		end
	end
	--end
end

local function CalcMod(tf, origPos, i)
	model:SetPrimaryPartCFrame(CFrame.new(posX, posY, posZ) * CFrame.new(1, 0, 1) * CFrame.Angles(0, math.rad(rot), 0))
end




local function CalcClone(tf, clone, origPos, i, coord)
	clone:SetPrimaryPartCFrame(CFrame.new(coord.X, coord.Y, coord.Z) * CFrame.new(1, 0, 1) * CFrame.Angles(0, math.rad(rot), 0))
end

local function CalcCloneOld(tf, clone, origPos, i, coord)
	---print("in the clone " .. coord.X)
	if currentRot then
		if Interpolate then
			clone:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame:Lerp(CFrame.new(coord.X + i.X * 2, coord.Y, coord.Z + i.Z * 2) * CFrame.new(1, 0, 1) * CFrame.Angles(0, math.rad(rot), 0), 1 - InterpolateSpeed))
		else
			clone:SetPrimaryPartCFrame(CFrame.new(coord.X + i.X * 2, coord.Y, coord.Z + i.Z * 2) * CFrame.new(1, 0, 1) * CFrame.Angles(0, math.rad(rot), 0))
		end
	else
		if Interpolate then
			clone:SetPrimaryPartCFrame(clone.PrimaryPart.CFrame:Lerp(CFrame.new(coord.X + i.X * 2, coord.Y, coord.Z + i.Z * 2) * CFrame.new(1, 0, 1) * CFrame.Angles(0, math.rad(rot), 0), 1 - InterpolateSpeed))
		else
			clone:SetPrimaryPartCFrame((CFrame.new(coord.X + i.X * 2, coord.Y, coord.Z + i.Z * 2) * CFrame.new(1, 0, 1)) * CFrame.Angles(0, math.rad(rot), 0))
		end
	end
end



local function ModifyCoordinates()
	if placingMode and canPlace and model and not dragging then
		CalcualateNewPosition()
		Calc(true)
		
		if DetectCollisions then
			CheckHitbox()
			EditColor()
		end
	end
end

local function ModifyCoordinatesDragging()
	local arr
	if placingMode and canPlace and model and dragging and currentMouse then
		repeat
			wait()
		until currentMouse ~= nil and model ~= nil
		if (math.abs(mouse.Hit.X - currentMouse.X) > math.abs(mouse.Hit.Z - currentMouse.Z)) then
			if mouse.Hit.X - currentMouse.X > 0 then
				arr = xP
				currentIndex = Vector3.new(1, 0, 0)
				--print("positive")
				for i = 1, math.ceil(math.abs((mouse.Hit.X - currentMouse.X)) / 2) do
					currentIndex = Vector3.new(i, 0, 0)
					if not arr[i] then
						local clone = model:Clone()
						clone.Parent = plot.Parent.PlacedObjects
						--print(clone.Parent)
						arr[i] = clone
						CalcClone(true, clone, currentMouse, Vector3.new(i, 0, 0), CalcualateNewPositionClone(currentMouse, Vector3.new(i, 0, 0)))
					end
				--CalcualateNewPositionMod(currentMouse, Vector3.new(i, 0, 0))
				--CalcMod(currentRot, currentMouse, Vector3.new(0, 0, 0))
				--CalcualateNewPosition()
				--Calc(true)
				end
				if #arr > math.ceil(math.abs((mouse.Hit.X - currentMouse.X)) / 2) then
					for i = math.ceil(math.abs((mouse.Hit.X - currentMouse.X)) / 2) + 1, #arr do
						arr[i]:Destroy()
						arr[i] = nil
					end
				end
				xP = arr
				if #xN > 0 then
					for i, v in pairs(xN) do
						if v then
							v:Destroy()
						end
					end
					xN = {}
				end
				if #zP > 0 then
					for i, v in pairs(zP) do
						if v then
							v:Destroy()
						end
					end
					zP = {}
				end
				if #zN > 0 then
					for i, v in pairs(zN) do
						if v then
							v:Destroy()
						end
					end
					zN = {}
				end
				else
					arr = xN
					currentIndex = Vector3.new(-1, 0, 0)
				
					for i = math.ceil((mouse.Hit.X - currentMouse.X)) / 2, 0 do
						currentIndex = Vector3.new(-i, 0, 0)
						if not arr[-i] then
							local clone = model:Clone()
							clone.Parent = plot.Parent.PlacedObjects
							arr[-i] = clone
							CalcClone(true, clone, currentMouse, Vector3.new(i, 0, 0), CalcualateNewPositionClone(currentMouse, Vector3.new(i, 0, 0)))
						end
				--CalcualateNewPositionMod(currentMouse, Vector3.new(i, 0, 0))
				--CalcMod(currentRot, currentMouse, Vector3.new(0, 0, 0))
				--CalcualateNewPosition()
				--Calc(true)
					end
					if #arr > math.ceil(math.abs((mouse.Hit.X - currentMouse.X)) / 2) then
					for i = -#arr, math.ceil((mouse.Hit.X - currentMouse.X)) / 2 - 1 do
						arr[-i]:Destroy()
						arr[-i] = nil
					end
				end
					xN = arr
					if #xP > 0 then
						for i, v in pairs(xP) do
							if v then
								v:Destroy()
							end
						end
						xP = {}
					end
					if #zP > 0 then
						for i, v in pairs(zP) do
							if v then
								v:Destroy()
							end
						end
						zP = {}
					end
					if #zN > 0 then
						for i, v in pairs(zN) do
							if v then
								v:Destroy()
							end
						end
						zN = {}
					end
				end
			else
				if mouse.Hit.Z - currentMouse.Z > 0 then
					arr = zP
					currentIndex = Vector3.new(0, 0, 1)
				
					for i = 1, (math.ceil(math.abs((mouse.Hit.Z - currentMouse.Z)) / 2)) do
						currentIndex = Vector3.new(0, 0, i)
						if not arr[i] then
							local clone = model:Clone()
							clone.Parent = plot.Parent.PlacedObjects
							arr[i] = clone
							CalcClone(true, clone, currentMouse, currentIndex, CalcualateNewPositionClone(currentMouse, Vector3.new(0, 0, i)))
						end
				--CalcualateNewPositionMod(currentMouse, Vector3.new(i, 0, 0))
				--CalcMod(currentRot, currentMouse, Vector3.new(0, 0, 0))
				--CalcualateNewPosition()
				--Calc(true)
					end
					if #arr > math.ceil(math.abs((mouse.Hit.Z - currentMouse.Z)) / 2) then
					for i = math.ceil(math.abs((mouse.Hit.Z - currentMouse.Z)) / 2) + 1, #arr do
						arr[i]:Destroy()
						arr[i] = nil
					end
				end
					zP = arr
					if #xN > 0 then
						for i, v in pairs(xN) do
							if v then
								v:Destroy()
							end
						end
						xN = {}
					end
					if #xP > 0 then
						for i, v in pairs(xP) do
							if v then
								v:Destroy()
							end
						end
						xP = {}
					end
					if #zN > 0 then
						for i, v in pairs(zN) do
							if v then
								v:Destroy()
							end				
						end
						zN = {}
					end
				else
					arr = zN
					currentIndex = Vector3.new(0, 0, -1)
					for i = 1, (math.ceil(math.abs((mouse.Hit.Z - currentMouse.Z)) / 2)) do
						currentIndex = Vector3.new(0, 0, -i)
						if not arr[i] then
							local clone = model:Clone()
							clone.Parent = plot.Parent.PlacedObjects
							arr[i] = clone
							CalcClone(true, clone, currentMouse, currentIndex, CalcualateNewPositionClone(currentMouse, Vector3.new(0, 0, -i)))
						end
				--CalcualateNewPositionMod(currentMouse, Vector3.new(i, 0, 0))
				--CalcMod(currentRot, currentMouse, Vector3.new(0, 0, 0))
				--CalcualateNewPosition()
				--Calc(true)
					end
				if #arr > math.ceil(math.abs((mouse.Hit.Z - currentMouse.Z)) / 2) then
					for i = -#arr, math.ceil((mouse.Hit.Z - currentMouse.Z)) / 2 - 1 do
						arr[-i]:Destroy()
						arr[-i] = nil
					end
				end
					zN = arr
					if #xN > 0 then
						for i, v in pairs(xN) do
							if v then
								v:Destroy()
							end
						end
						xN = {}
					end
					if #zP > 0 then
						for i, v in pairs(zP) do
							if v then
								v:Destroy()
							end
						end
						zP = {}
					end
					if #xP > 0 then
						for i, v in pairs(xP) do
							if v then
								v:Destroy()
							end
						end
						xP = {}
					end
				end
			end
		
			--for i = 0, (math.ceil(math.abs((mouse.Hit.X - currentMouse.X)) / 2) * currentIndex.X) do
				--currentIndex = Vector3.new(i, currentIndex.Y, currentIndex.Z)
			--	if not arr[i] then
			----		local clone = model:Clone()
				--	clone.Parent = plot.PlacedObjects
				--	arr[i] = clone
				--	CalcClone(true, clone, currentMouse, currentIndex, CalcualateNewPositionClone(currentMouse, Vector3.new(i, 0, 0)))
			--	end
				--CalcualateNewPositionMod(currentMouse, Vector3.new(i, 0, 0))
				--CalcMod(currentRot, currentMouse, Vector3.new(0, 0, 0))
				--CalcualateNewPosition()
				--Calc(true)
		--	end
			--for i = 0, (math.ceil(math.abs((mouse.Hit.X - currentMouse.X)) / 2) * currentIndex.X) do
			--	currentIndex = Vector3.new(i, currentIndex.Y, currentIndex.Z)
		--		if not xP[i] then
				--	local clone = model:Clone()
			--		clone.Parent = plot.PlacedObjects
			--		xP[i] = clone
			--		CalcClone(true, clone, currentMouse, currentIndex, CalcualateNewPositionClone(currentMouse, Vector3.new(i, 0, 0)))
			--	end
				--CalcualateNewPositionMod(currentMouse, Vector3.new(i, 0, 0))
				--CalcMod(currentRot, currentMouse, Vector3.new(0, 0, 0))
				--CalcualateNewPosition()
				--Calc(true)
--			end
		
			if DetectCollisions then
				CheckHitbox()
				EditColor()
			end
		else
			if placingMode and canPlace and model and dragging then
				CalcualateNewPosition()
				Calc(true)
		
				if DetectCollisions then
					CheckHitbox()
					EditColor()
				end
			end
		end
	end

local function EditFloor(g)
	if posY <= MaxHeight and posY >= startingY then
		if g == 2 then
			posY = posY + FloorStep
		else
			posY = posY - FloorStep
		end
	end
end

local function CheckRotation()
	if model then
		if currentRot then
			currentRot = false
		else 
			currentRot = true
		end
	end
end

local function RotateModel()
	if smartRot then
		if currentRot then
			rot = rot + RotationStep
		else
			rot = rot - RotationStep
		end
	else
		rot = rot + RotationStep
	end
	
	CheckRotation()
end

local function RemovePlacement(tf)
	placingMode = false
	canPlace = false
	canStart = true
	--if plot then
	if DisplayGrid then
		if plot then
			for i, v in pairs(plot:GetChildren()) do
				if v then
					if v:IsA("Texture") and v.Name == "GridTexture" then
						v:Destroy()
					end
				end
	--	end
		
				for i, v in pairs(plot.Parent.Floors:GetChildren()) do
					if v then
						if v:FindFirstChild("GridTexture") then
							v.GridTexture:Destroy()
						end
					end
				end
			end
		end
	end
	
	if plot then
		for i, v in pairs(plot.Parent.PlacedObjects:GetChildren()) do
			if v then
				if v:FindFirstChild("Shadow") then
					v:Destroy()
				end
			end
		end
	end
	
	stacking = false
	if model then
		if not BuildModeEnabled and tf then
			model:Destroy()
			model = nil
		else
			model:Destroy()
			model = nil
		end
	end
end

local function InputDetector(input, gpe)
	if placingMode and model then
		if input.KeyCode == KeyCodeCancel then
			RemovePlacement()
		elseif input.KeyCode == KeyCodeRaiseFloor then
			EditFloor(2)
		elseif input.KeyCode == KeyCodeLowerFloor then
			EditFloor(1)
		elseif input.KeyCode == KeyCodeCancel then
			RemovePlacement(false)
		elseif input.KeyCode == KeyCodeRotate then
			RotateModel()
		end
	end
end

local function DisplayGridOnCanvas()
	if DisplayGrid then
		if not plot:FindFirstChild("GridTexture") then
			local gridTex = Instance.new("Texture")
		
			gridTex.Name = "GridTexture"
			gridTex.Texture = GridTexture
			gridTex.Parent = plot
			gridTex.Face = Enum.NormalId.Top
			gridTex.StudsPerTileU = 2
			gridTex.StudsPerTileV = 2
		
			if SmartDisplay then
				gridTex.StudsPerTileU = grid
				gridTex.StudsPerTileV = grid	
			end
			for i, v in pairs(plot.Parent.Floors:GetChildren()) do
				local newGrid = Instance.new("Texture")
				newGrid.Name = "GridTexture"
				newGrid.Texture = GridTexture
				newGrid.Parent = v
				newGrid.Face = Enum.NormalId.Top
				newGrid.StudsPerTileU = 2
				newGrid.StudsPerTileV = 2
				newGrid.StudsPerTileU = grid
				newGrid.StudsPerTileV = grid	
			end
		end
	end
end

local function GetModel(loc, id, ignoreLocation)
	model = loc:FindFirstChild(id):Clone()
	
	startingY, posY = model.PrimaryPart.CFrame.Y, model.PrimaryPart.CFrame.Y
	model:SetPrimaryPartCFrame(CFrame.new(posX, lastY, posZ))
	origPosition = model.primary.Position
	
	model.Parent = ignoreLocation
	local var = Instance.new("StringValue")
	var.Name = "Shadow"
	var.Parent = model
	
	for i, m in pairs(model:GetDescendants()) do
		if m then
			if m:IsA("Part") or m:IsA("UnionOperation") or m:IsA("MeshPart") then
				m.CanCollide = false
				
				if TransparentModels then
					m.Transparency = m.Transparency + transparentDelta
				end
			end
		end
	end
	
	model.PrimaryPart.Transparency = hitboxTransparency
	
	if IgnoreItems and not stacking then
		mouse.TargetFilter = ignoreLocation
	else
		mouse.TargetFilter = model
	end
end

local function Setup(stk, location, id, loc, sr)
	placingMode = true
	canPlace = true
	canStart = false
	stacking = stk
	smartRot = sr
	
	if BuildModeEnabled then
		canStart = true
	end
	
	GetModel(loc, id, location)
	DisplayGridOnCanvas()
end

function PlacementModuleV2:Finish(e)
	if placingMode and model and not BuildModeEnabled then
		--wait(CollisionCheckCooldown)
		
		Calc(currentRot)
		CalcualateNewPosition()
		CalcFinalCFrame()
		CheckHitbox()
		
		if not colliding then
			e:FireServer(self:GetModelInfo(), model.Parent, cframe)
			
			RemovePlacement(false)
		else
			--print("i collided")
		end

		
	elseif BuildModeEnabled and canPlace and placingMode and not colliding and model then
		lastY = model.PrimaryPart.CFrame.Y
		
	--	wait(CollisionCheckCooldown)
		
		Calc(currentRot)
		CalcualateNewPosition()
		CalcFinalCFrame()
		CheckHitbox()
		
		if not colliding then
			
			e:FireServer(self:GetModelInfo(), model.Parent, cframe)
		end
	end
end




function PlacementModuleV2:Drag(e, orig, posOrig)--
	if placingMode and model and not BuildModeEnabled then--
		--wait(CollisionCheckCooldown)
		temp = model:Clone()
		
		if (math.abs(mouse.Hit.X - orig.X) > math.abs(mouse.Hit.Z - orig.Z)) then
			if mouse.Hit.X - orig.X > 0 then
				
				for i = 1, (math.ceil((mouse.Hit.X - orig.X) / (model.PrimaryPart.Size.X))) do
					--print(i)
					model = temp:Clone()
					increment = Vector3.new(i, 0, 0)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			else
				--print('else')
				for i = (math.ceil((mouse.Hit.X - orig.X) / (model.PrimaryPart.Size.X))), -1 do
					--print(i)
					model = temp:Clone()
					increment = Vector3.new(i, 0, 0)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			end
		else
			if mouse.Hit.Z - orig.Z > 0 then
				for i = 1, (math.ceil(mouse.Hit.Z - orig.Z) / (model.PrimaryPart.Size.Z)) do
					--print(i)
					model = temp:Clone()
					increment = Vector3.new(0, 0, i)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
			--		model.primary.Position = Vector3.new(posX, posY, posZ)
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			else
				for i = (math.ceil(mouse.Hit.Z - orig.Z) / (model.PrimaryPart.Size.Z)), -1 do
					--print('else')
					model = temp:Clone()
					increment = Vector3.new(0, 0, i)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
			--		model.primary.Position = Vector3.new(posX, posY, posZ)
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			end
		end
	elseif BuildModeEnabled and canPlace and placingMode and not colliding and model then
		lastY = model.PrimaryPart.CFrame.Y
		temp = model:Clone()
		
		if (math.abs(mouse.Hit.X - orig.X) > math.abs(mouse.Hit.Z - orig.Z)) then
			if mouse.Hit.X - orig.X > 0 then
				
				for i = 1, (math.ceil((mouse.Hit.X - orig.X) / (model.PrimaryPart.Size.X))) do
					--print(i)
					model = temp:Clone()
					increment = Vector3.new(i, 0, 0)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			else
				--print('else')
				for i = (math.ceil((mouse.Hit.X - orig.X) / (model.PrimaryPart.Size.X))), -1 do
					--print(i)
					model = temp:Clone()
					increment = Vector3.new(i, 0, 0)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			end
		else
			if mouse.Hit.Z - orig.Z > 0 then
				for i = 1, (math.ceil(mouse.Hit.Z - orig.Z) / (model.PrimaryPart.Size.Z)) do
					--print(i)
					model = temp:Clone()
					increment = Vector3.new(0, 0, i)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
			--		model.primary.Position = Vector3.new(posX, posY, posZ)
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			else
				for i = (math.ceil(mouse.Hit.Z - orig.Z) / (model.PrimaryPart.Size.Z)), -1 do
					--print('else')
					model = temp:Clone()
					increment = Vector3.new(0, 0, i)
					CalcMod(currentRot, orig, increment)
					CalcualateNewPositionMod(orig, increment)
					CalcFinalCFrame()
					model.Parent = workspace
					info = self:GetModelInfo()
					model:SetPrimaryPartCFrame(CFrame.new(cframe.X, cframe.Y, cframe.Z) * CFrame.Angles(0, math.rad(info.CFrame.Rotation), 0))	
			--		model.primary.Position = Vector3.new(posX, posY, posZ)
					CheckHitbox()
					model:Destroy()
					model = nil
					if not colliding then
						--print(cframe)
						e:FireServer(info, plot.Parent.PlacedObjects, cframe)
					end
				end
			end
		end	
	end
	RemovePlacement()
	if temp then
		temp:Destroy()
		temp = nil
	end
	dragging = false
	currentMouse = nil
end


function PlacementModuleV2:CancelPlacementManual()
	RemovePlacement(false)
end

function PlacementModuleV2:GetModelInfo()
	if model then
		modelInfo = {
			["Name"] = model.Name;
			["CollisionState"] = colliding;
			
			
			["CFrame"] = {
				["X"] = model.PrimaryPart.CFrame.X,
				["Y"] =  model.PrimaryPart.CFrame.Y,
				["Z"] =  model.PrimaryPart.CFrame.Z,
				["Rotation"] = model.PrimaryPart.Orientation.Y
			}
		}
		
		return modelInfo
	end
end

function PlacementModuleV2:GetCurrentState()
	local state
	
	if placingMode and not colliding then
		state = "Movement"
	elseif placing and not colliding then
		state = "Placing"
	elseif colliding then
		state = "Collision"
	elseif canStart and not placingMode then
		state = "Waiting"
	else
		state = nil
	end
	
	return state
end

function PlacementModuleV2:ResumeState(msg)
	if self:GetCurrentState() == "Movement" then
		placingMode = true
		canPlace = true
		
		return msg
	elseif self:GetCurrentState() == "Placing" then
		return "Not developed yet"
	elseif self:GetCurrentState() == "Collision" then
		colliding = nil
		placingMode = true
		canPlace = true
		
		return msg
	elseif self:GetCurrentState() == "Waiting" then
		return "Not developed yet"
	end
end

function PlacementModuleV2:PauseState(msg)
	if self:GetCurrentState() == "Movement" then
		placingMode = nil
		canPlace = nil
		
		return msg
	elseif self:GetCurrentState() == "Placing" then
		return "Not developed yet"
	elseif self:GetCurrentState() == "Collision" then
		placingMode = nil
		canPlace = nil
		colliding = true
		
		return msg
	elseif self:GetCurrentState() == "Waiting" then
		return "Not developed yet"
	end
end

function PlacementModuleV2:new(id, location, plt, loc, stack, smtr, drag)
	if canStart and not placingMode and not BuildModeEnabled then
		dragging = drag
		plot = plt
		
		Setup(stack, loc, id, location, smtr)
	elseif BuildModeEnabled then
		plot = plt
		
		if model then
			model:Destroy()
		end
		dragging = drag
		
		Setup(stack, loc, id, location, smtr)
	else
		return self:GetCurrentState()
	end
end

function PlacementModuleV2:updateData(mouseStart)
	if canStart and not placingMode and not BuildModeEnabled then
		currentMouse = mouseStart
	elseif BuildModeEnabled then
		currentMouse = mouseStart
	else
		return self:GetCurrentState()
	end
end

humanoid.Died:Connect(function()
	RemovePlacement(false)
end)
runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, ModifyCoordinates)
runService:BindToRenderStep("Input", Enum.RenderPriority.Input.Value, ModifyCoordinatesDragging)

userInputService.InputBegan:Connect(InputDetector)


return PlacementModuleV2
repeat wait() until script.Parent.Parent.Parent ~= game.ReplicatedStorage


-- Variables
local plot = script.Parent.Parent.Parent.Plot
local primary = script.Parent.Hitbox
local floorLeft = Instance.new("Part")
local floorRight = Instance.new("Part")
local floorFront = Instance.new("Part")
local floorBack = Instance.new("Part")

-- property options
local mat = Enum.Material.Slate
local color = Color3.new(163/255, 162/255, 165/255)
local floorHeight = 15
local stairSize = 2

--script.Parent.Hitbox.Position = Vector3.new(script.Parent.Hitbox.Position.X, script.Parent.Hitbox.Position.Y - floorHeight, script.Parent.Hitbox.Position.Z)

-- Properties
floorLeft.Parent = plot.Parent.Floors
floorRight.Parent = plot.Parent.Floors
floorFront.Parent = plot.Parent.Floors
floorBack.Parent = plot.Parent.Floors

floorLeft.Anchored = true
floorRight.Anchored = true
floorFront.Anchored = true
floorBack.Anchored = true

floorLeft.CastShadow = false
floorRight.CastShadow = false
floorFront.CastShadow = false
floorBack.CastShadow = false

floorLeft.Material = mat
floorRight.Material = mat
floorFront.Material = mat
floorBack.Material = mat

floorLeft.Color = color
floorRight.Color = color
floorFront.Color = color
floorBack.Color = color

-- Positioning and resizing
if(primary.Orientation.Y ~= 90 and primary.Orientation.Y ~= -90) then

floorLeft.Position = Vector3.new(primary.Position.X, plot.Position.Y + floorHeight, primary.Position.Z + 0.5 * primary.Size.Z + 0.5 * floorLeft.Size.Z)
	floorRight.Position = Vector3.new(primary.Position.X, plot.Position.Y + floorHeight, primary.Position.Z - 0.5 * primary.Size.Z - 0.5 * floorRight.Size.Z)
	floorFront.Position = Vector3.new(primary.Position.X + 0.5 * primary.Size.X + 0.5 * floorFront.Size.X, plot.Position.Y + floorHeight, primary.Position.Z)
	floorBack.Position = Vector3.new(primary.Position.X - 0.5 * primary.Size.X - 0.5 * floorBack.Size.X, plot.Position.Y + floorHeight, primary.Position.Z)

	floorLeft.Size = Vector3.new(plot.Size.X, 1, plot.Position.Z + 0.5 * plot.Size.Z - (floorLeft.Position.Z - 0.5 * floorLeft.Size.Z))

	--floorLeft:Resize(Enum.NormalId.Left, floorLeft.Position.X - 0.5 * floorLeft.Size.X - (plot.Position.X - 0.5 * plot.Size.X))
--	floorLeft:Resize(Enum.NormalId.Right, plot.Position.X + 0.5 * plot.Size.X - (floorLeft.Position.X + 0.5 * floorLeft.Size.X))
--	floorLeft:Resize(Enum.NormalId.Back, plot.Position.Z + 0.5 * plot.Size.Z - (floorLeft.Position.Z + 0.5 * floorLeft.Size.Z))
--  floorLeft.Size = Vector3.new(floorLeft.Size.X, 1, floorLeft.Size.Z)
	
	floorRight.Size = Vector3.new(plot.Size.X, 1, floorRight.Position.Z + 0.5 * floorRight.Size.Z - (plot.Position.Z - 0.5 * plot.Size.Z))
	
	--floorRight:Resize(Enum.NormalId.Left, floorRight.Position.X - 0.5 * floorRight.Size.X - (plot.Position.X - 0.5 * plot.Size.X))
	--floorRight:Resize(Enum.NormalId.Right, plot.Position.X + 0.5 * plot.Size.X - (floorRight.Position.X + 0.5 * floorRight.Size.X))
	--floorRight:Resize(Enum.NormalId.Front, floorRight.Position.Z - 0.5 * floorRight.Size.Z - (plot.Position.Z - 0.5 * plot.Size.Z))
	--floorRight.Size = Vector3.new(floorRight.Size.X, 1, floorRight.Size.Z)

	--floorBack:Resize(Enum.NormalId.Left, floorBack.Position.X - 0.5 * floorBack.Size.X - (plot.Position.X - 0.5 * plot.Size.X))
	floorBack.Size = Vector3.new(floorBack.Position.X + 0.5 * floorBack.Size.X - (plot.Position.X - 0.5 * plot.Size.X), 1, floorBack.Size.Z + stairSize)
	
	--floorFront:Resize(Enum.NormalId.Right, plot.Position.X + 0.5 * plot.Size.X - (floorFront.Position.X + 0.5 * floorFront.Size.X))
	floorFront.Size = Vector3.new(plot.Position.X + 0.5 * plot.Size.X - (floorFront.Position.X - 0.5 * floorFront.Size.X), 1, floorFront.Size.Z + stairSize)
	
	
	floorLeft.Position = Vector3.new(plot.Position.X, plot.Position.Y + floorHeight, primary.Position.Z + 0.5 * primary.Size.Z + 0.5 * floorLeft.Size.Z)
	floorRight.Position = Vector3.new(plot.Position.X, plot.Position.Y + floorHeight, primary.Position.Z - 0.5 * primary.Size.Z - 0.5 * floorRight.Size.Z)
	floorFront.Position = Vector3.new(primary.Position.X + 0.5 * primary.Size.X + 0.5 * floorFront.Size.X, plot.Position.Y + floorHeight, primary.Position.Z)
	floorBack.Position = Vector3.new(primary.Position.X - 0.5 * primary.Size.X - 0.5 * floorBack.Size.X, plot.Position.Y + floorHeight, primary.Position.Z)
else
	floorLeft.Position = Vector3.new(primary.Position.X, plot.Position.Y + floorHeight, primary.Position.Z + 0.5 * primary.Size.X + 0.5 * floorLeft.Size.Z)
	floorRight.Position = Vector3.new(primary.Position.X, plot.Position.Y + floorHeight, primary.Position.Z - 0.5 * primary.Size.X - 0.5 * floorRight.Size.Z)
	floorFront.Position = Vector3.new(primary.Position.X + 0.5 * primary.Size.Z + 0.5 * floorFront.Size.X, plot.Position.Y + floorHeight, primary.Position.Z)
	floorBack.Position = Vector3.new(primary.Position.X - 0.5 * primary.Size.Z - 0.5 * floorBack.Size.X, plot.Position.Y + floorHeight, primary.Position.Z)

--

	floorFront.Size = Vector3.new(plot.Position.X + 0.5 * plot.Size.X - (floorFront.Position.X - 0.5 * floorFront.Size.X), 1, plot.Size.Z)
	--floorFront:Resize(Enum.NormalId.Right, plot.Position.X + 0.5 * plot.Size.Z - (floorFront.Position.X + 0.5 * floorFront.Size.X))
	--floorFront:Resize(Enum.NormalId.Back, plot.Position.Z + 0.5 * plot.Size.X - (floorFront.Position.Z + 0.5 * floorFront.Size.Z))
	--floorFront:Resize(Enum.NormalId.Front, floorFront.Position.Z - 0.5 * floorFront.Size.Z - (plot.Position.Z - 0.5 * plot.Size.X))
	--floorFront.Size = Vector3.new(floorFront.Size.X, 1, floorFront.Size.Z)
	
	
	floorBack.Size = Vector3.new(floorBack.Position.X + 0.5 * floorBack.Size.X - (plot.Position.X - 0.5 * plot.Size.X), 1, plot.Size.Z)
	--floorBack:Resize(Enum.NormalId.Left, floorBack.Position.X - 0.5 * floorBack.Size.X - (plot.Position.X - 0.5 * plot.Size.X))
	--floorBack:Resize(Enum.NormalId.Back, plot.Position.Z + 0.5 * plot.Size.X - (floorBack.Position.Z + 0.5 * floorBack.Size.Z))
	--floorBack:Resize(Enum.NormalId.Front, floorBack.Position.Z - 0.5 * floorBack.Size.Z - (plot.Position.Z - 0.5 * plot.Size.X))
	--floorBack.Size = Vector3.new(floorBack.Size.X, 1, floorBack.Size.Z)

	--floorLeft:Resize(Enum.NormalId.Back, plot.Position.Z + 0.5 * plot.Size.X - (floorLeft.Position.Z + 0.5 * floorLeft.Size.Z))

	
	--floorRight:Resize(Enum.NormalId.Front, floorRight.Position.Z - 0.5 * floorRight.Size.Z - (plot.Position.Z - 0.5 * plot.Size.X))

	
	floorLeft.Size = Vector3.new(2 + stairSize, 1, plot.Position.Z + 0.5 * plot.Size.X - (floorLeft.Position.Z - 0.5 * floorLeft.Size.Z))
	floorRight.Size = Vector3.new(2 + stairSize, 1, floorRight.Position.Z + 0.5 * floorRight.Size.Z - (plot.Position.Z - 0.5 * plot.Size.X))
	
	floorLeft.Position = Vector3.new(primary.Position.X, plot.Position.Y + floorHeight, primary.Position.Z + 0.5 * primary.Size.X + 0.5 * floorLeft.Size.Z)
	floorRight.Position = Vector3.new(primary.Position.X, plot.Position.Y + floorHeight, primary.Position.Z - 0.5 * primary.Size.X - 0.5 * floorRight.Size.Z)
	floorFront.Position = Vector3.new(primary.Position.X + 0.5 * primary.Size.Z + 0.5 * floorFront.Size.X, plot.Position.Y + floorHeight, plot.Position.Z)
	floorBack.Position = Vector3.new(primary.Position.X - 0.5 * primary.Size.Z - 0.5 * floorBack.Size.X, plot.Position.Y + floorHeight, plot.Position.Z)


end


--repeat wait() until script.Parent.Parent == "PlacedObjects"


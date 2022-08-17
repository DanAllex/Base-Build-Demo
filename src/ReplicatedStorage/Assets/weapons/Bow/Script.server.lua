local RemoteEvent = script.Parent:WaitForChild("REClick")
local tool = script.Parent
local audShoot = tool:WaitForChild("Handle"):WaitForChild("audShoot")
local audPass = tool:WaitForChild("Handle"):WaitForChild("audPass")
local audHit = tool:WaitForChild("Handle"):WaitForChild("audHit")
local BASEDAMAGE = 50
local BASEDISTANCE = 80
local BASEMINEDAMAGE = 20
local MATERIAL = "SmoothPlastic"
local COLOR = "Pearl"

local function Shoot(player, held, hit)
	audShoot:Play()
	if held >= .7 then
		held = .7
	end
	local damage = math.floor(BASEDAMAGE * held)
	local minedamage = math.floor(BASEMINEDAMAGE * held)
	local maxdistance = math.floor(BASEDISTANCE * held)
	print(damage, maxdistance)
	script.Parent.Arrow.Transparency = 1
	local ray = Ray.new(tool.shoot.CFrame.p, (hit.p - tool.shoot.CFrame.p).unit * 300)
		local part, position = workspace:FindPartOnRay(ray, player.Character, false, true)
 
		local beam = Instance.new("Part", workspace)
		local audPassClone = audPass:Clone()
		audPassClone.Parent = beam
		audPassClone:Play()
		beam.BrickColor = BrickColor.new("Pearl")
		beam.FormFactor = "Custom"
		beam.Material = "SmoothPlastic"
		beam.Anchored = true
		beam.Locked = true
		beam.CanCollide = false
		local distance = (tool.shoot.CFrame.p - position).magnitude
		if (tool.shoot.CFrame.p - position).magnitude > maxdistance then
			distance = maxdistance
		end
		beam.Size = Vector3.new(0.1, 0.1, distance)
		beam.CFrame = CFrame.new(tool.shoot.CFrame.p, position) * CFrame.new(0, 0, -distance / 2)
 
		game:GetService("Debris"):AddItem(beam, 0.1)
 
		if part then
			if distance >= (tool.shoot.CFrame.p - position).magnitude then
			print((position - tool.shoot.CFrame.p).magnitude)
			local humanoid = part.Parent:FindFirstChild("Humanoid")
 			local hitpoints = part:FindFirstChild("intHitpoints")
			if not humanoid then
				humanoid = part.Parent.Parent:FindFirstChild("Humanoid")
			end
 
			if part.Name == "Head" and humanoid then
				local audHitClone = audHit:Clone()
				audHitClone.Parent = humanoid.Parent
				audHitClone:Play()
				humanoid:TakeDamage(math.floor(damage * 1.5))
				wait(1)
				audHitClone:Destroy()
			elseif humanoid then
				local audHitClone = audHit:Clone()
				audHitClone.Parent = humanoid.Parent
				audHitClone:Play()
				humanoid:TakeDamage(damage)
				wait(1)
				audHitClone:Destroy()
			elseif hitpoints then
				local audHitClone = audHit:Clone()
				audHitClone.Parent = hitpoints.Parent
				audHitClone:Play()
				hitpoints.Value = hitpoints.Value - minedamage
				wait(1)
				audHitClone:Destroy()
			end
			end
		end
			wait(1)
		script.Parent.Arrow.Transparency = 0
 end
RemoteEvent.OnServerEvent:Connect(Shoot)
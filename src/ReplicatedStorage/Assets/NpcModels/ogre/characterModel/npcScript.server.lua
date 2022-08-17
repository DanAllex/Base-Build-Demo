local PathfindingService = game:GetService("PathfindingService")

-- References
local Status = script.Parent.Parent.Parent.Status
local Destination = script.Parent.Destination
local Humanoid = script.Parent.Humanoid
local Torso = script.Parent.UpperTorso
local HumanoidRootPart = script.Parent.HumanoidRootPart
local swordAnimation = Humanoid:LoadAnimation(script.Parent.Sword.Slash)
local collision = false
local playerName = script.Parent.Parent.Parent.Parent.Name
playerName = string.sub(playerName, 1, string.len(playerName) - 4)


-- Constants and stuff
local distanceThreshold = 10
local damage = 10

-- Functions and Stuff
local path = PathfindingService:CreatePath()
local waypoints
local currentWaypointIndex = 0
local blockedConnection
local called = 0 -- Used to keep track of what path the character is traveling on
local retry = 0 -- Used to check if we need to retry making a path

local cooldown = false
local attackCooldownTime = 1

local previousDestination

-- Functions

function moveCharacterToWaypoint(waypoint)
	if waypoint.Action == Enum.PathWaypointAction.Jump then
		Humanoid.Jump = true
	end
	Humanoid:MoveTo(waypoint.Position)
	Humanoid.MoveToFinished:Wait(1)
end

-- Sets a new path whenever the destination changes
-- If the destination is close enough, then we just move to it
-- Else we create a path
function setNewPath()
	local destination = Destination.Value
	 -- Tells program the the previous path is outdated
	while cooldown do
		wait(0.5)
	end
	
	if canDirectlyWalk() then
		Humanoid:MoveTo(destination)
		called += 1
	else
		-- Only recompute path if we are far enough away
		if previousDestination ~= nil and (destination - previousDestination).Magnitude < 1 and retry == 0 then
			return
		else
			previousDestination = Destination.Value
			called += 1
		end
		-- Try to compute a path
		path:ComputeAsync(HumanoidRootPart.Position, destination)
		waypoints = {}
		
		if path.Status == Enum.PathStatus.Success then
			retry = 0 -- On success, make sure we reset retry so we can retry again when we might need tp
			-- Start moving along the waypoints towards the goal
			waypoints = path:GetWaypoints()			
			currentWaypointIndex = 1
			moveCharacterToWaypoint(waypoints[currentWaypointIndex]) -- move to the first waypoint in our path
		else
			-- If we fail to make a path, we should just
			if retry >= 3 then
				retry = 0
				-- On fail, we should probably teleport
				
				-- Return so that we don't try moving to the next waypoint
				return
			else
				-- If we haven't retried enough, retry 
				retry += 1
				wait(1)
				setNewPath()
			end
		end
		
		-- Move to next waypoint
		moveToNextWaypoint(destination, called)		
	end
end

function moveToNextWaypoint(target, call)
	if call ~= called then
		return
	elseif currentWaypointIndex < #waypoints then
		currentWaypointIndex = currentWaypointIndex + 1
		moveCharacterToWaypoint(waypoints[currentWaypointIndex])
		moveToNextWaypoint(target, call)
	end
end

function canDirectlyWalk()
	local ray = Ray.new(HumanoidRootPart.Position, Destination.Value - HumanoidRootPart.Position)
	local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {script.Parent})
	if (Destination.Value - position).Magnitude < 5 then
		return true
	end
	return false
end

function onCharacterDeath()
	wait(5)
	script.Parent:Destroy()
end

function attack(target)
	Humanoid:MoveTo(target.HumanoidRootPart.Position)
	swordAnimation:Play()
	target.Humanoid.Health = math.max(0, target.Humanoid.Health - damage) --  move to sword eventually
end


-- Event Listeners
Destination.Changed:Connect(setNewPath)
Humanoid.Died:Connect(onCharacterDeath)

script.Parent.HumanoidRootPart.Touched:Connect(function(target)
	if cooldown then
		return
	end
	cooldown = true
	if target.Parent and target.Parent:FindFirstChildWhichIsA("Humanoid") and target.Parent.Parent.Parent.Parent ~= Humanoid.Parent.Parent.Parent.Parent and target.Parent.Name ~= playerName then
		attack(target.Parent)
	end
	wait(attackCooldownTime)
	cooldown = false
end)
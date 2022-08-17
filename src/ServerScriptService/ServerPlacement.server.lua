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
		if not checkHitbox(plr.Character, item) and game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value >= item.Data.Price.Value then
			ChangeTransparency(item, 0)
			
			item.PrimaryPart.Transparency = 1
			game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value = game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value - item.Data.Price.Value
			
			return true
		else
			item:Destroy()
			
			return false
		end
	else
		
		if game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value >= item.Data.Price.Value then
			ChangeTransparency(item, 0)
			
			item.PrimaryPart.Transparency = 1
			game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value = game.ReplicatedStorage.StatFile[plr.Name].Stats.Gold.Value - item.Data.Price.Value
			return true
		else
			item:Destroy()
			return false
		end
	end
end

game.ReplicatedStorage.Events.PlaceObj.OnServerInvoke = place

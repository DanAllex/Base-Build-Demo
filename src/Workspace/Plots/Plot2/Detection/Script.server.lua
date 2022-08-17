local raiding = false
local activeDeciding = {}
local sendMsg = game.ReplicatedStorage.Events.sendMsg
local answerServer = game.ReplicatedStorage.Events.answerServer
local base = script.Parent.Parent
local Id = game.ReplicatedStorage.ServerStats.msgId
local initiated = {
	[1] = false,
	[2] = false,
	[3] = false,
	[4] = false
}
local StartRaid = game.ReplicatedStorage.Events.StartRaid
local outgoingIds = {}

local function sendNotif(h)
	if raiding == false then
		local failed = false
		for i,v in pairs(activeDeciding) do
			if i == h.Name then
				if tick() - v < 5 then
					failed = true
				end
			end
		end
		if not failed then
			activeDeciding[h.Name] = tick()
			Id.Value = Id.Value + 1
			local IdValues = {
				["Player"] = h.Name,
				["Opponent"] = base
			}
			outgoingIds[Id.Value] = IdValues
			sendMsg:FireClient(game.Players[h.Name], "Raid", "Raid ".. base.Data.Owner.Value .. "'s base?", "Yes", "No", "", 5, Id.Value)
		end
	end
end

local function findChar(h, wallId)
	if initiated[wallId] == false and base.Data.Owner.Value ~= "" then
		initiated[wallId] = true
		local char
		if h.Parent:FindFirstChild("Humanoid") then
			char = h.Parent
		elseif h.Parent.Parent:FindFirstChild("Humanoid") then
			char = h.Parent.Parent
		end
		if char ~= nil then
			if game.Players:FindFirstChild(char.Name) then
				initiated[wallId] = false
				return char
			end
		end
		initiated[wallId] = false
		return nil
	end
end

local function receiveAnswer(plr, ans, Id)
	print("we receiving an answer")
	if outgoingIds[Id] then
		if outgoingIds[Id]["Player"] == plr.Name then
			if ans == "Yes" then
				print("we read the answer")
				StartRaid:Fire(plr, outgoingIds[Id]["Opponent"])
				outgoingIds[Id] = nil
			end
			for i,v in pairs(activeDeciding) do
				if i == plr.Name then
					activeDeciding[i] = nil
					print(activeDeciding)
					break
				end
			end
		end
	end
end

answerServer.OnServerEvent:Connect(receiveAnswer)

script.Parent.Wall1.Touched:Connect(function(h)
	local char = findChar(h, 1)
	if char then
		sendNotif(char)
	end
end)

script.Parent.Wall2.Touched:Connect(function(h)
	local char = findChar(h, 2)
	if char then
		sendNotif(char)
	end
end)

script.Parent.Wall3.Touched:Connect(function(h)
	local char = findChar(h, 3)
	if char then
		sendNotif(char)
	end
end)

script.Parent.Wall4.Touched:Connect(function(h)
	local char = findChar(h, 4)
	if char then
		sendNotif(char)
	end
end)

local RS = game:GetService("ReplicatedStorage")
local SG = game:GetService("StarterGui")
local Notif = RS.Events.sendMsg
local answerServer = RS.Events.answerServer

Notif.OnClientEvent:Connect(function(Header, Caption, B1, B2, IconLink, Seconds, Id)
	print(Id)
	
	local retrieveAnswer = Instance.new("BindableFunction")
	retrieveAnswer.OnInvoke = function(text)
		if Id ~= nil then
			print("firing the server")
			answerServer:FireServer(text, Id)
		end
	end
	
	if Header and Caption then
		SG:SetCore("SendNotification", {
			Title = Header;
			Text = Caption;
			Callback = retrieveAnswer;
			Button1 = B1;
			Button2 = B2;
			Icon = IconLink;
			Duration = Seconds
		})
	end
end)
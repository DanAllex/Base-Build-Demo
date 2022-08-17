local Player = game.Players.LocalPlayer
repeat wait() until Player.Character
local Audio = script.Parent.Parent.Parent:WaitForChild("audSwitch")
local Equipped = false
local lastInput = nil
local Char = Player.Character
local Humanoid = Char:WaitForChild("Humanoid")
local img1 = script.Parent:WaitForChild("frmGrid"):WaitForChild("img1")
local btn1 = img1:WaitForChild("btn1")
local img2 = script.Parent:WaitForChild("frmGrid"):WaitForChild("img2")
local btn2 = img2:WaitForChild("btn1")
local img3 = script.Parent:WaitForChild("frmGrid"):WaitForChild("img3")
local btn3 = img3:WaitForChild("btn1")
local UIS = game:GetService("UserInputService")


UIS.InputBegan:connect(function(input)
	if not UIS:GetFocusedTextBox() then
	if input.KeyCode == Enum.KeyCode.One then
		Audio:Play()
		if Equipped == false then
			Equipped = true
			lastInput = "One"
			Humanoid:EquipTool(Player.Backpack:WaitForChild("Sword"))
			img1.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
		
		else
			if lastInput == "One" then
			lastInput = nil
			Equipped = false
			Humanoid:UnequipTools()
			
			img1.ImageColor3 = Color3.new(1, 1, 1)
			else
			
			lastInput = "One"
			Equipped = true
			Humanoid:UnequipTools()
			Humanoid:EquipTool(Player.Backpack:WaitForChild("Sword"))
			
		img1.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
			end
		end
	end
	
	
	
	if input.KeyCode == Enum.KeyCode.Two then
		Audio:Play()
		if Equipped == false then
			Equipped = true
			lastInput = "Two"
			Humanoid:EquipTool(Player.Backpack:WaitForChild("PickAxe"))
		img2.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img1.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
		
		else
			if lastInput == "Two" then
			lastInput = nil
			Equipped = false
			Humanoid:UnequipTools()
		
			img2.ImageColor3 = Color3.new(1, 1, 1)
			
			else
			lastInput = "Two"
			Equipped = true
			Humanoid:UnequipTools()
			Humanoid:EquipTool(Player.Backpack:WaitForChild("PickAxe"))
			img2.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img1.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
			end
		end	
	end
	
	
	
	
	if input.KeyCode == Enum.KeyCode.Three then
		Audio:Play()
		if Equipped == false then
			Equipped = true
			lastInput = "Three"
		Humanoid:EquipTool(Player.Backpack:WaitForChild("Bow"))
		
img3.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			img1.ImageColor3 = Color3.new(1, 1, 1)
		
		else
			if lastInput == "Three" then
			lastInput = nil
			Equipped = false
			Humanoid:UnequipTools()
			img3.ImageColor3 = Color3.new(1, 1, 1)
			else
			lastInput = "Three"
			Equipped = true
			Humanoid:UnequipTools()
			Humanoid:EquipTool(Player.Backpack:WaitForChild("Bow"))
		img3.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			img1.ImageColor3 = Color3.new(1, 1, 1)
		end
		end	
	end
	end
end)


btn1.MouseButton1Click:connect(function()
Audio:Play()
		if Equipped == false then
			Equipped = true
			lastInput = "One"
			Humanoid:EquipTool(Player.Backpack:WaitForChild("Sword"))
			img1.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
		
		else
			if lastInput == "One" then
			lastInput = nil
			Equipped = false
			Humanoid:UnequipTools()
			
			img1.ImageColor3 = Color3.new(1, 1, 1)
			else
			
			lastInput = "One"
			Equipped = true
			Humanoid:UnequipTools()
			Humanoid:EquipTool(Player.Backpack:WaitForChild("Sword"))
			
			img1.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
			end
			end
end)

btn2.MouseButton1Click:connect(function()
Audio:Play()
		if Equipped == false then
			Equipped = true
			lastInput = "Two"
			Humanoid:EquipTool(Player.Backpack:WaitForChild("PickAxe"))
		img2.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img1.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
		else
			if lastInput == "Two" then
			lastInput = nil
			Equipped = false
			Humanoid:UnequipTools()
			
		
			img2.ImageColor3 = Color3.new(1, 1, 1)

			
			else
			lastInput = "Two"
			Equipped = true
			Humanoid:UnequipTools()
			Humanoid:EquipTool(Player.Backpack:WaitForChild("PickAxe"))
			img2.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img1.ImageColor3 = Color3.new(1, 1, 1)

			img3.ImageColor3 = Color3.new(1, 1, 1)
			end
		end	
end)

btn3.MouseButton1Click:connect(function()
		Audio:Play()
		if Equipped == false then
			Equipped = true
			lastInput = "Three"
		Humanoid:EquipTool(Player.Backpack:WaitForChild("Bow"))
		
	img3.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img1.ImageColor3 = Color3.new(1, 1, 1)

			img2.ImageColor3 = Color3.new(1, 1, 1)
		
		else
			if lastInput == "Three" then
			lastInput = nil
			Equipped = false
			Humanoid:UnequipTools()		
			img3.ImageColor3 = Color3.new(1, 1, 1)

			else
			lastInput = "Three"
			Equipped = true
			Humanoid:UnequipTools()
			Humanoid:EquipTool(Player.Backpack:WaitForChild("Bow"))
img3.ImageColor3 = Color3.new(170/255, 170/255, 170/255)
		
			img1.ImageColor3 = Color3.new(1, 1, 1)

			img2.ImageColor3 = Color3.new(1, 1, 1)
		end
		end	
end)
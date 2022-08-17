local currentSelected = script.Parent.Parent.Parent.Parent.Parent.Placing


local buttonColor = {
	["Grey"] = Color3.new(189/255, 189/255, 189/255),
	["GreyShadow"] = Color3.new(157/255, 157/255, 157/255),
	["White"] = Color3.new(1, 1, 1),
	["WhiteShadow"] = Color3.new(190/255, 190/255, 190/255)
}

local function hoverButton(btn)
	if btn.ViewportFrame.obj.Value.Name ~= currentSelected.Value then
		btn.ImageColor3 = buttonColor.Grey
		btn.imgShadow.ImageColor3 = buttonColor.GreyShadow
	end
end

local function unhoverButton(btn)
	if btn.ViewportFrame.obj.Value.Name ~= currentSelected.Value then
		btn.ImageColor3 = buttonColor.White
		btn.imgShadow.ImageColor3 = buttonColor.WhiteShadow
	end
end

script.Parent.MouseButton1Click:Connect(function()
	if script.Parent.Parent.Parent.Parent.Parent.Placing.Value == script.Parent.Parent.ViewportFrame.obj.Value.Name then
		script.Parent.Parent.Parent.Parent.Parent.Placing.Value = ""
		print("set it to nil")
	else
		script.Parent.Parent.Parent.Parent.Parent.Placing.Value = script.Parent.Parent.ViewportFrame.obj.Value.Name
		print(script.Parent.Parent.Parent.Parent.Parent.Placing.Value == script.Parent.Parent.ViewportFrame.obj.Value.Name)
	end
end)

script.Parent.MouseEnter:Connect(function()
	hoverButton(script.Parent.Parent)
end)

script.Parent.MouseLeave:Connect(function()
	unhoverButton(script.Parent.Parent)
end)
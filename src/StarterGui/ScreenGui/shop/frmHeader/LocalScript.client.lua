local currentSelected = script.Parent.Selected
local Selection = script.Parent.Selection
local frmSelection = script.Parent.Parent.frmSelection

local buttonColor = {
	["Selected"] = Color3.new(30/255, 136/255, 229/255),
	["Hovered"] = Color3.new(66/255, 165/255, 245/255),
	["Unselected"] = Color3.new(100/255, 181/255, 246/255)
}

Selection.Decor.MouseButton1Click:Connect(function()
	currentSelected.Value = Selection.Decor.Name
end)

Selection.Generators.MouseButton1Click:Connect(function()
	currentSelected.Value = Selection.Generators.Name
end)

Selection.Traps.MouseButton1Click:Connect(function()
	currentSelected.Value = Selection.Traps.Name
end)

Selection.Structure.MouseButton1Click:Connect(function()
	currentSelected.Value = Selection.Structure.Name
end)

local function selectButton(btn)
	btn.Round.ImageColor3 = buttonColor.Selected
	btn.imgShadow.ImageTransparency = 0
	
	for i,v in pairs(Selection:GetChildren()) do
		if v.Name ~= btn.Name then
			v.Round.ImageColor3 = buttonColor.Unselected
			v.imgShadow.ImageTransparency = 1
		end
	end
	
	for i,v in pairs(frmSelection:GetChildren()) do
		if v.Name ~= btn.Name then
			v.Visible = false
		end
	end
	
	frmSelection[btn.Name].Visible = true
end

local function hoverButton(btn)
	if btn.Name ~= currentSelected.Value then
		btn.Round.ImageColor3 = buttonColor.Hovered
	end
end

local function unhoverButton(btn)
	if btn.Name ~= currentSelected.Value then
		btn.Round.ImageColor3 = buttonColor.Unselected
	end
end

currentSelected.Changed:Connect(function()
	selectButton(Selection[currentSelected.Value])
end)

Selection.Decor.MouseEnter:Connect(function()
	hoverButton(Selection.Decor)
end)

Selection.Decor.MouseLeave:Connect(function()
	unhoverButton(Selection.Decor)
end)

Selection.Traps.MouseEnter:Connect(function()
	hoverButton(Selection.Traps)
end)

Selection.Traps.MouseLeave:Connect(function()
	unhoverButton(Selection.Traps)
end)

Selection.Generators.MouseEnter:Connect(function()
	hoverButton(Selection.Generators)
end)

Selection.Generators.MouseLeave:Connect(function()
	unhoverButton(Selection.Generators)
end)

Selection.Structure.MouseEnter:Connect(function()
	hoverButton(Selection.Structure)
end)

Selection.Structure.MouseLeave:Connect(function()
	unhoverButton(Selection.Structure)
end)
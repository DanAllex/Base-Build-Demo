local currentSelected = script.Parent.Selected
local Selection = script.Parent.frmSelect.Selection
local frmSelection = script.Parent.frmItems
local placing = script.Parent.Placing

local buttonColor = {
	["Blue"] = Color3.new(66/255, 165/255, 245/255),
	["BlueShadow"] = Color3.new(44/255, 113/255, 166/255),
	["DarkGrey"] = Color3.new(158/255, 158/255, 158/255),
	["DarkGreyShadow"] = Color3.new(95/255, 95/255, 95/255),
	["Grey"] = Color3.new(189/255, 189/255, 189/255),
	["GreyShadow"] = Color3.new(157/255, 157/255, 157/255),
	["White"] = Color3.new(1, 1, 1),
	["WhiteShadow"] = Color3.new(190/255, 190/255, 190/255),
	["Black"] = Color3.new(0, 0, 0),
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

Selection.Inventory.MouseButton1Click:Connect(function()
	currentSelected.Value = Selection.Inventory.Name
end)

local function selectButton(btn)
	btn.Round.ImageColor3 = buttonColor.Blue
	btn.Round.Shadow.ImageColor3 = buttonColor.BlueShadow
	
	for i,v in pairs(Selection:GetChildren()) do
		if v.Name ~= btn.Name then
			v.Round.ImageColor3 = buttonColor.Grey
			v.Round.Shadow.ImageColor3 = buttonColor.GreyShadow
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
		btn.Round.ImageColor3 = buttonColor.DarkGrey
		btn.Round.Shadow.ImageColor3 = buttonColor.DarkGreyShadow
	end
end

local function unhoverButton(btn)
	if btn.Name ~= currentSelected.Value then
		btn.Round.ImageColor3 = buttonColor.Grey
		btn.Round.Shadow.ImageColor3 = buttonColor.GreyShadow
	end
end

placing.Changed:Connect(function()
	for i,v in pairs(frmSelection:GetChildren()) do
		for j,element in pairs(v:GetChildren()) do
			if element.Name ~= "UIGridLayout" and element.Name ~= "Template" then
				element.ImageColor3 = buttonColor.White
				element.imgShadow.ImageColor3 = buttonColor.WhiteShadow
				element.txtPrice.TextColor3 = buttonColor.Black
				if element.ViewportFrame.obj.Value ~= nil then
					if element.ViewportFrame.obj.Value.Name == placing.Value then
						element.ImageColor3 = buttonColor.Blue
						element.imgShadow.ImageColor3 = buttonColor.BlueShadow
						element.txtPrice.TextColor3 = buttonColor.White
					end
				end
			end
		end
	end
end)

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

Selection.Inventory.MouseEnter:Connect(function()
	hoverButton(Selection.Inventory)
end)

Selection.Inventory.MouseLeave:Connect(function()
	unhoverButton(Selection.Inventory)
end)
local mouse = game.Players.LocalPlayer:GetMouse()
function mouseHit(distance) 
	local ray = Ray.new(mouse.UnitRay.Origin, mouse.UnitRay.Direction * distance) --as you can see, here creating a ray with the same origin (which is the camera of course) and the same direction BUT longer, whatever the distance parameter is
	local _, position = workspace:FindPartOnRay(ray)
	
	return position 
end

while true do
	wait(1)
	--print(mouseHit(20).Y)
	print(mouseHit(20).Y)
end
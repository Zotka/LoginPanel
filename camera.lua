local Animation = 0
local ATimer
local Frames = 0

local Angle, Radius, AnimCenter

local MoveSpeed, AnimMove

local GrooveAnim, LookAt

function resetCoordinates(number)
	if number == 1 then
		Angle = 120
		Radius = 120
		AnimCenter = {
			x = 1544.1,
			y = -1353.3,
			z = 210
		}
	elseif number == 2 then
		MoveSpeed = 0.0001
		AnimMove = {
			x = 416,
			y = -1348,
			z = 17
		}
	elseif number == 3 then
		GrooveAnim = {
			x = 2379,
			y = -1658,
			z = 14
		}
		LookAt = {
			x = 2477,
			y = -1670,
			z = 14
		}
	end
end

function startLoginAnimation(number)
	fadeCamera(false, 2)
	if isTimer(ATimer) then return false end

	ATimer = setTimer(function()
		Animation = number
		fadeCamera(true, 2)
		Frames = 0
		triggerEvent("startLoginAnimation", localPlayer, number)
	end, 2000, 1)
end

function stopLoginAnimation()
	fadeCamera(false, 2)
	if isTimer(ATimer) then killTimer(ATimer) end

	ATimer = setTimer(function()
		Animation = 0
		setCameraTarget(localPlayer)
		fadeCamera(true, 2)
	end, 2000, 1)
end

addEvent("startLoginAnimation", true)
addEventHandler("startLoginAnimation", root, resetCoordinates)

addEventHandler("onClientRender", root, function()
	
	if Animation > 0 then Frames = Frames+1 end
	if Animation == 1 then

		Angle = Angle+0.15

		local x = AnimCenter.x + Radius*math.cos( math.rad(Angle) )
		local y = AnimCenter.y - Radius*math.sin( math.rad(Angle) )
		local z = AnimCenter.z +70
		AnimCenter.z = AnimCenter.z - 0.05

		setCameraMatrix(x, y, z, AnimCenter.x, AnimCenter.y, AnimCenter.z, 0, 90)

		if Frames == 750 then
			startLoginAnimation(2)
		end

	elseif Animation == 2 then

		AnimMove.x = AnimMove.x + 0.12
		AnimMove.y = AnimMove.y + 0.08
		AnimMove.z = AnimMove.z + MoveSpeed

		MoveSpeed = MoveSpeed+0.00006

		local lx = AnimMove.x-6
		local ly = AnimMove.y-4
		local lz = AnimMove.z-1 + (30*MoveSpeed)

		setCameraMatrix(AnimMove.x, AnimMove.y, AnimMove.z, lx, ly, lz, 0, 90)

		if Frames == 620 then
			startLoginAnimation(3)
		end

	elseif Animation == 3 then

		GrooveAnim.x = GrooveAnim.x+0.14
		if GrooveAnim.x > LookAt.x then GrooveAnim.z = GrooveAnim.z + 0.01 end

		setCameraMatrix(GrooveAnim.x, GrooveAnim.y, GrooveAnim.z, LookAt.x, LookAt.y, LookAt.z, 0, 90)

		if Frames == 800 then
			startLoginAnimation(1)
		end

	end
end)
local Fonts = 
{
	["Bold"] = "fonts/Roboto-Bold.ttf",
	["Medium"] = "fonts/Roboto-Medium.ttf",
	["Regular"] = "fonts/Roboto-Regular.ttf"
}

local Images = 
{
	["Center"] = "images/shadow.png",
	["Top"] = "images/top.png",
	["Bottom"] = "images/bottom.png",
	["Shadow"] = "images/shadow_bottom.png",
	["Logo"] = "images/logo.png",
	["Animation"] = "images/animation.png",
	["Round"] = "images/round.png",
	["Pane"] = "images/pane.png"
}

local pane = Images["Pane"]

local Bold = guiCreateFont(Fonts["Bold"], 18)
local Medium = guiCreateFont(Fonts["Medium"], 12)
local Regular = guiCreateFont(Fonts["Regular"], 10)
local Regular14 = guiCreateFont(Fonts["Regular"], 14)

local Width, Height = guiGetScreenSize()

local BackShadow = guiCreateStaticImage((Width/2)-(416/2), (Height/2)-(470/2), 415, 470, Images["Center"], false)

local TopSide = guiCreateStaticImage((415-369)/2, (470-(313+110))/2, 369, 313, Images["Top"], false, BackShadow)
local BottomSide = guiCreateStaticImage((415-369)/2, (470-(313+110))/2 + 313, 369, 110, Images["Bottom"], false, BackShadow)

local TopShadow = guiCreateStaticImage(0, 0, 369, 17, Images["Shadow"], false, BottomSide)
guiSetProperty(TopShadow, "AlwaysOnTop", "True")

local AnimationTop = guiCreateStaticImage(0, 0, 400, 200, Images["Animation"], false, BottomSide)
local AnimationBottom = guiCreateStaticImage(0, 200, 400, 200, Images["Animation"], false, BottomSide)
guiSetEnabled(AnimationTop, false)
guiSetEnabled(AnimationBottom, false)

local NewY = 200
local Frames = 0
addEventHandler("onClientRender", root, function()

	if guiGetVisible(BackShadow) then

		local Limit = 1
		if getFPSLimit() <= 60 then Limit = 1
		elseif getFPSLimit() > 60 and getFPSLimit() <= 100 then Limit = 2
		else Limit = 3 end

		Frames = Frames+1
		if Frames >= Limit then

			NewY = NewY+1
			if NewY >= 199 then NewY = 199 end
			if NewY == 199 then NewY = 0 end

			guiSetPosition(AnimationTop, 0, NewY-200, false)
			guiSetPosition(AnimationBottom, 0, NewY, false)

			Frames = 0

		end

	end

end)

local LogoPanel = guiCreateStaticImage(138, 30, 94, 66, Images["Logo"], false, TopSide)

local _guiCreateEdit = guiCreateEdit
function guiCreateEdit(x, y, w, h, ...)

	local Edit = _guiCreateEdit(x, y, w, h, ...)

	guiCreateStaticImage(0, 0, w, 5, pane, false, Edit)
	guiCreateStaticImage(0, 0, 3, h, pane, false, Edit)
	guiCreateStaticImage(w-3, 0, 3, h, pane, false, Edit)
	guiCreateStaticImage(0, h-3, w, 3, pane, false, Edit)

	return Edit
end

local LogRound1 = guiCreateStaticImage(22, 250-41-17-41-17, 41, 41, Images["Round"], false, TopSide)
local LogRound2 = guiCreateStaticImage(369-41-22, 250-41-17-41-17, 41, 41, Images["Round"], false, TopSide)
guiSetEnabled(LogRound1, false)
guiSetEnabled(LogRound2, false)

local LoginEdit = guiCreateEdit(42, 250-41-17-41-17, (369-41-44), 41, "Логин", false, TopSide)
guiSetFont(LoginEdit, Regular)
guiSetProperty(LoginEdit, "NormalTextColour", "FF727272")
guiSetProperty(LoginEdit, "ActiveSelectionColour", "FFF1B26D")



local PassRound1 = guiCreateStaticImage(22, 250-41-17, 41, 41, Images["Round"], false, TopSide)
local PassRound2 = guiCreateStaticImage(369-41-22, 250-41-17, 41, 41, Images["Round"], false, TopSide)
guiSetEnabled(PassRound1, false)
guiSetEnabled(PassRound2, false)

local PassEdit = guiCreateEdit(42, 250-41-17, (369-41-44), 41, "Пароль", false, TopSide)
guiSetFont(PassEdit, Regular)
guiSetProperty(PassEdit, "NormalTextColour", "FF727272")
guiSetProperty(PassEdit, "ActiveSelectionColour", "FFF1B26D")

addEventHandler("onClientGUIClick", root, function()

	if source == LoginEdit then
		if guiGetText(LoginEdit) == "Логин" then 
			guiSetText(LoginEdit, "")
		end
	else
		if guiGetText(LoginEdit) == "" or
			guiGetText(LoginEdit) == " "
			then

				guiSetText(LoginEdit, "Логин")

		end
	end

	if source == PassEdit then
		if guiGetText(PassEdit) == "Пароль" then 
			guiSetText(PassEdit, "")
			guiEditSetMasked(PassEdit, true)
		end
	else
		if guiGetText(PassEdit) == "" or
			guiGetText(PassEdit) == " "
			then

				guiSetText(PassEdit, "Пароль")
				guiEditSetMasked(PassEdit, false)

		end
	end

end)

addEventHandler("onClientGUIFocus", root, function()
	if source == LoginEdit or source == PassEdit then triggerEvent("onClientGUIClick", source) end
end)
addEventHandler("onClientGUIBlur", root, function()
	if source == LoginEdit or source == PassEdit then triggerEvent("onClientGUIClick", source) end
end)

local ButRound1 = guiCreateStaticImage(22, 250, 41, 41, Images["Round"], false, TopSide)
local ButRound2 = guiCreateStaticImage(369-41-22, 250, 41, 41, Images["Round"], false, TopSide)
local ButCenter = guiCreateStaticImage(42, 250, (369-41-44), 41, pane, false, TopSide)

function setButtonColor(color)
	guiSetProperty(ButRound1, "ImageColours", "tl:FF"..color.." tr:FF"..color.." bl:FF"..color.." br:FF"..color)
	guiSetProperty(ButRound2, "ImageColours", "tl:FF"..color.." tr:FF"..color.." bl:FF"..color.." br:FF"..color)
	guiSetProperty(ButCenter, "ImageColours", "tl:FF"..color.." tr:FF"..color.." bl:FF"..color.." br:FF"..color)
end

setButtonColor("F1B26D")

local ButTitle = guiCreateLabel(0, 0, 1, 0.96, "Вход", true, ButCenter)
guiLabelSetVerticalAlign(ButTitle, "center")
guiLabelSetHorizontalAlign(ButTitle, "center")
guiSetFont(ButTitle, Medium)
guiLabelSetColor(ButTitle, 110, 71, 30)
guiSetEnabled(ButTitle, false)

addEventHandler("onClientMouseEnter", root, function()

	if source == ButCenter or
		source == ButRound1 or
		source == ButRound2 then

			setButtonColor("F6D5A4")

	end

end)

addEventHandler("onClientMouseLeave", root, function()

	setButtonColor("F1B26D")

end)

addEventHandler("onClientGUIMouseDown", root, function()
	if source == ButCenter or
		source == ButRound1 or
		source == ButRound2 then

			setButtonColor("FBEECB")

	end
end)

addEventHandler("onClientGUIMouseUp", root, function()

	if source == ButCenter or
		source == ButRound1 or
		source == ButRound2 then

			setButtonColor("F6D5A4")

	else

		setButtonColor("F1B26D")

	end

end)

local RegisterLine = guiCreateStaticImage(113, 77, 146, 3, pane, false, BottomSide)
guiSetProperty(RegisterLine, "ImageColours", "tl:996E471E tr:996E471E bl:00000000 br:00000000")

local RegisterButton = guiCreateLabel(113, 77-25, 146, 25, "Регистрация", false, BottomSide)
guiLabelSetVerticalAlign(RegisterButton, "center")
guiLabelSetHorizontalAlign(RegisterButton, "center")
guiSetFont(RegisterButton, Bold)
guiLabelSetColor(RegisterButton, 110, 71, 30)

local InfoLabel = guiCreateLabel(0, 77-55, 369, 30, "Нет аккаунта?", false, BottomSide)
guiLabelSetVerticalAlign(InfoLabel, "center")
guiLabelSetHorizontalAlign(InfoLabel, "center")
guiSetFont(InfoLabel, Regular14)
guiLabelSetColor(InfoLabel, 110, 71, 30)
guiSetEnabled(InfoLabel, false)

addEventHandler("onClientMouseEnter", root, function()
	if source == RegisterButton then
		guiLabelSetColor(RegisterButton, 135, 90, 50)
	end
end)
addEventHandler("onClientMouseLeave", root, function()
	guiLabelSetColor(RegisterButton, 110, 71, 30)
end)
addEventHandler("onClientGUIMouseDown", root, function()
	if source == RegisterButton then
		guiLabelSetColor(RegisterButton, 160, 108, 71)
	end
end)
addEventHandler("onClientGUIMouseUp", root, function()
	if source == RegisterButton then
		guiLabelSetColor(RegisterButton, 135, 90, 50)
	else
		guiLabelSetColor(RegisterButton, 110, 71, 30)
	end
end)

function visibleLoginPanel(bool)
	showCursor(bool)
	guiSetVisible(BackShadow, bool)
	showPlayerHudComponent("all", not bool)
	showChat(not bool)
	if bool then
		startLoginAnimation(math.random(3))
	else
		stopLoginAnimation()
	end
end

--[[bindKey("o", "down", function()
	visibleLoginPanel( not guiGetVisible(BackShadow) )
end)]]

guiSetVisible(BackShadow, false)

function showLoginError(title)
	guiSetText(InfoLabel, title)
	setTimer(function()
		guiSetText(InfoLabel, "Нет аккаунта?")
	end, 2000, 1)
end



addEventHandler("onClientGUIClick", root, function()

	if source == ButRound1 or source == ButRound2 or source == ButCenter then

		triggerServerEvent("loginPlayer", localPlayer, localPlayer, guiGetText(LoginEdit), guiGetText(PassEdit), "Login")

	elseif source == RegisterButton then

		triggerServerEvent("loginPlayer", localPlayer, localPlayer, guiGetText(LoginEdit), guiGetText(PassEdit), "Register")

	end

end)

addEvent("hideLogin", true)
addEventHandler("hideLogin", root, function() visibleLoginPanel(false) end)

addEvent("showLogin", true)
addEventHandler("showLogin", root, function() visibleLoginPanel(true) end)

addEvent("errorLogin", true)
addEventHandler("errorLogin", root, function(title) showLoginError(title) end)
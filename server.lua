addEvent("loginPlayer", true)
addEventHandler("loginPlayer", root, function(player, login, pass, types)

	if not isGuestAccount(getPlayerAccount(player)) then 
		triggerClientEvent(player, "hideLogin", player)
	else 
		local acc = getAccount(login)
		if acc then
			if types == "Register" then
				triggerClientEvent(player, "errorLogin", player, "Аккаунт существует")
			else
				acc = getAccount(login, pass)
				if acc then
					logIn(player, acc, pass)
				else
					triggerClientEvent(player, "errorLogin", player, "Неверный пароль")
				end
			end
		else
			if types == "Login" then
				triggerClientEvent(player, "errorLogin", player, "Аккаунта не существует")
			else
				acc = addAccount(login, pass)
				if acc then
					logIn(player, acc, pass)
				else
					triggerClientEvent(player, "errorLogin", player, "Ошибка регистрации")
				end
			end
		end
	end

end)

addEventHandler("onPlayerLogin", root, function()
	triggerClientEvent(source, "hideLogin", source)
end)
addEventHandler("onPlayerLogout", root, function()
	triggerClientEvent(source, "showLogin", source)
end)

addEventHandler("onResourceStart", root, function(res)
	if res ~= getThisResource() then return false end

	for _, player in ipairs(getElementsByType("player")) do
		if isGuestAccount(getPlayerAccount(player)) then
			triggerClientEvent(source, "showLogin", source)		
		end
	end
end)
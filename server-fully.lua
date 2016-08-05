addEvent("loginPlayer", true) --Добавляем событие авторизации игрока
addEventHandler("loginPlayer", root, function(player, login, pass, types) --Расписываем событие
	--Аргументами являются игрок, логин, пароль и тип авторизации

	--Проверяем, авторизирован ли игрок
	if not isGuestAccount(getPlayerAccount(player)) then 
		triggerClientEvent(player, "hideLogin", player) --Если игрок авторизирован, то скрываем логин панель
	else --Если игрок гость
		local acc = getAccount(login) --То получаем аккаунт с введённым логином
		if acc then --Если такой аккаунт существует
			--То проверяем тип авторизации
			if types == "Register" then --Если тип - регистрация
				--То отправляем игроку ошибку о том, что аккаунт с данным ником существует
				triggerClientEvent(player, "errorLogin", player, "Аккаунт существует")
			--Если тип авторизации - вход
			else 
				--То проверяем правильность пароля аккаунта
				acc = getAccount(login, pass)
				--Если пароль верный
				if acc then
					--То авторизируем пользователя в данный аккаунт
					logIn(player, acc, pass)
				else
					--Если нет - уведомляем игрока о неправильном пароле
					triggerClientEvent(player, "errorLogin", player, "Неверный пароль")
				end
			end

		--Если аккаунт не существует
		else
			--А типом авторизации выбран логин
			if types == "Login" then
				--То уведомляем, что такого аккаунта не существует
				triggerClientEvent(player, "errorLogin", player, "Аккаунта не существует")
			--Если тип - регистрация
			else
				--То добавляем аккаунт
				--{{{{ВНИМАНИЕ - ДАННАЯ ФУНКЦИЯ ТРЕБУЕТ ПРАВ АДМИНИСТРАТОРА В ACL}}}}
				--{{{{КАК ЕЁ УСТАНОВИТЬ РАССКАЗАНО В ВИДЕО}}}}
				acc = addAccount(login, pass) --Аргументами являются логин и пароль
				if acc then --Если аккаунт создан
					logIn(player, acc, pass) --То авторизируем пользователя в него
				--Если аккаунт не создался
				else
					--Отправляем игроку ошибку регистрации
					triggerClientEvent(player, "errorLogin", player, "Ошибка регистрации")
				end
			end
		end
	end

end)

--Когда пользователь авторизируется, мы скрываем логин панель
addEventHandler("onPlayerLogin", root, function()
	--По событию авторизации скрываем
	triggerClientEvent(source, "hideLogin", source)
end)
--Когда пользователь выходит из аккаунта
addEventHandler("onPlayerLogout", root, function()
	--То в событии logout мы навязчиво просим игрока авторизироваться
	triggerClientEvent(source, "showLogin", source)
end)

--Теперь когда ресурс стартует, нужно неавторизированным пользователям предложить авторизироваться
addEventHandler("onResourceStart", root, function(res) --Аргумент события - res - запускаемый ресурс
	if res ~= getThisResource() then return false end --Если ресурс, который запускается, не является данным, то нижний код не участвует в работе

	--Циклим игроков по элементам
	for _, player in ipairs(getElementsByType("player")) do
		--Данный цикл проходят все игроки, существующие на данный момент на сервере
		if isGuestAccount(getPlayerAccount(player)) then --Если игрок является гостем
			triggerClientEvent(source, "showLogin", source)	--То предлагаем ему авторизироваться
		end
	end
end)
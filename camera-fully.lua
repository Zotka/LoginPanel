
--В видеоуроке скрипт будет упрощён, и некоторые переменные будут переименованы для того, чтобы быть более понятными

local Animation = 0 --Анимированная камера
local ATimer --Переменная для таймера отключения камеры
local Frames = 0 --Отсчёт кадров для одной анимации

--[[Переменные для первой анимации]]
local ugol, radius = 120, 120 --Начальный угол поворота камеры и радиус окружности
local center = {["x"] = 1544.1, ["y"] = -1353.3, ["z"] = 210} --Точка для центровки кадра

--[[Переменные для второй анимации]]
local startPositions = {["x"] = 416, ["y"] = -1348, ["z"] = 17}
local SpeedUp = 0.0001

--[[Переменные для третьей анимации]]
local groove = {["x"] = 2379, ["y"] = -1658, ["z"] = 14}


--Функции для начала и окончания анимации
function startLoginAnimation(number) --Номер анимации будет как аргумент
	if isTimer(ATimer) then return false end --Если таймер уже запущен, то закончить действия
	fadeCamera(false, 2) --закрыть камеру

	ATimer = setTimer(function()
		Animation = number --Number (Номер анимации) - начать выбранную анимацию
		fadeCamera(true, 2) --открыть камеру
		Frames = 0 --Обнуляем кадры
		triggerEvent("startLoginAnimation", localPlayer, number) --Отправляем триггер для обнуления стандартных переменных
	end, 2000, 1)
end

function stopLoginAnimation()
	fadeCamera(false, 2) --Закрыть камеру
	if isTimer(ATimer) then killTimer(ATimer) end --И если есть таймер, убиваем его

	ATimer = setTimer(function()  --И через секунду
		Animation = 0  -- 0 - остановить анимацию
		setCameraTarget(localPlayer) --Поставить камеру позади игрока
		fadeCamera(true, 2) --Открыть камеру
	end, 2000, 1)
end


addEvent("startLoginAnimation", true)
addEventHandler("startLoginAnimation", root, function(number)
	if number == 1 then --Для первой анимации обнуляем первые переменные

		ugol, radius = 120, 120 
		center = {["x"] = 1544.1, ["y"] = -1353.3, ["z"] = 210}

	elseif number == 2 then--Для второй анимации тоже

		startPositions = {["x"] = 416, ["y"] = -1348, ["z"] = 17}
		SpeedUp = 0.0001

	elseif number == 3 then --Для третьей анимации

		groove = {["x"] = 2379, ["y"] = -1658, ["z"] = 14}

	end
end)



addEventHandler("onClientRender", root, function() --Событие отрисовки анимации

	if Animation == 1 then --Если первая анимация, то

		Frames = Frames+1 --Добавляем по кадру

		ugol = ugol+0.15 --Добавляем для угла значения
		local x = center.x+radius*math.cos(math.rad(ugol)) --Новые координаты X
		local y = center.y-radius*math.sin(math.rad(ugol)) --Новые коодинаты Y
		center.z = center.z-0.05 --Опускаем камеру вниз

		setCameraMatrix(x, y, center.z+70, center.x, center.y, center.z, 0, 90) --Двигаем камеру

		if Frames == 750 then --По достижению нужных кадров
			startLoginAnimation(2) --Меняем анимацию
		end

	elseif Animation == 2 then

		Frames = Frames+1 --Для этой анимации тоже

		startPositions.x = startPositions.x + 0.12 --Здесь мы будем перемещать по X
		startPositions.y = startPositions.y + 0.08 --Тут по Y
		startPositions.z = startPositions.z + SpeedUp --Тут по Z
		SpeedUp = SpeedUp+0.00006 --Увеличиваем значение скорости подъёма

		--Устанавливаем новые координаты с учётом позиций просмотра (+увеличение значения высоты обзора для плавности)
		setCameraMatrix(startPositions.x, startPositions.y, startPositions.z, startPositions.x-6, startPositions.y-4, startPositions.z-1+(30*SpeedUp), 0, 90) --Двигаем камеру

		if Frames == 620 then --По достижению нужных кадров
			startLoginAnimation(3) --Меняем анимацию
		end

	elseif Animation == 3 then

		Frames = Frames+1 --Увеличиваем кадры

		groove.x = groove.x+0.14
		if groove.x > 2477 then groove.z = groove.z+0.01 end
		setCameraMatrix(groove.x, groove.y, groove.z, 2477, -1670, 14, 0, 90)

		--outputDebugString(Frames)

		if Frames == 800 then --По достижению нужных кадров
			startLoginAnimation(1) --Меняем анимацию
		end

	end

end)
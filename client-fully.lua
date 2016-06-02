--Переменные, которые объявляем в начале ресурса

local Fonts = --Таблица шрифтов Fonts, хранящихся в ресурсе
{
	["Bold"] = "fonts/Roboto-Bold.ttf", --Жирно выделенный шрифт
	["Medium"] = "fonts/Roboto-Medium.ttf", --Шрифт средней толщины линии
	["Regular"] = "fonts/Roboto-Regular.ttf" -- Обычный шрифт
}

local Images = --Таблица изображений Images, хранящихся в ресурсе
{
	["Center"] = "images/shadow.png", --Тень от всего меню, располагается в самом низу
	["Top"] = "images/top.png", --Верхняя часть меню
	["Bottom"] = "images/bottom.png", --Нижняя часть меню
	["Shadow"] = "images/shadow_bottom.png", --Тень, идущая от верхней части на нижнюю
	["Logo"] = "images/logo.png", --Логотип в меню
	["Animation"] = "images/animation.png", --Картинка, которая превратится в анимацию
	["Round"] = "images/round.png", --Окружность для выделения кнопок
	["Pane"] = "images/pane.png" --Квадратик 1х1 пиксель, для создания цветных прямоугольников
}

--Сразу же создадим переменню для обозначения квадратика 1х1, чтобы удобнее было вызывать
local pane = Images["Pane"] --Создали переменную pane, которая равна значению Pane в таблице изображений Images

--Создадим сразу набор шрифтов для использования их в GUI-разработке
local Bold = guiCreateFont(Fonts["Bold"], 18) --Создаём перенную Bold, в которую поместим GUI-шрифт с заданными параметрами, как директория шрифта, и его размер
local Medium = guiCreateFont(Fonts["Medium"], 12) --Создаём перенную Medium, в которую поместим GUI-шрифт с заданными параметрами, как директория шрифта, и его размер
local Regular = guiCreateFont(Fonts["Regular"], 10) --Создаём перенную Regular, в которую поместим GUI-шрифт с заданными параметрами, как директория шрифта, и его размер
local Regular14 = guiCreateFont(Fonts["Regular"], 14) --Создадим переменную Regular14, в которую поместим шрифт с директорией предыдущего шрифта, но размером - 14


--И начнём поочерёдно создавать элементы
--Для начала найдём размеры экрана пользователя, чтобы затем помещать на него элементы (тк у каждого пользователя собственное разрешение экрана)
local Width, Height = guiGetScreenSize()

--Затем создаём элементы на экране, учитывая середину экрана
local X, Y = Width/2-(416/2), Height/2-(470/2) --Разделяем ширину экрана пополам, затем вычитаем половину размера элемента (данные изображения)
--По данным координатам создаём заднюю часть панели, относительно которой будут считаться следующий координаты
local BackShadow = guiCreateStaticImage(X, Y, 415, 470, Images["Center"], false) --Используем полученные половинные координаты и реальные размеры изображения, а так-же само изображение (false - это использование неабсолютных координат и размеров - это когда длины экрана принимаются за 1, и вокруг них ведутся рассчёты (0.5, 0.5 - половина экрана))

--Теперь на данное изображение наложим верхнюю и нижнюю части
--Так как X и Y переменные своё отработали, сделаем их снова в действии
X, Y = (415-369)/2, (470-(313+110))/2
--По данным координатам создаём верхнюю часть, 
local TopSide = guiCreateStaticImage(X, Y, 369, 313, Images["Top"], false, BackShadow) --Заметим, что в конце стоит BackShadow - это элемент, на который накладывается данный, и относительно него ведутся координатные рассчёты
local BottomSide = guiCreateStaticImage(X, Y+313, 369, 110, Images["Bottom"], false, BackShadow) --Сделали тоже самое, только в случае с координатой Y - мы добавили к ней полный размер верхнего изображения, чтобы получить нижнюю координату

--Затем нанесём тень от верхней части на нижнюю
--Для этого на нижний элемент поместим уже заготовленную тень
local TopShadow = guiCreateStaticImage(0, 0, 369, 17, Images["Shadow"], false, BottomSide) --Используются координаты равные 0, так как данный элемент принадлежит нижней панельке, и относительно неё считаются координаты
--Сделаем эту тень постоянно на верху, чтобы анимация её не загораживала
guiSetProperty(TopShadow, "AlwaysOnTop", "True") -- Для этого мы просто зададим ей параметр AlwaysOnTop на True (здесь обязательны все кавычки)


--Теперь создаём элементы анимации (она будет непрерывной, поэтому создаём два изображения, которые будут заменять друг друга)
local AnimationTop = guiCreateStaticImage(0, 0, 400, 200, Images["Animation"], false, BottomSide)
local AnimationBottom = guiCreateStaticImage(0, 200, 400, 200, Images["Animation"], false, BottomSide) --Вторую точно такую-же поместим ниже первой, так как она будет циклически заменяться
--Сделаем так, чтобы данную анимацию нельзя было выдвинуть вперёд (чтобы тень не исчезала)
guiSetEnabled(AnimationTop, false)
guiSetEnabled(AnimationBottom, false)

--Приступим к анимации движения изображения на нижней части
--Делать мы его будем в событии Render, так как здесь анимация проходит в зависимости от частоты обновления игры (количества FPS)
local H = 200 --Переменная, отвечающая за положение анимации на экране (Чтобы сделать движение вниз, установите здесь значение 0)
local Frames = 0 --Переменная, отвечающая за время движения пикселя, чтобы замедлить движение изображения
addEventHandler("onClientRender", root, function() --Создаём событие рендера, и сразу открываем в нём функцию (root - принадлежность события ко всем элементам)

	--Сделаем проверку на видимость панели, чтобы рассчёты не проводились во время закрытой панели
	if guiGetVisible(BackShadow) then --Если самая дальняя картинка (являющаяся всем изображениям ресурсом "родителем") видна, то будем считать

		local N = 1 --Счётчик скорости для разных кадров
		if getFPSLimit() <= 60 then N = 1 --Если кадры меньше 60, то скорость - 1
		elseif getFPSLimit() > 60 and getFPSLimit() <= 100 then N = 2 --Для 60 до 100 - скорость - 2
		elseif getFPSLimit() > 100 then N = 3 end --И более - 3

		Frames = Frames+1 --Добавляем кадры, чтобы делать их рассчёт
		if Frames >= N then --За каждые N кадра будет подъём на заданное количество пикселей

			--[[Начало комментирования]]
			--[[

			--Минус показывает направление движения, здесь движение будет вверх
			H = H-1 --Здесь 1 - это количество пикселей за кадр (скорость анимации)
			if H <= 0 then H = 0 end --Сделаем проверку на координаты, чтобы не было лишних наездов и переездов
			if H == 0 then H = 199 end --Снова обновляем координаты, чтобы цикл пошёл снова

			--Обновляем координаты для двух анимаций
			guiSetPosition(AnimationTop, 0, H-200, false) --Верхнее изображение поднимаем вверх, выше его размера
			guiSetPosition(AnimationBottom, 0, H, false) --А нижнее за ним поднимаем

			]]
			--[[Конец комментирования]]


			--Для того, чтобы сделать движение вниз, закомментируйте верхний код, и раскомментируйте нижний

			--[[Начало комментирования]]

			H = H+1
			if H >= 199 then H = 199 end
			if H == 199 then H = 0 end
			guiSetPosition(AnimationTop, 0, H-200, false)
			guiSetPosition(AnimationBottom, 0, H, false)

			--[[Конец комментирования]]

			Frames = 0 --Обнуляем кадры, чтобы их снова засчитывать

		end


	end

end) --Закрываем функцию для события Render


--Самое время поместить на экран логотип
--Координаты - 138, 30
local LogoPanel = guiCreateStaticImage(138, 30, 94, 66, Images["Logo"], false, TopSide)


--Cоздадим функцию для того, чтобы была возможность создавать квадратные плоские Edit-панели
--Для этого сначала обнулим имеющуюся функцию
local _guiCreateEdit = guiCreateEdit
function guiCreateEdit(x, y, w1, h1, ...) --Аргументы данной функции просто равны аргументом обычной Edit-функции, но первые 4 аргумента важны
	local Edit = _guiCreateEdit(x, y, w1, h1, ...) --Создаём обычным эдит
	--И поверх него накладываем 4 белые картинки, которые загораживают тени и некрасивые части эдита

    guiCreateStaticImage(0, 0, w1, 5, pane, false, Edit) --Изображение сверху эдит-поля (pane - это переменная изображения)
    guiCreateStaticImage(0, 0, 3, h1, pane, false, Edit) --Изображение слева эдит-поля (pane - это переменная изображения)
   	guiCreateStaticImage(w1-3, 0, 3, h1, pane, false, Edit) --Изображение справа эдит-поля (pane - это переменная изображения)
    guiCreateStaticImage(0, h1-3, w1, 3, pane, false, Edit) --Изображение снизу эдит-поля (pane - это переменная изображения)

	return Edit --Вернём сам эдит
end

--Теперь определимся с координатами
--Для логинбокса координаты такие:
X, Y = 22, 250-41-17-41-17 --250 - позиция кнопки "Вход", 41 - высота поля, 17 - расстояние между элементами
--Так как боковые грани поля ввода будут округлые, то создадим по данным коодинатам круги (слева и справа)
local LogRound1 = guiCreateStaticImage(X, Y, 41, 41, Images["Round"], false, TopSide)
local LogRound2 = guiCreateStaticImage(369-41-X, Y, 41, 41, Images["Round"], false, TopSide) --Здесь другой Х, так как учитываем размер панели
--И сделаем их недосягаемыми
guiSetEnabled(LogRound1, false)
guiSetEnabled(LogRound2, false)
--Теперь создаём поле для ввода логина
local LoginEdit = guiCreateEdit(X+20, Y, (369-41-2*X), 41, "Логин", false, TopSide)
guiSetFont(LoginEdit, Regular) --Установим шрифт
guiSetProperty(LoginEdit, "NormalTextColour", "FF727272") --Зададим цвет текста
guiSetProperty(LoginEdit, "ActiveSelectionColour", "FFF1B26D") --Зададим цвет выделения
--Проделаем тоже самое с паролем

--Создаём кружочки для пароля
Y = 250-41-17 --Обновим Y координату
local PassRound1 = guiCreateStaticImage(X, Y, 41, 41, Images["Round"], false, TopSide)
local PassRound2 = guiCreateStaticImage(369-41-X, Y, 41, 41, Images["Round"], false, TopSide) --Здесь другой Х, так как учитываем размер панели
--И сделаем их недосягаемыми
guiSetEnabled(PassRound1, false)
guiSetEnabled(PassRound2, false)
--Теперь создаём поле для ввода логина
local PassEdit = guiCreateEdit(X+20, Y, (369-41-2*X), 41, "Пароль", false, TopSide)
guiSetFont(PassEdit, Regular) --Установим шрифт
guiSetProperty(PassEdit, "NormalTextColour", "FF727272") --Зададим цвет текста
guiSetProperty(PassEdit, "ActiveSelectionColour", "FFF1B26D") --Зададим цвет выделения

--Теперь нужно, чтобы при действии с данными полями для ввода, исчезали подсказки (логин, пароль), и пароль автоматически вуалировался
--Для этого мы вопрользуемся событиями нажатия
addEventHandler("onClientGUIClick", root, function()

	if source == LoginEdit then --Если мы нажимаем на поле ввода логина
		if guiGetText(LoginEdit) == "Логин" then --То делаем проверку, написано ли в данном поле слово логин
			--Если да, то чистим текст
			guiSetText(LoginEdit, "")
		end
	else --Если нажимаем не на поле ввода логина
		--То проверяем на символы
		if guiGetText(LoginEdit) == "" or --Если поле пустое
			guiGetText(LoginEdit) == " " --Или в нём стоит пробел
			then
				guiSetText(LoginEdit, "Логин") --То мы возвращаем слово Логин обратно
		end
	end

	--Тоже самое повторим и с паролем

	if source == PassEdit then --Если мы нажимаем на поле ввода пароля
		if guiGetText(PassEdit) == "Пароль" then --То делаем проверку, написано ли в данном поле слово пароль
			--Если да, то чистим текст, и маскируем поле
			guiSetText(PassEdit, "")
			guiEditSetMasked(PassEdit, true)
		end
	else --Если нажимаем не на поле ввода логина
		--То проверяем на символы
		if guiGetText(PassEdit) == "" or --Если поле пустое
			guiGetText(PassEdit) == " " --Или в нём стоит пробел
			then
				guiSetText(PassEdit, "Пароль") --То мы возвращаем слово Пароль обратно
				guiEditSetMasked(PassEdit, false) --И делаем текст видимым
		end
	end

end)
--А для фокусировки на гуи (tab например нажали), чтобы текст исчезал, мы просто отправим триггер на нажатие
addEventHandler("onClientGUIFocus", root, function()
	if source == LoginEdit then triggerEvent("onClientGUIClick", LoginEdit) end --Для логин поля мы отправим триггер на клик
	if source == PassEdit then triggerEvent("onClientGUIClick", PassEdit) end --И для пароля
end)
--А это при расфокусировании с гуи элемента
addEventHandler("onClientGUIBlur", root, function()
	if source == LoginEdit then triggerEvent("onClientGUIClick", LoginEdit) end --Отправляем те же самые триггеры
	if source == PassEdit then triggerEvent("onClientGUIClick", PassEdit) end --И для пароля тоже
end)


--Теперь создаём кнопку Входа
--Для начала зададим ей координатную высоту
Y = 250 --Обновили
--Создаём кружочки по бокам
local ButRound1 = guiCreateStaticImage(X, Y, 41, 41, Images["Round"], false, TopSide)
local ButRound2 = guiCreateStaticImage(369-41-X, Y, 41, 41, Images["Round"], false, TopSide)
--Теперь центр
local ButCenter = guiCreateStaticImage(X+20, Y, (369-41-2*X), 41, pane, false, TopSide)
--Теперь задаём им цвета
guiSetProperty(ButRound1, "ImageColours", "tl:FFF1B26D tr:FFF1B26D bl:FFF1B26D br:FFF1B26D") --Задаём каждому краю картинки одинаковый цвет - TL - Top Left, BR - Bottom Right, и так далее
guiSetProperty(ButRound2, "ImageColours", "tl:FFF1B26D tr:FFF1B26D bl:FFF1B26D br:FFF1B26D") --И повторяем
guiSetProperty(ButCenter, "ImageColours", "tl:FFF1B26D tr:FFF1B26D bl:FFF1B26D br:FFF1B26D") --И повторяем
--Теперь помещаем текст "Вход" на кнопку
local ButTitle = guiCreateLabel(0, 0, 1, 0.96, "Вход", true, ButCenter) --Здесь мы применяем метод относительных координат, так как в данном случае его очень удобно использовать, ведь здесь большие числа не нужны
guiLabelSetVerticalAlign(ButTitle, "center") --Отцентровываем относительно высоты
guiLabelSetHorizontalAlign(ButTitle, "center") --Отцентровываем относительно длины
guiSetFont(ButTitle, Medium) --Установим шрифт
guiLabelSetColor(ButTitle, 110, 71, 30) --Установим цвет для текста
guiSetEnabled(ButTitle, false) --И сделаем его нетрогаемым

--Теперь сделаем событие при наведении на кнопку входа
--Мы будем делать переливающуюся кнопку
--Для этого нам понадобится:
local AnimatedHover = 0 --Переменная для обозначения анимации. 1 - это навести, 2 - это отвести (вернуть в исходный цвет), 3 - цвет при нажатии
local ColorTable = { --Таблица перехода цветов
	[1] = "F1B26D", --Стандартный цвет, без наведения
	[2] = "F4C287", 
	[3] = "F5CC96",
	[4] = "F6D5A4", --Средний цвет
	[5] = "F8DEB3", 
	[6] = "FAE8C2",
	[7] = "FBEECB" --Самый яркий (полное наведение)
}
local Rater = 1 --Счётчик для цвета
addEventHandler("onClientMouseEnter", root, function() --Событие при наведении на GUI-элемент

	if source == ButCenter or --Если мыш наведена на центральную часть кнопки
		source == ButRound1 or --Или левый круг
		source == ButRound2 --Или правый
		then --То

			AnimatedHover = 1 --Запустим анимацию наведения

	end

end)
--И сразу же её закончим
addEventHandler("onClientMouseLeave", root, function() --Событие при отведении курсора от GUI-элемента

	AnimatedHover = 2 --Во избежания ошибок с появлением окон, при отведении включаем анимацию отведения

end)

--Сделаем более светлое наведение при нажатии
addEventHandler("onClientGUIMouseDown", root, function() --Событие при нажатии на элемент

	if source == ButCenter or --Если нажато на центральную часть кнопки
		source == ButRound1 or --Или левый круг
		source == ButRound2 --Или правый
		then --То

			AnimatedHover = 3 --Запустим анимацию нажатия

	end

end)

--И при отжатии клавиши тоже вернёмся к наведённому цвету
addEventHandler("onClientGUIMouseUp", root, function() --Событие при отжатия мыши от GUI-элемента

	if source == ButCenter or --Если нажато на центральную часть кнопки
		source == ButRound1 or --Или левый круг
		source == ButRound2 --Или правый
		then --То

			AnimatedHover = 4 --Запустим анимацию возвращение к половине

	else 
		AnimatedHover = 2 --Во избежания ошибок с появлением окон, при отведении включаем анимацию отведения
	end
end)

--И приступим к анимированию
addEventHandler("onClientRender", root, function() --Соответственно будем работать с событием Render

	if AnimatedHover > 0 then --Если анимация всё таки включена

		local N, Max = 0, 0 --Создадим переменные, которые будут отвечать за изменение цвета и максимального значения цвета
		if AnimatedHover == 1 then N, Max = 1, 4 end --Если это анимация наведения, то будем добавлять 1, и максимальный цвет будет четвёртый
		if AnimatedHover == 2 then N, Max = -1, 1 end --При анимации отведения, будем отнимать 1, и возвращать на первый цвет
		if AnimatedHover == 3 then N, Max = 1, 7 end --Если анимация нажатия, то будем добавлять 1 до самого последнего цвета
		if AnimatedHover == 4 then N, Max = -1, 4 end --И если анимация отжатия (при условии, что курсор стоит на именно этих кнопках) мы вернём цвет к наведённому

		Rater = Rater+N --К счётчику цвета будем прибавлять переменную изменения цвета

		--Далее нам надо не напароться на проблему, благодаря которой значения будут уходить за рамки имеющегося
		if Max == 1 then --Если максимальное значение равно 1 (в случае с анимацией отведения) (здесь явно будет вычитаться из счётчика)
			if Rater < Max then Rater = Max end --То проверяем, если счётчик меньше минимального значения, то ставим ему минимальное значение
		elseif Max == 7 then --Если максимальное значение равно 7 (в случае с нажатием)
			if Rater > Max then Rater = Max end --То проверяем, если счётчик больше максимального значения, то ставим ему этот максимум
		elseif Max == 4 then --И если максимальное значение равно четырём
			--То тут рассматриваем два случая
			if AnimatedHover == 1 then --Если это анимация наведения
				if Rater > Max then Rater = Max end --То проверяем, больше ли значение счётчика от максимального, и если так - то ставим его ему
			else  --Если это вторая анимация, а именно - отжатия
				if Rater < Max then Rater = Max end --То делаем наоборот, проверяем на минимальность, и ставим её
			end
		end

		if not ColorTable[Rater] then Rater = 1 end --Если счётчик ошибся, то обнуляем его - ставим исходный цвет
		--Создадим переменную для рассчёта цвета, аналогичную параметру
		local Color = "tl:FF"..ColorTable[Rater].." tr:FF"..ColorTable[Rater].." bl:FF"..ColorTable[Rater].." br:FF"..ColorTable[Rater] --Где ColorTable[Rater] - это значение цвета в данной таблице
		--И установим её как параметры изображений
		guiSetProperty(ButRound1, "ImageColours", Color)
		guiSetProperty(ButRound2, "ImageColours", Color)
		guiSetProperty(ButCenter, "ImageColours", Color)

		--И если счётчик достиг своего максимального значения, закрываем его
		if Rater == Max then AnimatedHover = 0 end

	end

end)


--Далее нам понадобится кнопка регистрации
--Она будет размещена на анимированном изображении
--Положение полоски для кнопки регистрации располагается по координатам 113:77, и имеет размеры 146:2
local RegisterLine = guiCreateStaticImage(113, 77, 146, 3, pane, false, BottomSide) --Помещаем её в нижний блок, там где анимация
guiSetProperty(RegisterLine, "ImageColours", "tl:996E471E tr:996E471E bl:00000000 br:00000000") --И установим ей цвет (99 - степень прозрачности)

--Теперь нам нужна кнопка
local RegisterButton = guiCreateLabel(113, 77-25, 146, 25, "Регистрация", false, BottomSide) --Создадим текстовый лейбл для кнопки регистрации
guiLabelSetVerticalAlign(RegisterButton, "center") --Отцентровываем относительно высоты
guiLabelSetHorizontalAlign(RegisterButton, "center") --Отцентровываем относительно длины
guiSetFont(RegisterButton, Bold) --Установим шрифт
guiLabelSetColor(RegisterButton, 110, 71, 30) --Установим цвет для текста

--Создадим обычный информационный лейбл
local InfoLabel = guiCreateLabel(113, 77-55, 146, 30, "Нет аккаунта?", false, BottomSide)
guiLabelSetVerticalAlign(InfoLabel, "center") --Отцентровываем относительно высоты
guiLabelSetHorizontalAlign(InfoLabel, "center") --Отцентровываем относительно длины
guiSetFont(InfoLabel, Regular14) --Установим шрифт
guiLabelSetColor(InfoLabel, 110, 71, 30)

--Теперь сделаем таблицу цветов для кнопки регистрации
local RegisterColors = {
	[1] = {110, 71, 30}, --Поместим в первый пункт таблицы массив с цветами R, G и B - здесь это стандартный цвет
	[2] = {135, 90, 50}, --Здесь цвет при наведении
	[3] = {160, 108, 71} --Здесь цвет при клике
}
--Плавности в данном случае не нужно, ибо прирост цвета совсем небольшой
--Теперь создадим события для наведения
addEventHandler("onClientMouseEnter", root, function()

	if source == RegisterButton then --Если мы наводим на кнопку регистрации
		guiLabelSetColor(RegisterButton, RegisterColors[2][1], RegisterColors[2][2], RegisterColors[2][3]) --То мы ставим цвета из второго пункта таблицы
	end

end)
--При отведении сразу для предотвращения ошибок обнуляем цвет
addEventHandler("onClientMouseLeave", root, function()

	guiLabelSetColor(RegisterButton, RegisterColors[1][1], RegisterColors[1][2], RegisterColors[1][3]) --Возвращаем цвета, они записаны в первом пункте таблицы

end)
--При нажатии на клавишу, делаем её ещё светлее
addEventHandler("onClientGUIMouseDown", root, function()

	if source == RegisterButton then --Если мы нажимаем на кнопку регистрации
		guiLabelSetColor(RegisterButton, RegisterColors[3][1], RegisterColors[3][2], RegisterColors[3][3]) --То мы ставим цвета из третьего пункта таблицы
	end

end)
--При отпускании клавиши, мы обнуляем цвет, если было отпущено вне кнопки, или возвращаем цвет наведения, если курсор всё ещё на кнопке
addEventHandler("onClientGUIMouseUp", root, function()

	if source == RegisterButton then --Если мы отжимаем клавишу от кнопки регистрации
		guiLabelSetColor(RegisterButton, RegisterColors[2][1], RegisterColors[2][2], RegisterColors[2][3]) --То мы ставим цвета наведения
	else --Иначе (если отжимаем клавишу не в пределах кнопки регистрации)
		guiLabelSetColor(RegisterButton, RegisterColors[1][1], RegisterColors[1][2], RegisterColors[1][3]) --Мы ставим чистый цвет для кнопки
	end

end)

--Функция для открытия/закрытия панели логина
function visibleLoginPanel(bool) 
	showCursor(bool) --Показать/скрыть курсор
	guiSetVisible(BackShadow, bool) --Показать/скрыть главный элемент окна логина
	showPlayerHudComponent("all", not bool) --Скрыть/показать худ игроку
	showChat(not bool) --Скрыть/показать чат игроку
	if bool then startLoginAnimation(math.random(3)) --Если панель открывается, то начать рандомную анимацию из 3х существующих
	else stopLoginAnimation() end --Иначе закрыть анимацию
end

bindKey("o", "down", function() --Создать бинд на кнопку О для открытия или закрытия логин панели
	visibleLoginPanel(not guiGetVisible(BackShadow)) --Открыть/закрыть логин панель в зависимости от её видимости - если её не видно, то открыть, иначе - закрыть
end)

--Сначала просто закрыть окно
guiSetVisible(BackShadow, false)
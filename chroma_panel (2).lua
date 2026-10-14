-- ВЕРСИЯ С НОВЫМ GUI (тёмная тема, градиентные кнопки, одна панель за раз). Логика такая же, как в chroma_panel.lua.
-- Chroma Panel: панель R/G/B + коды + диагностика + подбор цветов + сброс
-- K или кнопка  - открыть/закрыть. Панель перетаскивается.
-- 🇺/🇺🇸 - переключатель языка. 🔄 - сброс скрипта.
-- НОВОЕ: кнопка «Инструкция», 🎲 в «Примерке» (рандомайзер, умный пропуск, обход предметов).

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local TOGGLE_KEY = Enum.KeyCode.K
local NEW_GUI = true  -- false = обычный вид, true = новый GUI (файл chroma_panel_newgui.lua)

------------------------------------------------------------
-- ПЕРЕВОД
------------------------------------------------------------
local currentLang = "ru"

local L = {
	title = {ru = "Цвет в палитру игры  [K]", en = "Color to game palette  [K]"},
	applyBtn = {ru = "Применить цвет", en = "Apply color"},
	methodBtn = {ru = "Метод 1", en = "Method 1"},
	codeBtn = {ru = "Код", en = "Code"},
	diagBtn = {ru = "1) Диагностика", en = "1) Diagnostics"},
	spyBtn = {ru = "2) Remote spy (25с)", en = "2) Remote spy (25s)"},
	colorNameLabel = {ru = "Название / HEX / RGB:", en = "Name / HEX / RGB:"},
	colorNameHint = {ru = "(lime, #FF5733, 255,87,51)", en = "(lime, #FF5733, 255,87,51)"},
	historyLabel = {ru = "Прошлый: —", en = "History: —"},
	matchLabel = {ru = "Подходящие:", en = "Matching:"},
	rPh = {ru = "R", en = "R"},
	gPh = {ru = "G", en = "G"},
	bPh = {ru = "B", en = "B"},
	codePh = {ru = "lime / #FF5733 / RGB", en = "lime / #FF5733 / RGB"},
	wheelTitle = {ru = "Круговая палитра", en = "Color wheel"},
	darkerBtn = {ru = "Темнее", en = "Darker"},
	lighterBtn = {ru = "Ярче", en = "Lighter"},
	wheelApply = {ru = "Применить", en = "Apply"},
	resetBtn = {ru = " Сброс", en = "🔄 Reset"},
	resetConfirm = {ru = "⚠ Точно?", en = "⚠ Sure?"},
	msgReady = {ru = "Готово. K - открыть/закрыть.", en = "Ready. K - toggle."},
	msgFieldsNotFound = {ru = "Поля R/G/B не найдены.", en = "R/G/B fields not found."},
	msgApplied = {ru = "Готово: %d,%d,%d (метод %d)", en = "Done: %d,%d,%d (method %d)"},
	msgNotChanged = {ru = "Цвет не изменился (%d,%d,%d)", en = "Color didn't change (%d,%d,%d)"},
	msgEnterThree = {ru = "Введите 3 числа (0-255)", en = "Enter 3 numbers (0-255)"},
	msgEnterName = {ru = "Введите цвет/HEX/RGB", en = "Enter color/HEX/RGB"},
	msgUnknownCode = {ru = "Неизвестный код: %s", en = "Unknown code: %s"},
	msgSimilar = {ru = ". Похожие: %s", en = ". Similar: %s"},
	msgDiagReady = {ru = "Готово: F9 и palette_info.txt", en = "Done: F9 and palette_info.txt"},
	msgDiagNoFields = {ru = "Поля не найдены", en = "Fields not found"},
	msgDiagNoDecompile = {ru = "decompile недоступен", en = "decompile unavailable"},
	msgDiagSaved = {ru = "Сохранено: %s", en = "Saved: %s"},
	msgSpyNoHook = {ru = "Перехват недоступен", en = "Hook unavailable"},
	msgSpyStart = {ru = "Слежение 25с...", en = "Spy 25s..."},
	msgSpyEnd = {ru = "Слежение: %d вызовов", en = "Spy: %d calls"},
	msgSpyFail = {ru = "Перехват не удался", en = "Hook failed"},
	tryName = {ru = "Примерка", en = "Try-on"},
	listName = {ru = "Цвета", en = "Colors"},
	tryTitle = {ru = "Примерка цветов", en = "Color try-on"},
	slot1 = {ru = "Цвет 1", en = "Color 1"},
	slot2 = {ru = "Цвет 2", en = "Color 2"},
	slot3 = {ru = "Цвет 3", en = "Color 3"},
	slotOutline = {ru = "Контур", en = "Outline"},
	modeTwo = {ru = "2 цвета + контур", en = "2 colors + outline"},
	modeThree = {ru = "3 цвета + контур", en = "3 colors + outline"},
	applyAll = {ru = "Применить всё", en = "Apply all"},
	autoBtn = {ru = "Авто", en = "Auto"},
	resetColors = {ru = "Сброс цветов", en = "Reset colors"},
	listTitle = {ru = "Все цвета", en = "All colors"},
	searchPh = {ru = "Поиск: красный, lime, #FF0000", en = "Search: red, lime, #FF0000"},
	listApply = {ru = "Применить", en = "Apply"},
	listPicked = {ru = "Выбрано: %s", en = "Selected: %s"},
	listNone = {ru = "Сначала выберите цвет в списке", en = "Pick a color from the list first"},
	favFilter = {ru = "★ Избр.", en = "★ Favs"},
	favSaveCur = {ru = "★ Сохранить цвет из R/G/B", en = "★ Save color from R/G/B"},
	msgFavAdded = {ru = "Добавлено в избранное: %s", en = "Added to favorites: %s"},
	msgFavHave = {ru = "Этот цвет уже в избранном", en = "This color is already a favorite"},
	msgFavEmpty = {ru = "Избранное пусто: нажмите ☆ у цвета", en = "No favorites yet: press ☆ on a color"},
	myColor = {ru = "Мой цвет", en = "My color"},
	catHair = {ru = "Волосы", en = "Hair"},
	catTop = {ru = "Кофта", en = "Top"},
	catPants = {ru = "Штаны", en = "Pants"},
	catShoes = {ru = "Обувь", en = "Shoes"},
	catAcc = {ru = "Шапка", en = "Hat"},
	catHairFull = {ru = "Волосы", en = "Hair"},
	catTopFull = {ru = "Кофта / куртка", en = "Top / jacket"},
	catPantsFull = {ru = "Штаны / брюки", en = "Pants"},
	catShoesFull = {ru = "Обувь", en = "Shoes"},
	catAccFull = {ru = "Аксессуар", en = "Accessory"},
	learnName = {ru = "Разметка предметов", en = "Item mapping"},
	learnTitle = {ru = "Разметка предметов", en = "Item mapping"},
	learnHint = {ru = "1) Нажмите «Выбрать» у категории. 2) Кликайте по предметам в меню игры (повторный клик убирает). 3) Нажмите «Выбрать» ещё раз - выбор сохранится. «Сброс» во время выбора убирает отмеченное, в обычном режиме очищает категорию.", en = "1) Press Pick on a category. 2) Click items in the game menu (click again to unmark). 3) Press Pick again to save. Reset while picking clears the marks, otherwise it clears the category."},
	learnAutoOn = {ru = "Автоопределение: ВКЛ", en = "Auto-detect: ON"},
	learnAutoOff = {ru = "Автоопределение: ВЫКЛ", en = "Auto-detect: OFF"},
	learnPick = {ru = "Выбрать: %s (%d)", en = "Pick: %s (%d)"},
	learnDone = {ru = "Готово: %s - нажмите ещё раз", en = "Done: %s - press again"},
	learnReset = {ru = "Сброс", en = "Reset"},
	msgLearnStart = {ru = "Кликайте по предметам в меню игры, потом нажмите кнопку ещё раз.", en = "Click items in the game menu, then press the button again."},
	msgLearnSaved = {ru = "Сохранено предметов: %d", en = "Items saved: %d"},
	msgLearnBusy = {ru = "Сначала завершите выбор (нажмите активную кнопку ещё раз).", en = "Finish the current pick first (press the active button again)."},
	msgLearnTab = {ru = "Вкладка меню запомнена: предметы, которые отметите дальше, будут искаться на ней.", en = "Menu tab remembered: items you mark next will be looked for on it."},
	msgLearnMark = {ru = "Отмечено: %s", en = "Marked: %s"},
	msgLearnUnmark = {ru = "Снято: %s", en = "Unmarked: %s"},
	msgLearnNoName = {ru = "Не удалось определить название предмета под курсором.", en = "Could not read the item name under the cursor."},
	msgLearnCleared = {ru = "Очищено: %s", en = "Cleared: %s"},
	msgLearnAuto = {ru = "Категория: %s (по вашей разметке)", en = "Category: %s (from your mapping)"},
	msgCatFound = {ru = " Категория: %s.", en = " Category: %s."},
	msgCatMany = {ru = " Видно несколько категорий (%s) - выберите вручную.", en = " Several categories visible (%s) - pick manually."},
	msgCatNone = {ru = " Категорию по тексту игры определить не удалось - выберите вручную.", en = " Could not detect the category from game text - pick manually."},
	msgSlotsApplied = {ru = "Слотов применено: %d из %d.", en = "Slots applied: %d of %d."},
	msgSlotMissing = {ru = " Вкладки не найдены: %s.", en = " Tabs not found: %s."},
	msgSlotUnsure = {ru = " Не подтверждено: %s.", en = " Not confirmed: %s."},
	msgAutoThree = {ru = "Определено: 3 цвета + контур", en = "Detected: 3 colors + outline"},
	msgAutoTwo = {ru = "Определено: 2 цвета + контур", en = "Detected: 2 colors + outline"},
	msgAutoNew = {ru = "Новая настройка: переключайте режим кнопкой +/− вручную.", en = "New settings: switch the mode with the +/- button."},
	msgAutoFail = {ru = "Не удалось определить. Откройте вкладку цветов у предмета (старая настройка).", en = "Could not detect. Open the item's color tab (old settings)."},

	-- ===== новое: инструкция, рандомайзер, умный пропуск, обход предметов =====
	instrName = {ru = "Инструкция", en = "Guide"},
	instrTitle = {ru = "Инструкция", en = "Guide"},
	instrT1 = {ru = "Начало", en = "Start"},
	instrS1 = {
		ru = [[<b><font color="#9FC0FF">БЫСТРЫЙ СТАРТ</font></b>
1. Откройте в игре меню персонажа и нужную категорию (волосы, кофта, штаны…).
2. Нажмите «+ Примерка» и выберите категорию вверху.
3. Нажмите слот (Цвет 1 / 2 / 3 / Контур) и задайте цвет: поля R/G/B, круг, код или список «Цвета».
4. Нажмите «Применить всё» - скрипт сам откроет вкладки Цвет 1/2/3/Контур в игре и впишет цвета.
5. Нужно покрасить сразу все причёски или вещи? Сначала «Разметка», потом 🎲 → «Обход: все предметы» → «▶ Запуск».

<b><font color="#9FC0FF">ГДЕ ЧТО ИСКАТЬ</font></b>
• Вкладка «Примерка» - слоты, иконка предмета, «Применить всё».
• Вкладка «Рандом» - режимы «Похожие» и «Рандом», настройки 🎲.
• Вкладка «Цвета» - главное окно, список цветов, избранное ★.
• Вкладка «Разметка» - какие предметы игры считать кофтой, штанами и т.д.
• Вкладка «Проблемы» - если что-то не работает.

<b><font color="#9FC0FF">ВАЖНО</font></b>
• Меню персонажа нужной категории должно быть открыто до запуска.
• Не закрывайте панелями плитки предметов - клики идут по экрану.
• Текст листается колесом мыши, ползунком справа или кнопками ▲ ▼.]],
		en = [[<b><font color="#9FC0FF">QUICK START</font></b>
1. Open the character menu and the category you need in the game (hair, top, pants...).
2. Press "+ Try-on" and pick a category at the top.
3. Press a slot (Color 1 / 2 / 3 / Outline) and set a color: R/G/B fields, wheel, code or the "Colors" list.
4. Press "Apply all" - the script opens the Color 1/2/3/Outline tabs in the game and types the colors in.
5. Want to paint every hairstyle or item at once? First "Item mapping", then 🎲 → "Scope: all items" → "▶ Run".

<b><font color="#9FC0FF">WHERE TO LOOK</font></b>
• "Try-on" tab - slots, item icon, "Apply all".
• "Random" tab - "Similar" and "Random" modes, 🎲 settings.
• "Colors" tab - main window, color list, favorites ★.
• "Mapping" tab - which game items count as top, pants, etc.
• "Issues" tab - if something does not work.

<b><font color="#9FC0FF">IMPORTANT</font></b>
• The character menu of the right category must be open before running.
• Don't cover item tiles with panels - clicks go to the screen.
• The text scrolls with the mouse wheel, the scrollbar on the right or the ▲ ▼ buttons.]],
	},
	instrT2 = {ru = "Примерка", en = "Try-on"},
	instrS2 = {
		ru = [[<b><font color="#9FC0FF">КАТЕГОРИИ</font></b>
Вверху: Волосы, Кофта, Штаны, Обувь, Шапка. У каждой своя иконка и свои цвета - при переключении они не сбрасываются.
• Волосы - 3 цвета + контур.
• Кофта, Штаны, Обувь - 2 цвета + контур.
• Шапка (аксессуар) - 2 или 3 цвета + контур: переключатель [+] / [−] в заголовке.

<b><font color="#9FC0FF">СЛОТЫ</font></b>
Справа от иконки: Цвет 1, Цвет 2, Цвет 3, Контур. Нажмите слот и задайте цвет (поля R/G/B, круг, список, код). Цвет сразу виден на иконке.
• Волосы: Цвет 1 - верх, Цвет 2 - низ (смешиваются по центру), Цвет 3 - блик внутри.

<b><font color="#9FC0FF">КНОПКИ</font></b>
• «Применить всё» - скрипт нажимает вкладки Цвет 1/2/3/Контур в игре и вписывает цвета.
• «Авто» - определяет категорию и 2 или 3 цвета по тексту меню игры.
• «Сброс цветов» - возвращает цвета текущей категории.
• «+★» и квадраты ☆ внизу - быстрые слоты избранного: «+★» сохраняет цвет активного слота, квадрат вставляет цвет в слот.]],
		en = [[<b><font color="#9FC0FF">CATEGORIES</font></b>
At the top: Hair, Top, Pants, Shoes, Hat. Each has its own icon and its own colors - they are kept when you switch.
• Hair - 3 colors + outline.
• Top, Pants, Shoes - 2 colors + outline.
• Hat (accessory) - 2 or 3 colors + outline: the [+] / [−] switch in the title.

<b><font color="#9FC0FF">SLOTS</font></b>
Next to the icon: Color 1, Color 2, Color 3, Outline. Press a slot and set a color (R/G/B fields, wheel, list, code). The icon shows it at once.
• Hair: Color 1 - top, Color 2 - bottom (blended in the middle), Color 3 - highlight inside.

<b><font color="#9FC0FF">BUTTONS</font></b>
• "Apply all" - the script presses the Color 1/2/3/Outline tabs in the game and types the colors in.
• "Auto" - detects the category and 2 or 3 colors from the game menu text.
• "Reset colors" - restores the colors of the current category.
• "+★" and the ☆ squares at the bottom - quick favorite slots: "+★" saves the active slot color, a square puts that color into the slot.]],
	},
	instrT3 = {ru = "Рандом", en = "Random"},
	instrS3 = {
		ru = [[<b><font color="#9FC0FF">ДВА РЕЖИМА</font></b>
Переключатели под слотами только ВКЛЮЧАЮТ режим (повторное нажатие выключает, включён может быть один). Запускает всё кнопка «▶ Запуск» в окне 🎲.

<b><font color="#9FC0FF">+ ПОХОЖИЕ</font></b>
Образец - цвет, который вы задали последним (если ничего не вписывали - Цвет 1). Скрипт ищет в ВСЁМ списке похожие цвета и ставит их в слоты, отмеченные [x]. Стиль выбирается в 🎲:
  - «рядом с образцом»: образец остаётся на своём слоте, похожие идут в следующие, контур - тёмный оттенок образца;
  - «ярче / темнее»: Цвет 1 ярче образца, Цвет 2 темнее, Цвет 3 ещё темнее, контур тёмный;
  - «вперемешку»: образец и похожие раскладываются по слотам случайно.
Каждый запуск даёт новый вариант.

<b><font color="#9FC0FF">+ РАНДОМ</font></b>
Цвета берутся случайно из ВСЕГО списка и подбираются так, чтобы не быть слишком похожими.

<b><font color="#9FC0FF">НАСТРОЙКИ 🎲 (свои у каждой категории)</font></b>
• [x] / [  ] у слотов - какие цвета можно менять местами и красить. Снимите [x] с «Контур» - контур останется как есть.
• «Обход: 1 предмет / все предметы» - красить выбранный предмет или все предметы категории из «Разметки».
• «▶ Запуск» - выполняет включённый режим или красит текущими цветами. Во время обхода кнопка меняется на «■ Стоп».
• «↻ Бросить палитру» - новая палитра только на иконке; в игру попадёт через «Применить всё» или «▶ Запуск».
• «Палитра: одна на все / у каждого своя» - для «все предметы».
• «Контур тёмный» - случайный контур только из тёмных цветов.
• «🎲 Рандом: ВКЛ/ВЫКЛ» и «Перемешать сейчас» - поменять местами цвета отмеченных слотов.
• «Пропускать подходящие» - если в полях RGB игры уже стоит почти нужный или подходящий по сочетанию цвет, он не перезаписывается, скрипт идёт к следующему слоту.
• «Пауза» - сколько секунд ждать после выбора предмета. Если игра тормозит, увеличьте.]],
		en = [[<b><font color="#9FC0FF">TWO MODES</font></b>
The switches under the slots only TURN ON a mode (press again to turn off, only one can be on). Everything runs with the "▶ Run" button in the 🎲 window.

<b><font color="#9FC0FF">+ SIMILAR</font></b>
The sample is the color you set last (if you set nothing - Color 1). The script searches the WHOLE list for similar colors and puts them into the slots ticked [x]. The style is chosen in 🎲:
  - "near the sample": the sample stays on its slot, similar colors go to the next slots, the outline is a dark shade of the sample;
  - "lighter / darker": Color 1 brighter than the sample, Color 2 darker, Color 3 darker still, the outline dark;
  - "shuffled": the sample and similar colors are laid out over the slots randomly.
Every run gives a new variant.

<b><font color="#9FC0FF">+ RANDOM</font></b>
Colors come at random from the WHOLE list and are kept apart from each other.

<b><font color="#9FC0FF">SETTINGS 🎲 (separate per category)</font></b>
• [x] / [  ] on slots - which colors may be swapped and painted. Untick "Outline" and the outline stays as is.
• "Scope: 1 item / all items" - paint the selected item or all items of the category from "Mapping".
• "▶ Run" - runs the mode that is on or paints with the current colors. During a walk the button turns into "■ Stop".
• "↻ Roll palette" - a new palette on the icon only; it reaches the game via "Apply all" or "▶ Run".
• "Palette: one for all / own per item" - for "all items".
• "Dark outline" - a random outline from dark colors only.
• "🎲 Random: ON/OFF" and "Shuffle now" - swap the colors of ticked slots.
• "Skip matching" - if the game's RGB fields already hold a nearly right or matching color, it is not overwritten and the script moves on.
• "Delay" - seconds to wait after picking an item. Raise it if the game is slow.]],
	},
	instrT4 = {ru = "Цвета", en = "Colors"},
	instrS4 = {
		ru = [[<b><font color="#9FC0FF">ГЛАВНОЕ ОКНО</font></b>
• R / G / B - числа цвета. «Применить цвет» вписывает их в поля игры.
• «Код» - название цвета, HEX (#FF5733) или RGB (255,87,51).
• [+] справа вверху - круговая палитра.
• «Подходящие» - цвета, которые сочетаются с текущим.
• Кнопка «Метод» - способ ввода чисел в игру. Если цвет не меняется, переключите на другой.

<b><font color="#9FC0FF">СПИСОК «ЦВЕТА»</font></b>
• Поиск по названию или HEX.
• Нажмите на цвет - он попадёт в поля R/G/B (и в активный слот примерки).
• ☆ у цвета - добавить в избранное, ★ - убрать.
• «★ Избр.» показывает только избранные.
• «★ Сохранить цвет из R/G/B» - сохранить свой цвет в избранное.
• Избранное запоминается между запусками, если executor умеет записывать файлы.]],
		en = [[<b><font color="#9FC0FF">MAIN WINDOW</font></b>
• R / G / B - color numbers. "Apply color" types them into the game's fields.
• "Code" - color name, HEX (#FF5733) or RGB (255,87,51).
• [+] top right - color wheel.
• "Matching" - colors that go well with the current one.
• The "Method" button - how numbers are typed into the game. If the color doesn't change, switch it.

<b><font color="#9FC0FF">COLORS LIST</font></b>
• Search by name or HEX.
• Press a color - it goes into the R/G/B fields (and the active try-on slot).
• ☆ on a color - add to favorites, ★ - remove.
• "★ Favs" shows favorites only.
• "★ Save color from R/G/B" - save your own color to favorites.
• Favorites are kept between runs if your executor can write files.]],
	},
	instrT5 = {ru = "Разметка", en = "Mapping"},
	instrS5 = {
		ru = [[<b><font color="#9FC0FF">ЗАЧЕМ</font></b>
Скрипт должен знать, какие предметы игры вы считаете кофтой, штанами, волосами и т.д. Тогда он сам определяет категорию и умеет красить все предметы категории подряд.

<b><font color="#9FC0FF">КАК РАЗМЕТИТЬ</font></b>
1. Откройте «+ Разметка предметов».
2. Нажмите «Выбрать: Кофта» (или другую категорию).
3. Если предметы лежат на другой вкладке меню игры (👤 / 👕 0 / 👕 1), сначала нажмите эту вкладку в игре - скрипт запомнит её.
4. Кликайте по плиткам в меню игры, которые считаете кофтами (повторный клик снимает отметку).
5. Нажмите ту же кнопку ещё раз - выбор сохранится.
• «Сброс» во время выбора убирает только отмеченное, в обычном режиме - очищает категорию.
• У предмета только одна категория: новая отметка переносит его.

<b><font color="#9FC0FF">АВТООПРЕДЕЛЕНИЕ</font></b>
Кнопка вверху окна. Когда она включена, клик по размеченной плитке сам переключает категорию в «Примерке».

<b><font color="#9FC0FF">ОБХОД ВСЕХ ПРЕДМЕТОВ</font></b>
Область «все предметы» ходит только по размеченным предметам: сама переключает вкладку меню игры, листает список вниз до нужной плитки и красит её. Если плитка не найдена, она пропускается, а в конце видно, сколько не найдено.]],
		en = [[<b><font color="#9FC0FF">WHY</font></b>
The script needs to know which game items you consider a top, pants, hair, etc. Then it detects the category itself and can paint every item of a category in a row.

<b><font color="#9FC0FF">HOW TO MARK</font></b>
1. Open "+ Item mapping".
2. Press "Pick: Top" (or another category).
3. If the items are on another tab of the game menu (👤 / 👕 0 / 👕 1), press that tab in the game first - the script remembers it.
4. Click the tiles in the game menu you consider tops (click again to unmark).
5. Press the same button again - the pick is saved.
• "Reset" while picking clears only the marks, otherwise it clears the category.
• An item has one category: a new mark moves it.

<b><font color="#9FC0FF">AUTO-DETECT</font></b>
The button at the top of the window. When on, clicking a marked tile switches the category in "Try-on" by itself.

<b><font color="#9FC0FF">WALKING OVER ALL ITEMS</font></b>
The "all items" scope visits only marked items: it switches the game menu tab itself, scrolls the list down to the tile and paints it. If a tile is not found it is skipped and the end message shows how many were missed.]],
	},
	instrT6 = {ru = "Проблемы", en = "Issues"},
	instrS6 = {
		ru = [[<b><font color="#9FC0FF">ЧИСЛА МЕНЯЮТСЯ, ЦВЕТ В ИГРЕ - НЕТ</font></b>
Переключите кнопку «Метод» в главном окне и нажмите «Применить цвет» ещё раз.

<b><font color="#9FC0FF">ПЛИТКА НЕ НАЙДЕНА / ПРОПУЩЕНА</font></b>
Откройте в игре меню нужной категории, не закрывайте плитки панелями скрипта, проверьте «Разметку».

<b><font color="#9FC0FF">СЛОТ НЕ ПОДТВЕРЖДЁН</font></b>
Увеличьте «Пауза» в 🎲, если игра тормозит, и повторите «Применить всё».

<b><font color="#9FC0FF">ЦВЕТ ПРОПУЩЕН</font></b>
Включена «Пропускать подходящие»: выключите её, если нужно записать цвет в любом случае.

<b><font color="#9FC0FF">НЕ ТА КАТЕГОРИЯ</font></b>
Выберите категорию вверху «Примерки» вручную или повторите «Разметку».

<b><font color="#9FC0FF">ИЗБРАННОЕ НЕ СОХРАНЯЕТСЯ</font></b>
Executor не даёт записывать файлы - избранное и разметка живут до перезапуска скрипта.]],
		en = [[<b><font color="#9FC0FF">NUMBERS CHANGE BUT THE GAME COLOR DOES NOT</font></b>
Switch the "Method" button in the main window and press "Apply color" again.

<b><font color="#9FC0FF">TILE NOT FOUND / SKIPPED</font></b>
Open the category menu in the game, don't cover tiles with script panels, check "Mapping".

<b><font color="#9FC0FF">SLOT NOT CONFIRMED</font></b>
Raise "Delay" in 🎲 if the game is slow and press "Apply all" again.

<b><font color="#9FC0FF">COLOR SKIPPED</font></b>
"Skip matching" is on: turn it off to write the color anyway.

<b><font color="#9FC0FF">WRONG CATEGORY</font></b>
Pick the category at the top of "Try-on" manually or redo "Mapping".

<b><font color="#9FC0FF">FAVORITES NOT SAVED</font></b>
Your executor can't write files - favorites and mapping live until the script restarts.]],
	},
	autoTitle = {ru = "Авто и рандом", en = "Auto & random"},
	randOn = {ru = "🎲 Рандом: ВКЛ", en = "🎲 Random: ON"},
	randOff = {ru = "🎲 Рандом: ВЫКЛ", en = "🎲 Random: OFF"},
	swapLbl = {ru = "Менять: [x] да, [  ] не трогать", en = "Change: [x] yes, [  ] keep"},
	shuffleNow = {ru = "Перемешать сейчас", en = "Shuffle now"},
	smartOn = {ru = "Пропускать подходящие: ВКЛ", en = "Skip matching: ON"},
	smartOff = {ru = "Пропускать подходящие: ВЫКЛ", en = "Skip matching: OFF"},
	smartHint = {ru = "Если в полях RGB игры уже стоит подходящий цвет - не трогать, идти к следующему слоту.", en = "If the game's RGB fields already hold a fitting color - leave it and go to the next slot."},
	walkInfo = {ru = "Предметов в разметке: %d", en = "Marked items: %d"},
	delayLbl = {ru = "Пауза: %.1f с", en = "Delay: %.1f s"},
	walkStart = {ru = "▶ Обход предметов", en = "▶ Walk items"},
	walkStop = {ru = "■ Стоп", en = "■ Stop"},
	walkNote = {ru = "Ходит по предметам из «Разметки» этой категории.", en = "Visits the items marked in Item mapping for this category."},
	msgShuffled = {ru = "Цвета перемешаны", en = "Colors shuffled"},
	msgShuffleFew = {ru = "Отметьте минимум 2 слота для обмена", en = "Tick at least 2 slots to swap"},
	msgShuffleSame = {ru = "Выбранные цвета одинаковые - менять нечего", en = "Selected colors are identical - nothing to swap"},
	msgWalkNoItems = {ru = "В категории «%s» нет размеченных предметов. Откройте «Разметка предметов» и отметьте их.", en = "No marked items in \"%s\". Open Item mapping and mark them."},
	msgWalkProgress = {ru = "Обход %d/%d: %s", en = "Walk %d/%d: %s"},
	msgWalkDone = {ru = "Обход завершён: покрашено %d из %d. Не найдено в меню: %d.", en = "Walk finished: painted %d of %d. Not found in menu: %d."},
	msgWalkStopped = {ru = "Обход остановлен: покрашено %d из %d. Не найдено в меню: %d.", en = "Walk stopped: painted %d of %d. Not found in menu: %d."},
	msgSlotKept = {ru = " Оставлено (уже подходит): %s.", en = " Kept (already fits): %s."},
	palStyleNear = {ru = "Похожие: рядом с образцом", en = "Similar: near the sample"},
	palStyleLight = {ru = "Похожие: ярче / темнее", en = "Similar: lighter / darker"},
	palStyleMix = {ru = "Похожие: вперемешку", en = "Similar: shuffled"},
	palModeNone = {ru = "текущие цвета", en = "current colors"},
	palModeSim = {ru = "Похожие", en = "Similar"},
	palModeRnd = {ru = "Рандом", en = "Random"},
	palRunWith = {ru = "▶ Запуск: %s", en = "▶ Run: %s"},
	palSimOn = {ru = "− Похожие: ВКЛ", en = "− Similar: ON"},
	palSimOff = {ru = "+ Похожие: ВЫКЛ", en = "+ Similar: OFF"},
	palRndOn = {ru = "− Рандом: ВКЛ", en = "− Random: ON"},
	palRndOff = {ru = "+ Рандом: ВЫКЛ", en = "+ Random: OFF"},
	palScopeOne = {ru = "Обход: 1 предмет", en = "Scope: 1 item"},
	palScopeAll = {ru = "Обход: все предметы", en = "Scope: all items"},
	msgPalNoMode = {ru = "Сначала включите «+ Похожие» или «+ Рандом»", en = "Turn on \"+ Similar\" or \"+ Random\" first"},
	palStopBtn = {ru = "■ Стоп", en = "■ Stop"},
	palRollBtn = {ru = "↻ Бросить палитру", en = "↻ Roll palette"},
	palSameOn = {ru = "Палитра: одна на все", en = "Palette: one for all"},
	palSameOff = {ru = "Палитра: у каждого своя", en = "Palette: own per item"},
	palDarkOn = {ru = "Контур тёмный: ВКЛ", en = "Dark outline: ON"},
	palDarkOff = {ru = "Контур тёмный: ВЫКЛ", en = "Dark outline: OFF"},
	msgPalSimilar = {ru = "Подобраны похожие цвета из списка, применяю...", en = "Similar colors picked from the list, applying..."},
	msgPalRolled = {ru = "Случайная палитра из всего списка", en = "Random palette from the whole list"},
	msgPalBusy = {ru = "Дождитесь конца обхода/применения", en = "Wait for the walk/apply to finish"},
	msgPalNoSlots = {ru = "В 🎲 отметьте [x], какие цвета можно менять", en = "In 🎲 tick [x] which colors may change"},
}

local function t(key)
	local entry = L[key]
	if not entry then return key end
	return entry[currentLang] or entry.ru or key
end

local translatable = {}
local function regTranslatable(obj, key, isPlaceholder)
	translatable[#translatable + 1] = {obj = obj, key = key, isPlaceholder = isPlaceholder}
end

------------------------------------------------------------
-- УТИЛИТЫ
------------------------------------------------------------
local function norm(s)
	local ok, res = pcall(function()
		local out = {}
		for _, cp in utf8.codes(s) do
			if cp >= 0x410 and cp <= 0x42F then cp += 32 end
			if cp == 0x401 or cp == 0x451 then cp = 0x435 end
			if cp >= 65 and cp <= 90 then cp += 32 end
			local ch = utf8.char(cp)
			if not ch:match("[%s_%-]") then table.insert(out, ch) end
		end
		return table.concat(out)
	end)
	local r = ok and res or string.lower((string.gsub(s, "[%s_%-]", "")))
	return (string.gsub(r, "grey", "gray"))
end

local function hex(h)
	return { tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16) }
end

local function to255(x) return math.clamp(math.floor(x * 255 + 0.5), 0, 255) end
local function hexOf(c) return ("#%02X%02X%02X"):format(to255(c.R), to255(c.G), to255(c.B)) end

------------------------------------------------------------
-- ПОДБОР СОЧЕТАЮЩИХСЯ ЦВЕТОВ
------------------------------------------------------------
local function getMatchingColors(r, g, b)
	local c = Color3.fromRGB(r, g, b)
	local h, s, v = c:ToHSV()
	if v < 0.05 then
		return {{255,255,255,"white"},{255,215,0,"gold"},{255,0,0,"red"},{0,255,255,"cyan"}}
	end
	if s < 0.1 then
		return {{220,50,50,"red"},{50,120,220,"blue"},{50,180,80,"green"},{240,180,50,"yellow"}}
	end
	local matches = {}
	local cc = Color3.fromHSV((h + 0.5) % 1, s, v)
	table.insert(matches, {to255(cc.R), to255(cc.G), to255(cc.B), "complement"})
	local a1 = Color3.fromHSV((h + 0.083) % 1, s, v)
	table.insert(matches, {to255(a1.R), to255(a1.G), to255(a1.B), "analogous1"})
	local a2 = Color3.fromHSV((h - 0.083 + 1) % 1, s, v)
	table.insert(matches, {to255(a2.R), to255(a2.G), to255(a2.B), "analogous2"})
	local t1 = Color3.fromHSV((h + 0.333) % 1, s, v)
	table.insert(matches, {to255(t1.R), to255(t1.G), to255(t1.B), "triad"})
	return matches
end

------------------------------------------------------------
-- БАЗА ЦВЕТОВ
------------------------------------------------------------
local CUSTOM = { ["Wild Blue Crayola"] = { 122, 137, 184 } }

local CSS = {
	{"AliceBlue","F0F8FF"},{"AntiqueWhite","FAEBD7"},{"Aqua","00FFFF"},{"Aquamarine","7FFFD4"},
	{"Azure","F0FFFF"},{"Beige","F5F5DC"},{"Bisque","FFE4C4"},{"Black","000000"},
	{"BlanchedAlmond","FFEBCD"},{"Blue","0000FF"},{"BlueViolet","8A2BE2"},{"Brown","A52A2A"},
	{"BurlyWood","DEB887"},{"CadetBlue","5F9EA0"},{"Chartreuse","7FFF00"},{"Chocolate","D2691E"},
	{"Coral","FF7F50"},{"CornflowerBlue","6495ED"},{"Cornsilk","FFF8DC"},{"Crimson","DC143C"},
	{"Cyan","00FFFF"},{"DarkBlue","00008B"},{"DarkCyan","008B8B"},{"DarkGoldenrod","B8860B"},
	{"DarkGray","A9A9A9"},{"DarkGreen","006400"},{"DarkKhaki","BDB76B"},{"DarkMagenta","8B008B"},
	{"DarkOliveGreen","556B2F"},{"DarkOrange","FF8C00"},{"DarkOrchid","9932CC"},{"DarkRed","8B0000"},
	{"DarkSalmon","E9967A"},{"DarkSeaGreen","8FBC8F"},{"DarkSlateBlue","483D8B"},{"DarkSlateGray","2F4F4F"},
	{"DarkTurquoise","00CED1"},{"DarkViolet","9400D3"},{"DeepPink","FF1493"},{"DeepSkyBlue","00BFFF"},
	{"DimGray","696969"},{"DodgerBlue","1E90FF"},{"Firebrick","B22222"},{"FloralWhite","FFFAF0"},
	{"ForestGreen","228B22"},{"Fuchsia","FF00FF"},{"Gainsboro","DCDCDC"},{"GhostWhite","F8F8FF"},
	{"Gold","FFD700"},{"Goldenrod","DAA520"},{"Gray","808080"},{"Green","008000"},
	{"GreenYellow","ADFF2F"},{"Honeydew","F0FFF0"},{"HotPink","FF69B4"},{"IndianRed","CD5C5C"},
	{"Indigo","4B0082"},{"Ivory","FFFFF0"},{"Khaki","F0E68C"},{"Lavender","E6E6FA"},
	{"LavenderBlush","FFF0F5"},{"LawnGreen","7CFC00"},{"LemonChiffon","FFFACD"},{"LightBlue","ADD8E6"},
	{"LightCoral","F08080"},{"LightCyan","E0FFFF"},{"LightGoldenrodYellow","FAFAD2"},{"LightGray","D3D3D3"},
	{"LightGreen","90EE90"},{"LightPink","FFB6C1"},{"LightSalmon","FFA07A"},{"LightSeaGreen","20B2AA"},
	{"LightSkyBlue","87CEFA"},{"LightSlateGray","778899"},{"LightSteelBlue","B0C4DE"},{"LightYellow","FFFFE0"},
	{"Lime","00FF00"},{"LimeGreen","32CD32"},{"Linen","FAF0E6"},{"Magenta","FF00FF"},
	{"Maroon","800000"},{"MediumAquamarine","66CDAA"},{"MediumBlue","0000CD"},{"MediumOrchid","BA55D3"},
	{"MediumPurple","9370DB"},{"MediumSeaGreen","3CB371"},{"MediumSlateBlue","7B68EE"},{"MediumSpringGreen","00FA9A"},
	{"MediumTurquoise","48D1CC"},{"MediumVioletRed","C71585"},{"MidnightBlue","191970"},{"MintCream","F5FFFA"},
	{"MistyRose","FFE4E1"},{"Moccasin","FFE4B5"},{"NavajoWhite","FFDEAD"},{"Navy","000080"},
	{"OldLace","FDF5E6"},{"Olive","808000"},{"OliveDrab","6B8E23"},{"Orange","FFA500"},
	{"OrangeRed","FF4500"},{"Orchid","DA70D6"},{"PaleGoldenrod","EEE8AA"},{"PaleGreen","98FB98"},
	{"PaleTurquoise","AFEEEE"},{"PaleVioletRed","DB7093"},{"PapayaWhip","FFEFD5"},{"PeachPuff","FFDAB9"},
	{"Peru","CD853F"},{"Pink","FFC0CB"},{"Plum","DDA0DD"},{"PowderBlue","B0E0E6"},
	{"Purple","800080"},{"RebeccaPurple","663399"},{"Red","FF0000"},{"RosyBrown","BC8F8F"},
	{"RoyalBlue","4169E1"},{"SaddleBrown","8B4513"},{"Salmon","FA8072"},{"SandyBrown","F4A460"},
	{"SeaGreen","2E8B57"},{"Seashell","FFF5EE"},{"Sienna","A0522D"},{"Silver","C0C0C0"},
	{"SkyBlue","87CEEB"},{"SlateBlue","6A5ACD"},{"SlateGray","708090"},{"Snow","FFFAFA"},
	{"SpringGreen","00FF7F"},{"SteelBlue","4682B4"},{"Tan","D2B48C"},{"Teal","008080"},
	{"Thistle","D8BFD8"},{"Tomato","FF6347"},{"Turquoise","40E0D0"},{"Violet","EE82EE"},
	{"Wheat","F5DEB3"},{"White","FFFFFF"},{"WhiteSmoke","F5F5F5"},{"Yellow","FFFF00"},
	{"YellowGreen","9ACD32"},
	{"Peach","FFCBA4"},{"Mint","98FF98"},{"Cream","FFFDD0"},{"Lilac","C8A2C8"},
	{"Rose","FF007F"},{"Burgundy","800020"},{"Emerald","50C878"},{"Ruby","E0115F"},
	{"Sapphire","0F52BA"},{"Amber","FFBF00"},{"Cobalt","0047AB"},{"Cerulean","007BA7"},
	{"Scarlet","FF2400"},{"Mustard","FFDB58"},{"Rust","B7410E"},{"Bronze","CD7F32"},
	{"Copper","B87333"},{"Neon Green","39FF14"},{"Neon Pink","FF6EC7"},{"Neon Blue","1F51FF"},
	{"Baby Blue","89CFF0"},{"Sky","87CEEB"},{"Wine","722F37"},{"Olive Green","6B8E23"},
	{"Coffee","6F4E37"},{"Chocolate Brown","7B3F00"},{"Sand","C2B280"},{"Pastel Pink","FFD1DC"},
	{"Pastel Blue","AEC6CF"},{"Pastel Green","B2E2B2"},{"Pastel Purple","C3B1E1"},{"Pastel Yellow","FDFD96"},
}

local RU = {
	{"красный","FF0000"},{"синий","0000FF"},{"зелёный","008000"},{"жёлтый","FFFF00"},
	{"оранжевый","FFA500"},{"розовый","FFC0CB"},{"фиолетовый","800080"},{"голубой","87CEEB"},
	{"белый","FFFFFF"},{"чёрный","000000"},{"серый","808080"},{"коричневый","A52A2A"},
	{"лайм","00FF00"},{"золотой","FFD700"},{"бирюзовый","40E0D0"},{"бордовый","800000"},
	{"салатовый","7FFF00"},{"сиреневый","C8A2C8"},{"бежевый","F5F5DC"},{"малиновый","DC143C"},
	{"персиковый","FFDAB9"},{"мятный","98FF98"},{"лавандовый","E6E6FA"},{"серебряный","C0C0C0"},
	{"тёмно-синий","00008B"},{"светло-голубой","ADD8E6"},{"светло-зелёный","90EE90"},
	{"тёмно-зелёный","006400"},{"пурпурный","FF00FF"},{"циан","00FFFF"},{"индиго","4B0082"},
	{"хаки","F0E68C"},{"кремовый","FFFDD0"},{"изумрудный","50C878"},{"рубиновый","E0115F"},
}

-- Двуязычный список для меню «Цвета»: { English, Русский, HEX }
local PALETTE = {
	{"Red","чистый красный","FF0000"},{"Crimson","тёмно-алый","DC143C"},{"Scarlet","ярко-алый","FF2400"},
	{"Maroon","бордовый","800000"},{"Firebrick","кирпичный","B22222"},{"DarkRed","тёмно-красный","8B0000"},
	{"Coral","коралловый","FF7F50"},{"Salmon","лососёвый","FA8072"},{"Orange","оранжевый","FFA500"},
	{"Gold","золотой","FFD700"},{"DarkOrange","тёмно-оранжевый","FF8C00"},{"PeachPuff","персиковый","FFDAB9"},
	{"Tan","бежевый-оранжевый","D2B48C"},{"Yellow","жёлтый","FFFF00"},{"LemonChiffon","лимонный","FFFACD"},
	{"Beige","бежевый","F5F5DC"},{"Khaki","хаки светлый","F0E68C"},{"Goldenrod","золотисто-жёлтый","DAA520"},
	{"Green","чистый зелёный","008000"},{"Lime","лайм","00FF00"},{"ForestGreen","лесной зелёный","228B22"},
	{"DarkGreen","тёмно-зелёный","006400"},{"Olive","оливковый","808000"},{"SpringGreen","весенний зелёный","00FF7F"},
	{"Teal","бирюзово-зелёный","008080"},{"MintCream","мятный","F5FFFA"},{"Cyan","циан","00FFFF"},
	{"Aqua","аква","00FFFF"},{"Turquoise","бирюзовый","40E0D0"},{"LightBlue","светло-голубой","ADD8E6"},
	{"SkyBlue","небесно-голубой","87CEEB"},{"SteelBlue","стальной синий","4682B4"},{"Navy","тёмно-синий","000080"},
	{"MidnightBlue","полуночный синий","191970"},{"CornflowerBlue","васильковый","6495ED"},{"Purple","фиолетовый","800080"},
	{"Violet","сиреневый","EE82EE"},{"Magenta","пурпурный","FF00FF"},{"Lavender","лавандовый","E6E6FA"},
	{"Pink","розовый","FFC0CB"},{"HotPink","ярко-розовый","FF69B4"},{"DeepPink","насыщенный розовый","FF1493"},
	{"Plum","сливовый","DDA0DD"},{"Brown","коричневый","A52A2A"},{"Chocolate","шоколадный","D2691E"},
	{"SaddleBrown","тёмно-коричневый","8B4513"},{"Gray","серый","808080"},{"Silver","серебряный","C0C0C0"},
	{"DimGray","тускло-серый","696969"},{"White","белый","FFFFFF"},{"Black","чёрный","000000"},
	{"Ivory","слоновая кость","FFFFF0"},{"Linen","льняной","FAF0E6"},
	-- остальные веб-цвета
	{"Blue","синий","0000FF"},{"AliceBlue","бледно-голубой","F0F8FF"},{"AntiqueWhite","античный белый","FAEBD7"},
	{"Aquamarine","аквамарин","7FFFD4"},{"Azure","лазурь","F0FFFF"},{"Bisque","бисквитный","FFE4C4"},
	{"BlanchedAlmond","миндальный","FFEBCD"},{"BlueViolet","сине-фиолетовый","8A2BE2"},{"BurlyWood","светло-коричневый","DEB887"},
	{"CadetBlue","серо-голубой","5F9EA0"},{"Chartreuse","шартрез","7FFF00"},{"Cornsilk","кукурузный","FFF8DC"},
	{"DarkBlue","тёмный синий","00008B"},{"DarkCyan","тёмный циан","008B8B"},{"DarkGoldenrod","тёмное золото","B8860B"},
	{"DarkGray","тёмно-серый","A9A9A9"},{"DarkKhaki","тёмный хаки","BDB76B"},{"DarkMagenta","тёмный пурпурный","8B008B"},
	{"DarkOliveGreen","тёмно-оливковый","556B2F"},{"DarkOrchid","тёмная орхидея","9932CC"},{"DarkSalmon","тёмный лосось","E9967A"},
	{"DarkSeaGreen","тёмно-морской зелёный","8FBC8F"},{"DarkSlateBlue","тёмный сланцево-синий","483D8B"},{"DarkSlateGray","тёмный сланцево-серый","2F4F4F"},
	{"DarkTurquoise","тёмно-бирюзовый","00CED1"},{"DarkViolet","тёмно-фиолетовый","9400D3"},{"DeepSkyBlue","насыщенный небесно-голубой","00BFFF"},
	{"DodgerBlue","ярко-синий","1E90FF"},{"FloralWhite","цветочный белый","FFFAF0"},{"Fuchsia","фуксия","FF00FF"},
	{"Gainsboro","гейнсборо","DCDCDC"},{"GhostWhite","призрачно-белый","F8F8FF"},{"GreenYellow","зелёно-жёлтый","ADFF2F"},
	{"Honeydew","медовая роса","F0FFF0"},{"IndianRed","индийский красный","CD5C5C"},{"Indigo","индиго","4B0082"},
	{"LavenderBlush","лавандовый румянец","FFF0F5"},{"LawnGreen","газонный зелёный","7CFC00"},{"LightCoral","светло-коралловый","F08080"},
	{"LightCyan","светлый циан","E0FFFF"},{"LightGoldenrodYellow","светло-золотистый","FAFAD2"},{"LightGray","светло-серый","D3D3D3"},
	{"LightGreen","светло-зелёный","90EE90"},{"LightPink","светло-розовый","FFB6C1"},{"LightSalmon","светлый лосось","FFA07A"},
	{"LightSeaGreen","светлая морская волна","20B2AA"},{"LightSkyBlue","светлый небесно-голубой","87CEFA"},{"LightSlateGray","светлый сланцево-серый","778899"},
	{"LightSteelBlue","светлая сталь","B0C4DE"},{"LightYellow","светло-жёлтый","FFFFE0"},{"LimeGreen","зелёный лайм","32CD32"},
	{"MediumAquamarine","средний аквамарин","66CDAA"},{"MediumBlue","средний синий","0000CD"},{"MediumOrchid","средняя орхидея","BA55D3"},
	{"MediumPurple","средне-фиолетовый","9370DB"},{"MediumSeaGreen","средняя морская волна","3CB371"},{"MediumSlateBlue","средний сланцево-синий","7B68EE"},
	{"MediumSpringGreen","средний весенний зелёный","00FA9A"},{"MediumTurquoise","средне-бирюзовый","48D1CC"},{"MediumVioletRed","средний фиолетово-красный","C71585"},
	{"MistyRose","туманная роза","FFE4E1"},{"Moccasin","мокасиновый","FFE4B5"},{"NavajoWhite","белый навахо","FFDEAD"},
	{"OldLace","старое кружево","FDF5E6"},{"OliveDrab","серо-оливковый","6B8E23"},{"OrangeRed","красно-оранжевый","FF4500"},
	{"Orchid","орхидея","DA70D6"},{"PaleGoldenrod","бледно-золотистый","EEE8AA"},{"PaleGreen","бледно-зелёный","98FB98"},
	{"PaleTurquoise","бледно-бирюзовый","AFEEEE"},{"PaleVioletRed","бледный фиолетово-красный","DB7093"},{"PapayaWhip","папайя","FFEFD5"},
	{"Peru","перу","CD853F"},{"PowderBlue","пудрово-голубой","B0E0E6"},{"RebeccaPurple","ребекка пурпурный","663399"},
	{"RosyBrown","розово-коричневый","BC8F8F"},{"RoyalBlue","королевский синий","4169E1"},{"SandyBrown","песочно-коричневый","F4A460"},
	{"SeaGreen","морской зелёный","2E8B57"},{"Seashell","морская ракушка","FFF5EE"},{"Sienna","сиена","A0522D"},
	{"SlateBlue","сланцево-синий","6A5ACD"},{"SlateGray","сланцево-серый","708090"},{"Snow","снежный","FFFAFA"},
	{"Thistle","чертополох","D8BFD8"},{"Tomato","томатный","FF6347"},{"Wheat","пшеничный","F5DEB3"},
	{"WhiteSmoke","дымчато-белый","F5F5F5"},{"YellowGreen","жёлто-зелёный","9ACD32"},
	-- дополнительные оттенки
	{"Peach","персик","FFCBA4"},{"Mint","мята","98FF98"},{"Cream","кремовый","FFFDD0"},{"Lilac","сирень","C8A2C8"},
	{"Rose","роза","FF007F"},{"Burgundy","бордо","800020"},{"Emerald","изумрудный","50C878"},{"Ruby","рубиновый","E0115F"},
	{"Sapphire","сапфировый","0F52BA"},{"Amber","янтарный","FFBF00"},{"Cobalt","кобальтовый","0047AB"},{"Cerulean","церулеан","007BA7"},
	{"Mustard","горчичный","FFDB58"},{"Rust","ржавый","B7410E"},{"Bronze","бронзовый","CD7F32"},{"Copper","медный","B87333"},
	{"Neon Green","неоновый зелёный","39FF14"},{"Neon Pink","неоновый розовый","FF6EC7"},{"Neon Blue","неоновый синий","1F51FF"},
	{"Baby Blue","нежно-голубой","89CFF0"},{"Wine","винный","722F37"},{"Coffee","кофейный","6F4E37"},{"Sand","песочный","C2B280"},
	{"Pastel Pink","пастельный розовый","FFD1DC"},{"Pastel Blue","пастельный голубой","AEC6CF"},{"Pastel Green","пастельный зелёный","B2E2B2"},
	{"Pastel Purple","пастельный фиолетовый","C3B1E1"},{"Pastel Yellow","пастельный жёлтый","FDFD96"},{"Raspberry","малиновый","E30B5D"},
	{"Terracotta","терракотовый","E2725B"},{"Champagne","шампань","F7E7CE"},{"Amethyst","аметистовый","9966CC"},{"Pearl","жемчужный","EAE0C8"},
	{"Tangerine","мандариновый","F28500"},{"Banana","банановый","FFE135"},{"Cherry","вишнёвый","DE3163"},{"Strawberry","клубничный","FC5A8D"},
	{"Dark Burgundy","тёмно-бордовый","4A0000"},{"Wild Blue Crayola","дикий синий (Crayola)","7A89B8"},
}

local CODES = {}
local NAMES = {}

local function addCode(name, rgb, override)
	local k = norm(name)
	if k ~= "" and (override or not CODES[k]) then CODES[k] = rgb; NAMES[k] = name end
end

for name, rgb in pairs(CUSTOM) do addCode(name, rgb, true) end
for _, e in ipairs(PALETTE) do local rgb = hex(e[3]); addCode(e[1], rgb); addCode(e[2], rgb) end
for _, e in ipairs(CSS) do addCode(e[1], hex(e[2])) end
for _, e in ipairs(RU) do addCode(e[1], hex(e[2])) end

pcall(function()
	for i = 1, 1100 do
		local ok, bc = pcall(BrickColor.new, i)
		if ok and bc and bc.Number == i then
			local c = bc.Color
			addCode(bc.Name, { math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5) })
		end
	end
end)

------------------------------------------------------------
-- ЦВЕТА С get-color.ru: формат "HEX|название", по строке на цвет.
-- Попадают в меню «Все цвета» и работают как названия в поле кода.
-- Чтобы добавить свои, дописывайте строки в конец блока.
------------------------------------------------------------
local COLOR_DATA = [==[
C93F38|100 миль в час
A59344|Зеленый цвет 18 века
7B463B|1975 Красная Земля
DD3366|1989 Горячая линия Майами
191971|20000 Лье под водой
E56E24|24 Моркови
DFC685|24 Карата
225577|3 ЧАСА НОЧИ в Сибуе
C0A98E|Латте в 3 часа ночи
D2D2C0|Пленка 400XT
9BAFAD|5-Masted Preußen
990066|8 Кусочков баклажана
3D1C02|90% Какао
F2850D|Апельсиновый
94568C|Без косточекǐ Фиолетовый
5BA8FF|Аби Синий
88DDBB|Небо Асмани
FFCCDA|Распустившаяся вишня
FFAABB|Совершенно новый день
D1EDEE|Определенный Оттенок Зеленого
D3DDE4|Пруд пруди
456789|Намек на постепенный синий цвет
F6ECDE|A La Mode
FFBCC5|С большой любовью
BCDDB3|Мятный напиток Манна
BFAF92|Пара карих глаз
F3E9D9|Запах выпечки
88FFCC|Аромат мяты
05A3AD|Река Аре Бриенц
00B89F|Река Аре
1150AF|Аархусианское небо
231F20|Абаддон Блэк
F2F1E6|Абаид Белый
E1DED9|Раковина морского ушка
F8F3F6|Морское ушко
94877E|Заброшенный особняк
746E6A|Заброшенная игровая площадка
747A8A|Заброшенный космический корабль
CD716B|Abbey Pink
A79F92|Эбби-Роуд
ABA798|Камень аббатства
ECE6D0|Белый аббатства
4C4F56|Аббатство
4D3C2D|Аббат
166461|Похищение
EAE3D2|Абилиновое кружево
C04641|Пылающий
F1CBCD|Ткацкий станок
77AA77|Мерзость
966165|Абра Кадабра
EEC400|Абра Золотарник
15151C|Отсутствие света
76B583|Абсент Зеленый
008A60|Абсент Бирюзовый
FF9944|Абсолют Абрикоса
0048BA|Абсолютный ноль
EDE9DD|Абстрактный белый
E4CB97|Абстрактный
629763|Abundance
A19361|Abura Green
8F9E9D|Abyss
1B2632|Abyssal Anchorfish Blue
00035B|Abyssal Blue
10246A|Abyssal Depths
005765|Abyssal Waters
404C57|Abyssal
3D5758|Abysse
000033|Abyssopelagic Water
486241|Acacia Green
969C92|Acacia Haze
DACD65|Acacia
2C3E56|Academic Blue
525367|Academy Purple
E5B7BE|Acadia Bloom
35312C|Acadia
42314B|Acai Berry
942193|Acai Juice
46295A|Acai
4C2F27|Acajou
90977A|Acanthus Leaf
9899A7|Acanthus
7FA8A7|Acapulco Aqua
4E9AA8|Acapulco Cliffs
65A7DD|Acapulco Dive
EB8A44|Acapulco Sun
75AA94|Acapulco
208468|Accent Green Blue
E56D00|Accent Orange
D2C7B7|Accessible Beige
7C94B2|Accolade
090807|Accursed Black
C7CCE7|Ace
727A5F|Aceituna Picante
4E4F48|Aceto Balsamico
EFEDD7|Acid Blond
A8C74D|Acid Candy
11FF22|Acid Drop
8FFE09|Acid Green
BADF30|Acid Lime
00EE22|Acid Pool
33EE66|Acid Pops
30FF21|Acid Reflux
4FC172|Acid Sleazebag
00FF22|Acid
9E9991|Acier
FFD8B1|Acini di Pepe
7249D6|Aconite Purple
9C52F2|Aconite Violet
D48948|Acorn Nut
B87439|Acorn Spice
EDA740|Acorn Squash
7E5E52|Acorn
EFECE1|Acoustic White
B3E1E8|Across the Bay
FF44EE|Actinic Light
00504B|Action Green
00A67E|Active Green
006F72|Active Turquoise
BB1133|Active Volcano
A7A6A3|Actor's Star
46ADF9|Adamantine Blue
3B845E|Adamite Green
661111|Adana Kebabı
867E70|Adaptive Shade
585D58|Addo Skin
CCB0B5|Adeline
293947|Adept
7C8286|Adeptus Battlegrey
9E9CAB|Adhesion
74858F|Adirondack Blue
B0B9C1|Adirondack
50647F|Admiral Blue
404E61|Admiralty
F6F3D3|Admiration
FB9587|Adobe Avenue
DCBFA6|Adobe Beige
BA9F99|Adobe Rose
E8DEC5|Adobe Sand
E5C1A7|Adobe South
C3A998|Adobe Straw
E6DBC4|Adobe White
BD6C48|Adobe
A99681|Adolescent Rodent
EFBF4D|Adonis Rose Yellow
64B5BF|Adonis
8D8DC9|Adora
E3BEB0|Adorable
5C899B|Adriatic Blue
96C6CD|Adriatic Haze
D3ECE4|Adriatic Mist
016081|Adriatic Sea
93B8E3|Adrift on the Nile
4B9099|Adrift
20726A|Advantageous
F87858|Adventure Island Pink
6F9FB9|Adventure Isle
EDA367|Adventure Orange
3063AF|Adventure of the Seas
34788C|Adventure
72664F|Adventurer
7CAC88|Adventurine
D8CB4B|Advertisement Green
0081A8|Advertising Blue
53A079|Advertising Green
E6D3B6|Aebleskiver
4E6E81|Aegean Blue
4C8C72|Aegean Green
9CBBE2|Aegean Mist
508FA2|Aegean Sea
E48B59|Aegean Sky
9BA0A4|Aegean Splendor
A0B2C8|Aerial View
C0E8D5|Aero Blue
7CB9E8|Aero
A2C348|Aerobic Fix
2B3448|Aeronautic
FF4F00|Aerospace Orange
355376|Aerostatics
E3DDD3|Aesthetic White
745085|Affair
AAFFFF|Affen Turquoise
FED2A5|Affinity
905E26|Afghan Carpet
E2D7B5|Afghan Hound
D3A95C|Afghan Sand
78A3C2|Afloat
C7927A|African Bubinga
939899|African Grey
CD4A4A|African Mahogany
826C68|African Mud
86714A|African Plain
645E42|African Queen
B16B40|African Safari
CCAA88|African Sand
B085B7|African Violet
FD8B60|After Burn
3C3535|After Dark
E3F5E5|After Dinner Mint
D6EAE8|After Eight Filling
3D2E24|After Eight
38393F|After Midnight
C1DBEA|After Rain
FEC65F|After Shock
24246D|After Work Blue
8BC4D1|After the Rain
33616A|After the Storm
C95EFB|After-Party Pink
85C0CD|Aftercare
F3E6C9|Afterglow
D91FFF|Afterlife
D9C5A1|Afternoon Stroll
594E40|Afternoon Tea
FBCB78|Afternoon
BBC5DE|Agapanthus
956A60|Agate Brown
599F99|Agate Green
B1B09F|Agate Grey
5A5B74|Agate Violet
5A6E6A|Agave Frond
6B7169|Agave Green
879C67|Agave Plant
879D99|Agave
886B2E|Aged Antics
846262|Aged Beech
D7CFC0|Aged Beige
87413F|Aged Brandy
5F4947|Aged Chocolate
E0DCDA|Aged Cotton
898253|Aged Eucalyptus
DD9944|Aged Gouda
6C6956|Aged Jade
73343A|Aged Merlot
7E7E7E|Aged Moustache Grey
6E6E30|Aged Mustard Green
7E7666|Aged Olive
CEB588|Aged Papyrus
E9DDCA|Aged Parchment
889999|Aged Pewter
C99F99|Aged Pink
FFFA86|Aged Plastic Casing
A442A0|Aged Purple
7A4134|Aged Teak
9D7147|Aged Whisky
E8DECD|Aged White
895460|Aged Wine
A58EA9|Aged to Perfection
E7A995|Ageless Beauty
ECECDF|Ageless
6FFFFF|Aggressive Baby Blue
FF7799|Aggressive Salmon
6A5B4E|Aging Barrel
393121|Agrax Earthshade
D1CBC1|Agreeable Grey
A17C59|Agrellan Earth
00FBFF|Agressive Aqua
F0E2D3|Agrodolce
9FC5CC|Agua Fría
00FA92|Ahaetulla Prasina
C22147|Ahmar Red
0082A1|Ahoy! Blue
2A3149|Ahoy
199EBD|Ahriman Blue
274447|Ai Indigo
B4C8B6|Aida
ECF7F7|Aijiro White
EEE5E1|Aimee
2E372E|Aimiru Brown
77ACC7|Air Blue
D7D1E9|Air Castle
5D8AA8|Air Force Blue
72A0C1|Air Superiority Blue
D8F2EE|Air of Mint
F6DCD2|Air-Kiss
A2C2D0|Airborne
AA6C51|Airbrushed Copper
354F58|Aircraft Blue
939498|Aircraft Exterior Grey
2A2C1F|Aircraft Green
EDF2F8|Aircraft White
D9E5E4|Airflow
364D70|Airforce
8C9632|Airline Green
AEC1D4|Airway
88CCEE|Airy Blue
DBE0C4|Airy Green
DAE6E9|Airy
FAECD9|Ajo Lily
D3DE7B|Ajwain Green
C3272B|Akabeni
BC012E|Akai Red
F07F5E|Akakō Red
C90B42|Akari Red
BEB29A|Akaroa
CF3A24|Ake Blood
983FB2|Akebi Purple
FA7B62|Akebono Dawn
B0E313|Akhdhar Green
601EF9|Akihabara Arcade
E12120|Akira Red
871646|Akuma's Fury
A32638|Alabama Crimson
E9E3D2|Alabaster Beauty
F0DEBD|Alabaster Gleam
DFD4BF|Alabaster White
F3E7DB|Alabaster
5500FF|Aladdin's Feather
81585B|Alaea
8E8C97|Alaitoc Blue
FFAE52|Alajuela Toad
CA9234|Alameda Ochre
939B71|Alamosa Green
EC0003|Alarm
2CE335|Alarming Slime
DADAD1|Alaska
6DA9D2|Alaskan Blue
34466C|Alaskan Cruise
BCBEBC|Alaskan Grey
7E9EC2|Alaskan Ice
ECF0E5|Alaskan Mist
05472A|Alaskan Moss
CDDCED|Alaskan Skies
BAE3EB|Alaskan Wind
CC0001|Albanian Red
38546E|Albeit
4F5845|Albert Green
E1DACB|Albescent White
FBEEE5|Albino
CCA47E|Albuquerque
E7CF8C|Alchemy
AAA492|Aldabra
7A4B49|Alden Till
954E2C|Alert Tan
F1CEB3|Alesan
4D7EAA|Aleutian Isle
9A9EB3|Aleutian
DB9785|Alexandra Peach
FF8F73|Alexandria
FCEFC1|Alexandria's Lighthouse
BCD9DC|Alexandrian Sky
767853|Alexandrite Green
598C74|Alexandrite
416082|Alexis Blue
A55232|Alfajor Brown
78AD6D|Alfalfa Bug
546940|Alfalfa Extract
B7B59F|Alfalfa
80365A|Alfonso Olive
8DA98D|Alga Moss
93DFB8|Algae Green
983D53|Algae Red
54AC68|Algae
21C36F|Algal Fuel
479784|Algen Gerne
FC5A50|Algerian Coral
00859C|Algiers Blue
C1DBEC|Algodon Azul
F7F2E1|Alhambra Cream
00A465|Alhambra Green
008778|Alhambra
D4CBC4|Alibi
F0F8FF|Alice Blue
C2CED2|Alice White
0CFF0C|Alien Abduction
84DE02|Alien Armpit
B9CC81|Alien Breed
55FF33|Alien Parasite
490648|Alien Purple
415764|Alien
00CC55|Alienated
9790A4|Alienator Grey
00728D|Align
E32636|Alizarin Crimson
E34636|Alizarin
676C58|All About Olive
E6999D|All Dressed Up
EFD7E7|All Made Up
455454|All Nighter
994411|All the Leaves Are Brown
C68886|All's Ace
5A6A8C|Allegiance
B4B2A9|Allegory
B28959|Allegro
656874|Alley Cat
B8C4D9|Alley
2B655F|Alliance
EAEED7|Alligator Egg
444411|Alligator Gladiator
646048|Alligator Scales
886600|Alligator
F1EAD4|Allison Lace
9569A3|Allium
C46210|Alloy Orange
98979A|Alloy
1F6A7D|Allports
8E443D|Allspice Berry
F8CDAA|Allspice
ED2E38|Allura Red
7291B4|Allure
9EC4CD|Alluring Blue
F8DBC2|Alluring Gesture
FFF7D8|Alluring Light
977B4D|Alluring Umber
EFE1D2|Alluring White
BB934B|Alluvial Inca
CB738B|Allyson
E8DEC9|Almanac
C2A37E|Almandine
F5E0C9|Almeja
E8D6BD|Almendra Tostada
DFD5CA|Almond Beige
E9C9A9|Almond Biscuit
E0D2D1|Almond Blossom Pink
F5BEC7|Almond Blossom
E5D3B9|Almond Brittle
CCB390|Almond Buff
D8C6A8|Almond Butter
EEC87C|Almond Cookie
F4C29F|Almond Cream
9A8678|Almond Frost
595E4C|Almond Green
EFE3D9|Almond Icing
F6E3D4|Almond Kiss
D6C0A4|Almond Latte
D6CEBE|Almond Milk
F4EFC1|Almond Oil
E5DBC5|Almond Paste
F0E8E0|Almond Roca
CC8888|Almond Rose
E1CFB2|Almond Silk
BF9E77|Almond Toast
7D665B|Almond Truffle
E6C9BC|Almond Willow
D6CAB9|Almond Wisp
EDDCC8|Almond
EFDECD|Almond
FEDEBC|Almondine
BFE5B1|Almost Aloe
E5B39B|Almost Apricot
98DDC5|Almost Aqua
3A5457|Almost Famous
E7DCD9|Almost Mauve
F0E3DA|Almost Pink
BEB0C2|Almost Plum
6A2DED|Almost Royal
C97863|Aloe Blossom
DBE5B9|Aloe Cream
ECF1E2|Aloe Essence
61643F|Aloe Leaf
DCF2E3|Aloe Mist
DFE2C9|Aloe Nectar
B8BA87|Aloe Plant
888B73|Aloe Thorn
8A9480|Aloe Tip
7E9B39|Aloe Vera Green
848B71|Aloe Vera Tea
678779|Aloe Vera
D0D3B7|Aloe Wash
817A60|Aloe
6A432D|Aloeswood
E9AA91|Aloha Sunset
1DB394|Aloha
000066|Alone in the Dark
C9C9C0|Aloof Grey
D6C5A0|Aloof Lama
D4E2E6|Aloof
DED7C5|Alpaca Blanket
F9EDE2|Alpaca Wool
F7E5DA|Alpaca
F0BEB8|Alpenglow
588BB4|Alpha Blue
4D5778|Alpha Centauri
AE8E5F|Alpha Gold
715A45|Alpha Male
628FB0|Alpha Tango
ABCDEF|Alphabet Blue
A9B4A9|Alpine Air
BADBE6|Alpine Alabaster
F7E0BA|Alpine Berry Yellow
DBE4E5|Alpine Blue
40464D|Alpine Duck Grey
99EEFF|Alpine Expedition
E0DED2|Alpine Frost
F1F2F8|Alpine Goat
005F56|Alpine Green
ABBEC0|Alpine Haze
449955|Alpine Herbs
4F603E|Alpine Lake Green
117B87|Alpine Landing
6AAE2E|Alpine Meadow
DED3E6|Alpine Moon
A6CCD8|Alpine Morning Blue
234162|Alpine Race
051009|Alpine Salamander
A5A99A|Alpine Summer
515A52|Alpine Trail
AD8A3B|Alpine
FFAAA5|Alright Then I Became a Princess
B1575F|Alsike Clover Red
DFD5B1|Alsot Olive
4D4C80|Altar of Heaven
1F56A7|Altdorf Guard Blue
00A1AC|Altdorf Sky Blue
69656D|Alter Ego
EFC7BE|Altered Pink
CDC6C5|Alto
DDBB00|Alu Gobi
000055|Alucard's Night
A9A0A9|Aluminium Powder
AEAFB4|Aluminium Snow
848789|Aluminium
D2D9DB|Aluminum Foil
8C8D91|Aluminum Silver
ADAFAF|Aluminum Sky
9F9586|Aluminum
A5C970|Alverda
EBE5D2|Always Almond
A0A667|Always Apple
A2BACB|Always Blue
11AA00|Always Green Grass
66778C|Always Indigo
DFD7CB|Always Neutral
E79DB3|Always Rosey
F4E2D6|Alyssa
F2D5D7|Alyssum
297CBF|Amalfi Coast
016E85|Amalfi
033B9A|Amalfitan Azure
7B2331|Amaranth Blossom
9F2B68|Amaranth Deep Purple
CD2682|Amaranth Light Cherry
ED3CCA|Amaranth Magenta
F19CBB|Amaranth Pink
6A397B|Amaranth Purple
AB274F|Amaranth Purple
D3212D|Amaranth Red
E86EAD|Amaranth
E52B50|Amaranth, Manganese Red
CC3311|Amarantha Red
5F4053|Amaranthine
C09856|Amaretto Sour
AB6F60|Amaretto
FFF1D4|Amarillo Bebito
FBF1C3|Amarillo Yellow
551199|Amarklor Violet
B85045|Amaryllis
F2C1CB|Amaya
806568|Amazing Amethyst
A9A797|Amazing Boulder
BEB5A9|Amazing Grey
6680BB|Amazing Smoke
EBEBD6|Amazon Breeze
505338|Amazon Depths
606553|Amazon Foliage
786A4A|Amazon Green
686747|Amazon Jungle
ECECDC|Amazon Mist
7E8C7A|Amazon Moss
80E45F|Amazon Parrot
948F54|Amazon Queen
E6B2B8|Amazon River Dolphin
777462|Amazon River
7E7873|Amazon Stone
ABAA97|Amazon Vine
387B54|Amazon
A7819D|Amazonian Orchid
AA6644|Amazonian
00C4B0|Amazonite
0D2F5A|Ambassador Blue
C69C6A|Amber Autumn
D7A361|Amber Brew
A66646|Amber Brown
F6BC77|Amber Dawn
C79958|Amber Glass
F29A39|Amber Glow
C19552|Amber Gold
9A803A|Amber Green
D0A592|Amber Grey
BA9971|Amber Leaf
EED1A5|Amber Moon
B18140|Amber Romance
FF9988|Amber Sun
FFAFA3|Amber Tide
D78B55|Amber Wave
FAB75A|Amber Yellow
FFBF00|Amber
DC793E|Amberglow
AA8559|Amberized
E2BEA2|Amberlight
E7E7E6|Ambience White
F8EDE0|Ambient Glow
97653F|Ambit
F0CB97|Ambitious Amber
E9687E|Ambitious Rose
EEE9D3|Ambrosia Coffee Cake
FFF4EB|Ambrosia Ivory
F4DED3|Ambrosia Salad
D2E7CA|Ambrosia
47AE9C|Ambrosial Oceanside
BECCC2|Amelia
34546D|America's Cup
7595AB|American Anthem
A73340|American Beauty
3B3B6D|American Blue
391802|American Bronze
804040|American Brown
D3AF37|American Gold
34B334|American Green
52352F|American Mahogany
63403A|American Milking Devon
FF8B00|American Orange
FF9899|American Pink
431C53|American Purple
B32134|American Red
626E71|American River
995544|American Roast
FF033E|American Rose
CFCFCF|American Silver
551B8C|American Violet
F2B400|American Yellow
EFDCD4|American Yorkshire
0477B4|Americana
463732|Americano
ECEAEC|Amethyst Cream
4F3C52|Amethyst Dark Violet
8F00FE|Amethyst Ganzstar
776985|Amethyst Gem
9C89A1|Amethyst Grey Violet
9085C4|Amethyst Grey
A0A0AA|Amethyst Haze
D0C9C6|Amethyst Ice
CFC2D1|Amethyst Light Violet
926AA6|Amethyst Orchid
9C8AA4|Amethyst Paint
9B91A1|Amethyst Phlox
562F7E|Amethyst Purple
BD97CF|Amethyst Show
95879C|Amethyst Smoke
CDC7D5|Amethyst Tint
9966CC|Amethyst
DED1E0|Ametrine Quartz
783E48|Amfissa Olive
DF965B|Amiable Orange
E6DDBE|Amish Bread
3A5F4E|Amish Green
A58D6D|Ammonite Fossil
F8FBEB|Amnesiac White
DDCC22|Amok
EE3377|Amor
BB22AA|Amora Purple
AE2F48|Amore
3CAA3C|Amorous Toad
B1A7B7|Amorphous Rose
F5E6EA|Amour Frais
EE5851|Amour
E0DFE8|Amourette Eternelle
C8C5D7|Amourette
4960A8|Amparo Blue
264C47|Amphibian
384E47|Amphitrite
9F8672|Amphora
3F425A|Amphystine
01748E|Amulet Gem
7D9D72|Amulet
69045F|Amygdala Purple
FEA7BD|Amélie's Tutu
00BB44|Anaheim Pepper
8CCEEA|Anakiwa
BFB6A7|Analytical Grey
DB304A|Anarchist
DE0300|Anarchy
DDCDA6|Ancestral Gold
D0D0D0|Ancestral Water
D0C1C3|Ancestral
9E90A7|Ancestry Violet
7A5145|Ancho Pepper
596062|Anchor Grey
435D8B|Anchor Point
2C3641|Anchorman
9EBBCD|Anchors Away
2B3441|Anchors Aweigh
756F6B|Anchovy
DA6304|Ancient Bamboo
73754C|Ancient Bonsai
AA6611|Ancient Brandy
9C5221|Ancient Bronze
624147|Ancient Burgundy
99522B|Ancient Chest
9F543E|Ancient Copper
DCC9A8|Ancient Doeskin
746550|Ancient Earth
A44769|Ancient Fuchsia
73FDFF|Ancient Ice
E3AF8E|Ancient Inca
F1E6D1|Ancient Ivory
D6D8CD|Ancient Kingdom
483C32|Ancient Lavastone, Taupe
953D55|Ancient Magenta
D1CCB9|Ancient Marble
959651|Ancient Maze
895B8A|Ancient Murasaki Purple
6A5536|Ancient Olive
DDD4CE|Ancient Pages
898D91|Ancient Pewter
774411|Ancient Planks
A37D5E|Ancient Pottery
5A3D3F|Ancient Prunus
922A31|Ancient Red
70553D|Ancient Root
843F5B|Ancient Royal Banner
E0CAC0|Ancient Ruins
F0E4D1|Ancient Scroll
83696E|Ancient Shelter
765640|Ancient Spice
DED8D4|Ancient Stone
EECD00|Ancient Yellow
EFEEDC|Ancient
AFCDC7|Andean Opal Green
90B19D|Andean Slate
C1A097|Andes Ash
78D8D9|Andes Sky
424036|Andiron
603535|Andorra
B58338|Andouille
FAF0D3|Andover Cream
4477DD|Andrea Blue
A4C639|Android Green
ABCDEE|Andromeda Blue
F9EFE4|Anemone White
842C48|Anemone
BEB6AB|Anew Grey
AFA8AE|Angel Aura
83C5CD|Angel Blue
F7E3DA|Angel Blush
DCAF9F|Angel Breath
FE83CC|Angel Face Rose
A3BDD3|Angel Falls
F4EFEE|Angel Feather
B8ACB4|Angel Finger
D7A14F|Angel Food Cake
F0E8D9|Angel Food
004225|Angel Green
D2D6DB|Angel Hair Silver
A17791|Angel Heart
CEC7DC|Angel Kiss
E19640|Angel Shark
F3DFD7|Angel Wing
BBC6D9|Angel in Blue Jeans
C6F0E7|Angel of Death Victorious
EED4C8|Angel's Face
F3F1E6|Angel's Feather
F6DD34|Angel's Trumpet
DBDFD4|Angel's Whisper
A9C1E5|Angela Bay
C99997|Angela Canyon
BBC6D6|Angelic Blue
E9D9DC|Angelic Choir
EECC33|Angelic Descent
BBD1E8|Angelic Eyes
E3DFEA|Angelic Sent
EBE9D8|Angelic Starlet
F4EDE4|Angelic White
F4DFA7|Angelic Yellow
F2DCD7|Angelic
EACFC2|Angelico
DD0055|Anger
B9C6D8|Angora Blue
EDE7DE|Angora Goat
EBDFEA|Angora Pink
DFD1BB|Angora
F4F6EC|Angraecum Orchid
F04E45|Angry Flamingo
9799A6|Angry Gargoyle
EEBBBB|Angry Ghost
37503D|Angry Gremlin
EE9911|Angry Hornet
4E6665|Angry Ocean
FFCC55|Angry Pasta
D82029|Angry Tomato
D8DEE7|Angélique Grey
B9ABAD|Aniline Mauve
A41313|Animal Blood
F4E6CE|Animal Cracker
BCC09E|Animal Kingdom
ED9080|Animated Coral
FF7A83|Anime Blush
CCC14D|Anime
C0BAAF|Anise Biscotti
F4E3B5|Anise Flower
B0AC98|Anise Grey Yellow
8CB684|Aniseed Leaf Green
CDA741|Aniseed
91A0B7|Anita
CDCA9F|Anjou Pear
F5D547|Anna Banana
F7EFCF|Annabel
384A66|Annapolis Blue
8C5341|Annatto
6B475D|Annis
E17861|Annular
89A4CD|Anode
BDBFC8|Anon
DADCD3|Anonymous
C7BBA4|Another One Bites the Dust
016884|Ansel
B05D4A|Ant Red
2B3F5C|Antarctic Blue
0000BB|Antarctic Circle
35383F|Antarctic Deep
EDDEE6|Antarctic Love
BFD2D0|Antarctica Lake
C6C5C6|Antarctica
B19664|Antelope
7F684E|Anthill
3D475E|Anthracite Blue
373F42|Anthracite Grey
73293B|Anthracite Red
28282D|Anthracite
464451|Anthracite
BEBDBC|Anti Rainbow Grey
F2F3F4|Anti-Flash White, Munsell
06B1C4|Antigua Blue
83C2CD|Antigua Sand
FFE7C8|Antigua Sunrise
256D73|Antigua
3B5E8D|Antilles Blue
8AA277|Antilles Garden
C7C8C1|Antimony
946644|Antiquarian Brown
BA8A45|Antiquarian Gold
8D8AA0|Antiquate
9C867B|Antique Bear
926B43|Antique Bourbon
6C461F|Antique Brass
CD9575|Antique Brass
704A07|Antique Bronze
553F2D|Antique Brown
F0BAA4|Antique Cameo
F4E1D6|Antique Candle Light
A7856D|Antique Chest
FDF6E7|Antique China
B5B8A8|Antique Coin
9E6649|Antique Copper
FFC7B0|Antique Coral
7E6C5F|Antique Earth
915C83|Antique Fuchsia
8E5E5E|Antique Garnet
B59E5F|Antique Gold
29675C|Antique Green
69576D|Antique Grey
CDBACB|Antique Heather
B39355|Antique Honey
B07F9E|Antique Hot Pink
7B7062|Antique Iron
F9ECD3|Antique Ivory
C5BBA8|Antique Kilim
FDF2DB|Antique Lace
9E8E7E|Antique Leather
FAEEDB|Antique Linen
F1E9D7|Antique Marble
BBB0B1|Antique Mauve
7A973B|Antique Moss
F4F0E8|Antique Paper
EAD8C1|Antique Parchment
EBD7CB|Antique Pearl
957747|Antique Penny
E8E3E3|Antique Petal
C27A74|Antique Pink
7D4F51|Antique Red
997165|Antique Rose
72393F|Antique Rosewood
841B2D|Antique Ruby
918E8C|Antique Silver
6E7173|Antique Tin
BB9973|Antique Treasure
004E4E|Antique Turquoise
928BA6|Antique Viola
ECE6D5|Antique White
FAEBD7|Antique White
F3D3A1|Antique Wicker Basket
B6A38D|Antique Windmill
8B846D|Antique
BDCCC1|Antiqued Aqua
8A6C57|Antiquities
C1A87C|Antiquity
864F3E|Antler Moth
C0AD96|Antler Velvet
957A76|Antler
E7C2B4|Antoinette Pink
B09391|Antoinette
312231|Anubis Black
C68E3F|Anzac
00800C|Ao
27B692|Aoife's Green
006442|Aotake Bamboo
31827B|Apatite Blue
BBFF99|Apatite Crystal Green
8A843B|Apeland
E35A63|Aphrodisiac
45E9C1|Aphrodite Aqua
EEFFFF|Aphrodite's Pearls
DD14AB|Aphroditean Fuchsia
B5D0A2|Apium
284FBD|Apnea Dive
F4711E|Apocalyptic Orange
99CCFF|Apocyan
748697|Apollo Bay
E5E5E1|Apollo Landing
DDFFFF|Apollo's White
848B80|Appalachian Forest
CFB989|Appalachian Trail
876E52|Appaloosa Spots
C2BCA9|Apparition
B1E5AA|Appetite
66AA00|Appetizing Asparagus
858C9B|Applause Please
DDBCA0|Apple Blossom
D5E69D|Apple Bob
9C6757|Apple Brown Betty
844B4D|Apple Butter
F81404|Apple Cherry
DA995F|Apple Cider
B0885A|Apple Cinnamon
F4EED8|Apple Core
B8D7A6|Apple Cream
E19C55|Apple Crisp
FEE5C9|Apple Crunch
DBDBBC|Apple Cucumber
FDDFAE|Apple Custard
7E976D|Apple Day
EDF4EB|Apple Flower
CC9350|Apple Fritter
76CD26|Apple Green
4B4247|Apple Herb Black
A69F8D|Apple Hill
BFCA87|Apple II Beige
93D6BF|Apple II Blue
DA680E|Apple II Chocolate
04650D|Apple II Green
25C40D|Apple II Lime
DC41F1|Apple II Magenta
AC667B|Apple II Rose
BDD0B1|Apple Ice
DDAABB|Apple Infusion
8B974E|Apple Jack
F9FDD9|Apple Martini
93C96A|Apple Orchard
CAAB94|Apple Pie
883E3F|Apple Polish
F4EBD2|Apple Sauce
A77C53|Apple Seed
F1F0BF|Apple Slice
E8C194|Apple Turnover
EA8386|Apple Valley
B59F62|Apple Wine
903F45|Apple-A-Day
DAB5B4|Appleblossom
AEAD93|Applegate Park
8AC479|Applegate
F3F5E9|Applemint Soda
CDEACD|Applemint
C2A377|Applesauce Cake
F6D699|Applesauce
929637|Appletini
6EB478|Appleton
8B97A5|Approaching Dusk
039487|Approval Green
FEC382|Apricot Appeal
FEAEA5|Apricot Blush
C26A5A|Apricot Brandy
CC7E5B|Apricot Brown
CD7E4D|Apricot Buff
DA8923|Apricot Chicken
F1BD89|Apricot Cream
FFBB80|Apricot Flower
EEDED8|Apricot Foam
FFD2A0|Apricot Fool
F3CFB7|Apricot Freeze
F5D7AF|Apricot Gelato
EEAA22|Apricot Glazed Chicken
FFCE79|Apricot Glow
F8CC9C|Apricot Ice Cream
FFF6E9|Apricot Ice
FBBE99|Apricot Iced Tea
E2C4A6|Apricot Illusion
EEA771|Apricot Jam
FFCA95|Apricot Light
FECFB5|Apricot Lily
B47756|Apricot Mix
FCDFAF|Apricot Mousse
ECAA79|Apricot Nectar
F8C4B4|Apricot Obsession
C86B3C|Apricot Orange
EEB192|Apricot Preserves
E8917D|Apricot Red
FACD9E|Apricot Sherbet
E8A760|Apricot Sorbet
F1B393|Apricot Spring
DD9760|Apricot Tan
FBAC82|Apricot Wash
F7F0DB|Apricot White
F7BD81|Apricot Yellow
FFB16D|Apricot
FBCEB1|Apricot, Lips of Apricot
D8A48F|Apricotta
F6D0D8|April Blush
1FB57A|April Fool's Red
A9B062|April Green
909245|April Hills
8B3D2F|April Love
CCD9C9|April Mist
DADEB5|April Showers
FBE198|April Sunshine
B4CBD4|April Tears
C5CFB1|April Wedding
D5E2E5|April Winds
B5DFC9|Aqua Bay
7ACAD0|Aqua Belt
96D3D8|Aqua Bloom
79B6BC|Aqua Blue
D8E8E4|Aqua Breeze
8BD0DD|Aqua Clear
01F1F1|Aqua Cyan
014B43|Aqua Deep
B7C9B5|Aqua Dream
85C7A6|Aqua Eden
038E85|Aqua Experience
96E2E1|Aqua Fiesta
ADC3B4|Aqua Foam
5FA777|Aqua Forest
4A9FA3|Aqua Fresco
A9D1D7|Aqua Frost
D2E8E0|Aqua Glass
12E193|Aqua Green
889FA5|Aqua Grey
D9DDD5|Aqua Haze
A1DAD7|Aqua Island
30949D|Aqua Lake
A0C9CB|Aqua Mist
08787F|Aqua Nation
BCE8DD|Aqua Oasis
05696B|Aqua Obscura
DDF2EE|Aqua Pura
63A39C|Aqua Rapids
539F91|Aqua Revival
6BAAAE|Aqua Sea
7BC4C4|Aqua Sky
8C9FA0|Aqua Smoke
D3E4E6|Aqua Sparkle
85CED1|Aqua Splash
A5DDDB|Aqua Spray
E8F3E8|Aqua Spring
DBE4DC|Aqua Squeeze
E5F1EE|Aqua Tint
00A29E|Aqua Velvet
56B3C3|Aqua Verde
7BBDC7|Aqua Vitale
00937D|Aqua Waters
BFDFDF|Aqua Whisper
A0E3D1|Aqua Wish
7CD8D6|Aqua Zing
9CB0B3|Aqua-Sphere
E1F0EA|Aquacade
006F49|Aquadazzle
7B9F82|Aquadulce
57B7C5|Aqualogic
71D9E2|Aquamarine Blue
B3C4BA|Aquamarine Dream
7FFFD4|Aquamarine Hiroshima
82CDAD|Aquamarine Ocean
2EE8BB|Aquamarine
00A800|Aquamentus Green
E8E0D5|Aquarelle Beige
BFE0E4|Aquarelle Blue
E2F4E4|Aquarelle Green
EDC8FF|Aquarelle Lilac
DBF4D8|Aquarelle Mint
FBE8E0|Aquarelle Orange
FBE9DE|Aquarelle Pink
D8E1F1|Aquarelle Purple
FEDDDD|Aquarelle Red
BCE4EB|Aquarelle Sky
F4EEDA|Aquarelle Yellow
61AAB1|Aquarelle
66CDAA|Aquarium Blue
0A98AC|Aquarium Diver
356B6F|Aquarium
4D5AF3|Aquarius Mood Indigo
559999|Aquarius Reef Base
3CADD4|Aquarius
89C6B7|Aquastone
41A0B4|Aquatic Cool
BFD6D1|Aquatic Edge
49999A|Aquatic Green
99C1CC|Aquatic
B8E7DE|Aquatint
A6B5A9|Aquatone
A3C0BD|Aquaverde
60B3BC|Aqueduct
59B6D9|Aquella
388D95|Aqueous
E2ECED|Aquifer
88ABB4|Aquitaine
82ACC4|Arabella
D16F52|Arabesque
CD9945|Arabian Bake
A14C3F|Arabian Red
DDC6B1|Arabian Sands
786E97|Arabian Silk
884332|Arabian Spice
C9FFFA|Arabian Veil
6F4D3F|Arabic Coffee
C0FFEE|Arabica Mint
7A552E|Arable Brown
47BA87|Aragon Green
B06455|Aragon
6A95B1|Aragonite Blue
948E96|Aragonite Grey
F3F1F3|Aragonite White
E4E0D4|Aragonite
EC8254|Araigaki Orange
3F4635|Arame Seaweed Green
FF7013|Arancio
274A5D|Arapawa
93A344|Arathi Highlands
ADD8E1|Araucana Egg
A18D71|Arava
CDA182|Arbol De Tamarindo
C1C2B4|Arbor Hollow
BBC3AD|Arbor Vitae
70BA9F|Arboretum
CCDDFF|Arc Light
EE3311|Arcade Fire
0022CC|Arcade Glow
EDEBE2|Arcade White
00A28A|Arcadia
A3C893|Arcadian Green
3B6C3F|Arcala Green
6A2F2F|Arcane Red
98687E|Arcane
6A0002|Arcavia Red
8E785C|Archaeological Site
6E6A5E|Archeology
7195A6|Architecture Blue
6B6A69|Architecture Grey
9F8C73|Archivist
CBD8E5|Arctic Air
95D6DC|Arctic Blue
E6E3DF|Arctic Cotton
EBE4BE|Arctic Daisy
E3E5E8|Arctic Dawn
735B6A|Arctic Dusk
AFBEC1|Arctic Feelings
DAEAE4|Arctic Flow
E7E7E2|Arctic Fox
C9D1E9|Arctic Glow
45BCB3|Arctic Green
BBCCDD|Arctic Grey
BFC7D6|Arctic Ice
6F7872|Arctic Lichen Green
D0FF14|Arctic Lime
345C61|Arctic Nights
66C3D0|Arctic Ocean
B8DFF8|Arctic Paradise
C7DAED|Arctic Rain
B7ABB0|Arctic Rose
D9E5EB|Arctic Shadow
00FCFC|Arctic Water
E9EAE7|Arctic White
648589|Arctic
E2DEDF|Ardcoat
E5756A|Ardent Coral
232F2C|Ardósia
DD2200|Ares Red
62584C|Ares Shadow
8B593E|Argan Oil
888888|Argent
CECAC3|Argento
BDBDB7|Argos
895C79|Argyle Purple
C48677|Argyle Rose
348A5D|Argyle
F9E8D8|Aria Ivory
E3E4E2|Aria
DCD6C6|Arid Landscape
B6B4A9|Arid Plains
AED7EA|Ariel
B2A5D3|Ariel's Delight
F887C7|Aries Hot Pink
FAF0DF|Aristocrat Ivory
ECCEB9|Aristocrat Peach
354655|Aristocratic Blue
DDAACC|Aristocratic Pink
980B4A|Aristocratic Velvet
AD735A|Arizona Clay
00655A|Arizona Stone
EBBCB9|Arizona Sunrise
E5BC82|Arizona Tan
669264|Arizona Tree Frog
EEB377|Arizona
536762|Armada
7D4638|Armadillo Egg
484A46|Armadillo
926A25|Armageddon Dunes
D3A907|Armageddon Dust
AD916C|Armagnac
030303|Armor Wash
74857F|Armor
747769|Armored Steel
6A6B65|Armory
5B6F61|Army Canvas
6C7735|Army Golf
4B5320|Army Green
838254|Army Issue Green
8A806B|Army Issue
E59B00|Arnica Yellow
BF8F37|Arnica
96D2D6|Aroma Blue
A1C4A8|Aroma Garden
D3C1C5|Aroma
F9970C|Aromango
FFCECB|Aromatic Breeze
98C945|Aromatic Herbs
F2FF26|Aromatic Lemon
706986|Aromatic
879BA3|Arona
A1B670|Around the Gills
776600|Arousing Alligator
5C546E|Arraign
5A3532|Arresting Auburn
927257|Arrow Creek
C7A998|Arrow Quiver
A28440|Arrow Rock
5C503A|Arrow Shaft
58728A|Arrowhead Lake
F9EAEB|Arrowhead White
514B40|Arrowhead
F8DECF|Arrowroot
E4DECF|Arrowroote
827A67|Arrowtown
BC8D1F|Arrowwood
3B444B|Arsenic
CDACA0|Art Deco Pink
623745|Art Deco Red
94897C|Art District
C06F70|Art House Pink
A29AA0|Art Nouveau Glass
9C932F|Art Nouveau Green
A08994|Art Nouveau Violet
896956|Art and Craft
65A98F|Artemesia Green
DDDDEE|Artemis Silver
D2A96E|Artemis
E3EBEA|Artemisia
711518|Arterial Blood Red
A6BEE1|Artesian Pool
007DB6|Artesian Water
5EB2AA|Artesian Well
91B4B3|Artful Aqua
80505D|Artful Magenta
CC6C82|Artful Pink
B30103|Artful Red
A19676|Artichoke Dip
4B6D41|Artichoke Green
E4D588|Artichoke Heart
C19AA5|Artichoke Mauve
8F9779|Artichoke
CA9D8D|Artifact
E6E2D3|Artifice
FF43A4|Artificial (Wild) Strawberry
41B45C|Artificial Turf
746F67|Artillery
B99779|Artisan Crafts
AC5B50|Artisan Red
B09879|Artisan Tan
DAC2AF|Artisan Tea
845E40|Artisan Tile
8F5C45|Artisan
F2AB46|Artisans Gold
01343A|Artist Blue
EEE4D2|Artist's Canvas
A1969B|Artist's Shadow
987387|Artiste
434053|Artistic License
5C6B65|Artistic Stone
C3B1AC|Artistic Taupe
D0D2E9|Artistic Violet
F5C68B|Arts & Crafts Gold
7D6549|Arts and Crafts
D1DED3|Aruba Aqua
81D7D3|Aruba Blue
54B490|Aruba Green
75AD5B|Arugula
E9D66B|Arylide Yellow
48929B|Asagi Blue
455559|Asagi Koi
F7BB7D|Asagi Yellow
FCEF01|Asfar Yellow
D7BEA5|Ash Blonde
C0C6C9|Ash Blue
98623C|Ash Brown
E8D3D1|Ash Cherry Blossom
8C6F54|Ash Gold
C1B5A9|Ash Grey
B2BEB5|Ash Grey, Wet Ash
B9B3BF|Ash Grove
A88E8B|Ash Hollow
737486|Ash Mauve
998E91|Ash Pink
E8D3C7|Ash Plum
B5817D|Ash Rose
CECFD6|Ash Tree Bark
AABB99|Ash Tree
9695A4|Ash Violet
E9E4D4|Ash White
F0BD7E|Ash Yellow
D9DDE5|Ash in the Air
4E4E4C|Ash to Ash
BEBAA7|Ash
B495A4|Ashberry
994444|Ashen Brown
9B9092|Ashen Plum
D3CABF|Ashen Tan
94A9B7|Ashen Wind
C9BFB2|Ashen
104071|Ashenvale Nights
45575E|Asher Benjamin
BBB3A2|Ashes to Ashes
B8B5AD|Ashes
8699AB|Ashley Blue
D2D9DA|Ashlin Grey
A7A49F|Ashlite
4A79BA|Ashton Blue
7B8EB0|Ashton Skies
BCC4BD|Ashwood
ECE0CD|Asian Fusion
E8E0CD|Asian Ivory
D4B78F|Asian Jute
AE9156|Asian Pear
8B818C|Asian Violet
70B2CC|Aspara
96AF54|Asparagus Cream
B9CB5A|Asparagus Fern
D2CDB4|Asparagus Green
576F44|Asparagus Sprig
DAC98E|Asparagus Yellow
77AB56|Asparagus
83A494|Aspen Aura
C6BCAD|Aspen Branch
FFD662|Aspen Gold
7E9B76|Aspen Green
6A8D88|Aspen Hush
CFD7CB|Aspen Mist
F0F0E7|Aspen Snow
687F7A|Aspen Valley
EDF1E3|Aspen Whisper
F6DF9F|Aspen Yellow
474C55|Asphalt Blue
5E5E5D|Asphalt Grey
130A06|Asphalt
A08A80|Aspiration
A2C1C0|Aspiring Blue
2D4F83|Assassin
F60206|Assassin's Red
E1D0B2|Assateague Sand
1C4374|Assault
9BACD8|Aster Flower Blue
D4DAE2|Aster Petal
7D74A8|Aster Purple
8F629A|Aster Violetta
867BA9|Aster
F091A9|Astilbe
DD482B|Astorath Red
EDD5A6|Astra
363151|Astral Aura
8EC2E7|Astral Spirit
376F89|Astral
77FF77|Astro Arcade Green
899FB9|Astro Bound
5383C3|Astro Nautico
6D5ACF|Astro Purple
937874|Astro Sunset
797EB5|Astro Zinger
3B424C|Astrogranite Debris
757679|Astrogranite
2D96CE|Astrolabe Reef
214559|Astronaut Blue
445172|Astronaut
E8F2EB|Astronomer
474B4A|Astronomical
6B7C85|Astronomicon Grey
AFB4B6|Astroscopus Grey
67A159|Astroturf
273E51|Asurmen Blue Wash
17181C|Aswad Black
9E9985|At Ease Soldier
E7EEE1|At Ease
E7D9B9|At The Beach
A3ABB8|Atelier
003A6C|Ateneo Blue
66DDFF|Athena Blue
E9B4C3|Athena Pink
DCD7CC|Athena
92A18A|Athenian Green
DCDDDD|Athens Grey
3F74B1|Athens
6D8E44|Athonian Camoshade
D5CBB2|Aths Special
008997|Atlantic Blue
CBE1EE|Atlantic Breeze
2B2F41|Atlantic Charter
274E55|Atlantic Deep
001166|Atlantic Depths
D7CEB9|Atlantic Fig Snail
4B8EB0|Atlantic Gull
00629A|Atlantic Mystique
13336F|Atlantic Navy
A7D8E4|Atlantic Ocean
DCD5D2|Atlantic Sand
708189|Atlantic Shoreline
3E586E|Atlantic Tide
B598C3|Atlantic Tulip
3D797C|Atlantic Wave
264243|Atlantic Waves
006477|Atlantis Myth
336172|Atlantis
667A6E|Atlas Cedar Green
5CA0A7|Atlas Cedar
82193A|Atlas Red
EDE5CF|Atlas White
0099DD|Atmosphere
C2D0E1|Atmospheric Pressure
ACE1F0|Atmospheric Soft Blue
899697|Atmospheric
FFCF9E|Atoll Sand
2B797A|Atoll
8F9CAC|Atom Blue
B9FF03|Atomic Lime
F88605|Atomic Orange
FB7EFD|Atomic Pink
FF9966|Atomic Tangerine
3D4B52|Atomic
F1EEE4|Atrium White
994240|Attar of Rose
A1BCA9|Attica
7C7D75|Attitude Grey
A48884|Attitude
3F4258|Attorney
9E6759|Au Chico
FF9D45|Au Gratin
E5E1CE|Au Natural
E8CAC0|Au Naturel
3F3130|Auberge
F2E4DD|Aubergine Flesh
8B762C|Aubergine Green
6E5861|Aubergine Grey
3B2741|Aubergine Mauve
5500AA|Aubergine Perl
372528|Aubergine
B58271|Auburn Glaze
78342F|Auburn Lights
D8A394|Auburn Wave
712F2C|Auburn
A52A2A|Auburn, Red Brown
B5ACB7|Audition
AE8087|Audrey's Blush
9F9292|Auger Shell
E6E1D6|August Moon
FFD79D|August Morning
90AA0B|Augustus Asparagus
7C7469|Aumbry
7C0087|Aunt Violet
B4262A|Aura Orange
DEE2E4|Aura White
B2A8A1|Aura
FDEE00|Aureolin
E8BC6D|Auric Armour Gold
C48919|Auric
32FFDC|Aurichalcite
533552|Auricula Purple
6E7F80|AuroMetalSaurus
6A4238|Aurora Brown
6ADC99|Aurora Green
D3C5C4|Aurora Grey
963B60|Aurora Magenta
EC7042|Aurora Orange
E881A6|Aurora Pink
B93A32|Aurora Red
595682|Aurora Splendor
EDDD59|Aurora
BEBFB2|Austere Grey
726848|Austere
F4C4A5|Australian Apricot
84A194|Australian Jade
EFF8AA|Australian Mint
CC9911|Australien
E7B53B|Australium Gold
DEE6E7|Austrian Ice
6B5446|Authentic Brown
EADDC6|Authentic Tan
C38743|Automn Fox
C6C7C5|Autonomous
D2A888|Autumn Air
CDA449|Autumn Apple Yellow
F9986F|Autumn Arrival
816B68|Autumn Ashes
E3AD59|Autumn Avenue
9D6F46|Autumn Bark
D9922E|Autumn Blaze
EED0AE|Autumn Blonde
FFE0CB|Autumn Bloom
E4D1C0|Autumn Blush
FBE6C1|Autumn Child
447744|Autumn Crocodile
67423B|Autumn Fall
507B49|Autumn Fern
BE7D33|Autumn Fest
A28B36|Autumn Festival
C44E4F|Autumn Fire
AFB8BA|Autumn Fog
B3573F|Autumn Glaze
E9874E|Autumn Glimmer
FF8812|Autumn Glory
E5C382|Autumn Glow
7D623C|Autumn Gold
E6AE76|Autumn Gourd
B2ABA7|Autumn Grey
D4C2B1|Autumn Haze
784F50|Autumn Hills
E47227|Autumn Landscape
9D8D66|Autumn Laurel
7A560E|Autumn Leaf Brown
D07A04|Autumn Leaf Orange
623836|Autumn Leaf Red
B56A4C|Autumn Leaf
6E4440|Autumn Leaves
CEA48E|Autumn Malt
C46215|Autumn Maple
ACB78E|Autumn Meadow, Swamp Green
F7B486|Autumn Mist
3B5861|Autumn Night
EE9950|Autumn Orange
9D9093|Autumn Orchid
158078|Autumn Pine Green
99451F|Autumn Red
9B423F|Autumn Ridge
C2452D|Autumn Robin
A4746E|Autumn Russet
AEA26E|Autumn Sage
FE9A50|Autumn Splendor
F38554|Autumn Sunset
AE704F|Autumn Umber
FAE2CF|Autumn White
FBD1B6|Autumn Wind
C9A0DC|Autumn Wisteria
E99700|Autumn Yellow
AF865B|Autumn
BA7A61|Autumn's Hill
A15325|Autumnal
106B21|Avagddu Green
799B96|Avalon
FF77EE|Avant-Garde Pink
576E6A|Aventurine
D2C2B0|Avenue Tan
FFAA1D|Averland Sunset
C6E3E8|Aviary Blue
7D6049|Aviator
F4C69F|Avid Apricot
C5B47F|Aviva
B7BF6B|Avocado Cream
3E4826|Avocado Dark Green
87A922|Avocado Green
555337|Avocado Pear
39373B|Avocado Peel
4E3E1F|Avocado Stone
90B134|Avocado Toast
CDD6B1|Avocado Whip
568203|Avocado
CCBDB4|Avorio
A7A3BB|Awaken
E3DAE9|Awakened
BB9E9B|Awakening
315886|Award Blue
54617D|Award Night
FEF0DE|Award Winning White
E3EBB1|Awareness
CCC1DA|Awesome Aura
A7B2D4|Awesome Violet
FF2052|Awesome, Fly Agaric
D208CC|Awkward Purple
90413E|Awning Red
6B4730|Axe Handle
756050|Axinite
BAB6CB|Axis
FFF0DF|Axolotl
665500|Ayahuasca Vine
763568|Ayame Iris
A07254|Ayrshire
EFC0CB|Azalea Flower
4A6871|Azalea Leaf
F9C0C4|Azalea Pink
D42E5B|Azalea
A5B546|Azeitona
0085A7|Azores Blue
7C968B|Azores
4C6CB3|Azraq Blue
B13916|Azshara Vein
FFEFBC|Aztec Aura
9E8352|Aztec Brick
C46943|Aztec Copper
E7B347|Aztec Glimmer
C39953|Aztec Gold
33BB88|Aztec Jade
4DB5D7|Aztec Sky
84705B|Aztec Temple
00D6E2|Aztec Turquoise
BB0066|Aztec Warrior
293432|Aztec
96514D|Azuki Bean
672422|Azuki Red
0089C4|Azul Caribe
C9E3EB|Azul Cielito Lindo
537FAF|Azul Pavo Real
E2EFF2|Azul Primavera
C0CFC7|Azul Tequila
6ABAC4|Azul Turquesa
1D5DEC|Azul
211D49|Azulado
025669|Azure Blue
4D91C6|Azure Blue
053976|Azure Dragon
006C81|Azure Green Blue
DDDCE1|Azure Hint
7BBBC8|Azure Lake
F0FFF1|Azure Mist
007F1F|Azure Radiance
B0E0F6|Azure Sky
2B9890|Azure Tide
007FFF|Azure
59BAD9|Azurean
DBE9F4|Azureish White
CC81F0|Azuremyst Isle
497F73|Azurite Water Green
2E5894|B'dazzled Blue
A35046|BBQ
610023|Baal Red Wash
EEBB88|Baba Ganoush
BECFCD|Babbling Brook
A7BAD3|Babbling Creek
DC7B7C|Babe
876FA3|Babiana
ABCCC3|Baby Aqua
E9E3CE|Baby Artichoke
C3C3B8|Baby Barn Owl
6F5944|Baby Bear
9C4A62|Baby Berries
FAEFE9|Baby Blossom
A1CAF1|Baby Blue Eyes
A2CFFE|Baby Blue
89CFF0|Baby Blue, Pool Tiles
BBB98A|Baby Bok Choy
F0D0B0|Baby Breath
ABCAEA|Baby Bunting
8C665C|Baby Burro
87BEA3|Baby Cake
FFEDA2|Baby Chick
F3ACB9|Baby Fish Mouth
C8BA63|Baby Frog
FFDFE8|Baby Girl
8ABD7B|Baby Grass
8CFF9E|Baby Green
D0A7A8|Baby Jane
FFA468|Baby Melon
8FCBDC|Baby Motive
FFB7CE|Baby Pink
F4C2C2|Baby Pink, Tea Rose
FEFEFA|Baby Powder
CA9BF7|Baby Purple
A1A5A8|Baby Seal
005784|Baby Shoes
89A882|Baby Spinach
A78B81|Baby Sprout
F5C9DA|Baby Steps
BABABA|Baby Talk Grey
66B9D6|Baby Tears
DCC2CB|Baby Tone
EEFFDD|Baby Tooth
5D6942|Baby Vegetable
4D5588|Baby Whale
FFAEC1|Baby's Blanket
E8C1C2|Baby's Booties
D8E4E8|Baby's Breath
EECCBB|Babyccino
945759|Baca Berry
8A3A3C|Bacchanalia Red
8FAACA|Bachelor Blue
4ABBD5|Bachelor Button
FDDEA5|Bachimitsu Gold
16141C|Back In Black
6B625B|Back Stage
726747|Back To Basics
BDB98F|Back to Nature
C1853B|Back to School
7C725F|Backcountry
A7A799|Backdrop
FCF0E5|Backlight
687078|Backwater
4A6546|Backwoods
879877|Backyard
DF3F32|Bacon Strips
F1C983|Bad Hair Day
F2E5B4|Bad Moon Yellow
0A0908|Badab Black Wash
B4DA55|Badass Grass
FF6316|Badlands Orange
936A5B|Badlands Sunset
B5695A|Badlands
D3A194|Badshahi Brown
E1BD88|Bag of Gold
F6CD9B|Bagel
1C5544|Bagpiper
B5936A|Baguette
25597F|Bahama Blue
3FA49B|Bahaman Bliss
58C1CD|Baharroth Blue
C4C5AD|Bahia Grass
A9C01C|Bahia
887938|Baikō Brown
8A8EC9|Bailey Bells
8273FD|Bainganī
C7CDA8|Baize Green
4B5445|Baize
66A6D9|Baja Blue
FFF8D1|Baja White
D2C1A8|Baja
B34646|Baked Apple
B2754D|Baked Bean
DAD3CC|Baked Biscotti
DACBA9|Baked Bread
EDE9D7|Baked Brie
9C5642|Baked Clay
89674A|Baked Cookie
EEC8BC|Baked Ham
B69E87|Baked Potato
DF9876|Baked Salmon
E5D3BC|Baked Scone
9B775E|Baked Sienna
D7995D|Bakelite Gold
C6B788|Bakelite Yellow
E6D4A5|Bakelite
BF8284|Baker Rose
5C3317|Baker's Chocolate
C98F70|Baker's Dream
FF92AE|Baker-Miller Pink
F0F4F2|Bakery Box
AB9078|Bakery Brown
D0B393|Baker’s Bread
EFB435|Baklava
273F4B|Bakos Blue
C3C5A7|Balance Green
D1DBC2|Balance
C0B2A2|Balanced Beige
D7D2D1|Balanced
AFD3DA|Balboa
E2BCB8|Balcony Rose
D78E6B|Balcony Sunset
155187|Baleine Blue
6F5937|Bali Batik
5E9EA0|Bali Bliss
8A8E93|Bali Deep
849CA9|Bali Hai
F6E8D5|Bali Sand
F1A177|Balinese Sunset
21ABCD|Ball Blue
525661|Ball Gown
C0CEDA|Ballad Blue
CAB6C6|Ballad
E8DED6|Ballerina Beauty
F9EAEA|Ballerina Gown
F7B6BA|Ballerina Pink
F0DEE0|Ballerina Silk
F2BBB1|Ballerina Tears
C8647F|Ballerina Tutu
F2CFDC|Ballerina
AFC4D9|Ballet Blue
FC8258|Ballet Cream
D3ADB1|Ballet Rose
EDB9BD|Ballet Shoes
FFC5B3|Ballet Skirt
EBCED5|Ballet Slipper
FCA2AD|Ballet Slippers
F2E7D8|Ballet White
F7D5D4|Ballet
B2B29C|Ballie Scott Sage
A6B3C9|Ballroom Blue
58A83B|Ballyhoo
5C6F64|Balmy Palm Tree
B4DCD3|Balmy Seas
C5D8DE|Balmy
9C6B08|Balor Brown
CBBB92|Balsa Stone
9A7550|Balsa Wood
36574E|Balsam Branch
909E91|Balsam Fir
576664|Balsam Green
B19338|Balsam Pear
BEC4B7|Balsam
434340|Balsamic Reduction
130D07|Balsamico
A47552|Balthasar Gold
6C969A|Baltic Blue
9FBBDA|Baltic Bream
3AA098|Baltic Green
135952|Baltic Prince
3C3D3E|Baltic Sea
125761|Baltic Trench
00A49A|Baltic Turquoise
279D9F|Baltic
8EDACC|Bambino
C1ABA0|Bamboo Beige
C87F00|Bamboo Brown
454A48|Bamboo Charcoal
B1A979|Bamboo Forest
82994C|Bamboo Grass Green
99B243|Bamboo Leaf
E5DA9F|Bamboo Mat
BCAB8C|Bamboo Screen
A3B6A4|Bamboo Shoot
C6CFAD|Bamboo White
AE884B|Bamboo Yellow
E3DEC6|Bamboo
A50B5E|Banafsaji Purple
5A1991|Banafš Violet
FAF3A6|Banan-appeal
EFE073|Banana Ball
F8F739|Banana Bandanna
FFDE7B|Banana Biscuit
933E49|Banana Blossom
FDC838|Banana Boat
F7E82E|Banana Bombshell
FFCF73|Banana Bread
E8D82C|Banana Brick
F7EAB9|Banana Brûlée
D6D963|Banana Chalk
EEDD00|Banana Clan
FFF49C|Banana Cream
E7D3AD|Banana Crepe
FCF3C5|Banana Custard
FFDF38|Banana Farm
EEFE02|Banana Flash
DDD5B6|Banana Frappé
F1D3B2|Banana Ice Cream
FFFB08|Banana King
9D8F3A|Banana Leaf
FBE7B2|Banana Mania
FAE7B5|Banana Mania, Banana Yogurt
FAFE4B|Banana Mash
FFF7AD|Banana Milk
EDE6CB|Banana Milkshake
95A263|Banana Palm
FFE774|Banana Peel
FDD630|Banana Pepper
F7EFD7|Banana Pie
D0C101|Banana Powder
F3DB00|Banana Propaganda
F4EFC3|Banana Pudding
B29705|Banana Puree
FFE292|Banana Republic
F6F5D7|Banana Sparkes
F7EEC8|Banana Split
FFE135|Banana Yellow
FFFC79|Banana
E4D466|Bananarama
DCBE97|Bananas Foster
816E54|Bancroft Village
D7A97C|Band-Aid
E0D3BD|Banded Tulip
878466|Bandicoot
937F6D|Baneblade Brown
BBAA88|Bangalore
006A4F|Bangladesh Green
D2B762|Banh Bot Loc Dumpling
745E6F|Banished Brown
3E4652|Bank Blue
757374|Bank Vault
4B5539|Banksia Leaf
A6B29A|Banksia
A28557|Banner Gold
806B5D|Bannister Brown
E1E0D6|Bannister White
DAF0E6|Banshee
AF6C5D|Bantam Egg
98AB8C|Banyan Serenity
8D793E|Banyan Tree
E9546B|Bara Red
551100|Baragon Brown
006665|Barbados Bay
B8A983|Barbados Beige
2766AC|Barbados Blue
AA0A27|Barbados Cherry
3E6676|Barbados
FF0FF3|Barbara
A17308|Barbarian Leather
F78C5A|Barbarian
A84734|Barbarossa
C26157|Barbecue
D2C61F|Barberry Bush
E1D4BC|Barberry Sand
F3BD32|Barberry Yellow
EE1133|Barberry
FE46A5|Barbie Pink
C4B39C|Barcelona Beige
926A46|Barcelona Brown
FF9500|Barcelona Orange
E8D3C9|Bare Beige
EEDDCC|Bare Bone
F2E1DD|Bare Pink
817E6D|Bare
BAE9E0|Barely Aqua
DDAADD|Barely Bloomed
DDE0DF|Barely Blue
DD6655|Barely Brown
F8E9C2|Barely Butter
CCBDB9|Barely Mauve
FFE9C7|Barely Peach
EDEBDB|Barely Pear
F8D7DD|Barely Pink
FFE3CB|Barely Ripe Apricot
EDE0E3|Barely Rose
E1E3DD|Barely White
94AC02|Barf Green
68534A|Bargeboard Brown
BCAFA2|Barista
9E7B5C|Barite
708E95|Baritone
8FFF9F|Barium Green
F4E1C5|Barium
73532A|Bark Brown
AB9004|Bark Sawdust
5F5854|Bark
C5B497|Barking Prairie Dog
B6935C|Barley Corn
C7BCAE|Barley Field
FBF2DB|Barley Groats
F7E5B7|Barley White
D5B37E|Barley
8E5959|Barn Door
8B4044|Barn Red
4D332A|Barn Swallow
A00498|Barney Purple
AC1DB8|Barney
9C9480|Barnfloor
87857E|Barnwood Ash
9E9589|Barnwood Grey
554D44|Barnwood
5DAC51|Barnyard Grass
847098|Baroness Mauve
A785A7|Baroness
5A4840|Baronial Brown
95B6B5|Baroque Blue
AECCCB|Baroque Chalk Soft Blue
5F5D64|Baroque Grey
7B4F5D|Baroque Red
B35A66|Baroque Rose
DDAA22|Baroque
452E39|Barossa
8B6945|Barrel Aged
8E7E67|Barrel Stove
F0B069|Barrel
B9ABA3|Barren
F5D1B2|Barrett Quince
84623E|Barricade
0084A1|Barrier Reef
9F8E71|Barro Verde
4D423E|Basalt Black
4E5754|Basalt Grey
989998|Basalt Grey
575C3A|Base Camp
BB9955|Base Sand
F4EADC|Baseball Base
6994CF|Bashful Blue
B2B0AC|Bashful Emu
D0D2E3|Bashful Lilac
D9CDE5|Bashful Pansy
B88686|Bashful Rose
E3EDED|Bashful
DBC3B6|Basic Coral
C3B69F|Basic Khaki
828249|Basil Chiffonade
54622E|Basil Green
E2E6DB|Basil Icing
6C5472|Basil Mauve
529D6E|Basil Pesto
B7E1A1|Basil Smash
879F84|Basil
4A9FA7|Basilica Blue
BCECAC|Basilisk Lizard
9AB38D|Basilisk
B9DEE4|Basin Blue
C0A98B|Basket Beige
F4CC3C|Basket of Gold
EE6730|Basketball
BDA286|Basketry
CAAD92|Basketweave Beige
EBE1C9|Basmati White
5F6033|Basque Green
D3C1CB|Bassinet
C9B196|Basswood
FFCC88|Bastard-amber
2C2C32|Bastille
4D4A4A|Bastion Grey
7E7466|Bat Wing
EE3366|Bat's Blood Soup
FEFF00|Bat-Signal
87B2C9|Batch Blue
7A5F5A|Bateau Brown
1B7598|Bateau
E6F2EA|Bath Bubbles
0A696A|Bath Green
BBDED7|Bath Salt Green
62BAA8|Bath Turquoise
88EEEE|Bath Water
D8E9DB|Bath
C2E0E3|Bathe Blue
93C9D0|Bathing
7E738B|Batik Lilac
9C657E|Batik Pink
656E72|Batman
940084|Batman's NES Cape
973C6C|Baton Rouge
866F5A|Baton
1F1518|Bats Cloak
EDE2D4|Battered Sausage
1DACD4|Battery Charged Blue
74828F|Battle Blue
2B7414|Battle Cat
7E8270|Battle Dress
9C9C82|Battle Harbor
828F72|Battleship Green
6F7476|Battleship Grey
848482|Battleship Grey, Old Silver
9C9895|Battleship
11CC55|Battletoad
595438|Batu Cave
006392|Bauhaus Blue
CFB49E|Bauhaus Buff
B0986F|Bauhaus Gold
CCC4AE|Bauhaus Tan
3F4040|Bauhaus
1C3382|Bavarian Blue
FFF9DD|Bavarian Cream
20006D|Bavarian Gentian
749A54|Bavarian Green
4D3113|Bavarian Sweet Mustard
4D5E42|Bavarian
AFA490|Bay Area
773300|Bay Brown
9899B0|Bay Fog
214048|Bay Isle Pointe
86793D|Bay Leaf
D2CDBC|Bay Salt
FBE6CD|Bay Scallop
325F8A|Bay Site
6A819E|Bay View
AAAD94|Bay Water
747F89|Bay Wharf
BFC9D0|Bay of Hope
353E64|Bay of Many
BAE5D6|Bay
7B9AAD|Bay's Water
D0D9C7|Bayberry Frost
B6AA89|Bayberry Wax
255958|Bayberry
0098D4|Bayern Blue
20706F|Bayou
8EA6BA|Bayshore Blue
89CEE0|Bayshore
5FC9BF|Bayside
C9D8E4|Baywater Blue
8F7777|Bazaar
98777B|Bazaar
FFA6C9|Bazooka Pink, Carnation Pink
FFC943|Be Daring
F4E3E7|Be Mine
EC9DC3|Be My Valentine
A5CB66|Be Spontaneous
9B983D|Be Yourself
ADB864|Beach Bag
EFC700|Beach Ball
5F9CA2|Beach Blue
CEAB90|Beach Boardwalk
A69081|Beach Cabana
665A38|Beach Casuarina
94ADB0|Beach Cottage
C6BB9C|Beach Dune
CDE0E1|Beach Foam
96DFCE|Beach Glass
DCDDB8|Beach Grass
EDD481|Beach House
BDA2C4|Beach Lilac
FBD05C|Beach Party
FBB995|Beach Sand
FCE3B3|Beach Towel
FEDECA|Beach Trail
819AAA|Beach Umbrella
4F7694|Beach View
F6EED6|Beach White
DCE1E2|Beach Wind
CAC0B0|Beach Woods
EFE4BB|Beach
D9E4E5|Beachcomber
E4C683|Beachcombing
ACDBDB|Beachside Drive
C3B296|Beachside Villa
D2B17A|Beachwalk
E6D0B6|Beachy Keen
265C98|Beacon Blue
F2C98A|Beacon Yellow
494D8B|Beaded Blue
8D6737|Beagle Brown
33FFFF|Beaming Blue
FFF8DF|Beaming Sun
68755D|Bean Counter
685C27|Bean Green
8B6B51|Bean Pot
91923A|Bean Shoot
F3F9E9|Bean Sprout
EBF0E4|Bean White
4A1207|Bean
31AA74|Beanstalk
44382B|Bear Brown
AE6B52|Bear Claw
836452|Bear Creek
796359|Bear Hug
5A4943|Bear Rug
5B4A44|Bear in Mind
766E65|Bear
834D18|Bears Ear
7D756D|Bearsuit
B08F69|Beast Hide
680C08|Beastly Red
663300|Beasty Brown
6E6A44|Beat Around the Bush
73372D|Beaten Copper
4E0550|Beaten Purple
D1BE92|Beaten Track
448844|Beating Around the Bush
5F8748|Beatnik
BEBAD9|Beatrice
BCD4E6|Beau Blue
7DB39E|Beau Monde
0C6064|Beau Vert
80304C|Beaujolais
92774C|Beaumont Brown
553F44|Beauport Aubergine
186DB6|Beautiful Blue
686D70|Beautiful Darkness
B6C7E3|Beautiful Dream
D6DAD6|Beautiful Mint
EBB9B3|Beauty Bush
834F44|Beauty Patch
BE5C87|Beauty Queen
C79EA2|Beauty Secret
604938|Beauty Spot
C99680|Beauty and the Beach
866B8D|Beauty
997867|Beaver Fur
9F8170|Beaver Kit
60564C|Beaver Pelt
926F5B|Beaver
607879|Becker Blue
85A699|Beckett
4BEC13|Becquerel
B893AB|Bed of Roses
D3B9CC|Bedazzled
968775|Bedbox
AA8880|Bedford Brown
9E9D99|Bedrock
E1B090|Bedtime Story
FFAA33|Bee Cluster
F2CC64|Bee Hall
735B3B|Bee Master
EBCA70|Bee Pollen
FEFF32|Bee Yellow
F1BA55|Bee
E8D9D2|Bee's Knees
EABF86|Bee's Wax
574128|Beech Brown
758067|Beech Fern
D7B59A|Beech Nut
5B4F3B|Beech
C2C18D|Beechnut
6E5955|Beechwood
B64701|Beef Bourguignon
A85D2E|Beef Hotpot
A25768|Beef Jerky
BB5533|Beef Patties
E1B781|Beehive
F6E491|Beekeeper
449933|Beer Garden
773311|Beer Glazed Bacon
F28E1C|Beer
BF7E41|Beeswax Candle
E9D7AB|Beeswax
F5D297|Beeswing
7A1F3D|Beet Red
55584C|Beetle
CF2D71|Beetroot Purple
C58F9D|Beetroot Rice
663F44|Beetroot
736A86|Beets
96496D|Befitting
BD6F56|Before Winter
4D6A77|Before the Storm
5A4D39|Beggar
EC9ABE|Begonia Pink
C3797F|Begonia Rose
FA6E79|Begonia
5E6F8E|Beguiling Blue
AFA7AC|Beguiling Mauve
79553D|Beige Brown
CFB095|Beige Ganesh
E0D8B0|Beige Green
6D6552|Beige Grey
C5A88D|Beige Intenso
987A5B|Beige Intuition
E2DAC6|Beige Linen
C1876B|Beige Red
DE9408|Beige Red
CFC8B8|Beige Royal
FFC87C|Beige Topaz
E6DAA6|Beige
F5F5DC|Beige, Holy White
3E7DAA|Beijing Blue
A9A2A3|Beijing Moon
25A26F|Bejewelled
819AC1|Bel Air Blue
9BBCC3|Bel Esprit
558D4F|Belfast
A3A9A6|Belgian Block
F7EFD0|Belgian Blonde
F9F1E2|Belgian Cream
8D7560|Belgian Sweet
F3DFB6|Belgian Waffle
DBC7A8|Believable Buff
B9C3B3|Belize Green
7FD3D3|Belize
618B97|Bell Blue
A475B1|Bell Heather
DAD0BB|Bell Tower
93C3B1|Bella Green
DAC5BD|Bella Mia
E08194|Bella Pink
40465D|Bella Sera
0B695B|Bella Vista
574057|Bella
220011|Belladonna
ADC3A7|Belladonna's Leaf
B7DFF3|Bellagio Fountains
E3CBC0|Belle of the Ball
E1E9EF|Bellflower Blue
B2A5B7|Bellflower Violet
5D66AA|Bellflower
F5C78E|Bellini Fizz
F4C9B1|Bellini
EDE3A1|Bells and Whistles Gold
773B38|Belly Fire
00817F|Belly Flop
626A60|Belmont Green
E9D3D4|Beloved Pink
FFBA24|Beloved Sunflower
87CDED|Below Zero
0A2F7C|Below the Surface
EFF2F1|Beluga
E3DBC3|Belvedere Cream
F0F1E1|Belyi White
694977|Benevolence
DD1188|Benevolent Pink
38738B|Bengal Blue
8E773F|Bengal Grass
CC974D|Bengal
8F2E14|Bengala Red
913225|Bengara Red
B85241|Beni Shoga
BB7796|Benifuji
F35336|Benihi Red
5A4F74|Benikakehana Purple
44312E|Benikeshinezumi Purple
78779B|Benimidori Purple
007BAA|Benitoite
FB8136|Beniukon Bronze
000011|Benthic Black
CC363C|Bento Box
00D973|Benzol Green
D8CFB6|Berber
F59D59|Bergamot Orange
95C703|Bergamot
4B5B6E|Bering Sea
3D6D84|Bering Wave
7E613F|Berkeley Hills
F0E1CF|Berkshire Lace
5588CC|Berlin Blue
8CB1C2|Bermuda Blue
A19F79|Bermuda Grass
6B8BA2|Bermuda Grey
9D5A8F|Bermuda Onion
DACBBF|Bermuda Sand
F9EEE3|Bermuda Shell
F0E9BE|Bermuda Son
6F8C9F|Bermuda Triangle
1B7D8D|Bermuda
6BC271|Bermudagrass
386171|Bermudan Blue
E20909|Bern Red
9E6A75|Berries and Cream
F2B8CA|Berries n Cream
662277|Berry Blackmail
9E8295|Berry Bliss
264B56|Berry Blue Green
32607A|Berry Blue
B88591|Berry Blush
BB5588|Berry Boost
A08497|Berry Bright
544F4C|Berry Brown
AC72AF|Berry Burst
77424E|Berry Bush
A6AEBB|Berry Chalk
4F4763|Berry Charm
F8E3DD|Berry Cheesecake
3F000F|Berry Chocolate
765269|Berry Conserve
9A8CA2|Berry Cream
AA6772|Berry Crush
B3A1C6|Berry Frappé
EBDED7|Berry Frost
655883|Berry Jam
673B66|Berry Light
555A90|Berry Mix
B6CACA|Berry Mojito
84395D|Berry Patch
4F6D8E|Berry Pie
D6A5CD|Berry Popsicle
E5A2AB|Berry Riche
992244|Berry Rossi
895360|Berry Smoothie
64537C|Berry Syrup
624D55|Berry Wine
990F4B|Berry
D75E6C|Berrylicious
45DCFF|Berta Blue
BFE4D4|Beru
7082A4|Berwick Berry
2B322D|Beryl Black Green
BCBFA8|Beryl Green
E2E3DF|Beryl Pearl
A16381|Beryl Red
E9E5D7|Beryllonite
D4BA9D|Bespoke
685E5B|Bessie
C6B49C|Best Beige
5D513E|Best Bronze
B9B7BD|Best in Show
F7F2D9|Best of Summer
BD5442|Best of the Bunch
CD343D|Bestial Blood
6B3900|Bestial Brown
992211|Bestial Red
D38A57|Bestigor
7D655C|Betalain Red
352925|Betel Nut Dye
CADBBD|Bethany
EE0022|Bethlehem Red
EAEEDA|Bethlehem Superstar
73C9D9|Betsy
3A6B66|Betta Fish
EBE2CB|Better Than Beige
EDE1BE|Beurre Blanc
7ACCB8|Beveled Glass
6A393C|Bewitched
BBD0E3|Bewitching Blue
75495E|Bewitching
AAEEFF|Beyond the Clouds
688049|Beyond the Pines
0A3251|Beyond the Stars
D7E0EB|Beyond the Wall
DBB0D3|Bff
947706|Bhūrā Brown
F4EFE0|Bianca
3DCFC2|Bianchi Green
1C5022|Białowieża Forest
FFE58C|Bicycle Yellow
802C3A|Bicyclette
A9B9B5|Bidwell Blue
B19C8F|Bidwell Brown
507CA0|Biedermeier Blue
1BA169|Biel-Tan Green
F0908D|Bierwurst
AFABA0|Big Band
FF0099|Big Bang Pink
FFDA8B|Big Bus Yellow
7ECBE2|Big Chill
B98675|Big Cypress
5D6B75|Big Daddy Blue
9C2542|Big Dip O’Ruby
41494B|Big Dipper
DADBE1|Big Fish to Fry
99A38E|Big Fish
E88E5A|Big Foot Feet
B79E94|Big Horn Mountains
CDE2DE|Big Sky
ACDDAF|Big Spender
886E54|Big Stone Beach
334046|Big Stone
3F6E8E|Big Sur Blue Jade
B3CADC|Big Sur
96D0D1|Big Surf
FFEE22|Big Yellow Streak
FFFF33|Big Yellow Taxi
715145|Bigfoot
20120E|Bighorn Sheep
4E5E7F|Bijou Blue
A33D3B|Bijou Red
676B55|Bijoux Green
77212E|Biking Red
C3C0B1|Biking Trail
3E8027|Bilbao
71777E|Bilberry
B5C306|Bile
E39F08|Bilious Brown
A9D171|Bilious Green
1B6F81|Billabong
AD7C35|Billet
276B40|Billiard Ball
305A4A|Billiard Green
50846E|Billiard Room
155843|Billiard Table
00AA92|Billiard
01B44C|Billiards Cloth
D8DEE3|Billowing Clouds
D8E7E7|Billowing Sail
6E726A|Billowing Smoke
AFC7CD|Billowy Breeze
F6F0E9|Billowy Clouds
EFF0E9|Billowy Down
C0C6BC|Billowy
4C77A4|Billycart Blue
AE99D2|Biloba Flower
0075B8|Biloxi Blue
F4E4CD|Biloxi
E3C9A1|Biltmore Buff
410200|Biltong
007A91|Bimini Blue
616767|Binary Star
8B3439|Bindi Dot
B0003C|Bindi Red
AF4967|Bing Cherry Pie
433D3C|Binrouji Black
465F9E|Bio Blue
889900|BioShock
FBFB4C|Biohazard Suit
91A135|Biology Experiments
55EEFF|Bioluminescence
66FF55|Biopunk
EEEE44|Biotic Grasp
EEDD55|Biotic Orb
D9C3A1|Birch Beige
899A8B|Birch Forest
637E1D|Birch Leaf Green
DFB45F|Birch Strain
F6EEDF|Birch White
3F3726|Birch
CCBEAC|Birchwood
806843|Birchy Woods
CDDFE7|Bird Bath Blue
7F92A0|Bird Blue Grey
7B929E|Bird Blue
D0C117|Bird Flower
0083A8|Bird Of Paradise
FFF1CF|Bird's Child
AACCB9|Bird's Egg Green
CFBB9B|Bird's Nest
6C483A|Birdhouse Brown
89ACDA|Birdie Num Num
E9E424|Birdie
E2C28E|Birdseed
E4C495|Birdseye Maple
AB823D|Birdseye
B9030A|Bird’s Eye
2F3946|Biro Blue
F6EBC2|Birth of Venus
FCE9DF|Birth of a Star
E9D2CC|Birthday Cake
CFA2AD|Birthday Candle
9BDCB9|Birthday King
E2C7B6|Birthday Suit
79547A|Birthstone
224634|Birōdo Green
097988|Biscay Bay
55C6A9|Biscay Green
2F3C53|Biscay
DAC7AB|Biscotti
956C87|Утонченная Сирень
5D5153|Изысканная Слива
537175|Изысканный Бирюзовый
BFB5A6|Утонченность
7D7170|Второкурсник
A0D8EF|Сора Блю
4D8FAC|Сора Скай
A1A6D6|Сиреневый сорбет со льдом
DAC100|Сорбет Желтый
DD6B38|Сорбус
3398CE|Колдун
9B6D51|Щавель коричневый
A49688|Войлок из щавеля
887E64|Лист щавеля
9D7F61|Соррелл Браун
F1D058|Соррено с лимоном
FC0156|Соркс Красный
47788A|Сотек Зеленый
EDD1A8|Суфле
7E989D|Закалка души
377290|Поиск души
FFAA55|Сторона Души
58475E|Поезд души
757C91|Одухотворенный Синий
3B4457|Душевная музыка
374357|Душевный
1B150D|Бездушный
FFC8E9|Розовая Родственная душа
85777B|Родственная душа
DFE5D7|Звуки природы
AAEE22|Конфета с кислым яблоком
33BB00|Кольца из кислых яблок
A0AC4F|Кислое яблоко
8B844E|Кислый Бубба
66B348|Кислая конфета
E24736|Кислая вишня
ADC979|Кислое лицо
C8FFB0|Кисло - Зеленая вишня
C1E613|Кисло - Зеленый
FFEEA5|Кислый лимон
F4D9C5|Кислый Персик
FEE5C8|Кислые тарталетки
EEFF04|Кисло - желтый
CDEAE5|Синий источник
84B6A2|Источник Зеленый
C9B59A|Закваска
76614B|Южный Кингстон
698694|Южная часть Тихого океана
EAD2BB|Южный Персик
EADFD2|Южный Пик
A6847B|Трасса Саут- Рим - Трейл
FFDC9E|Солнце Южного Берега
B98258|Грязь Южных пустошей
F7DDDB|Южная красавица
A6D6C3|Южная красавица
365787|Южный Синий
E4DFD1|Южный бриз
34657D|Южный вечер
BCA66A|Southern Moss
ACB4AB|Southern Pine
D0D34D|Southern Platyfish
DE9F85|Southwest Stone
CC6758|Southwestern Clay
EDE0CE|Southwestern Sand
CE243F|Sovereign Red
4B4356|Sovereign
304E63|Sovereignty
FFD900|Soviet Gold
D5D2C7|Soy Milk
6F634B|Soya Bean
FAE3BC|Soya
D2C29D|Soybean
578363|Soylent Green
D3DEDF|Spa Blue
1993BE|Spa Dream
D4E4E6|Spa Retreat
D7C9A5|Spa Sangria
CEECE7|Spa
3B4271|Space Angel
440099|Space Battle Blue
505150|Space Black
1D2951|Space Cadet
150F5B|Space Colonization
667788|Space Convoy
002299|Space Dust
001199|Space Exploration
114499|Space Explorer
110022|Space Grey
139D08|Space Invader
324471|Space Missions
5511DD|Space Opera
4B433B|Space Shuttle
6C6D7A|Space Station
DAE6EF|Space Wolves Grey
5C6B6B|Spacebox
5F6882|Spaceman
222255|Spacescape
877D75|Spacious Grey
9A8557|Spacious Plain
D5EAF2|Spacious Skies
AEB5C7|Spacious Sky
424142|Spade Black
DDDDAA|Spaghetti Carbonara
EECC88|Spaghetti Monster
FBAED2|Spaghetti Strap Pink
FEF69E|Spaghetti
8D7F75|Spalding Grey
36B14E|Spandex Green
E5DBE5|Spangle
807532|Spanish Bistre
0070B8|Spanish Blue
D10047|Spanish Carmine
7F5F52|Spanish Chestnut
FCE5C0|Spanish Cream
E51A4C|Spanish Crimson
817863|Spanish Galleon
B09A4F|Spanish Gold
7B8976|Spanish Green
989898|Spanish Grey
FCE8CA|Spanish Lace
8E6A3F|Spanish Leather
684B40|Spanish Mustang
A1A867|Spanish Olive
E86100|Spanish Orange
C57556|Spanish Peanut
F7BFBE|Spanish Pink
5C3357|Spanish Plum
66033C|Spanish Purple
61504E|Spanish Raisin
E60026|Spanish Red
111133|Spanish Roast
CAB08E|Spanish Sand
00FFFE|Spanish Sky Blue
93765C|Spanish Style
DFBAA9|Spanish Villa
4C2882|Spanish Violet
007F5C|Spanish Viridian
DED1B7|Spanish White
F6B511|Spanish Yellow
E4E4DD|Spare White
F5D2B5|Sparkle Glow
FFEE99|Sparkler
77B244|Sparkling Apple
C15187|Sparkling Blueberry Lemonade
DCEEE3|Sparkling Brook
EFCF98|Sparkling Champagne
FFFDEB|Sparkling Cider
2DA4B6|Sparkling Cove
1F6C53|Sparkling Emerald
D2D5DA|Sparkling Frost
773376|Sparkling Grape
66EE00|Sparkling Green
EECCFF|Sparkling Lavender
C3C3C7|Sparkling Metal
A4DDD3|Sparkling Mint
F5CEE6|Sparkling Pink
CC11FF|Sparkling Purple
EE3333|Sparkling Red
D6EDF1|Sparkling River
CBD0CD|Sparkling Silver
F5FEFD|Sparkling Snow
D9E3E0|Sparkling Spring
FF7711|Sparks In The Dark
22EEFF|Sparky Blue
523E47|Sparrow Grey Red
69595C|Sparrow
FF6622|Sparrow’s Fire
76A4A7|Spartacus
7A8898|Spartan Blue
9E1316|Spartan Crimson
AFA994|Spartan Stone
C1EDD3|Spatial Spirit
DEDDDB|Spatial White
FFD9A6|Speak To Me
826A6C|Speakeasy
A8415B|Speaking of the Devil
885500|Spear Shaft
5FB6BF|Spearfish
5CBE86|Spearmint Burst
8DC2A8|Spearmint Frosting
BFD3CB|Spearmint Ice
CBECE6|Spearmint Leaf
E8F0E2|Spearmint Stick
B1EAE8|Spearmint Water
64BFA4|Spearmint
BCE3C9|Spearmints
A5B2B7|Special Delivery
7B787D|Special Grey
868B53|Special Ops
DCD867|Species
D38798|Speckled Easter Egg
BB02FE|Spectacular Purple
EDD924|Spectacular Saffron
F72305|Spectacular Scarlet
009B8C|Spectra Green
F7B718|Spectra Yellow
375D4F|Spectra
008664|Spectral Green
DFDCD8|Spectral
3D3C7C|Spectrum Blue
F20000|Spectrum Red
90BFD4|Speedboat
F9F1D7|Speeding Ticket
5A6272|Speedwell
4A373E|Spell Caster
5E4F50|Spell
E7DFCE|Spellbound
A38C6B|Spelt Grain Brown
35465E|Spelunking
A5AD44|Sphagnales Moss
75693D|Sphagnum Moss
F2E8CC|Sphere
AB9895|Sphinx
86613F|Spice Bazaar
B87243|Spice Cake
F0DED3|Spice Cookie
F3E9CF|Spice Delight
C9D6B4|Spice Garden
E1C2C1|Spice Girl
EBD0A4|Spice Is Nice
F4EEDC|Spice Ivory
B84823|Spice Market
FFB088|Spice Pink
B95B3F|Spice Route
86493F|Spice of Life
6C4F3F|Spice
604941|Spiceberry
783937|Spiced Apple
E9D2BB|Spiced Beige
85443F|Spiced Berry
BB9683|Spiced Brandy
FFD978|Spiced Butternut
A4624C|Spiced Carrot
D3B080|Spiced Cashews
915B41|Spiced Cider
805B48|Spiced Cinnamon
D75C5D|Spiced Coral
A38061|Spiced Honey
53433E|Spiced Hot Chocolate
886C57|Spiced Latte
B99563|Spiced Mustard
FFBB72|Spiced Nectarine
BC693E|Spiced Nut
927D6C|Spiced Nutmeg
EDC7B6|Spiced Orange
6D4773|Spiced Plum
905D5F|Spiced Potpourri
D88D56|Spiced Pumpkin
BB1166|Spiced Purple
8B4C3D|Spiced Red
AD8B6A|Spiced Rum
AB6162|Spiced Tea
E67A37|Spiced Up Orange
B14B38|Spiced Up
CDBA99|Spiced Vinegar
664942|Spiced Wine
BB715B|Spiced
CC3366|Spicy Berry
9B5B4F|Spicy Cayenne
A85624|Spicy Cinnamon
994B35|Spicy Hue
EEBBAA|Spicy Hummus
8B5F4D|Spicy Mix
74640D|Spicy Mustard
D73C26|Spicy Orange
F38F39|Spicy Paella
FF1CAE|Spicy Pink
B9396E|Spicy Purple
97413E|Spicy Red
F6AC00|Spicy Sweetcorn
C75433|Spicy Tomato
C75F26|Spicy and Oriental
FF1111|Spicy
E2E8DF|Spider Cotton
656271|Spike
FDDDB7|Spiked Apricot
600000|Spikey Red
9B351B|Spill the Beans
E4E1DE|Spilled Cappuccino
F4F4D1|Spilt Milk
AAAA55|Spinach Banana Smoothie
B1CDAC|Spinach Dip
909B4C|Spinach Green
83825B|Spinach Souffle
6E750E|Spinach Soup
E4E8DA|Spinach White
46A35A|Spinach
B3C4D8|Spindle
73FCD6|Spindrift
41435B|Spinel Black
6A5662|Spinel Grey
FF4DC9|Spinel Red
272A3B|Spinel Stone Black
38283D|Spinel Violet
018CB6|Spinnaker Blue
A3E2DD|Spinnaker
5B6A7C|Spinning Blue
F3DDBC|Spinning Silk
F6EDDA|Spinning Wheel
514B80|Spirit Dance
6A8B98|Spirit Mountain
5F534E|Spirit Rock
D45341|Spirit Warrior
E3EEBF|Spirit Whisper
B2BBC6|Spirit
FDE7E3|Spirited Away
BDDEC7|Spirited Green
FFDC83|Spirited Yellow
FD411E|Spiritstone Red
0FC0FC|Spiro Disco Ball
5A665C|Spirulina
6F757D|Spitsbergen Blue
5984B0|Splash Palace
D8B98C|Splash of Honey
F1D79E|Splash
D4E8D8|Splashdown
44DDFF|Splashing Wave
019196|Splashy
D01A2C|Splatter Movie
A9586C|Splatter
CCEE00|Spleen Green
806E7C|Splendiferous
FFB14E|Splendor Gold
5870A4|Splendor and Pride
F3DFCC|Splendor
A3713F|Splinter
3194CE|Splish Splash
C8B165|Split Pea Soup
9C9A40|Split Pea
8E6C51|Split Rail
E8FF2A|Spoiled Egg
B6BFE5|Spoiled Rotten
FFFE40|Sponge Cake
A49775|Sponge
D4D1D9|Spooky Ghost
685E4F|Spooky Graveyard
D1D2BF|Spooky
F5EAE3|Spooled White
E7E9E3|Spoonful of Sugar
7F8162|Spores
00A27D|Sport Green
EFD678|Sport Yellow
434C47|Sporting Green
399BB4|Sports Blue
E08119|Sports Fan
4D8064|Sports Field Green
6A8AA4|Sporty Blue
FAEACD|Spotlight
BFBFBD|Spotted Dove
B1D3E3|Spotted Snake Eel
AEA692|Spray Green
BDD0C3|Spray of Mint
7ECDDD|Spray
007711|Spreadsheet Green
D6C1C5|Sprig Muslin
8BE0BA|Sprig of Mint
E9EDBD|Spring Blossom
6DCE87|Spring Bouquet
D7B9CB|Spring Boutique
A98C37|Spring Branch
A7FC00|Spring Bud
C9E0C8|Spring Burst
FFF6C2|Spring Buttercup
BA69A1|Spring Crocus
DBD7B7|Spring Day
D9EEE1|Spring Dew
E5E3BF|Spring Fever
4A7368|Spring Field
B3CDAC|Spring Fields
ECF1EC|Spring Fog
67926F|Spring Forest
11BB22|Spring Forth
BABD29|Spring Forward
87FF2A|Spring Frost
558961|Spring Garden
D3E0B8|Spring Glow
D5CB7F|Spring Grass
00FF7F|Spring Green
C5C6B3|Spring Grey
FFFDDD|Spring Heat
C4CBB2|Spring Hill
4A754A|Spring Juniper
E3EFB2|Spring Kiss
A8C3AA|Spring Leaves
B1B3CB|Spring Lilac
FCF4C8|Spring Lily
6C2C2F|Spring Lobster Brown
7A4171|Spring Lobster Dye
640125|Spring Lobster
C0B05D|Spring Marsh
D3E0DE|Spring Mist
E5F0D5|Spring Morn
A99757|Spring Moss
596C3C|Spring Onion
DFBCC9|Spring Pink
A3BD9C|Spring Rain
A1BFAB|Spring Reflection
C4A661|Spring Roll
CCEECC|Spring Savor
E2EDC1|Spring Shoot
ABDCEE|Spring Shower
B8F8B8|Spring Slumber Green
FACCBF|Spring Song
A2C09B|Spring Sprig
86BA4A|Spring Sprout
A9C6CB|Spring Storm
98BEB2|Spring Stream
F1F1C6|Spring Sun
D9DCDD|Spring Thaw
D8DCB3|Spring Thyme
99CDE6|Spring Tide
CED7C5|Spring Valley
82A320|Spring Vegetables
ACB193|Spring Walk
7AB5AE|Spring Water Turquoise
E0EED4|Spring Wheat
ECFCEC|Spring White
CDA4DE|Spring Wisteria
E9E1D9|Spring Wood
F2E47D|Spring Yellow
00F900|Spring
C8CB8E|Springtide Green
9AA955|Springtide Melodies
DB88AC|Springtime Bloom
FFFFEF|Springtime Dew
EBEEF3|Springtime Rain
E9E5B3|Springtime
7EA15A|Springview Green
EBDDEA|Sprinkle
E7A2AE|Sprinkled With Pink
CFECEE|Sprinkled with Dew
B9DCC3|Sprite Twist
76C5E7|Spritzig
CBD7D2|Sprout Green
B8CA9D|Sprout
F3D48B|Sprouted
91A49D|Spruce Shade
838A7A|Spruce Shadow
9FC09C|Spruce Stone
B35E97|Spruce Tree Flower
6E6A51|Spruce Woods
BE8A4A|Spruce Yellow
0A5F38|Spruce
9A7F28|Spruced Up
BCCFA4|Spumoni
F3ECDC|Spun Cotton
F4E4CF|Spun Jute
A2A1AC|Spun Pearl
FAE2ED|Spun Sugar
E3DED4|Spun Wool
FFEE88|Spätzle Yellow
666666|Squant
E7B17C|Squash Bisque
F8B438|Squash Blossom
F2AB15|Squash
6CC4DA|Squeaky
11EE00|Squeeze Toy Alien
6E2233|Squid Hat
001133|Squid Ink Powder
F5B4BD|Squid Pink
4D4E5C|Squid's Ink
AA4F44|Squig Orange
8F7D6B|Squirrel
665E48|Squirrel's Nest
95BCC5|Squirt
F56961|Sriracha
D0DDCC|St. Augustine
577C88|St. Bart's
EEDDDD|St. Nicholas Beard
2B8C4E|St. Patrick
DEE8F3|St. Petersburg
325482|St. Tropez
C1D0B2|Stability
F6E0BE|Stable Hay
858885|Stack
D1B992|Stacked Limestone
918676|Stacked Stone
D5F534|Stadium Grass
9AF764|Stadium Lawn
603B41|Stag Beetle
9E6928|Stage Gold
B081AA|Stage Mauve
7F5A44|Stagecoach
556682|Stained Glass
B4BDC7|Stainless Steel
67716E|Stairway to Heaven
D4C4A7|Stalactite Brown
7CB26E|Stalk
B0A8AD|Stamina
638636|Stamnankáthi Green
2EA18C|Stamp Pad Green
A0A09A|Stamped Concrete
7F8596|Stand Out
FF0066|Standby Led
BFB9BD|Standing Ovation
005599|Standing Waters
85979A|Standish Blue
658F7C|Stanford Green
BCAB9C|Stanford Stone
A40000|Stanger Red
9BC2B4|Stanley
5C5042|Star Anise
E8DDAE|Star Bright
5796A1|Star City
007BB8|Star Command Blue
F9F3DD|Star Dust
BEAA4A|Star Fruit Yellow Green
75DBC1|Star Grass
D8DCE6|Star Jasmine
E4D8D8|Star Magic
DAE2E9|Star Map
B3C6CE|Star Mist
9500FF|Star Platinum Purple
386192|Star Sapphire
F8F6E3|Star Shine
3A5779|Star Spangled
EFEFE8|Star White
C51F26|Star and Crescent Red
0000F7|Star of David
EBE3C7|Star of Gold
057BC1|Star of Life
EBBBBE|Star of Morning
FFE500|Star
F7EBAC|Star-Studded
016C4F|Starboard
F5ECC9|Starbright
6CB037|Starbur
DCE7E5|Starburst
A6B2B5|Stardew
DACFD4|Stardust Ballroom
B8BFDC|Stardust Evening
DDD3AE|Stardust
E5BCA5|Starfish
0096FF|Starfleet Blue
4E9AB0|Starflower Blue
F0E8D5|Starfox
E4D183|Starfruit
7777FF|Stargate Shimmer
B7C4D3|Stargate
39505C|Stargazer
414549|Stargazing
FAEEDE|Starglider
D2C6B6|Stark White
3E4855|Starless Night
EDC2DB|Starlet Pink
854E51|Starlet
B5CED4|Starlight Blue
BCC0CC|Starlight
E8DFD8|Starling's Egg
384351|Starlit Eve
3B476B|Starlit Night
286492|Starry Night
4F5E7E|Starry Sky Blue
FF47CA|Stars in Shock
758BA4|Starset
CCE7E8|Starship Tonic
229966|Starship Trooper
E3DD39|Starship
4664A5|Starstruck
E56131|Startling Orange
C5BDC4|Stately Frills
577A6C|Stately Stems
FAF9EA|Stately White
D5D3C3|Static
9EA4A5|Statuary
376D64|Statue of Liberty
D0BCB1|Statued
E0DFD9|Statuesque
DC8A30|Status Bronze
9FAC5C|Stay in Lime
314662|Stay the Night
4A5777|Steadfast
8A6B4D|Steady Brown
4B4844|Stealth Jet
CCD0DA|Steam Bath
EBE1A9|Steam Chestnut
B2B2AD|Steam Engine
E8E9E5|Steam White
DDDDDD|Steam
D2CCB4|Steamboat Geyser
E0D4BD|Steamed Chai
D3B17D|Steamed Chestnut
EAD8BE|Steamed Milk
EE8888|Steamed Salmon
C39C55|Steampunk Gold
6F3B34|Steampunk Leather
EAE9B4|Steamy Dumpling
B1CFC7|Steamy Spring
767275|Steel Armor
7D94C6|Steel Blue Eyes
436175|Steel Blue Grey
4682B4|Steel Blue
43464B|Steel Grey
7A744D|Steel Legion Drab
5599B6|Steel Light Blue
DDD5CE|Steel Me
C6CEDA|Steel Mist
71A6A1|Steel Pan Mallet
CC33CC|Steel Pink
5F8A8B|Steel Teal
929894|Steel Toe
767574|Steel Wool
797979|Steel
90979B|Steely Grey
827E7C|Steeple Grey
074863|Stegadon Scale Green
415862|Steiglitz Fog
F9DAA5|Stella Dora
F5D056|Stella
9FB5CE|Stellar Blue
002222|Stellar Explorer
FFF4DD|Stellar Light
AB9D9C|Stellar Mist
46647E|Stellar
ABDF8F|Stem Green
B4CEDA|Stencil Blue
7D7640|Steppe Green
A4A7A4|Stepping Stone
B2A18C|Stepping Stones
FFF5CF|Stereotypical Duck
A2B9C2|Sterling Blue
E9EBDE|Sterling Shadow
9EAFC2|Sterling Silver
D1D4D1|Sterling
9E7A58|Stetson
C5B5A4|Steveareno Beige
BAA482|Sticks & Stones
131212|Sticky Black Tarmac
CC8149|Sticky Toffee
8D8F8E|Stieglitz Silver
FADB5E|Stil De Grain Yellow
B6453E|Stiletto Love
323235|Stiletto
C154C0|Still Fuchsia
ABA9A0|Still Grey
CBC4B2|Still Moment
FFF8E1|Still Morning
4A5D5F|Still Water
ADAF9C|Still
C2D0DF|Stillwater Lake
70A4B0|Stillwater
A29A6A|Stilted Stalks
495D39|Stinging Nettle
AEFD6C|Stinging Wasabi
B0ABA3|Stingray Grey
2A545C|Stinkhorn
AE5A2C|Stirland Battlemire
492B00|Stirland Mud
F6B064|Stirring Orange
900910|Stizza
806852|Stock Horse
104F4A|Stockade Green
E9E5D8|Stocking White
647B72|Stockleaf
E0E0FF|Stoic White
EFDCD3|Stolen Kiss
0088B0|Stomy Shower
829CA5|Stone Blue
52706C|Stone Bridge
B79983|Stone Brown
888C90|Stone Cairn
7D867C|Stone Craft
8F9183|Stone Creek
5F7D6C|Stone Cypress Green
929C9C|Stone Fence
C5C0B0|Stone Fortress
F2A28C|Stone Fruit
C2CBD2|Stone Golem
658E67|Stone Green
8B8C7A|Stone Grey
9F9484|Stone Grey
CABA97|Stone Guardians
E8E0D8|Stone Harbour
93888C|Stone Haze
636869|Stone Hearth
B3A491|Stone Lion
7A7B75|Stone Mason
B6B7AD|Stone Mill
E4EFE5|Stone Path
EFE5D4|Stone Pillar
665C46|Stone Pine
ECE4DC|Stone Quarry
8BA8AE|Stone Silver
A09484|Stone Terrace
4D404F|Stone Violet
B5B09E|Stone Walkway
EFE1D8|Stone Wall
AFA791|Stone Walls
E5D4C0|Stone Wash
D6E0E7|Stone Washed
ADA587|Stone
605C58|Stone's Throw
DDCEA7|Stonebread
CBA97E|Stonebriar
A08F6F|Stonecrop
99917E|Stonegate
A79D8D|Stonehenge Greige
BAB1A3|Stonelake
8D7A4D|Stonetalon Mountains
C1C1C1|Stonewall Grey
807661|Stonewall
A5978D|Stoneware
74809A|Stonewash
DCCCC0|Stonewashed Brown
F4EEE4|Stonewashed Pink
DDD7C5|Stonewashed
CCB49A|Stonish Beige
948F82|Stony Creek
615547|Stony Field
C33A36|Stop
DD1111|Stoplight
F2F2E2|Storksbill White
E5E1DD|Storksbill
507B9C|Storm Blue
938988|Storm Break
808283|Storm Cloud
65645F|Storm Dust
787376|Storm Front
113333|Storm Green
717486|Storm Grey
3D3D63|Storm Is Coming
F9E69C|Storm Lightning
7F95A5|Storm Petrel
A28A88|Storm Red
696863|Storm Warning
444400|Storm
CFC9BC|Storm's Coming
E7B57F|Stormeye
80A7C1|Stormfang
BBC6C9|Stormhost Silver
8D9390|Storms Mountain
5C5954|Stormvermin Fur
9AAFAF|Stormy Bay
7D7B7C|Stormy Grey
777799|Stormy Horizon
71738C|Stormy Mauve
372354|Stormy Night
70818E|Stormy Oceans
C36666|Stormy Passion
E3B5AD|Stormy Pink
507B9A|Stormy Ridge
6E8082|Stormy Sea
0F9B8E|Stormy Strait Green
6B8BA4|Stormy Strait Grey
58646D|Stormy Weather
B0BCC3|Stormy
0F0B0A|Stout
7B8393|Stowaway
52A550|Straightforward Green
628026|Straken Green
DBB060|Stranglethorn Ochre
528A9A|Stratford Blue
8C8670|Stratford Sage
3799C8|Stratos Blue
000741|Stratos
9EC1CC|Stratosphere
ACB8B2|Stratton Blue
8193AA|Stratus
77515A|Stravinsky Pink
996E74|Stravinsky
D9C69A|Straw Basket
FCF679|Straw Gold
DBC8A2|Straw Harvest
F0D5A8|Straw Hat
BDB268|Straw Hut
F0D696|Straw Yellow
E4D96F|Straw
FFDADC|Strawberry Blonde
FFEBFA|Strawberry Bonbon
F8B3FF|Strawberry Buttercream
F4BFC6|Strawberry Confection
990011|Strawberry Cough
F4C3C4|Strawberry Cream
A23D50|Strawberry Daiquiri
FF88AA|Strawberry Dreams
FFF0EA|Strawberry Dust
FA8383|Strawberry Field
FFA2AA|Strawberry Frappé
C677A8|Strawberry Freeze
FFDBF7|Strawberry Frost
FF6FFC|Strawberry Frosting
DAB7BE|Strawberry Glaze
E78B90|Strawberry Ice
86423E|Strawberry Jam
C08591|Strawberry Jubilee
FFD9E7|Strawberry Milk
D47186|Strawberry Milkshake
E42D65|Strawberry Mix
CF5570|Strawberry Moon
A5647E|Strawberry Mousse
F57F8E|Strawberry Pink
EE2255|Strawberry Pop
D53032|Strawberry Red
B96364|Strawberry Rhubarb
F7CDCE|Strawberry Ripple
E29991|Strawberry Rose
FA8E99|Strawberry Shortcake
EE0055|Strawberry Smash
E79EA6|Strawberry Smoothie
F7879A|Strawberry Soap
FA4224|Strawberry Spinach Red
B9758D|Strawberry Surprise
F9D7CD|Strawberry Whip
CB6A6B|Strawberry Wine
E9B3B4|Strawberry Yogurt
FB2943|Strawberry
DDBDBA|Strawflower
556061|Stream Bed
495E7B|Stream
D8E2DF|Streetwise
2B2C30|Stretch Limo
9DBBD0|Stretch of Water
DFD8C8|Stretched Canvas
D7AA60|Streusel Cake
D7B55F|Strike It Rich
5A4659|Strike a Pose
946A81|Strikemaster
CE7843|Striking Orange
944E87|Striking Purple
C03543|Striking Red
00667B|Striking
F1E8D8|String Ball
FBF1DD|String Cheese
7F7860|String Deep
EBE3D8|String of Pearls
AA9F96|String
406356|Stromboli
0C06F7|Strong Blue
960056|Strong Cerise
782E2C|Strong Envy
5E5F7E|Strong Iris
6F372D|Strong Mocha
A88905|Strong Mustard
646756|Strong Olive
FF0789|Strong Pink
2B6460|Strong Sage
8A3E34|Strong Strawberry
454129|Strong Tone Wash
A3A59B|Strong Winds
A86F48|Stroopwafel
F0E1E8|Struck by Lightning
0E9BD1|Structural Blue
E8DECE|Stucco Tan
F1B19D|Stucco Wall
E2D3B9|Stucco White
A58D7F|Stucco
005577|Studer Blue
C1B2A1|Studio Beige
6D817B|Studio Blue Green
D9CCB8|Studio Clay
EBDBAA|Studio Cream
C6B9B8|Studio Mauve
A59789|Studio Taupe
E8DCD5|Studio White
724AA1|Studio
ADAC7C|Stuffed Olive
BF9B84|Stuffing
5E5F4D|Stump Green
DA9A5D|Stunning Gold
185887|Stunning Sapphire
676064|Stunning Shade
9B856F|Sturdy Brown
57544D|Sturgis Grey
BC3439|Stylish Red
CEC1A5|Stylish
9FA0A0|Su-Nezumi Grey
D1D8DD|Suave Grey
00576F|Subaqueous
CCB8B3|Subdue Red
C6B1AD|Subdued Hue
CC896C|Subdued Sienna
ECEDE0|Sublime
5566AA|Submarine Base
4D585C|Submarine Grey
7A7778|Submarine
4A7D82|Submerged
00576E|Submersible
012253|Subnautical
D8CCC6|Subpoena
4F4E4A|Subterrain Kingdom
1F3B4D|Subterranean River
452C1F|Subterranean
D9E3E5|Subtle Blue
B5CBBB|Subtle Green
554B4F|Subtle Night Sky
D8D8D0|Subtle Shadow
D0BD94|Subtle Suede
E4D89A|Subtle Sunshine
DBDBD9|Subtle Touch
7A9693|Subtle Turquoise
B29E9E|Subtle Violet
87857C|Subway
513B6E|Succinct Violet
990022|Succubus
BCCBB2|Succulent Garden
5E9B86|Succulent Green
658E64|Succulent Leaves
DCDD65|Succulent Lime
8BA477|Succulent
007744|Succulents
C6C1C5|Such Melodrama
FBDDAF|Such a Peach
AC6B29|Sudan Brown
6376A9|Sudden Sapphire
1A5897|Suddenly Sapphire
A6B4C5|Suds
D9C7B9|Suede Beige
857F7A|Suede Grey
585D6D|Suede Indigo
896757|Suede Leather
D79043|Suede Vest
BA8864|Suede
235E80|Suez Canal
ECD0A1|Suffragette Yellow
935529|Sugar Almond
834253|Sugar Beet
E3D4CD|Sugar Berry
F7C2BF|Sugar Cane Dahlia
EEEFDF|Sugar Cane
FFCCFF|Sugar Chic
BB6611|Sugar Coated Almond
FFEDF1|Sugar Coated
F2E2A4|Sugar Cookie
F56C73|Sugar Coral
C96FA8|Sugar Creek
F9EDE3|Sugar Dust
FFF0E1|Sugar Glaze
CC9955|Sugar Glazed Cashew
9437FF|Sugar Grape
EFC9EC|Sugar High
DDAA66|Sugar Honey Cashew
9C7647|Sugar Maple
FFF9F5|Sugar Milk
C0E2C5|Sugar Mint
C7A77B|Sugar Pie
73776E|Sugar Pine
914E75|Sugar Plum
AED6D4|Sugar Pool
E58281|Sugar Poppy
EBE5D7|Sugar Quill
CFB599|Sugar Rush Peach Pepper
EED5B6|Sugar Shack
EFE8DC|Sugar Soap
ECC4DC|Sugar Sweet
F3EEE7|Sugar Swizzle
D68F9F|Sugar Tooth
A2999A|Sugar Tree
8B2E16|Sugar-Candied Peanuts
B49D7B|Sugared Almond
FDDCC6|Sugared Peach
EBD5B7|Sugared Pears
554400|Sugarloaf Brown
FFDDFF|Sugarpills
FDC5E3|Sugarwinkle
A2999F|Sugilite
2B3036|Suit Blue
645A4B|Suitable Brown
E5CC69|Sulfur Pit
DBC058|Sulfur Yellow
EEED56|Sulfuric
A58B34|Sullen Gold
F7C5D1|Sullivan's Heart
BAA600|Sulphine Yellow
D5D717|Sulphur Spring
F2F3CF|Sulphur Water
CCC050|Sulphur Yellow
DDB614|Sulphur
F6AC17|Sultan Gold
E3C9BE|Sultan Sand
E89BC7|Sultan of Pink
134558|Sultan's Silk
674668|Sultana
948D84|Sultry Castle
506770|Sultry Sea
73696F|Sultry Smoke
716563|Sultry Spell
C6EA80|Sulu
E08A1E|Sumac dyed
4F666A|Sumatra Chicken
F6E8CC|Sumatra
595857|Sumi Ink
7058A3|Sumire Violet
3FAFCF|Summer Air
DBC2B9|Summer Beige
BBD5EF|Summer Birthday
FCF1CF|Summer Bliss
D1BEB4|Summer Bloom
1880A1|Summer Blue
F6DFD6|Summer Blush
D3E5DB|Summer Breeze
F8822A|Summer Citrus
BBFFEE|Summer Cloud
E5CFDE|Summer Clover
ECB6B5|Summer Cocktails
57595D|Summer Concrete
FAD1E0|Summer Cosmos
F2D6DA|Summer Crush
FFE078|Summer Daffodil
EAAA62|Summer Day
83ADA3|Summer Dragonfly
E2C278|Summer Field
BE4B3B|Summer Fig
228B22|Summer Forest Green
7AAC80|Summer Garden
EEAA44|Summer Glow
8FB69C|Summer Green
FFE69A|Summer Harvest
AA5939|Summer Heat
C1A58D|Summer Hill
C8EFE2|Summer House
FFEFC2|Summer Hue
EEEBD6|Summer Jasmine
0077A7|Summer Lake
F8D374|Summer Lily
EAD3AE|Summer Melon
DF856E|Summer Memory
CBEAEE|Summer Mist
FDEDCF|Summer Moon
36576A|Summer Night
FFB653|Summer Orange
F5F0D1|Summer Pear
E1E8DB|Summer Rain
F7EFBA|Summer Resort
ECE4CE|Summer Sandcastle
66A9B1|Summer Sea
D1D9D7|Summer Shade
E5EBE3|Summer Shower
38B0DE|Summer Sky
94D3D1|Summer Soft Blue
DED1A3|Summer Solstice
B0C5DF|Summer Storm
FFDC00|Summer Sun
D88167|Summer Sunset
F7E8C7|Summer Sunshine
4B9CAB|Summer Turquoise Blue
008572|Summer Turquoise
215399|Summer Waters
BB8E55|Summer Weasel
F4E9D6|Summer White
CDA168|Summer in the City
74CDD8|Summer of '82
DC9367|Summer's End
A97069|Summer's Eve
F9E699|Summer's Heat
376698|Summerday Blue
C47A3D|Summerset
F2D178|Summertime
8CBC9E|Summertown
997651|Summerville Brown
D4B28B|Summerwood
8BB6B8|Summit
E5B99B|Sumptuous Peach
A36658|Sun Baked Earth
D27F63|Sun Baked
E3EFE1|Sun Bleached Mint
E3AB7B|Sun Bleached Ochre
FADADD|Sun Bleached Pink
FFFED9|Sun City
FF8C00|Sun Crete
C4AA4D|Sun Dance
F0DCA0|Sun Deck
C79B36|Sun Dial
FFE7A3|Sun Drenched
752329|Sun Dried Tomato
EABD5B|Sun Dried
EAAF11|Sun Drops
F6E0A4|Sun Dust
D0D418|Sun Flooded Woods
F1F4D1|Sun Glare
FAF3D9|Sun Glint
DFBA5A|Sun God
EBD1BB|Sun Kiss
FFEEC2|Sun Kissed
F48037|Sun Orange
FFB219|Sun Ray
E7C26F|Sun Salutation
FFDE73|Sun Shower
E9AD17|Sun Song
FBD795|Sun Splashed
FFF2A0|Sun Surprise
FAD675|Sun Touched
698538|Sun Valley
ECC033|Sun Wukong's Crown
FFDF22|Sun Yellow
EF8E38|Sun
F6F2E5|Sun's Glory
A94E37|Sun's Rage
B75E41|Sun-Kissed Brick
DCD3B2|Suna White
AB9A6E|Sunbaked Adobe
FAD28F|Sunbathed Beach
F5DD98|Sunbathed
7E4730|Sunbathing Beauty
F0D39D|Sunbeam Yellow
F5EDB2|Sunbeam
FEFF0F|Sunblast Yellow
E5E0D7|Sunbleached
F9D964|Sunbound
B37256|Sunburn
FF404C|Sunburnt Cyclops
D79584|Sunburnt Toes
F6C289|Sunburst
FAC76C|Sundance
F6C778|Sunday Afternoon
FCC9C7|Sunday Best
DCC9AE|Sunday Drive
D7BAD1|Sunday Gloves
3D4035|Sunday Niqab
FAE198|Sundaze
E1CDAE|Sundew
C0805D|Sundial
F5C99E|Sundown
EBCF89|Sundress
692B2B|Sundried Tomato
FFDE02|Sundried
6E5F57|Sunezumi Brown
FFE26A|Sunflower Dandelion
FFCD01|Sunflower Island
FFB700|Sunflower Mango
FFE3A9|Sunflower Seed
FDBD27|Sunflower Valley
FFDA03|Sunflower Yellow
FFC512|Sunflower
C76155|Sunglo
FFCC33|Sunglow
51574F|Sunken Battleship
B29700|Sunken Gold
1C3D44|Sunken Harbor
C8DDDA|Sunken Pool
6B443D|Sunken Ship
F2BDA8|Sunkissed Apricot
DEAB9B|Sunkissed Beach
FFA56E|Sunkissed Coral
FED8BF|Sunkissed Peach
FFE9BA|Sunkissed Yellow
EA6676|Sunkist Coral
EDD59E|Sunlight
9787BB|Sunlit Allium
7D7103|Sunlit Kelp Green
FFDB78|Sunlit
DA8433|Sunlounge
E8D7B1|Sunning Deck
EADFAA|Sunny Burrata
DBA637|Sunny Disposition
FFC946|Sunny Festival
EDE1CC|Sunny Gazebo
E8D99C|Sunny Glory
C5CD40|Sunny Green
F8F0D8|Sunny Honey
D0875A|Sunny Horizon
DFEF87|Sunny Lime
F5F5CC|Sunny Mimosa
F7C84A|Sunny Mood
F6D365|Sunny Morning
D9D7D9|Sunny Pavement
FFDC41|Sunny Side Up
FFC900|Sunny Summer
E3E9CF|Sunny Summit
FEDF94|Sunny Veranda
F39F18|Sunny Yellow
FFF917|Sunny Yellow
F2F27A|Sunny
F8D016|Sunnyside
FFD18C|Sunporch
CFC5B6|Sunray Venus
E3AB57|Sunray
FEF0C5|Sunrise Glow
CAA061|Sunrise Heat
F4BF77|Sunrise
FFCF48|Sunrise, Sunglow Gecko
FFDB67|Sunrose Yellow
D0A584|Sunset Beige
FF9607|Sunset Boulevard
BE916D|Sunset Cloud
DCB397|Sunset Cove
FFBE94|Sunset Cruise
EABBA2|Sunset Drive
FFB52D|Sunset Glow
F7C46C|Sunset Gold
BA87AA|Sunset Horizon
A5A796|Sunset Meadow
FC7D64|Sunset Papaya
F8A77F|Sunset Peach
FAD6E5|Sunset Pink
6F456E|Sunset Purple
7F5158|Sunset Red
D70041|Sunset Riders
594265|Sunset Serenade
FFBC00|Sunset Strip
FA873D|Sunset Yellow
F0C484|Sunset in Italy
FEAC89|Sunset over the Alps
C0514A|Sunset
FA9D49|Sunshade
F5C20B|Sunshine Mellow
FCB02F|Sunshine Surprise
FFFD37|Sunshine Yellow
FADE85|Sunshine
886688|Sunshone Plum
FBCA69|Sunspark
FEE2B2|Sunstitch
C7887F|Sunstone
BE8C74|Suntan Glow
D9B19F|Suntan
E3C1B3|Sunwashed Brick
FFFE71|Super Banana
221100|Super Black
AA8822|Super Gold
CA535B|Super Hero
BA5E0F|Super Leaf Brown
E4BF45|Super Lemon
CE6BA4|Super Pink
14BAB4|Super Rare Jade
CB1028|Super Rose Red
FFDD00|Super Saiyan
FFAA88|Super Sepia
EEEEEE|Super Silver
785F8E|Super Violet
3A5E73|Superior Blue
786957|Superior Bronze
FF1122|Superman Red
00928C|Supermint
EF760E|Supernatural Saffron
313641|Supernatural
D9ECE9|Supernova Residues
FFF8D9|Supernova
FFCC11|Superstar
5B6E74|Superstition
AC91B5|Superstitious
E8EAEA|Superwhite
78A300|Support Green
CFDDC7|Supreme Green
86949F|Supreme Grey
D4D8DB|Supreme Pontiff
AFBED4|Supremely Cool
FC53FC|Surati Pink
C3D6BD|Surf Crest
427573|Surf Green
0193C2|Surf Rider
B4C8C2|Surf Spray
87CECA|Surf Wash
203C7F|Surf the Web
B8D4BB|Surf
374755|Surf'n'dive
C4D3E5|Surf's Surprise
C6E4EB|Surf's Up
FCDA89|Surfboard Yellow
DB6484|Surfer Girl
70B8BA|Surfer
007B77|Surfie Green
73C0D2|Surfin'
9ACAD3|Surfside
009F6B|Surgeon Green
59A4C1|Surgical Green
EFB57A|Surprise Amber
C9936F|Surprise
DCC89D|Surrey Cream
70191F|Surya Red
FFF7DF|Sushi Rice
7C9F2F|Sushi
58BAC2|Sussie
887F7A|Susu Green
6F514C|Susu-Take Bamboo
859D95|Sutherland
888387|Suva Grey
C2963F|Suzani Gold
9EA1A3|Suzu Grey
AA4F37|Suzume Brown
8C4736|Suzumecha Brown
7E2639|Suō
B2AC96|Svelte Sage
B8A3BB|Svelte
19B6B5|Swagger
154962|Swallow Blue
ECE9DD|Swallow-Tailed Moth
B79D69|Swamp Fox
748500|Swamp Green
094C49|Swamp Mausoleum
005511|Swamp Monster
252F2F|Swamp Mosquito
698339|Swamp Moss
857947|Swamp Mud
6D753B|Swamp Shrub
36310D|Swamp of Sorrows
7F755F|Swamp
226633|Swampland
E5E4DD|Swan Dive
C5E5E2|Swan Lake
A6C1BF|Swan Sea
F7F1E2|Swan White
F5F2E6|Swan Wing
B5B1B5|Swanky Grey
5F7963|Swanndri
DAE6DD|Swans Down
1D4E8F|Sweat Bee
CCCCC5|Sweater Weather
007EB1|Swedish Blue
7B8867|Swedish Clover
184D43|Swedish Green
FCE081|Swedish Yellow
C9AA37|Sweet & Sour
F29EAB|Sweet 60
CC9977|Sweet Almond
E7C2DE|Sweet Alyssum
F5C8BB|Sweet Angel
E8D08E|Sweet Angelica
9C946E|Sweet Annie
FCC0A6|Sweet Apricot
A7E8D3|Sweet Aqua
E5EAE3|Sweet Ariel
C24F40|Sweet Baby Rose
EEDADD|Sweet Bianca
AEBED2|Sweet Blue
E6BFC1|Sweet Blush
C8DAE3|Sweet Breeze
A83731|Sweet Brown
FFFCD7|Sweet Butter
FCEEDD|Sweet Buttermilk
CC764F|Sweet Carrot
DDAA77|Sweet Cashew
FFE186|Sweet Chamomile
84172C|Sweet Cherry Red
9F4F4D|Sweet Cherry
F5160B|Sweet Chilli
DD84A3|Sweet Chrysanthemum
F9E176|Sweet Corn
F0EAE7|Sweet Cream
E8A773|Sweet Curry
AA33EE|Sweet Desire
DBCBAB|Sweet Dough
9BC7EA|Sweet Dreams
AB9368|Sweet Earth
CBD1E1|Sweet Emily
8844FF|Sweet Escape
674196|Sweet Flag
8A9B76|Sweet Florence
E2E2EA|Sweet Flower
FFF8E4|Sweet Frosting
5FD1BA|Sweet Garden
EFE4DA|Sweet Gardenia
8B715A|Sweet Georgia Brown
4B3B4F|Sweet Grape
B2B68A|Sweet Grass
D9DDE7|Sweet Harbor
E5AAB0|Sweet Heart
D4A55C|Sweet Honey
E0E8EC|Sweet Illusion
F9F4D4|Sweet Jasmine
B8BFD2|Sweet Juliet
9A9BC1|Sweet Lavender
FFF45A|Sweet Lemon Seed
E8B5CE|Sweet Lilac
CCBBDD|Sweet Lucid Dreams
9B4040|Sweet Lychee
FFDEE2|Sweet Mallow
D35E3A|Sweet Mandarin
DDAF6C|Sweet Maple
ECD5AA|Sweet Marzipan
E87973|Sweet Melon
FDC8CD|Sweet Memories
C2E4BC|Sweet Menthol
A7C74F|Sweet Midori
BBEE99|Sweet Mint Pesto
D5E3D0|Sweet Mint Tea
B4CCBE|Sweet Mint
4B423F|Sweet Molasses
ECC5DF|Sweet Murmur
D1B871|Sweet Mustard
FABDAF|Sweet Nectar
FAE6E1|Sweet Nothing
BBDBD0|Sweet Nothings
EBCCB3|Sweet Orange
EDC8B1|Sweet Pastel
A3A969|Sweet Pea
E2BCB3|Sweet Peach
D49AB9|Sweet Perfume
CBBAD0|Sweet Petal
EE918D|Sweet Pink
917798|Sweet Potato Peel
D87C3B|Sweet Potato
93DAD3|Sweet Rhapsody
FFC4DD|Sweet Romance
EAE1DD|Sweet Roses
FFD8F0|Sweet Sachet
C7B7D0|Sweet Scent
FFC5D5|Sweet Serenade
F0B9A9|Sweet Sheba
EEBDB6|Sweet Sherry
FFC9D3|Sweet Sixteen
F8B8F8|Sweet Slumber Pink
D0DEDD|Sweet Slumber
A8946B|Sweet Sparrow
7B453E|Sweet Spiceberry
D1E8C2|Sweet Spring
D8AA86|Sweet Sue
C9D0B8|Sweet Surrender
ECBCD4|Sweet Taffy
EAAEA9|Sweet Tart
C18244|Sweet Tea
5F6255|Sweet Tooth
F0DCD7|Sweet Truffle
EEEBE6|Sweet Vanilla
B6FF1A|Sweet Venom
8C667A|Sweet Violet
FC5669|Sweet Watermelon
8892C1|Sweet William
E1C9D1|Sweet and Sassy
C4BF0B|Sweet and Sour
FFE9AC|Sweet as Honey
F3C3D8|Sweetheart
E1BBDB|Sweetie Pie
FFE5EF|Sweetly
F8DBC4|Sweetness
C39F87|Sweetwood
E7CEE3|Sweety Pie
82AADC|Swift
0A91BF|Swimmer
2DC5BB|Swimmers Pool
A8CFC0|Swimming Pool Green
C2E5E5|Swimming
947569|Swing Brown
C2C0A9|Swing Sage
706842|Swinging Vine
D7CEC5|Swirl
CECAC1|Swirling Smoke
E6E9E9|Swirling Water
E4DACC|Swiss Almond
6E5F53|Swiss Brown
DD5E6D|Swiss Chard
FFF4B9|Swiss Cheese
8C6150|Swiss Chocolate
D5C3AD|Swiss Coffee
ECEAD9|Swiss Cream
5946B2|Swiss Plum
E8D5DD|Swiss Rose
67667C|Swollen Sky
D6D2DE|Sword Steel
8BCBAB|Sybarite Green
6A8779|Sycamore Grove
959E8F|Sycamore Stand
9C8A79|Sycamore Tan
3F544F|Sycamore Tree
908D39|Sycamore
CBB394|Sycorax Bronze
97BBC8|Sydney Harbour
ADAAB1|Sylph
E7EACB|Sylvan Green
979381|Sylvan
AC8262|Sylvaneth Bark
B29EAD|Symbolic
8FA0A7|Symmetry
C0A887|Symphony Gold
89A0A6|Symphony of Blue
331133|Synallactida
C7D4CE|Synchronicity
F8C300|Syndicalist
918151|Syndicate Camouflage
48C2B0|Synergy
9FFEB0|Synthetic Mint
FF7538|Synthetic Pumpkin
1EF876|Synthetic Spearmint
A16717|Syrah Soil
6A282C|Syrah
DFCAE4|Syrian Violet
B18867|Syrup
3A2EFE|System Shock Blue
8020FF|Szöllősi Grape
FC824A|Sè Lèi Orange
4CA973|Sēn Lín Lǜ Forest
9B533F|Sōdenkaracha Brown
6FC1AF|T-Bird Turquoise
8E908D|T-Rex Fossil
C7C4A5|Ta Prohm
A02712|Tabasco
526525|Tabbouleh Green
709572|Tabbouleh
F1E9DC|Table Linen
E5C279|Table Pear Yellow
005553|Tabriz Teal
F6AE78|Tacao
D2B960|Tacha
F3C7B3|Taco
D3E7C7|Tactile
7AD7AD|Tadorna Teal
7D7771|Tadpole
81825F|Taffeta Sheen
F3E0EB|Taffeta Tint
FEA6C8|Taffy Pink
AAD0BA|Taffy Twist
C39B6A|Taffy
F9F2D4|Tagliatelle
9B856B|Tahini Brown
DDBB77|Tahini
DC722A|Tahiti Gold
B8E9E4|Tahitian Breeze
263644|Tahitian Pearl
F5DCB4|Tahitian Sand
C9E9E7|Tahitian Sky
006B7E|Tahitian Tide
00686D|Tahitian Treat
94B8C1|Tahoe Blue
D7E1E5|Tahoe Snow
D8CC9B|Tahuna Sands
768078|Taiga
DD4411|Tail Lights
DFC2AA|Tailor's Buff
BD9D7E|Tailored Tan
F5E8CF|Tailwind
EAD795|Tainted Gold
BB5520|Taisha Brown
9F5233|Taisha Red
3377A2|Taiwan Blue Magpie
C7AA71|Taiwan Gold
EDE9DF|Taj Mahal
734A33|Taj
B3C9D3|Take Five
D8D4DD|Take the Plunge
E6CCB7|Take-Out
A0928B|Talavera
707E84|Taliesin Blue
648149|Talipot Palm
159F9B|Talismanic Teal
853534|Tall Poppy
0E81B9|Tall Ships
5C9BCC|Tall Waves
947E74|Tallarn Leather
A79B5E|Tallarn Sand
A39977|Tallow
E7B25D|Talâyi Gold
FCD575|Tamago Egg
FFA631|Tamago Orange
3B3F40|Tamahagane
F8E7B7|Tamale Maize
F0E4C6|Tamale
DEAA9B|Tamanegi Peel
F2DD55|Tamarack Yellow
11DDEE|Tamarama
752B2F|Tamarillo
75503B|Tamarind Fruit
8E604B|Tamarind Tart
341515|Tamarind
7C7D57|Tambo Tank
BDC8AF|Tamboon
F0EDD6|Tambourine
658498|Tambua Bay
C1E6DF|Tame Teal
C5C5AC|Tame Thyme
9C2626|Tamed Beast
CFBCCF|Tamed Beauty
A38D6D|Tan 686A
AB7E4C|Tan Brown
A9BE70|Tan Green
FA9D5A|Tan Hide
C2AA87|Tan Oak
C19E78|Tan Plan
F0BD9E|Tan Temptation
A3755D|Tan Wagon
F1D7CE|Tan Whirl
B5905A|Tan Your Hide
D1B26F|Tan
D2B48C|Tan, Link to the Past
B69073|Tan-Gent
B8B5A1|Tana
91DCE8|Tanager Turquoise
A43834|Tanager
D0B25C|Tanami Desert
E9B581|Tanaris Beige
766451|Tanbark Trail
896656|Tanbark
4A766E|Tandayapa Cloud Forest
D25762|Tandoori Red
9F4440|Tandoori Spice
BB5C4D|Tandoori
97725F|Tangara
1E2F3C|Tangaroa
F2E9DE|Tangelo Cream
F94D00|Tangelo
50507F|Tangent Periwinkle
EAD3A2|Tangent
D86130|Tangerine Bliss
FFA089|Tangerine Cream, Vivid Tangerine
FF8449|Tangerine Dream
E57F5B|Tangerine Flake
DE8417|Tangerine Haze
F28500|Tangerine Skin
E1523D|Tangerine Tango
FF9E4B|Tangerine Tango
F8AD1B|Tangerine Twist
FECD01|Tangerine Yellow
FF9300|Tangerine
A97164|Tangier
7C7C65|Tangle
B19466|Tangled Twine
CAC19A|Tangled Vines
B2B2B2|Tangled Web
A58F85|Tanglewood
F8C884|Tango Mango
E47F7A|Tango Pink
AC0E2E|Tango Red
D46F31|Tango
9A9147|Tangy Dill
BB9B52|Tangy Green
E7CAC3|Tangy Taffy
E3C382|Tangy
848481|Tank Grey
9AA0A2|Tank Head
EFC93D|Tank Yellow
5C6141|Tank
7D7463|Tankard Grey
F2C108|Tanned Leather
8F6E4B|Tanned Wood
5C493E|Tannery Brown
A68A6D|Tannin
AE6C37|Tanooki Suit Brown
95945C|Tansy Green
C7C844|Tansy
669CCB|Tantalize
F3DCD1|Tantalizing Tan
87DCCE|Tantalizing Teal
857158|Tantanmen Brown
FCD215|Tanzanian Gold
114A6B|Tanzanite Blue
1478A7|Tanzanite
BFA77F|Taos Taupe
2B8C8A|Taos Turquoise
2A2B2D|Tap Shoe
7C7C72|Tapa
805D24|Tapenade
F7F2DD|Tapering Light
B8AC9E|Tapestry Beige
B4966B|Tapestry Gold
C06960|Tapestry Red
4D7F86|Tapestry Teal
B37084|Tapestry
DCCDBC|Tapioca
DEF1DD|Tara
767A49|Tara's Drapes
253C48|Tarawera
003B6F|Tardis Blue
105673|Tardis
A1CDBF|Tareyton
477F4A|Tarmac Green
5A5348|Tarmac
7F6C24|Tarnished Brass
797B80|Tarnished Silver
B9A47E|Tarnished Treasure
D5B176|Tarnished Trumpet
4C514A|Tarpaulin Grey
C1B55C|Tarpon Green
B4AC84|Tarragon Tease
A4AE77|Tarragon
825E61|Tarsier
B6D27E|Tart Apple
F6EEC9|Tart Gelato
FB4D46|Tart Orange
B1282A|Tartan Red
BF5B3C|Tartare
FDDCD9|Tartlet
F7D917|Tartrazine
919585|Tarzan Green
E6C562|Tasman Honey Yellow
BAC0B3|Tasman
658A8A|Tasmanian Sea
F9C0CE|Tassel Flower
9F9291|Tassel Taupe
C6884A|Tassel
C8A3B8|Taste of Berry
F2AE73|Taste of Summer
9B6D54|Tasty Toffee
AF9D83|Tatami Mat
BA8C64|Tatami Tan
DECCAF|Tatami
976E9A|Tatarian Aster
988F63|Tate Olive
A2806F|Tattered Teddy
80736A|Tattletail
376D03|Tatzelwurm Green
F7D60D|Tau Light Ochre
A3813F|Tau Sept Ochre
483C30|Taupe Brown
8B8589|Taupe Grey
E1D9D0|Taupe Mist
705A56|Taupe Night
C3A79A|Taupe Tapestry
E0D9CF|Taupe Tease
ADA090|Taupe Tone
C7C1BB|Taupe White
DAD2C6|Taupe of the Morning
B9A281|Taupe
77BE52|Taurus Forest Fern
957046|Tavern Creek
9E938F|Tavern Taupe
B7A594|Tavern
D19776|Tawny Amber
AE856C|Tawny Birch
AB856F|Tawny Brown
EEE4D1|Tawny Daylily
B39997|Tawny Mushroom
C4962C|Tawny Olive
D37F6F|Tawny Orange
978B71|Tawny Owl
643A48|Tawny Port
CCB299|Tawny Tan
CD5700|Tawny, Tenné
496569|Tax Break
5C3937|Taxite
5F5879|Taylor
2B4B40|Te Papa Green
726259|Tea Bag
F5EBE1|Tea Biscuit
B5A9AC|Tea Blossom Pink
605547|Tea Chest
F4E1C0|Tea Cookie
D0F0C0|Tea Green
A59564|Tea Leaf Brown
888E7E|Tea Leaf Mouse
8F8667|Tea Leaf
F8E4C2|Tea Light
FFD7D0|Tea Party
DCB5B0|Tea Room
F883C2|Tea Rose
D9BEBC|Tea Time
C5A5C7|Tea Towel
BFB5A2|Tea
B44940|Teaberry Blossom
DC3855|Teaberry
624133|Teak Wood
AB8953|Teak
89756B|Teakwood Brown
8D7E6D|Teakwood
57A1A0|Teal Bayou
01889F|Teal Blue
367588|Teal Blue, Clear Viridian
0F4D5C|Teal Dark Blue
006D57|Teal Dark Green
99E6B3|Teal Deer
24604F|Teal Drama
3DA3AE|Teal Essence
405B5D|Teal Forest
1A6C76|Teal Fury
006D5B|Teal Green
25A36F|Teal Green
D1EFE9|Teal Ice
0DACA7|Teal Me No Lies
C8EDE2|Teal Melody
50B7CF|Teal Moiré
406976|Teal Mosaic
006D73|Teal Motif
627F7B|Teal Stencil
D9F2E3|Teal Treat
94B9B4|Teal Tree
4E939D|Teal Trinket
00A093|Teal Trip
02708C|Teal Tune
007765|Teal Waters
8B9EA1|Teal Wave
01697A|Teal With It
008080|Teal
0CDC73|Tealish Green
24BCA8|Tealish
416986|Team Spirit
D1EAEA|Teardrop
F0F1DA|Tears of Joy
DED2E8|Teary Eyed
CEAEFA|Teasel Dipsacus
F1E1D7|Teasing Peach
C8A89E|Teatime Mauve
BE9B79|Teatime
4C7A9D|Tech Wave
9FA1A1|Techile
587C8D|Technical Blue
006B8B|Techno Blue
69AC58|Techno Green
DD95B4|Techno Pink
BFB9AA|Techno Taupe
60BD8E|Techno Turquoise
FF80F9|Technolust
A3BAE3|Teclis Blue
9D8164|Teddy Bear
BCAC9F|Teddy's Taupe
C00C20|Tedious Red
68855A|Tee Off
A67498|Teen Queen
326395|Teeny Bikini
F2DBD7|Teewurst
C1B65F|Tegreen
AD66D2|Teldrassil Purple
AA22CC|Telemagenta
2D2541|Telopea
47626A|Tempe Star
2B8725|Temperamental Green
BFB1AA|Temperate Taupe
772211|Tempered Chocolate
A1AEB1|Tempered Grey
79839B|Tempest
F2E688|Templar's Gold
A6C9E3|Template
339A8D|Temple Guard Blue
A9855D|Temple Tile
EE7755|Temple of Orange
018C94|Tempo Teal
33ABB2|Tempo
FF7733|Temptatious Tangerine
DD8CB5|Tempting Pink
CCAA99|Tempting Taupe
3C2126|Temptress
98F6B0|Tenacious Tentacles
C5CFB6|Tender Greens
E0D4E0|Tender Limerence
F8D5B8|Tender Peach
E8EACE|Tender Shoot
B5CC39|Tender Shoots
E8E287|Tender Sprout
C4B198|Tender Taupe
D5C6D6|Tender Touch
82D9C5|Tender Turquoise
B7CFE2|Tender Twilight
D4C3DA|Tender Violet
BADBDF|Tender Waves
EDEDB7|Tender Yellow
F7E8D7|Tender
C8DBCE|Tenderness
89A06B|Tendril
DFFF4F|Tennis Ball
7CB5C6|Tennis Blue
C8450C|Tennis Court
A35732|Tense Terracotta
A89F86|Tent Green
FFBACD|Tentacle Pink
9ECFD9|Tenzing
F4D0A4|Tequila
EB6238|Teri-Gaki Persimmon
DCDFE5|Terminator Chrome
BDB192|Terminatus Stone
DDBB66|Termite Beige
D5CDBD|Tern Grey
5A382D|Terra Brun
D08F73|Terra Cotta Clay
D38D71|Terra Cotta Pot
9C675F|Terra Cotta Sun
B06F60|Terra Cotta Urn
E2725B|Terra Cotta, Phoenix Red
CC7661|Terra Orange
534D42|Terra Pin
BB6569|Terra Rosa
9F6D66|Terra Rose
E8B57B|Terra Sol
B6706B|Terra Tone
73544D|Terrace Brown
A1D8E0|Terrace Pool
B2AB9C|Terrace Taupe
275B60|Terrace Teal
CAD0BF|Terrace View
C47C5E|Terracotta Chip
976A66|Terracotta Red Brown
D6BA9B|Terracotta Sand
CB6843|Terracotta
708157|Terrain
A1965E|Terran Khaki
5F6D5C|Terrarium
A28873|Terrazzo Brown
BE8973|Terrazzo Tan
276757|Terrestrial
1D4769|Terror from the Deep
DDAAFF|Testosterose
8D99A1|Teton Blue
DFEAE8|Teton Breeze
1E20C7|Tetraammine
8E6F73|Tetrarose
2B3733|Tetsu Black
005243|Tetsu Green
455765|Tetsu Iron
281A14|Tetsu-Guro Black
17184B|Tetsu-Kon Blue
2B3736|Tetsuonando Black
E2DDD1|Texan Angel
8B6947|Texas Boots
A54E37|Texas Heatwave
C9926E|Texas Hills
A0522D|Texas Ranger Brown, Sienna
F1D2C9|Texas Rose
B9A77C|Texas Sage
FC9625|Texas Sunset
794840|Texas Sweet Tea
ECE67E|Texas
5500EE|Tezcatlipōca Blue
7A7F3F|Thai Basil
CE0001|Thai Chili
AB6819|Thai Curry
FE1C06|Thai Hot
E0A878|Thai Ice Tea
E77200|Thai Mango
BB4455|Thai Spice
624435|Thai Teak
2E8689|Thai Teal
E7C630|Thai Temple
44AADD|Thalassophile
58F898|Thallium Flame
181818|Thamar Black
62676A|Thames Dusk
B56E4A|Thanksgiving
B0B08E|That's Atomic
DCD290|That's My Lime
867057|Thatch Brown
544E31|Thatch Green
B1948F|Thatch
D6C7A6|Thatched Cottage
EFE0C6|Thatched Roof
E1EEEC|Thawed Out
DD0088|The Art of Seduction
AB9F89|The Blarney Stone
FFC8C2|The Bluff
D0A492|The Boulevard
145775|The Broadway
837663|The Cottage
102030|The Count's Black
666420|The Devil's Grass
A75455|The Ego Has Landed
EED508|The End Is Beer
2A2A2A|The End
436174|The Fang Grey
585673|The Fang
F0E22C|The Fifth Sun
FFF08C|The First Daffodil
E9D2AF|The Golden State
AAA651|The Goods
BB00FF|The Grape War of 97'
B0BF1A|The Killing Joke
558844|The Legend of Green
FF8400|The New Black
448EE4|The Oregon Blue
4466EE|The Rainbow Fish
007883|The Real Teal
DB7093|The Sickener
F6F4EF|The Speed of Light
110066|The Vast of Night
F1EEE5|The White in my Eye
118844|The Wild Apothecary
21467A|Theatre Blue
EEF4DB|Theatre District Lights
274242|Theatre Dress
A76924|Theatre Gold
E2D4D4|Theatre Powder Rose
E2B13C|Themeda Japonica
EE7711|Therapeutic Toucan
002288|There Is Light
AD9569|There's No Place Like Home
9CCEBE|Thermal Aqua
589489|Thermal Spring
3F5052|Thermal
EB3318|Thermic Orange
8FADBD|Thermocline
D2BB95|Thermos
FBE4B3|They call it Mellow
5566DD|Thick Blue
DCD3CE|Thick Fog
88CC22|Thick Green
CC55DD|Thick Pink
8833DD|Thick Purple
B30D0D|Thick Red
F1D512|Thick Yellow
93840F|Thicket Green
69865B|Thicket
A05D8B|Thimble Red
AFA97D|Thimbleberry Leaf
E34B50|Thimbleberry
C6FCFF|Thin Air
D4DCDA|Thin Cloud
CAE0DF|Thin Heights
D9DCDB|Thin Ice
4D8871|Think Leaf
E5A5C1|Think Pink
726E9B|Thirsty Thursday
9499BB|Thistle Down
CCCAA8|Thistle Green
C0B6A8|Thistle Grey
834D7C|Thistle Mauve
D8BFD8|Thistle
8AB3BF|Thistleblossom Soft Blue
44CCFF|Thor's Thunder
B5A197|Thorn Crown
4C4A41|Thorny Branch
D8CDC8|Thought
317589|Thousand Herb
FFD9BB|Thousand Needles Sand
02D8E9|Thousand Sons Blue
316745|Thousand Years Green
4F6446|Thraka Green Wash
CEC2AA|Threaded Loom
C30305|Threatening Red
73C4D7|Thredbo
FDDBB6|Three Ring Circus
93CCE7|Thresher Shark
AC9A8A|Threshold Taupe
281F3F|Throat
A4B6A7|Thrush Egg
936B4F|Thrush
11610F|Thuja Green
DF6FA1|Thulian Pink
DDC2BA|Thulite Rose
BDADA4|Thumper
E88A76|Thundelarra
F9F5DB|Thunder & Lightning
CBD9D7|Thunder Bay
AAC4D4|Thunder Chi
57534C|Thunder Grey
CE1B1F|Thunder Mountain Longhorn Pepper
4D4D4B|Thunder
923830|Thunderbird
454C56|Thunderbolt Blue
FDEFAD|Thunderbolt
8A99A3|Thundercat
698589|Thundercloud
417074|Thunderhawk Blue
6D6C62|Thunderous
004F63|Thunderstorm Blue
9098A1|Thunderstorm
5F5755|Thunderstruck
7F7B60|Thurman
98514A|Thy Flesh Consumed
737B6C|Thyme Green
629A31|Thyme and Salt
50574C|Thyme
97422D|Tia Maria
9BB2AA|Tiamo
EAE0E8|Tiara Jewel
DAA6CF|Tiara Pink
B9C3BE|Tiara
184343|Tiber
6A6264|Tibetan Cloak
F6F3E1|Tibetan Jasmine
AE5848|Tibetan Orange
88FFDD|Tibetan Plateau
782A39|Tibetan Red
9C8A52|Tibetan Silk
DBEAED|Tibetan Sky
82C2C7|Tibetan Stone
814D50|Tibetan Temple
0084A6|Tibetan Turquoise
FEDF00|Tibetan Yellow
268BCC|Ticino Blue
FC89AC|Tickle Me Pink
B6BAA4|Tickled Crow
EFA7BF|Tickled Pink
BFB9A3|Tidal Foam
CDCA98|Tidal Green
E5E9E1|Tidal Mist
005E59|Tidal Pool
8B866B|Tidal Thicket
355978|Tidal Wave
F0F590|Tidal
C6D8D0|Tide Pools
BEB4AB|Tide
0A6F69|Tidepool
002400|Tides of Darkness
C2E3DD|Tidewater
C2DDD3|Tierra Del Fuego Sea Green
B58141|Tiffany Amber
0ABAB5|Tiffany Blue
7BF2DA|Tiffany Blue
FDE4B4|Tiffany Light
D2A694|Tiffany Rose
CDA035|Tiger Cat
E1DACA|Tiger Claw
DEAE46|Tiger Cub
E08D3C|Tiger Eye, Texas Longhorn
DD9922|Tiger King
DD6611|Tiger Moth Orange
F8F2DD|Tiger Moth
BF6F39|Tiger Stripe
FEE9C4|Tiger Tail
FFDE7E|Tiger Yellow
FF8855|Tiger of Mysore
BE9C67|Tiger
977C61|Tiger's Eye
BB7748|Tigereye
E2583E|Tigerlily
AA5500|Tijolo
8A6E45|Tiki Hut
8FBC8F|Tiki Monster
B9A37E|Tiki Straw
BB9E3F|Tiki Torch
008491|Tile Blue
7A958E|Tile Green
C76B4A|Tile Red
00CCCD|Tilla Kari Mosque
563474|Tillandsia Purple
80624E|Tilled Earth
6B4D35|Tilled Soil
EE5522|Tilted Pinball
991122|Tilted Red
A0855C|Timber Beam
605652|Timber Brown
324336|Timber Green
908D85|Timber Town
A1755C|Timber Trail
D9D6CF|Timber Wolf White
8D8070|Timber Wolf
DBD7D2|Timber Wolf, Eastern Wolf
73573F|Timberline
B4ACA3|Timberwolf
A59888|Time Capsule
7F6D37|Time Honored
FADEB8|Time Out
B3C4D5|Time Travel
9397A3|Time Warp
B6273E|Timeless Beauty
976D59|Timeless Copper
ECE9E8|Timeless Day
AFB2C4|Timeless Lilac
9A4149|Timeless Ruby
AFE4E2|Timeless Seafoam
908379|Timeless Taupe
B1D8DB|Timeless
20C073|Times Square Screens
E5E0DD|Timid Beige
D9E0EE|Timid Blue
DCDDE5|Timid Cloud
E1E2D6|Timid Green
E4E0DA|Timid Lime
DFDFEA|Timid Purple
66A9B0|Timid Sea
E4E0DD|Timid Sheep
DED3DD|Timid Violet
ADB274|Timothy Grass
48452B|Tin Bitz
ACB0B0|Tin Foil
928A98|Tin Lizzie
A4A298|Tin Man
A3898A|Tin Pink
BEBEBE|Tin Soldier
919191|Tin
D4C3CC|Tinge Of Mauve
E6541B|Tingle
FBEDB8|Tinker Light
FCF0C3|Tinkerbell Trail
4B492D|Tinny Tin
C3964D|Tinsel
DCE0DC|Tinsmith
CE9480|Tint of Earth
DAE9DC|Tint of Green
FFCBC9|Tint of Rose
41BFB5|Tint of Turquoise
CFF6F4|Tinted Ice
C4B7D8|Tinted Iris
9DA9D0|Tinted Lilac
E3E7C4|Tinted Mint
E1C8D1|Tinted Rosewood
0088AB|Tiny Bubbles
E0BFA5|Tiny Calf
C08B6D|Tiny Fawn
D4CFCC|Tiny Ghost Town
B8D3E4|Tiny Mr Frosty
FFD6C7|Tiny Pink
B98FAF|Tiny Ribbons
8A8D69|Tiny Seedling
D8C2CD|Tip Toes
BBE4EA|Tip of the Iceberg
D3BDA4|Tiramisu Cream
634235|Tiramisu
75DE2F|Tirisfal Lime
9E915C|Tirol
DDD6E1|Titan White
AD8F0F|Titanite Yellow
5B798E|Titanium Blue
545B62|Titanium Grey
E4E4E4|Titanium White
EEE600|Titanium Yellow
807D7F|Titanium
BD5620|Titian Red
D53E07|Titians Stone
B8B2BE|Titmouse Grey
F9F3DF|Tizzy
5DB3FF|Tiān Lán Sky
566B38|Tiāntāi Mountain Green
343450|Tiě Hēi Metal
316F82|Tlāloc Blue
3D6C54|Toad King
748D70|Toad
D7E7DA|Toadstool Dot
988088|Toadstool Soup
B8282F|Toadstool
D2AD84|Toast and Butter
9F715F|Toast
DACFBA|Toasted Almond
986B4D|Toasted Bagel
E7DDCB|Toasted Barley
E2D0B8|Toasted Cashew
A7775B|Toasted Chestnut
E9C2A1|Toasted Coconut
C5A986|Toasted Grain
FFF9EB|Toasted Marshmallow Fluff
EFE0D4|Toasted Marshmallow
C08768|Toasted Nut
A47365|Toasted Nutmeg
EFDECC|Toasted Oatmeal
A34631|Toasted Paprika
765143|Toasted Pecan
DCC6A6|Toasted Pine Nut
AF9A73|Toasted Sesame
AA3344|Toasted Truffle
746A5A|Toasted Walnut
C9AF96|Toasted Wheat
B59274|Toasted
D1CCC0|Toasty Grey
957258|Toasty
6D5843|Tobacco Brown
8C724F|Tobacco Leaf
684F3C|Tobacco
44362D|Tobago
D39898|Tobermory
077A7D|Tobernite
AD785C|Tobey Rattan
4C221B|Tobi Brown
E45C10|Tobiko Orange
F8DCBF|Toes in the Sand
947255|Toffee Bar
D98B51|Toffee Cream
995E39|Toffee Crunch
968678|Toffee Fingers
A5654A|Toffee Glaze
B17426|Toffee Sauce
C8A883|Toffee Tan
C08950|Toffee Tart
755139|Toffee
03719C|Tofino Belue
E6BAA9|Tofino
E8E3D9|Tofu
94BEE1|Toile Blue
8B534E|Toile Red
B88884|Toki Brown
007B43|Tokiwa Green
ECF3D8|Tokyo Underground
6C5846|Tol Barad Green
4E4851|Tol Barad Grey
DECBB1|Toledo Cuoio
3E2631|Toledo
4F6348|Tom Thumb
CAD3C1|Tomatillo Peel
BBB085|Tomatillo Salsa
E10D18|Tomato Baby
D15915|Tomato Bisque
D6201A|Tomato Burst
F6561C|Tomato Concassé
C57644|Tomato Cream
FF4444|Tomato Frog
C53346|Tomato Puree
DD4422|Tomato Queen
A12312|Tomato Red
EC2D01|Tomato Red
B21807|Tomato Sauce
E44458|Tomato Scepter
A2423D|Tomato Slices
EF4026|Tomato
FF6347|Tomato, Bruschetta Tomato
0099CC|Tomb Blue
CEC5B6|Tombstone Grey
FFC5A3|Tomorrow's Coral
D1908E|Tongue
DEDDAA|Tonic
975437|Tonicha
EDAC36|Tonkatsu
B1A290|Tony Taupe
E79E88|Tonys Pink
9596A4|Too Big to Whale
0088FF|Too Blue to be True
3D6695|Too Blue
0011BB|Too Dark Tonight
637985|Tool Blue
7F7711|Tool Green
F9DBE2|Tootie Fruity
FAD873|Top Banana
C1A393|Top Hat Tan
82889C|Top Shelf
D04838|Top Tomato
C5DDD0|Topaz Green
92653F|Topaz Mountain
EB975E|Topaz Yellow
D08344|Topaz
6F7C00|Topiary Garden
667700|Topiary Green
618A4D|Topiary Sculpture
BBC9B2|Topiary Tint
8E9655|Topiary
AA5C71|Topinambur Root
DAE2E0|Topsail
E7E2DA|Toque White
FD0D35|Torch Red
FFC985|Torchlight
353D75|Torea Bay
B61032|Toreador
DB3E00|Torii Red
5E5B60|Tornado Cloud
4D7179|Tornado Season
60635F|Tornado Wind
D1D3CF|Tornado
FFDECD|Toronja
220044|Torrefacto Roast
55784F|Torrey Pine
00938B|Torrid Turquoise
5E8E91|Tort
EFDBA7|Tortilla
754734|Tortoise Shell
84816F|Tortuga
374E88|Tory Blue
D6685F|Tory Red
744042|Tosca
9F846B|Toscana
E3C19C|Tostada
A67E4B|Tosty Crust
2C313D|Total Eclipse
F6EAD8|Total Recall
3F4041|Totally Black
909853|Totally Broccoli
CCA683|Totally Tan
DD9977|Totally Toffee
991B07|Totem Pole
FBC90D|Toucan Gentleman
F09650|Toucan
DBE9D5|Touch Of Green
C2D7E9|Touch of Blue
F6DED5|Touch of Blush
8E6F6E|Touch of Class
DD8844|Touch of Glamor
D1CFCA|Touch of Grey
E1E5D7|Touch of Lime
F8FFF8|Touch of Mint
D5C7BA|Touch of Sand
FAF7E9|Touch of Sun
EED9D1|Touch of Tan
F7E4D0|Touch of Topaz
A1D4CF|Touch of Turquoise
ECDFD8|Touchable Pink
C3E4E8|Touched by the Sea
F4E1D7|Touching White
C7AC7D|Toupe
BDA3A5|Tourmaline Mauve
4F9E96|Tourmaline Turquoise
99D3DF|Tourmaline Water Blue
86A1A9|Tourmaline
54836B|Tournament Field
7BA0A0|Tower Bridge
9CACA5|Tower Grey
D5B59B|Tower Tan
897565|Towering Cliffs
C3AA8C|Townhall Tan
C19859|Townhouse Tan
BBB09B|Townhouse Taupe
CCFF11|Toxic Boyfriend
CCEEBB|Toxic Essence
61DE2A|Toxic Green
E1F8E7|Toxic Latte
FF6037|Toxic Orange
43E85F|Toxic Slime
00BB33|Toxic Sludge
C1FDC9|Toxic Steam
00889F|Toy Blue
117700|Toy Camouflage
776EA2|Toy Mauve
005280|Toy Submarine Blue
6D6F4F|Toy Tank Green
DBB9A0|Tracery
849E88|Track Green
D66352|Track and Field
00BFFE|Tractor Beam
1C6A51|Tractor Green
FD0E35|Tractor Red
6A7978|Trade Secret
E6E3D6|Trade Winds
B7C5C6|Tradewind
BB8D3B|Trading Post
1F648D|Traditional Blue
C7C7C1|Traditional Grey
6F4F3E|Traditional Leather
BE013C|Traditional Rose
0504AA|Traditional Royal Blue
D6D2C0|Traditional Tan
776255|Traditional
55FF22|Traffic Green
8C9900|Traffic Light Green
FF1C1C|Traffic Red
F1F0EA|Traffic White
FEDC39|Traffic Yellow
D0C4AC|Trail Dust
6B6662|Trail Print
BFAA97|Trail Sand
C0B28E|Trailblazer
776C61|Trailhead
CFD5A7|Trailing Vine
8F97A5|Trance
7C9AA0|Tranquil Aqua
74B8DE|Tranquil Bay
ECE7F2|Tranquil Eve
A4AF9E|Tranquil Green
FCE2D7|Tranquil Peach
768294|Tranquil Pond
88DDFF|Tranquil Pool
DBD2CF|Tranquil Retreat
D2D2DF|Tranquil Sea
629091|Tranquil Seashore
B0A596|Tranquil Taupe
8AC7BB|Tranquil Teal
DDEDE9|Tranquil
6C9DA9|Tranquili Teal
8E9B96|Tranquility
307D67|Trans Tasman
C3AC98|Transcend
F8F4D8|Transcendence
A5ACB7|Transformer
EA1833|Transfusion
FFE9E1|Translucent Silk
FFEDEF|Translucent Unicorn
E5EFD7|Translucent Vision
E4E3E9|Translucent White
F4ECC2|Transparent Beige
DDDDFF|Transparent Blue
DDFFDD|Transparent Green
B4A6BF|Transparent Mauve
FFAA66|Transparent Orange
FFDDEE|Transparent Pink
CBDCCB|Transparent White
FFEEAA|Transparent Yellow
1E1E1E|Transport Black
063971|Transport Blue
308446|Transport Green
8D948D|Transport Grey
F54021|Transport Orange
A03472|Transport Purple
CC0605|Transport Red
FAD201|Transport Yellow
004F54|Transporter Green
0E1D32|Trapped Darkness
005239|Trapper Green
F4E8B6|Trapunto
B5AB8F|Travertine Path
E2DDC7|Travertine
DDF5E7|Treacherous Blizzard
DE9832|Treacle Fudge
885D2D|Treacle
9B7856|Treasure Casket
998866|Treasure Chamber
726854|Treasure Chest
47493B|Treasure Island
609D91|Treasure Isle
658FAA|Treasure Map Waters
D0BB9D|Treasure Map
3F363D|Treasure Seeker
E7D082|Treasure
BB2277|Treasured Love
52C1B3|Treasured Teal
006634|Treasured Wilderness
9C7947|Treasured
BA8B36|Treasures
DBD186|Treasury
665B4E|Tree Bark Brown
304B4A|Tree Bark Green
715E58|Tree Bark
8A7362|Tree Branch
7FB489|Tree Fern
7CA14E|Tree Frog Green
9FB32E|Tree Frog
2A7E19|Tree Green
3B2820|Tree House
79774A|Tree Hugger
8EA597|Tree Lined
DCDBCA|Tree Moss
7FAA4B|Tree Palm
A4345D|Tree Peony
E2813B|Tree Poppy
BDC7BC|Tree Pose
22CC00|Tree Python
CC7711|Tree Sap
476A30|Tree Shade
726144|Tree Swing
595D45|Tree of Life
D1B7A7|Treeless
609F6E|Treelet
615746|Treemoss
2F4A15|Treetop Cathedral
91B6AC|Treetop
47562F|Trefoil
D1AE9A|Trek Tan
4E606D|Trekking Blue
355048|Trekking Green
5D7F74|Trellis Vine
EAEFE5|Trellis
9AA097|Trellised Ivy
AF9770|Trench
7E8424|Trendy Green
805D80|Trendy Pink
DCC7AD|Tres Naturale
C2DFE2|Trevi Fountain
F2D1C4|Tri-Tip
94A089|Triamble
67422D|Triassic
514843|Tribal Drum
A78876|Tribal Pottery
807943|Tribal
A4918D|Tribeca
33373B|Tribecca Corner
EAB38A|Trick or Treat
2F2F30|Tricorn Black
DCD3E3|Tricot Lilac White
B09994|Tricycle Taupe
494F62|Tried & True Blue
F5F5DA|Triforce Shine
F0F00F|Triforce Yellow
A89896|Trillium
756D44|Trim
D0343D|Trinidad Moruga Scorpion
C54F33|Trinidad
B9B79B|Trinity Islands
7E633F|Trinket Box
A7885F|Trinket Gold
D69835|Trinket
C96272|Triple Berry
752B3E|Tripleberry
E5E3E5|Tripoli White
CC00EE|Trippy Velvet
8EB9C4|Trisha's Eyes
0C0C1F|Tristesse
F4F0E3|Trite White
705676|Trixter
775020|Trojan Horse Brown
014E2E|Troll Green
F4A34C|Troll Slayer Orange
818181|Trolley Grey
697A7E|Trooper
73B7C2|Tropez Blue
BCC23C|Tropic Canary
016F92|Tropic Sea
6CC1BB|Tropic Tide
6AB5A4|Tropic Turquoise
4889AC|Tropic
9DB7AF|Tropical Bay
D7967E|Tropical Blooms
AEC9EB|Tropical Blue
EBEDEE|Tropical Breeze
8CA8A0|Tropical Cascade
B9CABD|Tropical Cyclone
D9EAE5|Tropical Dream
33FF22|Tropical Elements
4DBBAF|Tropical Escape
CBCAB6|Tropical Fog
3E6252|Tropical Foliage
228B21|Tropical Forest Green
024A43|Tropical Forest
99DDCC|Tropical Freeze
FDD3A7|Tropical Fruit
55DD00|Tropical Funk
17806E|Tropical Green
C2343C|Tropical Heat
9C6071|Tropical Hibiscus
17A99E|Tropical Hideaway
8FCDC7|Tropical Holiday
009D7D|Tropical Kelp
1E98AE|Tropical Lagoon
9CD572|Tropical Light
CAE8E8|Tropical Mist
D2C478|Tropical Moss
2A2E4C|Tropical Night Blue
579AA5|Tropical Oasis
A0828A|Tropical Orchid
FFC4B2|Tropical Peach
BFDEEF|Tropical Pool
00755E|Tropical Rain Forest
447777|Tropical Rain
03A598|Tropical Sea
DDC073|Tropical Siesta
155D66|Tropical Skies
C5556D|Tropical Smoothie
70CBCE|Tropical Splash
FBB719|Tropical Sun
E0DEB8|Tropical Tale
CBB391|Tropical Tan
008794|Tropical Teal
5ECAAE|Tropical Tide
50A074|Tropical Tone
89D1B5|Tropical Trail
20AEA7|Tropical Tree
04CDFF|Tropical Turquoise
837946|Tropical Twist
CDA5DF|Tropical Violet
BEE7E2|Tropical Waterfall
007C7E|Tropical Waters
603B2A|Tropical Wood Brown
BA8F68|Tropical Wood
A8E8CB|Tropical
447700|Tropicana
009B8E|Tropics
918754|Trough Shell Brown
726D40|Trough Shell
00666D|Trouser Blue
F75300|Trout Caviar
4C5356|Trout
DCC49B|True Blonde
0073CF|True Blue
010FCC|True Blue
8B5643|True Copper
A22042|True Crimson
089404|True Green
B8AE98|True Khaki
7E89C8|True Lavender
E27E8A|True Love
3F5277|True Navy
65318E|True Purple
BF1932|True Red
4D456A|True Romance
A8A095|True Taupewood
0A8391|True Teal
CDD3A3|True To You
8E72C7|True V
967A67|True Walnut
B46C42|Truepenny
99BBFF|Truesky Gloxym
A35139|Truffle Trouble
C2A78E|Truffle
777250|Truly Olive
AC9E97|Truly Taupe
FAA76C|Trump Tan
E49977|Trumpet Flower
E9B413|Trumpet Gold
5A7D7A|Trumpet Teal
D1B669|Trumpet
907BAA|Trumpeter
9B5FC0|Trunks Hair
6600CC|Trusted Purple
527498|Trustee
B59F8F|Trusty Tan
344989|Truth
8B7F7B|Tsar
D1B4C6|Tsarina
869BAF|Tsunami
9BA88D|Tsurubami Green
454642|Tuatara
FFFAEC|Tuberose
00858B|Tucson Teal
C1CECF|Tudor Ice
B68960|Tudor Tan
A59788|Tuffet
F9D3BE|Tuft Bush
CBC2AD|Tuft
B96C46|Tufted Leather
417DC1|Tufts Blue
B89CBC|Tuileries Tint
573B2A|Tuk Tuk
FBF4DA|Tulip Petals
531938|Tulip Poplar Purple
B8516A|Tulip Red
C3C4D6|Tulip Soft Blue
E3AC3D|Tulip Tree
F1E5D1|Tulip White
FF878D|Tulip
966993|Tulipan Violet
805466|Tulipwood
8D9098|Tulle Grey
D9E7E5|Tulle Soft Blue
FBEDE5|Tulle White
DEAA88|Tumbleweed
CDBB9C|Tumblin' Tumbleweed
CEBF9C|Tumbling Tumbleweed
CF6275|Tuna Sashimi
46494E|Tuna
585452|Tundora
E1E1DB|Tundra Frost
D6D9D7|Tundra
B5AC9F|Tungsten
00CC00|Tunic Green
FFDDB5|Tunisian Stone
C0A04D|Tupelo Honey
9C9152|Tupelo Tree
F9BB59|Turbinado Sugar
F5CC23|Turbo
4E545B|Turbulence
536A79|Turbulent Sea
2A8948|Turf Green
009922|Turf Master
5F4F42|Turf
006169|Turkish Aqua
BB937B|Turkish Bath
007FAE|Turkish Blue
0E9CA5|Turkish Boy
483F39|Turkish Coffee
F7F3BD|Turkish Ginger
2B888D|Turkish Jade
A56E75|Turkish Rose
B57281|Turkish Rose
195190|Turkish Sea
2F7A92|Turkish Stone
72CAC1|Turkish Teal
00698B|Turkish Tile
D9D9D1|Turkish Tower
77DDE7|Turkish Turquoise
F3D8BE|Turkscap
C18116|Turmeric Brown
CA7A40|Turmeric Red
FEAE0D|Turmeric Root
D88E2D|Turmeric Tea
AE9041|Turmeric
8D7448|Turned Leaf
93BCBB|Turner's Light
E6C26F|Turner's Yellow
CED9C3|Turning Leaf
EDE1A8|Turning Oakleaf
EFC6A1|Turnip Boy
D3CFBF|Turnstone
448899|Turquesa
01A192|Turquish
00FFEF|Turquoise Blue
6FE7DB|Turquoise Chalk
0E7C61|Turquoise Cyan
6DAFA7|Turquoise Fantasies
04F489|Turquoise Green
A0D6B4|Turquoise Green
B4CECF|Turquoise Grey
89F5E3|Turquoise Pearl
6CDAE7|Turquoise Sea
00C5CD|Turquoise Surf
13BBAF|Turquoise Topaz
457B74|Turquoise Tortoise
A8E3CC|Turquoise Tower
CFE9DC|Turquoise White
06C2AC|Turquoise
30D5C8|Turquoise
84897F|Turtle Bay
CED8C1|Turtle Chalk
65926D|Turtle Creek
E3E1CF|Turtle Dove
75B84F|Turtle Green
73B7A5|Turtle Lake
939717|Turtle Moss
897C64|Turtle Shell
363E1D|Turtle Skin
B6B5A0|Turtle Trail
35B76D|Turtle Warrior
523F31|Turtle
DED7C8|Turtledove
E7D2AD|Tuscan Bread
6F4C37|Tuscan Brown
AA5E5A|Tuscan Clay
658362|Tuscan Herbs
DC938C|Tuscan Image
A08D71|Tuscan Mosaic
5D583E|Tuscan Olive
7C4848|Tuscan Red
723D3B|Tuscan Russet
FFD84D|Tuscan Sun
BB7C3F|Tuscan Sunset
FCC492|Tuscan Wall
FBD5A6|Tuscan
008893|Tuscana Blue
7E875F|Tuscany Hillside
BE9785|Tuscany
0082AD|Tusche Blue
9996B3|Tusi Grey
E3E5B1|Tusk
883636|Tuskgor Fur
BF914B|Tussock
BC587B|Tutti Frutti
F8E4E3|Tutu
E95295|Tutuji Pink
3F3C43|Tuxedo
CCDDEE|Tuğçe Silver
937B56|Tweed
FFEF00|Tweety, Canary Yellow
FFBE4C|Twenty Carat
77623A|Twig Basket
C8BFB5|Twilight Beige
0A437A|Twilight Blue
B59A9C|Twilight Blush
3F5363|Twilight Chimes
606079|Twilight Dusk
54574F|Twilight Forest
D1D6D6|Twilight Grey
8A496B|Twilight Lavender
DAC0CD|Twilight Light
8B6F70|Twilight Mauve
51A5A4|Twilight Meadow
BFBCD2|Twilight Pearl
66648B|Twilight Purple
71898D|Twilight Stroll
A79994|Twilight Taupe
7B85C6|Twilight Twinkle
E5E6D7|Twilight Twist
191916|Twilight Zone
4E518B|Twilight
8A795D|Twilight, Shadow Woods
A79B82|Twill
BEDBED|Twin Blue
A4C7C8|Twin Cities
684344|Twinberry
C19156|Twine
74A69B|Twining Vine
D0D7DF|Twinkle Blue
FCE79A|Twinkle Little Star
636CA8|Twinkle Night
FBD8CC|Twinkle Pink
E2D39B|Twinkle Toes
FCF0C5|Twinkle Twinkle
ADC6D3|Twinkle
E9DBE4|Twinkled Pink
FFFAC1|Twinkling Lights
CF4796|Twinkly Pinkily
4E632C|Twist of Lime
76C4D1|Twisted Blue
9A845E|Twisted Tail
7F6C6E|Twisted Time
655F50|Twisted Vine
1FAEE9|Twitter
BED3E1|Two Harbours
4C5053|Typewriter Ink
463D2B|Typhus Corrosion
CDC586|Tyrant Skull
66023C|Tyrian Purple
4E4D59|Tyrian
B3CDBF|Tyrol
00A499|Tyrolite Blue-Green
736458|Tyson Taupe
DDEECC|Tzatziki Green
323939|Tàn Hēi Soot
D90166|Tête-à-Tête
FAA945|Tōmorokoshi Corn
EEC362|Tōmorokoshi Yellow
D14155|Tōnatiuh Red
FFB61E|Tōō Gold
574D35|Tǔ Hēi Black
7B5838|Über Umber
0033AA|UA Blue
D9004C|UA Red
536895|UCLA Blue
FFB300|UCLA Gold
88AA11|UFO Defense Green
3CD070|UFO Green
014421|UP Forest Green
014431|UP Forest Green
7B1113|UP Maroon
00308F|US Air Force Blue
716140|US Field Drab
004F98|USAFA Blue
990010|USC Cardinal
FFCC00|USC Gold, Tangerine Yellow
373D31|USMC Green
0098C8|UV Light
8878C3|Ube
989FA3|Ufo
645530|Uguisu Brown
928C36|Uguisu Green
FABF14|Ukon Saffron
FCC680|Uldum Beige
C7E0D9|Ulthuan Grey
A9A8A9|Ultimate Grey
FF4200|Ultimate Orange
FF55FF|Ultimate Pink
7EBA4D|Ultra Green
4433FF|Ultra Indigo
A3EFB8|Ultra Mint
D1F358|Ultra Moss
F06FFF|Ultra Pink
F8F8F3|Ultra Pure White
FC6C85|Ultra Red
AA22AA|Ultra Violet Lentz
7366BD|Ultra Violet
770088|Ultraberry
4166F5|Ultramarine Blue
657ABB|Ultramarine Blue
006B54|Ultramarine Green
2E328F|Ultramarine Highlight
090045|Ultramarine Shadow
1D2A58|Ultramarine Violet
120A8F|Ultramarine
1805DB|Ultramarine
B6CCB6|Ultramint
BB44CC|Ultraviolet Berl
BB44BB|Ultraviolet Cryner
BB44AA|Ultraviolet Nusp
BB44DD|Ultraviolet Onsible
921D0F|Uluru Red
90EE90|Ulva Lactuca Green
613936|Umber Brown
765138|Umber Rust
4E4D2F|Umber Shade Wash
ECE7DD|Umber Style
B26400|Umber
87706B|Umbra Sand
211E1F|Umbra
520200|Umbral Umber
A2AF70|Umbrella Green
8F4155|Umemurasaki Purple
97645A|Umenezumi Plum
FA9258|Umezome Pink
75A14F|Unakite
F5D8BB|Unbleached Calico
FFDDCA|Unbleached Silk
FBFAF5|Unbleached
FBE7E6|Unburdened Pink
A9B0B1|Uncertain Grey
19565E|Uncharted
395D68|Under the Sea
BE9E48|Underbrush
7FC3E1|Undercool
524B4C|Underground Civilization
87968B|Underground Gardens
120A65|Underground Stream
665A51|Underground
B2AC88|Underhive Ash
CC4422|Underpass Shrine
90B1AE|Undersea
7C8E87|Underseas
D4C9BB|Understated
779999|Undertow
0022BB|Underwater Falling
06D078|Underwater Fern
E78EA5|Underwater Flare
4488AA|Underwater Moonlight
243062|Underwater Realm
657F7A|Underwater World
CFEEE8|Underwater
1E231C|Underworld
89C1BA|Undine
69667C|Unexplained
E7D8DE|Unfading Dusk
986960|Unfired Clay
AE8245|Unforgettably Gold
D6C8C0|Unfussy Beige
D6A766|Ungor Beige
FF2F92|Unicorn Dust
E8E8E8|Unicorn Silver
6E5D3E|Uniform Brown
5F7B7E|Uniform Green Grey
4C4623|Uniform Green
A8A8A8|Uniform Grey
A7B7CA|Uniform
8C7EB9|Unimaginable
B5D1C7|Uninhibited
9C9680|Union Springs
C7C5BA|Union Station
CBC9C9|Unique Grey
5B92E5|United Nations Blue
264D8E|Unity
006B38|Universal Green
B8A992|Universal Khaki
B78727|University of California Gold
006633|University of Michigan
F77F00|University of Tennessee Orange
C154C1|Unloaded Texture Purple
D2CAB7|Unmarked Trail
B12D35|Unmatched Beauty
FEFE66|Unmellow Yellow
4B4840|Unplugged
7B746B|Unpredictable Hue
5C6E70|Unreal Teal
DE5730|Untamed Orange
DD0022|Untamed Red
A3A7A0|Unusual Grey
F2F8ED|Unwind
6F9587|Up North
6E706D|Up in Smoke
F1D9A5|Upbeat
EB9724|Uplifting Yellow
A3758B|Upper Crust
8D6051|Upper East Side
EE1100|Uproar Red
A8ADC2|Upscale
AE2029|Upsdell Red
B52923|Upsed Tomato
F99A7A|Upstream Salmon
A791A8|Uptown Girl
F1E4D7|Uptown Taupe
BDC9D2|Upward
BCB58C|Urahayanagi Green
93B778|Uran Mica
DDD4C5|Urban Bird
AEA28C|Urban Charm
464E4D|Urban Chic
89776E|Urban Exploration
7C7466|Urban Garden
005042|Urban Green
CACACC|Urban Grey
A4947E|Urban Jungle
67585F|Urban Legend
D3DBD9|Urban Mist
9DACB7|Urban Pigeon
B0B1A9|Urban Putty
BDCBCA|Urban Raincoat
978B6E|Urban Safari
DBD8DA|Urban Snowfall
C9BDB6|Urban Taupe
8899AA|Urban Vibes
54504A|Urbane Bronze
4D5659|Urbanite
FFD72E|Uri Yellow
FFECC2|Urnebes Beige
E1AD21|Urobilin
231712|Used Oil
CFCABD|Useful Beige
BBBB7F|Ushabti Bone
E597B2|Usu Koubai Blossom
A87CA0|Usu Pink
8C9C76|Usuao Blue
F2666C|Usubeni Red
FCA474|Usugaki Persimmon
FEA464|Usukō
8DB255|Usumoegi Green
D3003F|Utah Crimson
AED1E8|Utah Sky
A58F7B|Utaupeia
FAFAD2|Utepils
B5A597|Utterly Beige
C7FFFF|VIC 20 Blue
FFFFB2|VIC 20 Creme
94E089|VIC 20 Green
EA9FF6|VIC 20 Pink
87D6DD|VIC 20 Sky
EFD5CF|Va Va Bloom
E3B34C|Va Va Voom
D1D991|Vacation Island
FDE882|Vacherin Cheese
AA8877|Vagabond
D1C5C4|Vaguely Mauve
DBE1EF|Vaguely Violet
D4574E|Valencia
BA789E|Valentine Heart
BA0728|Valentine Lava
9B233B|Valentine Red
A53A4E|Valentine
A63864|Valentine's Day
B63364|Valentine's Kiss
382C38|Valentino Nero
B64476|Valentino
9F7A93|Valerian
FDE6E7|Valerie
2A2B41|Valhalla
F2EDE7|Valhallan Blizzard
BC322C|Valiant Poppy
3E4371|Valiant Violet
EECC22|Valkyrie
30658E|Vallarta Blue
848D85|Valley Floor
FFDD9D|Valley Flower
848A83|Valley Hills
C9D5CB|Valley Mist
B0C376|Valley View
8A763D|Valley Vineyards
FF8A4A|Valley of Fire
2D7E96|Valley of Glaciers
D1E1E4|Valley of Tears
C2CCAC|Valleyview
79C9D1|Valonia
A3BCDB|Valor
C40233|Vampire Bite
CC2255|Vampire Fangs
9B0F11|Vampire Fiction
610507|Vampire Hunter
DD0077|Vampire Love Story
DD4132|Vampire Red
CC1100|Vampire State Building
9B2848|Vampirella
CC0066|Vampiric Bloodlust
5C0C0C|Vampiric Council
BFB6AA|Vampiric Shadow
523936|Van Cleef
664228|Van Dyke Brown
ABDDF1|Van Gogh Blue
65CE95|Van Gogh Green
759465|Van Gogh Olives
FAF7EB|Van de Cane
00A3E0|Vanadyl Blue
ABDEE4|Vandermint
7B5349|Vandyck Brown
362C1D|Vanilla Bean Brown
FCEDE4|Vanilla Blush
F4D8C6|Vanilla Cream
F3E0BE|Vanilla Custard
F5E8D5|Vanilla Delight
D1BEA8|Vanilla Doe
FFFFEB|Vanilla Drop
E9DFCF|Vanilla Flower
FDE9C5|Vanilla Frost
FFE6B3|Vanilla Ice Cream
C9DAE2|Vanilla Ice Smoke
FDF2D1|Vanilla Ice
E6E0CC|Vanilla Love
F1ECE2|Vanilla Milkshake
EBDBC8|Vanilla Mocha
F3E7D3|Vanilla Paste
FAF3DD|Vanilla Powder
F7E26B|Vanilla Pudding
CBC8C2|Vanilla Quake
CCB69B|Vanilla Seed
FFFBF0|Vanilla Shake
FFE6E7|Vanilla Strawberry
F1E9DD|Vanilla Tan
F3EAD2|Vanilla Wafer
F6EEE5|Vanilla White
F3E5AB|Vanilla
F2E3CA|Vanillin
CFDFEF|Vanishing Blue
990088|Vanishing Night
DDEEDD|Vanishing Point
331155|Vanishing
E6CCDD|Vanity Pink
5692B2|Vanity
000100|Vantablack
E8E8D7|Vape Smoke
BEBDBD|Vapor Blue
F5EEDF|Vapor Trail
F0FFFF|Vapor
DFDDD7|Vaporous Grey
22DDFF|Vaporwave Blue
99EEBB|Vaporwave Pool
FF66EE|Vaporwave
855F43|Vaquero Boots
FDEFD3|Varden
747D5A|Variegated Frond
E6DCCC|Varnished Ivory
C2B197|Vast Desert
D2C595|Vast Escape
A9C9D7|Vast Sky
C9BDB8|Vast
AA55FF|Vega Violet
006C47|Vegan Green
22BB55|Vegan Mastermind
AA9911|Vegan Villain
22BB88|Vegan
C5B358|Vegas Gold
26538D|Vegeta Blue
8B8C40|Vegetable Garden
78945A|Vegetarian Veteran
CCCC99|Vegetarian Vulture
22AA00|Vegetarian
5CCD97|Vegetation
4C433D|Vehicle Body Grey
DAD8C9|Veil of Dusk
80B690|Veiled Chameleon
B2B0BD|Veiled Delight
F8CDC9|Veiled Rose
CFD5D7|Veiled Spotlight
F6EDB6|Veiled Treasure
B19BB0|Veiled Violet
D4EAFF|Veiling Waterfalls
A17D61|Velddrif
EFE4D9|Vellum Parchment
BAA7BF|Velour
D7D8C3|Veltliner White
D6CEB9|Velum Smoke
D0C5B1|Velvet Beige
241F20|Velvet Black
E3D5D8|Velvet Blush
9D253D|Velvet Cake
623941|Velvet Cape
656D63|Velvet Clover
441144|Velvet Cosmos
9291BC|Velvet Crest
AA0066|Velvet Cupcake
7E85A3|Velvet Curtain
BDB0BC|Velvet Dawn
C5ADB4|Velvet Ears
33505E|Velvet Evening
737866|Velvet Green Grey
2F5D50|Velvet Green
ACAAB3|Velvet Grey
96C193|Velvet Leaf
BB1155|Velvet Magic
692B57|Velvet Mauve
60688D|Velvet Morning
573A56|Velvet Plum
939DCC|Velvet Robe
36526A|Velvet Rope
7E374C|Velvet Rose
E3DFEC|Velvet Scarf
C5D3DD|Velvet Sky
846C76|Velvet Slipper
523544|Velvet Touch
6B605A|Velvet Umber
43354F|Velvet Violet
9A435D|Velvet Wine
750851|Velvet
936064|Velveteen Crush
A2877D|Velvety Chestnut
794143|Velvety Merlot
ABC88C|Venerable Verde
9CB08A|Venetian Glass
B39142|Venetian Gold
F7EDDA|Venetian Lace
E7CEB6|Venetian Mask
7755FF|Venetian Nights
D2EAD5|Venetian Pearl
BB8E84|Venetian Pink
C80815|Venetian Red
EFC6E1|Venetian Rose
949486|Venetian Wall
F6E3A1|Venetian Yellow
928083|Venetian
2C5778|Venice Blue
76AFB2|Venice Escape
6BFFB3|Venice Green
E6C591|Venice Square
01FF01|Venom Dart
607038|Venom Wyrm
A9A52A|Venom
66FF22|Venomous Green
3F3033|Venous Blood Red
CDE6E8|Ventilated
7381B3|Venture Violet
FED8B1|Venus Deathtrap
8F7974|Venus Deva
9EA6CF|Venus Flower
94B44C|Venus Flytrap
5F606E|Venus Mist
F0E5E5|Venus Pink
DF73FF|Venus Slipper Orchid
85A4A2|Venus Teal
7A6DC0|Venus Violet
EED053|Venus
71384C|Venusian
66B6B0|Veranda Blue
9EB1AF|Veranda Charm
AF9968|Veranda Gold
8E977E|Veranda Green
CCB994|Veranda Hills
9DA4BE|Veranda Iris
61A9A5|Veranda
F1DFDF|Verbena
5AD33E|Verdant Fields
28615D|Verdant Forest
12674A|Verdant Green
75794A|Verdant Views
847E35|Verdant
877459|Verde Marrón
EDF5E7|Verde Pastel
A7AD8D|Verde Tortuga
758000|Verde Tropa
7FB383|Verde
81A595|Verdigreen
62BE77|Verdigris Coloured
62603E|Verdigris Foncé
61AC86|Verdigris Green
558367|Verdigris Roundhead
43B3AE|Verdigris
55AABB|Verditer Blue
00BBAA|Verditer
48531A|Verdun Green
937496|Veri Berri
232324|Verified Black
00844B|Veritably Verdant
2B7CAF|Vermeer Blue
DABE82|Vermicelle
BB835F|Vermicelles
D1B791|Vermicelli
F24433|Vermilion Bird
E34234|Vermilion Cinnabar
474230|Vermilion Green
B5493A|Vermilion Red
D1062B|Vermilion Scarlet
F4320C|Vermilion
F9633B|Vermillion Orange
973A36|Vermillion Seabass
DA3B1F|Vermillion
8F7303|Vermin Brown
55CC11|Verminal
A16954|Verminlord Hide
F8F5E8|Vermont Cream
48535A|Vermont Slate
E9D3BA|Verona Beach
ECBFA8|Veronese Peach
7E3075|Veronia Purple
A020F0|Veronica
ACDFAD|Vers de Terre
C4B0AD|Versailles Rose
C1B6AB|Versatile Taupe
18880D|Verse Green
4A615C|Vert Pierre
990055|Vertigo Cherry
944F80|Verve Violet
FCEDD8|Verve
B73275|Very Berry
33365B|Very Blue
664411|Very Coffee
927288|Very Grape
D5FFFF|Very Light Blue
3A4859|Very Navy
D6FFFE|Very Pale Blue
F3D19F|Vespa Yellow
99A0B2|Vesper Violet
0011CC|Vesper
CDC8BF|Vessel
937899|Vestige
879860|Vesuvian Green
A28A9F|Vesuvian Violet
A85533|Vesuvius
2E58E8|Veteran's Day Blue
807D6F|Vetiver
6B1B2A|Vevet Outbreak
C1BBB0|Viaduct
D9D140|Viameter
D1902E|Vibrant Amber
0339F8|Vibrant Blue
0ADD08|Vibrant Green
FFBD31|Vibrant Honey
544563|Vibrant Hue
00FFE5|Vibrant Mint
FF7420|Vibrant Orange
804B81|Vibrant Orchid
AD03DE|Vibrant Purple
C24C6A|Vibrant Red
88D6DC|Vibrant Soft Blue
BB0088|Vibrant Velvet
4B373A|Vibrant Vine
6C6068|Vibrant Vision
EAEDEB|Vibrant White
FFDA29|Vibrant Yellow
FFD44D|Vibrant
5F4D50|Vicarious Violet
EE00DD|Vice City
8F509D|Vicious Violet
08589D|Victoria Blue
006A4D|Victoria Green
007755|Victoria Peak
6A3C3A|Victoria Red
564985|Victoria
D4C5CA|Victorian Cottage
C38B36|Victorian Crown
558E4C|Victorian Garden
A2783B|Victorian Gold
00B191|Victorian Greenhouse
6D657E|Victorian Iris
EFE1CD|Victorian Lace
B68B88|Victorian Mauve
104A65|Victorian Peacock
F1E3D8|Victorian Pearl
828388|Victorian Pewter
8E6278|Victorian Plum
966B6F|Victorian Rose
D28085|Victorian Rouge
AE6AA1|Victorian Valentine
B079A7|Victorian Violet
988F97|Victorian
D6B2AD|Victoriana
3A405A|Victory Blue
92ABD8|Victory Lake
549019|Vida Loca
A1DDD4|Vidalia
F7EFEF|Vienna Dawn
E9D9D4|Vienna Lace
330022|Vienna Roast
FED1BD|Vienna Sausage
4278AF|Viennese Blue
8C8185|Viennese
EEC172|Vietnamese Lantern
81796F|Vigilant
645681|Vigorous Violet
757266|Viking Castle
CABAE0|Viking Diva
4DB1C8|Viking
8FCDB0|Vile Green
EFEAE1|Villa White
AB9769|Village Crier
7E867C|Village Green
7B6F60|Village Square
728F66|Villandry
B47463|Vin Cuit
955264|Vin Rouge
F48B8B|Vinaceous Cinnamon
C74300|Vinaceous Tawny
F59994|Vinaceous
EFDAAE|Vinaigrette
ACB3AE|Vinalhaven
45584C|Vinca & Vine
5778A7|Vinca
483743|Vincotto
AE7579|Vindaloo
6E5E2C|Vine Leaf Green
4D5F4F|Vine Leaf
338544|Vine
EE4455|Vineyard Autumn
5F7355|Vineyard Green
58363D|Vineyard Wine
819E84|Vineyard
B31A38|Vinho do Porto
4B7378|Vining Ivy
4C1C24|Vino Tinto
9B2D30|Vinous
DFE1CC|Vintage Beige
87B8B5|Vintage Blue
C7B0A7|Vintage Charm
9D5F46|Vintage Copper
D68C76|Vintage Coral
D8CEB9|Vintage Ephemera
CBD8B9|Vintage Glass
B79E78|Vintage Gold
6F636D|Vintage Grape
4A556B|Vintage Indigo
9A9186|Vintage Khaki
F1E7D2|Vintage Lace
E3DCCA|Vintage Linen
BAAFAC|Vintage Mauve
763D4B|Vintage Merlot
FFB05F|Vintage Orange
675D62|Vintage Plum
F2EDEC|Vintage Porcelain
A66C47|Vintage Pottery
9E3641|Vintage Red
9097B4|Vintage Ribbon
CDBFB9|Vintage Taupe
CBB0A8|Vintage Tea Rose
669699|Vintage Teal
485169|Vintage Velvet
94B2A6|Vintage Vessel
888F4F|Vintage Vibe
E59DAC|Vintage Victorian
634F62|Vintage Violet
F4EFE4|Vintage White
65344E|Vintage Wine
72491E|Vintage Wood
847592|Vintage
68546A|Vintner
2F2A41|Viola Black
8C6897|Viola Grey
C6C8D0|Viola Ice Grey
B9A5BD|Viola Sororia
966EBD|Viola
881188|Violaceous Greti
BF8FC4|Violaceous
7F00FF|Violent Violet
838BA4|Violet Aura
BAB3CB|Violet Beauty
49434A|Violet Black
324AB3|Violet Blue
510AC9|Violet Blue
B9B1C8|Violet Bouquet
DCDCE5|Violet Breeze
531745|Violet Carmine
EFECEF|Violet Clues
D8D3E6|Violet Crush
A89B9C|Violet Dawn
DFDEE5|Violet Echo
A387AC|Violet Eclipse
991199|Violet Eggplant
E6E5E6|Violet Essence
65677A|Violet Evening
DEE2EC|Violet Extract
BA97A9|Violet Fantasy
A66DA1|Violet Femmes
B8A4C8|Violet Fields
926EAE|Violet Frog
C4C0E9|Violet Gems
4422EE|Violet Glow
675B72|Violet Haze
CDB7FA|Violet Heaven
330099|Violet Hickey
E5E2E7|Violet Hush
C2ACB1|Violet Ice
3E285C|Violet Indigo
9400D3|Violet Ink
4D4456|Violet Intense
F0A0D1|Violet Kiss
64338B|Violet Magican
644982|Violet Majesty
DACCDE|Violet Mist
ACA8CD|Violet Mix
CA7988|Violet Orchid
927B97|Violet Persuasion
FB5FFC|Violet Pink
8601BF|Violet Poison
60394D|Violet Posy
C7CCD8|Violet Powder
3A2F52|Violet Purple
8B4963|Violet Quartz
A50055|Violet Red
BCC6DF|Violet Scent Soft Blue
4D4860|Violet Shadow
5C619D|Violet Storm
C7C5DC|Violet Sweet Pea
9E91C3|Violet Tulip
C193C0|Violet Tulle
E5DAE1|Violet Vapor
B19CD9|Violet Velvet
898CA3|Violet Verbena
898098|Violet Vibes
D8E0EA|Violet Vignette
B7BDD1|Violet Vision
B09F9E|Violet Vista
883377|Violet Vixen
E9E1E8|Violet Vogue
D2D6E6|Violet Water
833E82|Violet Webcap
DAD6DF|Violet Whimsey
B48BB8|Violet Whimsy
E2E3E9|Violet White
C8D4E4|Violet Wisp
9A0EEA|Violet
EE82EE|Violet, Mamie Pink
ACA7CB|Violeta Silvestre
5A226F|Violethargic
7487C6|Violets Are Blue
882055|Violettuce
674403|Violin Brown
008F3C|Viper Green
E2DCAB|Virgin Olive Oil
ECBDB0|Virgin Peach
B7C3D7|Virginia Blue
538F4E|Virgo Green Goddess
99CC00|Viric Green
BCD7D4|Viridian Green
1E9167|Viridian
40826D|Viridian, Shǔi Cǎo Lǜ Green
C8E0AB|Viridine Green
00846B|Viridis
FE0215|Virtual Boy
8AA56E|Virtual Forest
C1EE13|Virtual Golf
C6174E|Virtual Pink
8A7A6A|Virtual Taupe
66537F|Virtual Violet
5D5558|Virtuoso
B7B0BF|Virtuous Violet
9F7BA9|Virtuous
F9E496|Vis Vis
9B94C2|Vision Quest
DFD3CB|Vision of Light
D2CCE5|Vision
83477D|Visiona Red
F6E0A9|Visionary
97D5B3|Vista Blue
E3DFD9|Vista White
CBACAB|Vista
5C2C45|Vistoris Lake
138859|Vital Green
EDE0C5|Vital Yellow
8F9B5B|Vitality
2AAA45|Vitalize
E3AC72|Viva Gold
97BEE2|Viva La Bleu
B39953|Viva Las Vegas
DC89A8|Vivacious Pink
804665|Vivacious Violet
A32857|Vivacious
EF3939|Vivaldi Red
CC9900|Vivid Amber
922724|Vivid Auburn
152EFF|Vivid Blue
9F1D35|Vivid Burgundy
DA1D81|Vivid Cerise
00AAEE|Vivid Cerulean
CC0033|Vivid Crimson
B13AAD|Vivid Fuchsia
2FEF10|Vivid Green
5C9F59|Vivid Imagination
A6D608|Vivid Lime Green
00CC33|Vivid Malachite
B80CE3|Vivid Mulberry
FFA000|Vivid Orange Peel
FFA102|Vivid Orange Peel
FF5F00|Vivid Orange
CC00FF|Vivid Orchid
9900FA|Vivid Purple
FF006C|Vivid Raspberry
DF6124|Vivid Red Tangelo
F70D1A|Vivid Red
00CCFF|Vivid Sky Blue
F07427|Vivid Tangelo
FF9980|Vivid Tangerine
E56024|Vivid Vermilion
993C7C|Vivid Viola
9F00FF|Vivid Violet
5E4B62|Vivid Vision
FFE302|Vivid Yellow
573D37|Vixen
47644B|Vizcaya Palm
7B9E98|Vizcaya
BFC0EE|Vodka
050D25|Void
AF8BA8|Voila!
6F7678|Volcanic Ash
E15835|Volcanic Blast
72453A|Volcanic Brick
615C60|Volcanic Glass
605244|Volcanic Island
6B6965|Volcanic Rock
404048|Volcanic Sand
45433B|Volcanic Stone Green
A55749|Volcanic
4E2728|Volcano
2D135F|Voldemort
CEFF00|Volt
3B4956|Voltage
7711DD|Voluptuous Violet
445A5E|Volute
443240|Voodoo
FEEEED|Voracious White
83769C|Voxatron Purple
719CA4|Voyage
4D5062|Voyager
9A937F|Voysey Grey
5F3E42|Vulcan Burgundy
E6390D|Vulcan Fire
897F79|Vulcan Mud
36383C|Vulcan
424443|Vulcanized
C8C8B5|Wabi-Sabi
EEAACC|Waddles Pink
D4BBB1|Wafer
E2C779|Waffle Cone
CDBDBA|Wafting Grey
34B233|Wageningen Green
C2B79E|Wagon Wheel
272D4E|Wahoo
5B6E91|Waikawa Grey
218BA0|Waikiki
004411|Wailing Woods
4CA2D9|Waimea Blue
9C9D85|Wainscot Green
4C4E31|Waiouru
654BC9|Waiporoporo Purple
9D9D9D|Waiting
00656E|Wakame Green
6B9362|Wakatake Green
F6D559|Wake Me Up
295468|Wakefield
789BB6|Walden Pond
496568|Walk Me Home
88BB11|Walk in the Park
3BB08F|Walk in the Woods
3D87BB|Walker Lake
FAF5FA|Walkie Chalkie
849B63|Walking Dead
A3999C|Walkway
ABAE86|Wall Green
656D73|Wall Street
11CC44|Walled Garden
9B5953|Walleye
E4E3E6|Wallflower White
A0848A|Wallflower
C6BDBF|Wallis
E9EDF1|Walls of Santorini
4C0400|Walnut Brown
5B3A29|Walnut Brown
F5D8B2|Walnut Cream
5C5644|Walnut Grove
5D5242|Walnut Hull
FFF0CF|Walnut Milkies
EECB88|Walnut Oil
A68B6E|Walnut Shell Brown
AA8344|Walnut Shell
774E37|Walnut Wood
773F1A|Walnut
999B9B|Walrus
CBDCDF|Wan Blue
E4E2DC|Wan White
5E5648|Wanderer
73A4C6|Wandering River
876D5E|Wandering Road
A6A897|Wandering Willow
CDB573|Wandering
426267|Wanderlust
643530|War God
B50038|Warlock Red
BA0033|Warlord
654740|Warm Air of Debonair
FFB865|Warm Apricot
CFC9C7|Warm Ash
9C9395|Warm Asphalt
3B1F23|Warm Balaclavas Are Forever
E3CDAC|Warm Biscuits
004242|Warm Black
4B57DB|Warm Blue
F9E6D3|Warm Bread
964E02|Warm Brown
604840|Warm Brownie
E6D5BA|Warm Buttercream
D0B082|Warm Butterscotch
BF6A52|Warm Cider
F9D09C|Warm Cocoon
A88168|Warm Cognac
B38A82|Warm Comfort
B97254|Warm Copper
C36C2D|Warm Cream Spirit
E4CEB5|Warm Croissant
927558|Warm Earth
93817E|Warm Embrace
F6E2CE|Warm Fuzzies
F1CF8A|Warm Glow
A49E97|Warm Granite
ACA49A|Warm Grey Flannel
978A84|Warm Grey
736967|Warm Haze
BE9677|Warm Hearth
C89F59|Warm Leather
FFF9D8|Warm Light
6D4741|Warm Mahogany
E1BE8B|Warm Muffin
C1B19D|Warm Neutral
8F6A50|Warm Nutmeg
D8CFBA|Warm Oats
C7B63C|Warm Olive
4C4845|Warm Onyx
483838|Warm Operator's Overalls
B4ADA6|Warm Pewter
FB5581|Warm Pink
513938|Warm Port
5C4E44|Warm Pumpernickel
952E8F|Warm Purple
C5AE91|Warm Sand
DDC9B1|Warm Shell
987744|Warm Spice
4286BC|Warm Spring
A79A8A|Warm Stone
FAF6DB|Warm Sun
AF9483|Warm Taupe
C1775E|Warm Terra Cotta
F3F5DC|Warm Turbulence
9E6654|Warm Up
A66E68|Warm Wassail
A89A8C|Warm Waterlogged Lab Coat
7EBBC2|Warm Waters
EA9073|Warm Welcome
8D894A|Warm Wetlands
EFEBD8|Warm White
D4EDE3|Warm Winter
D0B55A|Warm Woolen
CBB68F|Warm and Toasty
5C3839|Warmed Wine
E4B9A2|Warming Peach
E6D7CC|Warmstone
803020|Warmth of Teamwork
9F552D|Warmth
E5D5C9|Warp & Weft
EAF2F1|Warp Drive
6B6A74|Warpfiend Grey
927D7B|Warplock Bronze Metal
515131|Warplock Bronze
168340|Warpstone Glow
B8966E|Warrant
6B654E|Warren Tavern
A32D48|Warrior Queen
7D685B|Warrior
A9AD74|Wasabi Green
333300|Wasabi Nori
849137|Wasabi Nuts
CAE277|Wasabi Paste
B4C79C|Wasabi Peanut
BDB38F|Wasabi Powder
D2CCA0|Wasabi Zing
AFD77F|Wasabi
FAFBFD|Wash Me
1F262A|Washed Black
94D1DF|Washed Blue
819DBE|Washed Denim
E1E3D7|Washed Dollar
CCD1C8|Washed Green
CAC2AF|Washed Khaki
C5C0A3|Washed Olive
BCF5A6|Washed Out Green
DEDFCC|Washed Sage
FAE8C8|Washed in Light
FFB3A7|Washed-Out Crimson
C3D8E4|Washing Powder Soft Blue
C2DCE3|Washing Powder White
DCB89D|Wassail
9C8855|Wasteland
89C3EB|Wasurenagusa Blue
8FBABC|Watchet
5AB5CB|Water Baby
CFDFDD|Water Baptism
0E87CC|Water Blue
256D7B|Water Blue
4999A1|Water Carrier
EDE4CF|Water Chestnut
355873|Water Chi
75A7AD|Water Cooler
E1E5DC|Water Droplet
75B790|Water Fern
7AC6D9|Water Flow
76AFB6|Водяной блеск
81B89A|Водно - Зеленый
A0A3D2|Водяной гиацинт
E2E3EB|Водяной Ирис
B6ECDE|Водяной лист
E6D6C4|Водяная Лилия Белая
DDE3D5|Водяная лилия
C7D8E3|Водяной туман
6FB0BE|Музыка воды
81D0DF|Водяная Нимфа
4F5156|Водяной Узел
54AF9C|Аквапарк
B56C60|Водяная хурма
0083C8|Водная дорожка качения
B0AB80|Водяной тростник
949381|Водный Скраб
A2CDD2|Водная горка
65A5D5|Водный спирт
44BBCC|Водные виды спорта
E5EECC|Водяной росток
D8EBEA|Водяной шприц
A9BDB8|Водная поверхность
958F88|Водонапорная башня
ACC7E5|Промывка водой
3994AF|Водяной рант
A28566|Водяное колесо
80D5CC|Водяные крылья
80D4D0|Чудо воды
D4F1F9|Вода
084D58|Акварель Голубая
96B47E|Акварель Зеленая
DBE5DB|Акварель Белая
5CCBD6|Водоток
C7C7A1|Песто из кресс- салата
748C69|Специя для кресс - салата
6E9377|Кресс - салат
E4EEEA|Туман водопада
3AB0A2|Водопад
D4E4E5|Набережная
2F3F53|Вода возвращается
436BAD|Синий по ватерлинии
7B7C94|Ватерлоо
DEE9DF|Водяной знак
FD5B78|Арбузные конфеты
BF6C6E|Арбузная крошка
C0686E|Арбузное мороженое
F05C85|Арбузный сок
DFCFCA|Арбузное молоко
FBE0E8|Арбузный мусс
C77690|Арбуз Розовый
E08880|Арбузный пунш
BF4147|Арбуз Красный
E77B68|Ломтик арбуза
E42B73|Арбузный сахар
FD4659|Арбуз
EB4652|Арбузонад
D3CCCD|Древесина водяной мельницы
C9E3E5|Waterpark
DCECE7|Waterscape
B0CEC2|Watershed
D2F3EB|Waterslide
A4F4F9|Waterspout
637FBB|Watertown
7EB7BF|Waterway
AFEBDE|Waterwings
00718A|Waterworld
88BFE7|Watery Sea
AEBDBB|Watery
74AEBA|Watson Lake
D6CA3D|Wattle
F2CDBB|Watusi
DCE9EA|Wave Crest
6C919F|Wave Jumper
CBE4E7|Wave Splash
AFD9D3|Wave Top
A0764A|Wave of Grain
A5CED5|Wave
D6E1E4|Wavecrest
7DC4CD|Wavelet
D2EAEA|Waves Queen
C7AA7C|Waves of Grain
AEA266|Wavy Glass
006597|Wavy Navy
00A4A6|Wax Crayon Blue
EEB39E|Wax Flower
D8DB8B|Wax Green
F1E6CC|Wax Poetic
E2D5BD|Wax Sculpture
D3B667|Wax Way
F6ECD6|Wax Wing
EDE9AD|Wax Yellow
DDBB33|Wax
B38241|Waxen Moon
C0C2C0|Waxwing
F8B500|Waxy Corn
1188CC|Way Beyond the Blue
00C000|Waystone Green
D9DCD1|Wayward Willow
DEDFE2|Wayward Wind
99CC04|Waywatcher Green
5E5A59|Waza Bear
B21B00|Wazdakka Red
FDD7D8|We Peep
CFE2EF|Weak Blue
E1F2DF|Weak Green
EADEE4|Weak Mauve
E0F0E5|Weak Mint
FAEDE3|Weak Orange
ECDEE5|Weak Pink
F2F6DB|Weak Yellow
B47B27|Weapon Bronze
9F947D|Weather Board
593A27|Weathered Bamboo
D2E2F2|Weathered Blue
59504C|Weathered Brown
EAD0A9|Weathered Coral
988A72|Weathered Fossil
D5C6C2|Weathered Hide
90614A|Weathered Leather
E4F5E1|Weathered Mint
BABBB3|Weathered Moss
7B9093|Weathered Pebble
EADFE8|Weathered Pink
F9F4D9|Weathered Plastic
B5745C|Weathered Saddle
DFC0A6|Weathered Sandstone
937F68|Weathered Shingle
C4C5C6|Weathered Stone
E6E3D9|Weathered White
97774D|Weathered Wicker
B19C86|Weathered Wood
BDAE95|Weatherhead
2C201A|Weathervane
BFB18A|Weaver's Spool
9D7F62|Weaver's Tool
8F684B|Webcap Brown
EDEADC|Wedded Bliss
E7E8E1|Wedding Cake White
EEE2C9|Wedding Cake
FEFEE7|Wedding Dress
BCB6CB|Wedding Flowers
F6DFD8|Wedding Pink
FFFEE5|Wedding in White
EDE6E9|Wedding
E1ECA5|Wedge of Lime
4C6B88|Wedgewood
9FE4AA|Weekend Gardener
E9C2AD|Weekend Retreat
5D8727|Weeping Fig
B3B17B|Weeping Willow
D7DDEC|Weeping Wisteria
9C8D7D|Weimaraner
3AE57F|Weird Green
B3833B|Weissbier
E4E1D6|Weisswurst White
C09C6A|Welcome Home
D4C6A7|Welcome Walkway
F3E3CA|Welcome White
EEAA00|Welcoming Wasp
6F6F6D|Welded Iron
7C98AB|Weldon Blue
00888B|Well Blue
8E3537|Well Read
63ADB9|Well Water
564537|Well-Bred Brown
4F6364|Wellington
B9B5A4|Wells Grey
22BB66|Welsh Onion
3E2A2C|Wenge Black
645452|Wenge
345362|Wentworth
7E6152|Werewolf Fur
5C512F|West Coast
E5823A|West Side
586D77|West Winds
D4CFC5|Westar
A49D70|Westcar Papyrus
797978|Westchester Grey
5D3B31|Western Brown
8B6A65|Western Clay
BA816E|Western Pink
8D5E41|Western Pursuit
9B6959|Western Red
8D876D|Western Reserve
B28B80|Western Ridge
BEAA99|Western Sandstone
FADCA7|Western Sky
DAA36F|Western Sunrise
CDBB8D|Western Wear
FCD450|Westfall Yellow
2A4442|Westhaven
F3EEE3|Westhighland White
9C7C5B|Westminster
A3623B|Wet Adobe
5A6457|Wet Aloeswood
505050|Wet Asphalt
989CAB|Wet Asphalt
89877F|Wet Cement
A49690|Wet Clay
353838|Wet Concrete
D1584C|Wet Coral
000B00|Wet Crow's Wing
001144|Wet Latex
B9A023|Wet Leaf
9E9F97|Wet Pavement
E0816F|Wet Pottery Clay
897870|Wet River Rock
AE8F60|Wet Sand
786D5F|Wet Sandstone
50493C|Wet Suit
907E6C|Wet Taupe
17806D|Wet Tropical Forest
929090|Wet Weather
7D949E|Wethers Field
859488|Wethersfield Moss
A49F80|Wetland Stone
372418|Wetlands Swamp
71736A|Wetlands
F1919A|Wewak
E5E7E5|Whale Bone
59676B|Whale Grey
607C8E|Whale Shark
505A92|Whale Skin
86878C|Whale Tail
A5A495|Whale Watching
7C8181|Whale
C7D3D5|Whale's Mouth
115A82|Whale's Tale
2E7176|Whaling Waters
65737E|Wharf View
E8D7BC|What Inheritance?
441122|What We Do in the Shadows
FFF4E8|What's Left
BF923B|Wheat Beer
DFBB7E|Wheat Bread
DDD6CA|Wheat Flour White
C7C088|Wheat Grass
976B53|Wheat Penny
E3D1C8|Wheat Seed
DFD4C4|Wheat Sheaf
A49A79|Wheat Tortilla
FBDD7E|Wheat
F5DEB3|Wheat, Gruyère Cheese
AD935B|Wheatacre
C8865E|Wheatberry
FBEBBB|Wheaten White
DFD7BD|Wheatfield
9E8451|Wheatmeal
FFCD00|Wheel of Dharma
584165|When Blue Met Red
564375|When Red Met Blue
C19851|Where Buffalo Roam
C7CCCE|Where There Is Smoke
DD262B|Whero Red
9F6F55|Whetstone Brown
D8D6C5|Whetstone
00EBFF|Whimsical Blue
ECE4E2|Whimsical White
B0DCED|Whimsy Blue
ED9987|Whimsy
A09176|Whipcord
C74547|Whiplash
FFD299|Whipped Apricot
F0EDD2|Whipped Citron
EDECE7|Whipped Coconut Cream
F2F0E7|Whipped Cream
C7DDD6|Whipped Mint
FACCAD|Whipped Peach
D1C0DC|Whipped Plum
C9565A|Whipped Strawberry
A1A8D5|Whipped Violet
F2EEE0|Whipped White
CEC1B5|Whippet
FAF5E7|Whipping Cream
DFD4C0|Whirligig Geyser
E6CDCA|Whirligig
A7D0C5|Whirlpool Green
A5D8CD|Whirlpool
E2D5D3|Whirlwind
F6F1E2|Whiskers
85705F|Whiskey Barrel
D4915D|Whiskey Sour
49463F|Whiskey and Wine
D29062|Whiskey
96745B|Whisky Barrel
772233|Whisky Cola
EEAA33|Whisky Sour
C2877B|Whisky
E5E8F2|Whisper Blue
E0E6D7|Whisper Green
E9E5DA|Whisper Grey
DACBBE|Whisper Pink
C9C3B5|Whisper Ridge
EDE6DB|Whisper White
FFE5B9|Whisper Yellow
CBEDE5|Whisper of Grass
CDA2AC|Whisper of Rose
CBCECF|Whisper of Smoke
EADBCA|Whisper of White
EFE6E6|Whisper
3F4855|Whispered Secret
C9DCDC|Whispering Blue
AC9D64|Whispering Grasslands
536151|Whispering Oaks
FEDCC3|Whispering Peach
C8CAB5|Whispering Pine
ECECDA|Whispering Rain
D8D8D4|Whispering Smoke
E3E6DB|Whispering Waterfall
919C81|Whispering Willow
B7C3BF|Whispering Winds
C49E8F|Whistler Rose
D7A98C|White Acorn
A5A5A5|White Aluminum, Rainy Grey
EFEBE7|White Alyssum
ECEABE|White Asparagus
E4DFD0|White Basics
E8EFEC|White Bass
F5EFE5|White Beach
E8D0B2|White Bean Hummus
EBDFDD|White Beet
E3E7E1|White Blaze
F4ECDB|White Blossom
CDD6DB|White Blue
FBECD8|White Blush
BFD0CB|White Box
E3E0E8|White Bud
DFDFDA|White Bullet
B0B49B|White Cabbage
FAECE1|White Canvas
DBD5D1|White Castle
F5DEC2|White Cedar
F6F4F1|White Chalk
E7DBDD|White Cherry
F0E3C7|White Chocolate
F4E8E8|White Christmas
D6D0CC|White City
E8E1D3|White Clay
E8E3C9|White Cliffs
E6E0D4|White Coffee
F4F2F4|White Convolvulus
F0D498|White Corn
F9F8EF|White Crest
F9EBC5|White Currant
FDFAF1|White Desert
EFEAE6|White Dogwood
F5EEDE|White Down
CECABA|White Duck
EDEDED|White Edgar
DEDEE5|White Elephant
F7C380|White Elf
F2E9D3|White Fence
FBF4E8|White Fever
C8C2C0|White Flag
F5EDE0|White Flour
DEE6EC|White Frost
F1EFE7|White Fur
C9C2BD|White Gauze
F1F1E1|White Geranium
DDEEEE|White Glaze
FFEEEE|White Gloss
F0EFED|White Glove
C8D1C4|White Granite
BBCC99|White Grape
FCF0DE|White Grapefruit
BDECB6|White Green
D6E9CA|White Green
E2E6D7|White Hamburg Grapes
FDF9EF|White Heat
E7E1D7|White Heron
EAD8BB|White Hot Chocolate
F3E5D1|White Hyacinth
F9F6DD|White Hydrangea
D7EEE4|White Ice
DFE2E7|White Iris
D4DBB2|White Jade
F7F4DF|White Jasmine
DFDFDB|White Kitten
E2E7E7|White Lake
E1E2EB|White Lavender
DEDEDC|White Lie
F9F3DB|White Lightning
E7E5E8|White Lilac
FAF0DB|White Lily
EEE7DD|White Linen
E2DCD3|White Luxe
F7F0E5|White Luxury
F2E6DF|White Meadow
ECF3E1|White Mecca
D1D1CF|White Metal
EFEEE9|White Mink
E0E7DA|White Mint
E7DCCC|White Mocha
EBEAE2|White Moderne
F6EDDB|White Mountain
B9A193|White Mouse
F8F6D8|White Nectar
CE9F6F|White Oak
E7E2DD|White Opal
F5F3F5|White Owl
F9E6DA|White Peach
EDE1D1|White Pearl
B6A893|White Pepper
F0EFEB|White Picket Fence
DAD6CC|White Pointer
F8FBF8|White Porcelain
C3BDAB|White Primer
F6E8DF|White Pudding
F8EEE7|White Rabbit
E2E8CF|White Radish
E5C28B|White Raisin
D4CFB4|White Rock
F0E0DC|White Russian
D2D4C3|White Sage
EBEBE7|White Sail
F5EBD8|White Sand
E4EEEB|White Sapphire
8C9FA1|White Scar
D7E5EA|White Sea
E4DBCE|White Sesame
D1D3E0|White Shadow
F1F0EC|White Shoulders
F5F5F5|White Smoke
F4F5FA|White Solid
9FBDAD|White Spruce
F1FAEA|White Sulfur
E4D7C5|White Swan
C5B8A8|White Tiger
EFDBCD|White Truffle
83CCD2|White Ultramarine
F7F1E3|White Veil
C5DCB3|White Vienna
EFE6D1|White Warm Wool
EDEEEF|White Whale
ECF4DD|White Willow
DEDBCE|White Wisp
DED8D2|White Woodruff
F2EFDE|White Wool
F8EEE3|White Zin
FEFEFE|White as Heaven
FFFFFF|White
F3E8EA|White-Red
DEE3DE|Whitecap Foam
E0D5C6|Whitecap Grey
FFFDFD|Whitecap Snow
050D02|Whiten't
DEE0D2|Whitened Sage
FBFBFB|Whiteout
F8F9F5|Whitest White
F4EEE5|Whitetail
CAC9C0|Whitewash Oak
FEFFFC|Whitewash
FAF2E3|Whitewashed Fence
BAC4AD|Whitewater Bay
B2A188|Whitney Oaks
8B7181|Who-Dun-It
03C03C|Whole Nine Yards
A48B73|Whole Wheat
AAA662|Wholemeal Cookie
BEC1CF|Whomp Grey
9BCA47|Wicked Green
847567|Wicker Basket
FCE4AF|Wickerware
C19E80|Wickerwork
4F6C8F|Wickford Bay
416FAF|Wide Sky
99AAFF|Widowmaker
874E3C|Wiener Dog
EE9900|Wiener Schnitzel
C9C844|Wiggle
FEF9D7|Wild Apple
92316F|Wild Aster
63775A|Wild Axolotl
EAC37E|Wild Bamboo
6B8372|Wild Beet Leaf
7E3A3C|Wild Berry
795745|Wild Bill Brown
7A89B8|Wild Blue Yonder
A2ADD0|Wild Blue Yonder
553322|Wild Boar
5A4747|Wild Boysenberry
47241A|Wild Brown
1CD3A2|Wild Caribbean Green
916D5D|Wild Cattail
BC5D58|Wild Chestnut
665134|Wild Chocolate
93A3C1|Wild Clary
6E3C42|Wild Cranberry
7C3239|Wild Currant
8B8C89|Wild Dove
545989|Wild Elderberry
38914A|Wild Forest
986A79|Wild Geranium
7C4C53|Wild Ginger
80805D|Wild Ginseng
5E496C|Wild Grapes
998643|Wild Grass
9D7B74|Wild Hemp
EECC00|Wild Honey
634A40|Wild Horse
8D6747|Wild Horses
2F2F4A|Wild Iris
6F7142|Wild Jungle
A47FA3|Wild Lavender
BEB8CD|Wild Lilac
C3D363|Wild Lime
684944|Wild Manzanita
FFE2C7|Wild Maple
A96388|Wild Mulberry
84704B|Wild Mushroom
695649|Wild Mustang
BEAE8A|Wild Nude
ECDBC3|Wild Oats
9C8042|Wild Olive
B4B6DA|Wild Orchid Blue
D979A2|Wild Orchid
6373B4|Wild Pansy
B97A77|Wild Party
9EA5C3|Wild Phlox
767C6B|Wild Pigeon
83455D|Wild Plum
B85B57|Wild Poppy
D6C0AA|Wild Porcini
EBDD99|Wild Primrose
614746|Wild Raisin
D5BFB4|Wild Rice
447382|Wild River
CE8498|Wild Rose
B5A38C|Wild Rye
7E877D|Wild Sage
E7E4DE|Wild Sand
8A6F45|Wild Seaweed
7C5644|Wild Stallion
FF3399|Wild Strawberry
654243|Wild Thing
9E9FB6|Wild Thistle
7E9C6F|Wild Thyme
463F3C|Wild Truffle
63209B|Wild Violet
FC6D84|Wild Watermelon
7E5C52|Wild West
E0E1D1|Wild Wheat
91857C|Wild Wilderness
BECA60|Wild Willow
686B93|Wild Wisteria
F5EEC0|Wildcat Grey
C2BAA8|Wilderness Grey
8F886C|Wilderness
FF8833|Wildfire
FFB3B1|Wildflower Bouquet
C69C5D|Wildflower Honey
CCCFE2|Wildflower Prairie
927D9B|Wildflower
5D9865|Wildness Mint
CDB99B|Wildwood
AA83A4|Wilhelminian Pink
D7D8DD|Will O the Wisp
179FA6|Will
53736F|William
DDC765|Williams Pear Yellow
293648|Willow Blue
59754D|Willow Bough
DFE6CF|Willow Brook
93B881|Willow Dyed
C3CABF|Willow Green
817B69|Willow Grey
69755C|Willow Grove
84C299|Willow Hedge
E6DAB6|Willow Herb
A1A46D|Willow Leaf
5B6356|Willow Sooty Bamboo
E7E6E0|Willow Springs
C8D5BB|Willow Tree Mouse
9E8F66|Willow Tree
D5DCA9|Willow Wind
58504D|Willow Wood
9A8B4F|Willow
F0D29D|Willow-Flower Yellow
8E4483|Willowherb
85877B|Willowleaf
F3F2E8|Willowside
FD5800|Willpower Orange
BD9872|Wilmington Tan
886144|Wilmington
AB4C3D|Wilted Brown
EEDAC9|Wilted Leaf
626D5B|Wimbledon
DDE3E7|Wind Blown
B1C9DF|Wind Blue
686C7B|Wind Cave
EFF3F0|Wind Chill
DFE0E2|Wind Chime
CAC5C2|Wind Chimes
D5E2EE|Wind Force
D0D8CF|Wind Fresh White
E8BABD|Wind Rose
BFD6D9|Wind Speed
6875B7|Wind Star
C7DFE6|Wind Tunnel
C5D1D8|Wind Weaver
C8DEEA|Wind of Change
D5D8D7|Windchill
84A7CE|Windfall
BC9CA2|Windflower
DED8CF|Windfresh White
5B584C|Windgate Hill
F5E6C9|Windham Cream
C6BBA2|Winding Path
62A5DF|Windjammer
A79B83|Windmill Park
F0F1EC|Windmill Wings
F5ECE7|Windmill
BCAFBB|Window Box
989EA1|Window Grey
E4ECDF|Window Pane
018281|Windows 95 Desktop
3778BF|Windows Blue
CEBCAE|Windrift Beige
5E6C62|Windrock
DBD3C6|Windrush
E0E1DA|Winds Breath
F4E4AF|Windsong
A75502|Windsor Brown
C4B49C|Windsor Greige
626066|Windsor Grey
A697A7|Windsor Haze
545C4A|Windsor Moss
C9AFD0|Windsor Purple
CABBA1|Windsor Tan
CCB490|Windsor Toffee
9FC9E4|Windsor Way
582B36|Windsor Wine
462C77|Windsor
6D98C4|Windstorm
718BAE|Windsurf Blue
91AAB8|Windsurf
D7E2DE|Windsurfer
3A7099|Windsurfing
E3E4E5|Windswept Beach
DBA480|Windswept Canyon
B7926B|Windswept Leaves
D1F1F5|Windswept
C2E5E0|Windwood Spring
AABAC6|Windy Blue
88A3C2|Windy City
8CB0CB|Windy Day
B0A676|Windy Meadow
3D604A|Windy Pine
667F8B|Windy Seas
E8EBE7|Windy Sky
BDD1D2|Windy
A33540|Wine & Roses
AA5522|Wine Barrel
254636|Wine Bottle Green
D3D6C4|Wine Bottle
5F3E3E|Wine Brown
70403D|Wine Cellar
866D4C|Wine Cork
602234|Wine Country
96837D|Wine Crush
673145|Wine Dregs
E5D8E1|Wine Frost
643B46|Wine Goblet
941751|Wine Grape
67334C|Wine Gummy Red
355E4B|Wine Leaf
864C58|Wine Not
5E2129|Wine Red
7B0323|Wine Red
69444F|Wine Stain
8F7191|Wine Stroll
492A34|Wine Tasting
653B66|Wine Tour
D7C485|Wine Yellow
80013F|Wine
722F37|Wine, Red Wine Vinegar
663366|Wineberry
433748|Wineshade
0065AC|Wing Commander
5A6868|Wing Man
EBE4E2|Winged Victory
BAD5D4|Wingsuit Wind
EDE3E7|Wink Pink
7792AF|Wink
365771|Winner's Circle
894144|Winning Red
636653|Winning Ticket
E0CFC2|Winsome Beige
E7E9E4|Winsome Grey
A7D8E1|Winsome Hue
D4B9CB|Winsome Orchid
C28BA1|Winsome Rose
B0A6C2|Winter Amethyst
314747|Winter Balsam
B8C8D3|Winter Blizzard
47243B|Winter Bloom
DEECED|Winter Breath
8ECED8|Winter Chill
83C7DF|Winter Chime
45494C|Winter Coat
BAAAA7|Winter Cocoa
6E7A7C|Winter Could Grey
E3E7E9|Winter Day
F5F1EA|Winter Doldrums
B8B8CB|Winter Dusk
FFFFE0|Winter Duvet
B4E5EC|Winter Escape
476476|Winter Evening
BCAF9E|Winter Feather
D6EEDD|Winter Fresh
E4DECD|Winter Frost
C4D2D0|Winter Garden
EAEBE0|Winter Glaze
5E737D|Winter Harbor
E1E6EB|Winter Haven
CEC9C1|Winter Haze
D0C383|Winter Hazel
798772|Winter Hedge
DBDFE9|Winter Ice
698B9C|Winter Lake
5C97CF|Winter Lakes
EFE0C9|Winter Lite
B7FFFA|Winter Meadow
E7FBEC|Winter Mist
D1C295|Winter Mood
D9D9D6|Winter Morn
A7B3B5|Winter Morning Mist
FDEBD8|Winter Morning
5B5A41|Winter Moss
A99F97|Winter Nap
63594B|Winter Oak
F2FAED|Winter Oasis
E7E3E7|Winter Orchid
41638A|Winter Palace
95928D|Winter Park
8E9549|Winter Pea Green
EBD9D0|Winter Peach
C7A55F|Winter Pear Beige
B0B487|Winter Pear
AE3C3D|Winter Poinsettia
AAA99D|Winter Rye
AA9D80|Winter Sage
DAC7BA|Winter Savanna
BECEDB|Winter Scene
303E55|Winter Sea
4F6B79|Winter Shadow
E3EFDD|Winter Shamrock
A9C0CB|Winter Sky
49545C|Winter Solstice
ACB99F|Winter Squash
4B7079|Winter Storm
E8DADD|Winter Sunrise
CA6636|Winter Sunset
7FB9AE|Winter Surf
4090A2|Winter Time
948A7A|Winter Twig
E0E7E0|Winter Veil
D8D5CC|Winter Walk
21424D|Winter Waves
3E474C|Winter Way
F1E4DC|Winter Wedding
DFC09F|Winter Wheat
F5ECD2|Winter White
C1D8AC|Winter Willow Green
A0E6FF|Winter Wizard
6E878B|Winter in Paris
D4DDDD|Winter's Breath
DEF7FE|Winter's Day
56887D|Wintergreen Dream
C6E5CA|Wintergreen Mint
4F9E81|Wintergreen Shadow
20F986|Wintergreen
94D2BF|Wintermint
BDD4DE|Winterscape
B5AFFF|Winterspring Lilac
786DAA|Wintertime Mauve
8BA494|Wintessa
FDE6D6|Winthrop Peach
A7AFAC|Wintry Sky
8B7180|Wiped Out
3E8094|Wipeout
676662|Wire Wool
E2E3D8|Wisdom
CDBBA5|Wise Owl
447F8A|Wish Upon a Star
B6BCDF|Wish
53786A|Wishard
D8DDE6|Wishful Blue
C8E2CC|Wishful Green
FCDADF|Wishful Thinking
F4F1E8|Wishful White
604F5A|Wishing Star
9A834B|Wishing Troll
D0D1C1|Wishing Well
EBDEDB|Wishy-Washy Beige
C6E0E1|Wishy-Washy Blue
D1C2C2|Wishy-Washy Brown
DFEAE1|Wishy-Washy Green
DEEDE4|Wishy-Washy Lichen
F5DFE7|Wishy-Washy Lilies
EEF5DB|Wishy-Washy Lime
EDDDE4|Wishy-Washy Mauve
DDE2D9|Wishy-Washy Mint
F0DEE7|Wishy-Washy Pink
E1DADD|Wishy-Washy Red
E9E9D5|Wishy-Washy Yellow
F2A599|Wisley Pink
C2DCB4|Wisp Green
F9E8E2|Wisp Pink
D9C7BE|Wisp of Mauve
E5E7E9|Wisp of Smoke
A9BADD|Wisp
C6AEAA|Wispy Mauve
BCC7A4|Wispy Mint
F3EBEA|Wispy Pink
FFC196|Wispy White
84A2D4|Wisteria Blue
BBBCDE|Wisteria Fragrance
A6A8C5|Wisteria Light Soft Blue
E6C8FF|Wisteria Powder
875F9A|Wisteria Purple
B2ADBF|Wisteria Trellis
F7C114|Wisteria Yellow
A87DC2|Wisteria
B2A7CC|Wisteria-Wise
EADDD7|Wistful Beige
E33928|Wistful Longing
946C74|Wistful Mauve
A29ECD|Wistful
AA9966|Wistman's Wood
888738|Witch Brew
8E8976|Witch Hazel Leaf
FBF073|Witch Hazel
692746|Witch Soup
113300|Witch Wart
7C4A33|Witch Wood
4C3D29|Witch's Cottage
474C50|Witchcraft
35343F|Witches Cauldron
4F4552|Witching
D1D1BB|With A Twist
BCA380|With the Grain
A26666|Withered Rose
90C0C9|Witness
B1D99D|Witty Green
0073CE|Wizard Blue
525E68|Wizard Grey
6D4660|Wizard Time
DFF1FD|Wizard White
4D5B88|Wizard
A090B8|Wizard's Brew
5D6098|Wizard's Potion
584B4E|Wizard's Spell
007C76|Wizards Orb
597FB9|Woad Blue
6C9898|Woad Indigo
584769|Woad Purple
C19A6B|Wobbegong Brown
A8FF04|Wolf Lichen
78776F|Wolf Pack
788389|Wolf
3D343F|Wolf's Bane
5C5451|Wolf's Fur
B5B6B7|Wolfram
91989D|Wolverine
92ADB2|Wonder Land
EF8E9F|Wonder Lust
A085A6|Wonder Violet
635D63|Wonder Wine
A97898|Wonder Wish
ABCB7B|Wonder Woods
718A70|Wonderland
B8CDDD|Wondrous Blue
A3B1F2|Wondrous Wisteria
D0A46D|Wonton Dumpling
645A56|Wood Acres
D7CAB0|Wood Ash
FBEEAC|Wood Avens
302621|Wood Bark
554545|Wood Brown
464646|Wood Charcoal
90835E|Wood Chi
7A7229|Wood Garlic
A78C59|Wood Green
A08475|Wood Lake
EBA0A7|Wood Nymph
AABBCC|Wood Pigeon
796A4E|Wood Stain Brown
A47D43|Wood Thrush
75406A|Wood Violet
61633F|Wood's Creek
584043|Wood-Black Red
7B7F32|Woodbine
B3987D|Woodbridge Trail
847451|Woodbridge
463629|Woodburn
8E746C|Woodchuck
8F847A|Woodcraft
B59B7E|Wooded Acre
765A3F|Wooden Cabin
745C51|Wooden Nutmeg
A89983|Wooden Peg
A58563|Wooden Swing
DFB07E|Wooden Sword
996633|Woodgrain
9E7B6C|Woodhaven
96856A|Woodkraft
5F4737|Woodland Brown
004400|Woodland Grass
5C645C|Woodland Moss
475C5D|Woodland Night
69804B|Woodland Nymph
A4A393|Woodland Sage
127A49|Woodland Soul
8B8D63|Woodland Walk
626746|Woodland
405B50|Woodlawn Green
4B5D31|Woodman
AE8C8E|Woodrose
8B9916|Woodruff Green
45402B|Woodrush
2B3230|Woodsmoke
E9CAB6|Woodstock Rose
9B8A5F|Woodstock
3D271D|Woodsy Brown
755F4A|Woodward Park
6E2D2B|Woody Brown
40446C|Wooed
5F655A|Woohringa
AD9A90|Wool Coat
D9CFBA|Wool Skein
005152|Wool Turquoise
917747|Wool Tweed
5E5587|Wool Violet
F9EDE4|Wool White
DBBDAA|Wool-Milk Pig
B59F55|Woolen Mittens
B0A582|Woolen Vest
E7D5C9|Woolly Beige
BB9C7C|Woolly Mammoth
907E63|Wooly Thyme
A5A192|Wooster Smoke
572B26|Worcestershire Sauce
004D67|Work Blue
CDA366|Workbench
BFE6D2|Workout Green
FFD789|Workout Routine
02667B|Workshop Blue
005477|World Peace
CEC6BF|Worldly Grey
9FAE9E|Wormwood Green
4282C6|Worn Denim
D4DED4|Worn Jade Tiles
A69C81|Worn Khaki
6F6C0A|Worn Olive
E8DBD3|Worn Wood
634333|Worn Wooden
AB9379|Worsted Tan
8E7B58|Woven Basket
DCB639|Woven Gold
CEAD8E|Woven Navajo
F1DFC0|Woven Raffia
DDDCBF|Woven Reed
C1AC8B|Woven Straw
B99974|Woven Wicker
E0D1A0|Woven
ECEAD0|Wrack White
5F6D6E|Wrapped in Twilight
76856A|Wreath
4A4139|Wren
71635E|Wright Brown
E9D6BD|Writer's Parchment
F1E6CF|Writing Paper
474749|Wrought Iron Gate
999E98|Wrought Iron
F8D106|Wu-Tang Gold
CE7639|Wulfenite
86A96F|Wyvern Green
5A06EF|Wèi Lán Azure
E6474A|X Marks the Spot
738678|Xanadu
FFEE55|Xanthe Yellow
F4E216|Xanthic
F1B42F|Xanthous
6AB4E0|Xavier Blue
847E54|Xena
B7C0D7|Xenon Blue
7D0061|Xereus Purple
BCB7B0|Xiao Long Bao Dumpling
ECE6D1|Xiàng Yá Bái Ivory
E60626|Xiān Hóng Red
990020|Xmas Candy
F08497|Xoxo
FEF2DC|Xâkestari White
FCE166|Xìng Huáng Yellow
CC1166|Xīpe Totēc Red
1560FB|Y7K Blue
265EF7|YInMn Blue
679BB3|Yacht Blue
485783|Yacht Club Blue
566062|Yacht Club
7C9DAE|Yacht Harbor
FABBA9|Yahoo
ECAB3F|Yakitori
0F4D92|Yale Blue
D0893F|Yam
FFA400|Yamabuki Gold
CB7E1F|Yamabukicha Gold
9C8A4D|Yanagicha
8C9E5E|Yanagizome Green
EDE8DD|Yang Mist
4D5A6B|Yankee Doodle
1C2841|Yankees Blue
9E826A|Yardbird
DCCFB6|Yarmouth Oyster
D8AD39|Yarrow
547497|Yawl
7C6C57|Ye Olde Rustic Colour
AD896A|Yearling
CA135E|Yearning Desire
061088|Yearning
FFFFBF|Yell Yellow
B68D4C|Yellow Acorn
F5F5D9|Yellow Avarice
F9EED0|Yellow Beam
E3C08D|Yellow Beige
FFDD33|Yellow Bell Pepper
F1CD7B|Yellow Bird
F4EABA|Yellow Bliss
FDF4BB|Yellow Blitz
FAF3CF|Yellow Bombinate
F9F6E8|Yellow Bonnet
EAC853|Yellow Brick Road
D6AE01|Yellow Broom
AE8B0C|Yellow Brown
EEDD11|Yellow Buzzing
FFEAAC|Yellow Canary
FFF44F|Yellow Cattleya, Lemon Yellow
F5F9AD|Yellow Chalk
EDB856|Yellow Coneflower
FFDE88|Yellow Corn
EFDC75|Yellow Cream
F7C66B|Yellow Currant
9D9101|Yellow Curry
F6F1D7|Yellow Diamond
F8E47E|Yellow Dragon
F0F0D9|Yellow Emulsion
D2CC81|Yellow Endive
FCE1B6|Yellow Essence
FFB102|Yellow Exhilaration
FFCA00|Yellow Flash
FFE1A0|Yellow Geranium
BE8400|Yellow Gold
CDA434|Yellow Gold
C5E384|Yellow Green Shade
C8FD3D|Yellow Green
8F8B66|Yellow Grey
F7B930|Yellow Groove
EEE78E|Yellow Iris
E1CC4F|Yellow Ivory
FFCC3A|Yellow Jacket
DAA436|Yellow Jasper
FFD379|Yellow Jubilee
F6D099|Yellow Lotus
CCAA4D|Yellow Lupine
C0A85A|Yellow Maize
FDFCBF|Yellow Mana
D28034|Yellow Mandarin
F6D255|Yellow Mask
F0D31E|Yellow Mellow
73633E|Yellow Metal
95804A|Yellow Nile
C39143|Yellow Ocher
AEA04B|Yellow Ochre
CB9D06|Yellow Ochre
FCB001|Yellow Orange
FFAE42|Yellow Orange, Mandarin Sorbet
EADCC6|Yellow Page
ECE99B|Yellow Pear
EEEF06|Yellow Pepper
F0E74B|Yellow Petal
E4E4CB|Yellow Phosphenes
FFE4B2|Yellow Pink
FCB867|Yellow Polka Dot
FCFD74|Yellow Powder
FFF000|Yellow Rose
FFF47C|Yellow Salmonberry
A28744|Yellow Sand
F49F35|Yellow Sea
F8E2CA|Yellow Shimmer
D19932|Yellow Shout
FADA5F|Yellow Stagshorn
FFFF14|Yellow Submarine
EDFF21|Yellow Sulfur
E19447|Yellow Sumac
F9B500|Yellow Summer
FFF601|Yellow Sunshine
F7EDB7|Yellow Taffy
FFF29D|Yellow Tail
FFE36E|Yellow Tan
FFD300|Yellow Tang
F9D988|Yellow Trumpet
F6D06E|Yellow Tulip
CDBB63|Yellow Umbrella
EAB565|Yellow Varnish
FFBA6F|Yellow Warbler
C69035|Yellow Warning
EDE5B7|Yellow Wax Pepper
FEF6BE|Yellow Yarn
EAAD04|Yellow of Izamal
FFFF00|Yellow
FFEE33|Yellow-Bellied
C8CD37|Yellow-Green Grosbeak
EEBB77|Yellow-Rumped Warbler
F6F1C4|Yellowed Bone
9B7A01|Yellowish Brown
B0DD16|Yellowish Green
EDEEDA|Yellowish Grey
FFAB0F|Yellowish Orange
FCFC81|Yellowish Tan
E9F1D0|Yellowish White
FAEE66|Yellowish
F3D80E|Yellowl
E4D6BA|Yellowstone Park
CEB736|Yellowstone
BFF128|Yellowy Green
C8C48F|Yerba Mate
C7D7E0|Yeti Footprint
656952|Yew Hedge
ABBC01|Yew
848999|Yin Hūi Silver
3B3C3C|Yin Mist
F9F59F|Yippie Ya Yellow
FFFF84|Yippie Yellow
E3E4D2|Yoga Daze
F5E9CE|Yoghurt Brûlée
8A8C66|Yogi
FFECC3|Yogurt
A291BA|Yolanda
D5A585|Yolande
E2B051|Yolk Yellow
EEC701|Yolk
AA987F|York Beige
F3D9C7|York Bisque
D7837F|York Pink
D3BFE5|York Plum
67706D|York River Green
735C53|Yorkshire Brown
BAC3CC|Yorkshire Cloud
55AA00|Yoshi
E2CAAF|You're Blushing
FCD8B5|Young Apricot
D5A1A9|Young At Heart
68BE8D|Young Bamboo
86AF38|Young Bud
938C83|Young Colt
BBFFFF|Young Cornflower
F6A09D|Young Crab
C3B4B3|Young Fawn
71BC78|Young Fern
AAC0AD|Young Gecko
C3D825|Young Grass
AACF53|Young Green Onion
97D499|Young Green
D8E698|Young Greens
B0C86F|Young Leaf
B9D08B|Young Leaves
CA3435|Young Mahogany
232323|Young Night
F2E1D2|Young Peach
ACC729|Young Plum
B28EBC|Young Prince
BC64A4|Young Purple
AB4E5F|Young Redwood
FFB6B4|Young Salmon
C9AFA9|Young Turk
E1E3A9|Young Wheat
61496E|Your Majesty
FFC5BB|Your Pink
787E93|Your Shadow
E2C9C8|Youth
EE8073|Youthful Coral
A7B3B7|Yreka!
F2EFE0|Yucatan White Habanero
E9AF78|Yucatan
A1D7C9|Yucca Cream
F2EAD5|Yucca White
75978F|Yucca
826A21|Yukon Gold
66B032|Yule Tree
FFD678|Yuma Gold
CFC5AE|Yuma Sand
C7B882|Yuma
FDD200|Yuzu Jam
FFD766|Yuzu Marmalade
112200|Yuzu Soy
D4DE49|Yuzukoshō
2138AB|Yuè Guāng Lán Blue
5959AB|Yuè Guāng Lán Moonlight
00008B|Yves Klein Blue
F1A141|Янгченг Оранжевый
E0E1E2|Инь Баи Серебро
B1C4CB|Белое Серебро
05FFA6|Инь Гуань Се Зеленый
FF69AF|Инь Гуань Се Розовый
632DE9|Инь Гуань Се Фиолетовый
C0E2E1|Ю Ши Бай Белый
A8C3BC|Ян Хуйи Курит
C1264C|Зеленый Хонг Бордовый
0014A8|Заффре
EC6D71|Захри Розовый
6B5A5A|Замбези
FF990E|Замбия
DDA026|Пустыня Замеси
B2C6B1|Занах
D38977|Занси
A39A61|Пыль Зандри
823C3D|Сундук Зангиефа
E47486|Безумно Розовый
7E6765|Занзибар
F1F3F3|Веселая Зебра
FDE634|Зард Желтый
60A448|Лист Затара
CEC6BB|Зебровый вьюрок
9DA286|Трава Зебры
0090AD|Zeftron
016612|Зелено - зеленый
9FA9BE|Дзен - синий
C6BFA7|Сущность Дзен
D1DAC0|Дзен - сад
5B5D5C|Дзен-ретрит
CFD9DE|Дзен
A6C8C7|Зенитные высоты
497A9F|Зенит
424F3B|Жадность Софении
D3D9D1|Зефирно - голубой
7CB083|Зеленый зефир
C89FA5|Зефир
DDD9C4|Ноль градусов
332233|Невесомость
C6723B|Изюминка
92A360|Пикантное яблоко
3C343D|Дворец Зевса
660077|Фиолетовый Зевс
6C94CD|Храм Зевса
3B3C38|Зевс
EEFF00|Молния Зевса
FEF200|Железногорск Желтый
E4C500|Желтый цвет
F8F8F9|Жемчужина Чжен Чжу Бай
CB464A|Чжу Хонг Вермиллион
9F0FEF|Зе Луо Лан Се Фиолетовый
C94CBE|Zǐ Sè Фиолетовый
082903|Зия Олив
81A6AA|Зиккурат
16B8F3|Зима Синяя
6A5287|Зимидар
463B3A|Кластер Zin
A3907E|Цинковая смесь
5B5C5A|Цинковая пыль
655B55|Цинк Серый
8C8373|Цинковый блеск
F8F32B|Цинк Желтый
92898A|Цинк
5A3844|Красный Зинфандель
5C2935|Зинфандель
FBC17B|Zing
DAC01A|Zingiber
FFD781|Цинния Золотая
FFA010|Цинния
2C1608|Циннвальдит Коричневый
EBC2AF|Циннвальдит
BCC5AA|Сион
00849D|Синий циркон
807473|Серый циркон
D0E4E5|Цирконовый лед
DEE3E3|Циркон
2C7C79|Бирюзовый цирконий
F4F3CD|Цитронензакер
CA6641|ZōNg Hóng Красный
EE8844|Зодиакальное созвездие
8B9196|Знак Зодиака
6A755A|Зомби
39A78E|Zomp
7B6C74|Увеличение
A29589|Зорба
97A98B|Крем из кабачков
E8A64E|Цветок цуккини
AFA170|Садовые кабачки
C8D07F|Лапша из кабачков
17462E|Кабачки
CDD5D5|Зумтор
6BC026|Зеленый Зунда
008996|Зуни
248BCC|Zürich Blue
E6E1D9|Zürich White
]==]

local SITE = {}
do
	local n = 0
	for hs, name in string.gmatch(COLOR_DATA, "(%x%x%x%x%x%x)|([^\n]+)") do
		n = n + 1
		local hv = tonumber(hs, 16)
		local rgb = { hv // 65536, (hv // 256) % 256, hv % 256 }
		local isRu = string.find(name, "[\208\209]") ~= nil
		SITE[n] = { en = isRu and "" or name, ru = isRu and name or "—", r = rgb[1], g = rgb[2], b = rgb[3], raw = true }
		addCode(name, rgb) -- свои и стандартные названия не перекрываются
	end
end

local function suggest(key)
	if #key < 2 then return {} end
	local found = {}
	for k, name in pairs(NAMES) do
		if k:find(key, 1, true) then table.insert(found, name) end
	end
	table.sort(found, function(a, b) return #a < #b or (#a == #b and a < b) end)
	while #found > 5 do table.remove(found) end
	return found
end

------------------------------------------------------------
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
------------------------------------------------------------
local gui, frame, toggleBtn
local rBox, gBox, bBox, swatch, codeBox, colorNameHintLabel
local applyBtn, methodBtn, codeBtn, diagBtn, spyBtn
local histLabel, histBtns, matchBtns, status
local ruFlag, enFlag, resetBtn
local wheelFrame, wheelApplyBtn, plusBtn
local connections = {}

local method = 1
local H, S, V = 0, 0, 1
local syncing = false
local history = {}
local currentApplied
local spyActive = false
local spyHooked = false
local spyLog = {}
local msgId = 0
local resetConfirmMode = false
local closeLibFn

------------------------------------------------------------
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ GUI
------------------------------------------------------------
local function round(o, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 6); c.Parent = o end

local function label(text, pos, size, p, textSize)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1; l.Text = text; l.TextColor3 = Color3.new(1, 1, 1)
	l.Font = Enum.Font.GothamMedium; l.TextSize = textSize or 12; l.Position = pos; l.Size = size
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextYAlignment = Enum.TextYAlignment.Top
	l.Parent = p
	return l
end

local function button(text, pos, size, p, color)
	local b = Instance.new("TextButton")
	b.Text = text; b.Position = pos; b.Size = size
	b.BackgroundColor3 = color or Color3.fromRGB(70, 90, 160)
	b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 12
	b.BorderSizePixel = 0; b.Parent = p
	round(b)
	return b
end

local function box(ph, pos, size, p)
	local t = Instance.new("TextBox")
	t.PlaceholderText = ph; t.Text = ""; t.Position = pos; t.Size = size
	t.BackgroundColor3 = Color3.fromRGB(50, 50, 60); t.TextColor3 = Color3.new(1, 1, 1)
	t.PlaceholderColor3 = Color3.fromRGB(150, 150, 160); t.Font = Enum.Font.Gotham
	t.TextSize = 13; t.ClearTextOnFocus = false; t.BorderSizePixel = 0; t.Parent = p
	round(t)
	return t
end

-- Универсальная функция подключения (работает и с обычными сигналами, и с GetPropertyChangedSignal)
local function connect(obj, eventName, fn, propName)
	local conn
	if eventName == "GetPropertyChangedSignal" and propName then
		conn = obj:GetPropertyChangedSignal(propName):Connect(fn)
	else
		conn = obj[eventName]:Connect(fn)
	end
	table.insert(connections, conn)
	return conn
end

------------------------------------------------------------
-- ФУНКЦИЯ СБРОСА
------------------------------------------------------------
local function resetScript()
	for _, conn in ipairs(connections) do
		pcall(function() conn:Disconnect() end)
	end
	connections = {}
	
	if gui then pcall(function() gui:Destroy() end) end
	
	method = 1
	H, S, V = 0, 0, 1
	syncing = false
	history = {}
	currentApplied = nil
	spyActive = false
	spyHooked = false
	spyLog = {}
	msgId = 0
	resetConfirmMode = false
	if closeLibFn then pcall(closeLibFn) end
	closeLibFn = nil
	translatable = {}
	
	init()
end

------------------------------------------------------------
-- ОСНОВНАЯ ИНИЦИАЛИЗАЦИЯ
------------------------------------------------------------
function init()
	local parent = (gethui and gethui()) or pg
	local old = parent:FindFirstChild("ColorFillGui")
	if old then old:Destroy() end

	gui = Instance.new("ScreenGui")
	gui.Name = "ColorFillGui"
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 999
	gui.Parent = parent

	toggleBtn = button("🎨", UDim2.new(0, 8, 0.5, -20), UDim2.fromOffset(36, 36), gui)
	toggleBtn.TextSize = 18

	frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(240, 440)
	frame.Position = UDim2.new(0, 55, 0.5, -220)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	frame.BorderSizePixel = 0; frame.Active = true; frame.Draggable = true; frame.Visible = false
	frame.Parent = gui
	round(frame, 8)

	local titleLabel = label(t("title"), UDim2.fromOffset(8, 6), UDim2.new(1, -50, 0, 18), frame, 12)
	regTranslatable(titleLabel, "title")

	rBox = box(t("rPh"), UDim2.fromOffset(8, 30), UDim2.fromOffset(55, 26), frame)
	regTranslatable(rBox, "rPh", true)
	gBox = box(t("gPh"), UDim2.fromOffset(68, 30), UDim2.fromOffset(55, 26), frame)
	regTranslatable(gBox, "gPh", true)
	bBox = box(t("bPh"), UDim2.fromOffset(128, 30), UDim2.fromOffset(55, 26), frame)
	regTranslatable(bBox, "bPh", true)

	swatch = Instance.new("Frame")
	swatch.Position = UDim2.fromOffset(188, 30); swatch.Size = UDim2.fromOffset(44, 26)
	swatch.BackgroundColor3 = Color3.new(1, 1, 1); swatch.BorderSizePixel = 0; swatch.Parent = frame
	round(swatch, 4)

	applyBtn = button(t("applyBtn"), UDim2.fromOffset(8, 64), UDim2.fromOffset(130, 26), frame)
	regTranslatable(applyBtn, "applyBtn")
	methodBtn = button(t("methodBtn"), UDim2.fromOffset(144, 64), UDim2.fromOffset(88, 26), frame, Color3.fromRGB(60, 120, 100))
	regTranslatable(methodBtn, "methodBtn")

	local colorNameLabel = label(t("colorNameLabel"), UDim2.fromOffset(8, 96), UDim2.new(1, -16, 0, 14), frame, 11)
	regTranslatable(colorNameLabel, "colorNameLabel")
	colorNameHintLabel = label(t("colorNameHint"), UDim2.fromOffset(8, 110), UDim2.new(1, -16, 0, 12), frame, 10)
	colorNameHintLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
	regTranslatable(colorNameHintLabel, "colorNameHint")

	codeBox = box(t("codePh"), UDim2.fromOffset(8, 126), UDim2.fromOffset(140, 26), frame)
	regTranslatable(codeBox, "codePh", true)
	codeBtn = button(t("codeBtn"), UDim2.fromOffset(154, 126), UDim2.fromOffset(78, 26), frame)
	regTranslatable(codeBtn, "codeBtn")

	histLabel = label(t("historyLabel"), UDim2.fromOffset(8, 158), UDim2.new(1, -16, 0, 14), frame, 11)
	histLabel.TextXAlignment = Enum.TextXAlignment.Left
	histBtns = {}
	for i = 1, 6 do
		local hb = Instance.new("TextButton")
		hb.Position = UDim2.fromOffset(8 + (i - 1) * 36, 175)
		hb.Size = UDim2.fromOffset(30, 18)
		hb.Text = ""
		hb.BorderSizePixel = 0
		hb.Visible = false
		hb.Parent = frame
		round(hb, 4)
		histBtns[i] = hb
	end

	local matchLabel = label(t("matchLabel"), UDim2.fromOffset(8, 200), UDim2.new(1, -16, 0, 14), frame, 11)
	regTranslatable(matchLabel, "matchLabel")
	matchBtns = {}
	for i = 1, 4 do
		local mb = Instance.new("TextButton")
		mb.Position = UDim2.fromOffset(8 + (i - 1) * 56, 217)
		mb.Size = UDim2.fromOffset(50, 24)
		mb.Text = ""
		mb.BorderSizePixel = 0
		mb.Visible = false
		mb.Parent = frame
		round(mb, 3)
		
		local mbLabel = Instance.new("TextLabel")
		mbLabel.BackgroundTransparency = 1
		mbLabel.Text = ""
		mbLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
		mbLabel.Font = Enum.Font.Gotham
		mbLabel.TextSize = 8
		mbLabel.Position = UDim2.fromOffset(0, 24)
		mbLabel.Size = UDim2.fromOffset(50, 10)
		mbLabel.Parent = mb
		
		matchBtns[i] = {btn = mb, label = mbLabel}
	end

	diagBtn = button(t("diagBtn"), UDim2.fromOffset(8, 255), UDim2.fromOffset(110, 26), frame, Color3.fromRGB(90, 70, 130))
	regTranslatable(diagBtn, "diagBtn")
	spyBtn = button(t("spyBtn"), UDim2.fromOffset(124, 255), UDim2.fromOffset(108, 26), frame, Color3.fromRGB(90, 70, 130))
	regTranslatable(spyBtn, "spyBtn")

	status = label("", UDim2.fromOffset(8, 372), UDim2.new(1, -16, 0, 40), frame, 11)
	status.TextWrapped = true; status.TextYAlignment = Enum.TextYAlignment.Top

	-- ФЛАГИ + КНОПКА СБРОСА
	local flagsFrame = Instance.new("Frame")
	flagsFrame.Size = UDim2.fromOffset(130, 22)
	flagsFrame.Position = UDim2.new(1, -136, 1, -26)
	flagsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	flagsFrame.BorderSizePixel = 0
	flagsFrame.Parent = frame
	round(flagsFrame, 4)

	ruFlag = button("RU", UDim2.fromOffset(2, 2), UDim2.fromOffset(24, 18), flagsFrame, currentLang == "ru" and Color3.fromRGB(100, 140, 200) or Color3.fromRGB(60, 60, 70))
	ruFlag.TextSize = 10
	enFlag = button("US", UDim2.fromOffset(28, 2), UDim2.fromOffset(24, 18), flagsFrame, currentLang == "en" and Color3.fromRGB(100, 140, 200) or Color3.fromRGB(60, 60, 70))
	enFlag.TextSize = 10
	resetBtn = button(t("resetBtn"), UDim2.fromOffset(54, 2), UDim2.fromOffset(74, 18), flagsFrame, Color3.fromRGB(180, 100, 60))
	resetBtn.TextSize = 10
	regTranslatable(resetBtn, "resetBtn")

	-- Обработчики флагов и сброса
	connect(ruFlag, "MouseButton1Click", function()
		currentLang = "ru"
		ruFlag.BackgroundColor3 = Color3.fromRGB(100, 140, 200)
		enFlag.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		resetConfirmMode = false
		resetBtn.Text = t("resetBtn")
		resetBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 60)
		updateAllTexts()
	end)

	connect(enFlag, "MouseButton1Click", function()
		currentLang = "en"
		enFlag.BackgroundColor3 = Color3.fromRGB(100, 140, 200)
		ruFlag.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
		resetConfirmMode = false
		resetBtn.Text = t("resetBtn")
		resetBtn.BackgroundColor3 = Color3.fromRGB(180, 100, 60)
		updateAllTexts()
	end)

	connect(resetBtn, "MouseButton1Click", function()
		if not resetConfirmMode then
			resetConfirmMode = true
			resetBtn.Text = t("resetConfirm")
			resetBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
			say(currentLang == "ru" and "Нажмите ещё раз для сброса" or "Click again to reset", false, 4)
		else
			say(currentLang == "ru" and "Перезапуск..." or "Restarting...", true, 2)
			task.delay(0.3, resetScript)
		end
	end)

	function say(text, good, long)
		msgId += 1
		local my = msgId
		status.Text = text
		status.TextColor3 = good and Color3.fromRGB(120, 230, 140) or Color3.fromRGB(255, 120, 120)
		task.delay(long or 5, function() if msgId == my then status.Text = "" end end)
	end

	------------------------------------------------------------
	-- ПОДБОР СОЧЕТАЮЩИХСЯ ЦВЕТОВ
	------------------------------------------------------------
	-- Клики по подсказкам подключаются один раз; цвет хранится в mb.color
	for i = 1, 4 do
		local mb = matchBtns[i]
		connect(mb.btn, "MouseButton1Click", function()
			local col = mb.color
			if not col then return end
			rBox.Text, gBox.Text, bBox.Text = tostring(col[1]), tostring(col[2]), tostring(col[3])
			say(hexOf(Color3.fromRGB(col[1], col[2], col[3])), true, 3)
		end)
	end

	local function updateMatchingColors()
		local r = tonumber(rBox.Text)
		local g = tonumber(gBox.Text)
		local b = tonumber(bBox.Text)
		if not (r and g and b) then return end
		r, g, b = math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)

		local matches = getMatchingColors(r, g, b)

		for i = 1, 4 do
			local mb = matchBtns[i]
			local m = matches[i]
			if m then
				mb.color = { m[1], m[2], m[3] }
				mb.btn.Visible = true
				mb.btn.BackgroundColor3 = Color3.fromRGB(m[1], m[2], m[3])
				mb.label.Text = hexOf(Color3.fromRGB(m[1], m[2], m[3]))
			else
				mb.color = nil
				mb.btn.Visible = false
			end
		end
	end

	------------------------------------------------------------
	-- ПОИСК ПОЛЕЙ R/G/B
	------------------------------------------------------------
	local function isShown(g)
		local cur = g
		while cur and cur:IsA("GuiObject") do
			if not cur.Visible then return false end
			cur = cur.Parent
		end
		local sg = g:FindFirstAncestorOfClass("ScreenGui")
		return sg == nil or sg.Enabled
	end

	local function center(g) return g.AbsolutePosition + g.AbsoluteSize / 2 end

	local function findFields()
		local labels = { R = {}, G = {}, B = {} }
		local inputs = {}
		for _, d in ipairs(pg:GetDescendants()) do
			if d:IsA("GuiObject") and not d:IsDescendantOf(gui) and isShown(d) then
				if d:IsA("TextBox") then
					table.insert(inputs, d)
				elseif d:IsA("TextLabel") or d:IsA("TextButton") then
					local t2 = string.upper((string.gsub(d.Text, "[%s:]", "")))
					if labels[t2] then table.insert(labels[t2], d) end
					if tonumber(d.Text) then table.insert(inputs, d) end
				end
			end
		end
		local result = {}
		for _, ch in ipairs({ "R", "G", "B" }) do
			local best, bestScore
			for _, lab in ipairs(labels[ch]) do
				local lc = center(lab)
				for _, tb in ipairs(inputs) do
					local bc = center(tb)
					local dx, dy = bc.X - lc.X, math.abs(bc.Y - lc.Y)
					if dx > 0 and dx < 300 and dy < 25 then
						local score = dx + dy * 3
						if not bestScore or score < bestScore then best, bestScore = tb, score end
					end
				end
			end
			result[ch] = best
		end
		return result, inputs
	end

	------------------------------------------------------------
	-- ВПИСЫВАНИЕ
	------------------------------------------------------------
	local function fireConns(signal, ...)
		if not getconnections then return 0 end
		local ok, conns = pcall(getconnections, signal)
		if not ok or type(conns) ~= "table" then return 0 end
		local n = 0
		for _, c in ipairs(conns) do
			local f = c.Function
			if f then task.spawn(f, ...); n += 1
			elseif c.Fire then pcall(c.Fire, c, ...); n += 1 end
		end
		return n
	end

	local VIM
	pcall(function() VIM = game:GetService("VirtualInputManager") end)

	connect(methodBtn, "MouseButton1Click", function()
		method = method % 3 + 1
		methodBtn.Text = (currentLang == "ru" and "Метод " or "Method ") .. method
	end)

	local function commit(tb, value, m)
		m = m or method
		local text = tostring(value)
		if not tb:IsA("TextBox") then tb.Text = text; return end
		if m == 1 then
			pcall(function() tb:CaptureFocus() end)
			task.wait(0.05)
			tb.Text = text
			task.wait(0.05)
			pcall(function() tb:ReleaseFocus(true) end)
		elseif m == 2 then
			tb.Text = text
			if VIM then
				local c = center(tb)
				local sg = tb:FindFirstAncestorOfClass("ScreenGui")
				local dy = (sg and sg.IgnoreGuiInset) and 0 or game:GetService("GuiService"):GetGuiInset().Y
				pcall(function()
					VIM:SendMouseButtonEvent(c.X, c.Y + dy, 0, true, game, 1)
					VIM:SendMouseButtonEvent(c.X, c.Y + dy, 0, false, game, 1)
				end)
				task.wait(0.1)
				tb.Text = text
				pcall(function()
					VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
					VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
				end)
			end
		else
			tb.Text = text
			local fired = false
			if firesignal then fired = pcall(firesignal, tb.FocusLost, true) end
			if not fired then fireConns(tb.FocusLost, true) end
		end
		task.wait(0.05)
	end

	local function gameShowsColor(r, g, b)
		local function close(c)
			return math.abs(c.R * 255 - r) < 3 and math.abs(c.G * 255 - g) < 3 and math.abs(c.B * 255 - b) < 3
		end
		for _, d in ipairs(pg:GetDescendants()) do
			if d:IsA("GuiObject") and not d:IsDescendantOf(gui) and isShown(d)
				and d.AbsoluteSize.X >= 60 and d.AbsoluteSize.Y >= 60 then
				if d.BackgroundTransparency < 1 and close(d.BackgroundColor3) then return true end
				if d:IsA("ImageLabel") and close(d.ImageColor3) then return true end
			end
		end
		return false
	end

	local function parseChannel(text)
		local n = tonumber(text)
		if not n then return nil end
		return math.clamp(math.floor(n + 0.5), 0, 255)
	end

	local function applyToGame(r, g, b, name, noHistory)
		local fields = findFields()
		if not (fields.R and fields.G and fields.B) then
			say(t("msgFieldsNotFound"), false)
			return false
		end
		swatch.BackgroundColor3 = Color3.fromRGB(r, g, b)
		local rec = recordApplied
		if rec and not noHistory then rec(r, g, b, name) end

		local order = { method, method % 3 + 1, (method + 1) % 3 + 1 }
		for i, m in ipairs(order) do
			commit(fields.R, r, m); commit(fields.G, g, m); commit(fields.B, b, m)
			task.wait(0.25)
			if gameShowsColor(r, g, b) then
				method = m
				methodBtn.Text = (currentLang == "ru" and "Метод " or "Method ") .. m
				say(string.format(t("msgApplied"), r, g, b, m), true, 6)
				return true
			end
			fields = findFields()
			if not (fields.R and fields.G and fields.B) then break end
		end
		say(string.format(t("msgNotChanged"), r, g, b), false, 10)
		return false
	end

	connect(applyBtn, "MouseButton1Click", function()
		local r, g, b = parseChannel(rBox.Text), parseChannel(gBox.Text), parseChannel(bBox.Text)
		if not (r and g and b) then say(t("msgEnterThree"), false) return end
		applyToGame(r, g, b)
	end)

	local function parseColorText(text)
		local h6 = text:match("^%s*#?(%x%x%x%x%x%x)%s*$")
		if h6 then local t2 = hex(h6); return t2[1], t2[2], t2[3] end
		local a, b, c = text:match("^%s*#(%x)(%x)(%x)%s*$")
		if a then return tonumber(a..a,16), tonumber(b..b,16), tonumber(c..c,16) end
		local t2 = string.lower(text):gsub("rgb",""):gsub("[%(%)]","")
		local n1, n2, n3 = t2:match("^%s*(%d+)[%s,;%.]+(%d+)[%s,;%.]+(%d+)%s*$")
		if n1 then return math.clamp(tonumber(n1),0,255), math.clamp(tonumber(n2),0,255), math.clamp(tonumber(n3),0,255) end
		return nil
	end

	local function applyCode()
		local key = norm(codeBox.Text)
		local c = CODES[key]
		local parsedName
		if not c then
			local pr, pgc, pbl = parseColorText(codeBox.Text)
			if pr then c = {pr, pgc, pbl}; parsedName = ("#%02X%02X%02X"):format(pr, pgc, pbl) end
		end
		if not c then
			if key == "" then say(t("msgEnterName"), false) return end
			local sg = suggest(key)
			local msg = string.format(t("msgUnknownCode"), codeBox.Text)
			if #sg > 0 then msg = msg .. string.format(t("msgSimilar"), table.concat(sg, ", ")) end
			say(msg, false, 8)
			return
		end
		rBox.Text, gBox.Text, bBox.Text = tostring(c[1]), tostring(c[2]), tostring(c[3])
		local shownName = parsedName or NAMES[key] or codeBox.Text
		codeBox.Text = ""
		applyToGame(c[1], c[2], c[3], shownName)
	end

	connect(codeBtn, "MouseButton1Click", applyCode)
	connect(codeBox, "FocusLost", function(enterPressed) if enterPressed then applyCode() end end)

	local onRGBChanged
	local onTryOnColor
	local function preview()
		local r, g, b = parseChannel(rBox.Text), parseChannel(gBox.Text), parseChannel(bBox.Text)
		if r and g and b then
			swatch.BackgroundColor3 = Color3.fromRGB(r, g, b)
			if onRGBChanged and not syncing then onRGBChanged(r, g, b) end
			if onTryOnColor then onTryOnColor(r, g, b) end
			updateMatchingColors()
		end
	end
	-- Сигнал изменения свойства не передаёт аргументов, поэтому просто вызываем preview()
	for _, tb in ipairs({ rBox, gBox, bBox }) do
		connect(tb, "GetPropertyChangedSignal", function() preview() end, "Text")
	end

	------------------------------------------------------------
	-- КРУГОВАЯ ПАЛИТРА
	------------------------------------------------------------
	local WHEEL_R = 85
	local VAL_X, VAL_Y = 10 + WHEEL_R * 2 + 10, 34

	plusBtn = button("+", UDim2.new(1, -34, 0, 4), UDim2.fromOffset(26, 22), frame, Color3.fromRGB(60, 120, 100))

	wheelFrame = Instance.new("Frame")
	wheelFrame.Size = UDim2.fromOffset(226, 330)
	wheelFrame.Position = UDim2.new(1, 8, 0, 0)
	wheelFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	wheelFrame.BorderSizePixel = 0
	wheelFrame.Active = true
	wheelFrame.Visible = false
	wheelFrame.Parent = frame
	round(wheelFrame, 8)

	local wheelTitle = label(t("wheelTitle"), UDim2.fromOffset(10, 6), UDim2.new(1, -20, 0, 18), wheelFrame, 12)
	regTranslatable(wheelTitle, "wheelTitle")

	local wheelArea = Instance.new("Frame")
	wheelArea.Size = UDim2.fromOffset(WHEEL_R * 2, WHEEL_R * 2)
	wheelArea.Position = UDim2.fromOffset(10, 34)
	wheelArea.BackgroundTransparency = 1
	wheelArea.Parent = wheelFrame

	local STEP = 1.5
	for deg = 0, 180 - STEP, STEP do
		local spoke = Instance.new("Frame")
		spoke.AnchorPoint = Vector2.new(0.5, 0.5)
		spoke.Position = UDim2.fromScale(0.5, 0.5)
		spoke.Size = UDim2.fromOffset(WHEEL_R * 2, 4)
		spoke.Rotation = deg
		spoke.BackgroundColor3 = Color3.new(1, 1, 1)
		spoke.BorderSizePixel = 0
		local grad = Instance.new("UIGradient")
		grad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHSV(((deg + 180) % 360) / 360, 1, 1)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, Color3.fromHSV(deg / 360, 1, 1)),
		})
		grad.Parent = spoke
		spoke.Parent = wheelArea
	end

	local shade = Instance.new("Frame")
	shade.Size = UDim2.fromScale(1, 1)
	shade.BackgroundColor3 = Color3.new(0, 0, 0)
	shade.BorderSizePixel = 0
	shade.ZIndex = 2
	shade.Parent = wheelArea
	round(shade, 999)

	local cursor = Instance.new("Frame")
	cursor.AnchorPoint = Vector2.new(0.5, 0.5)
	cursor.Size = UDim2.fromOffset(14, 14)
	cursor.BackgroundTransparency = 1
	cursor.ZIndex = 3
	cursor.Parent = wheelArea
	round(cursor, 999)
	local cursorStroke = Instance.new("UIStroke")
	cursorStroke.Color = Color3.new(1, 1, 1)
	cursorStroke.Thickness = 2
	cursorStroke.Parent = cursor

	local wheelHit = Instance.new("TextButton")
	wheelHit.Size = UDim2.fromScale(1, 1)
	wheelHit.BackgroundTransparency = 1
	wheelHit.Text = ""
	wheelHit.ZIndex = 4
	wheelHit.Parent = wheelArea

	local valBar = Instance.new("Frame")
	valBar.Position = UDim2.fromOffset(VAL_X, VAL_Y)
	valBar.Size = UDim2.fromOffset(24, WHEEL_R * 2)
	valBar.BackgroundColor3 = Color3.new(1, 1, 1)
	valBar.BorderSizePixel = 0
	valBar.Parent = wheelFrame
	round(valBar, 4)
	local valGrad = Instance.new("UIGradient")
	valGrad.Rotation = 90
	valGrad.Parent = valBar

	local valHandle = Instance.new("Frame")
	valHandle.AnchorPoint = Vector2.new(0.5, 0.5)
	valHandle.Size = UDim2.fromOffset(32, 6)
	valHandle.BackgroundColor3 = Color3.new(1, 1, 1)
	valHandle.BorderSizePixel = 0
	valHandle.ZIndex = 3
	valHandle.Parent = wheelFrame
	round(valHandle, 3)
	local handleStroke = Instance.new("UIStroke")
	handleStroke.Color = Color3.new(0, 0, 0)
	handleStroke.Thickness = 1
	handleStroke.Parent = valHandle

	local valHit = Instance.new("TextButton")
	valHit.Position = UDim2.fromOffset(VAL_X - 4, VAL_Y - 6)
	valHit.Size = UDim2.fromOffset(32, WHEEL_R * 2 + 12)
	valHit.BackgroundTransparency = 1
	valHit.Text = ""
	valHit.ZIndex = 4
	valHit.Parent = wheelFrame

	local darkBtn = button(t("darkerBtn"), UDim2.fromOffset(10, 212), UDim2.fromOffset(98, 26), wheelFrame)
	regTranslatable(darkBtn, "darkerBtn")
	local lightBtn = button(t("lighterBtn"), UDim2.fromOffset(118, 212), UDim2.fromOffset(98, 26), wheelFrame)
	regTranslatable(lightBtn, "lighterBtn")
	local infoV = label("", UDim2.fromOffset(10, 242), UDim2.new(1, -20, 0, 14), wheelFrame, 11)
	local infoC = label("", UDim2.fromOffset(10, 258), UDim2.new(1, -20, 0, 14), wheelFrame, 11)
	local wheelPrev = Instance.new("Frame")
	wheelPrev.Position = UDim2.fromOffset(10, 276)
	wheelPrev.Size = UDim2.new(1, -20, 0, 14)
	wheelPrev.BorderSizePixel = 0
	wheelPrev.Parent = wheelFrame
	round(wheelPrev, 4)
	wheelApplyBtn = button(t("wheelApply"), UDim2.fromOffset(10, 296), UDim2.new(1, -20, 0, 26), wheelFrame)
	regTranslatable(wheelApplyBtn, "wheelApply")

	local function updateWheelUI(fromWheel)
		local c = Color3.fromHSV(H, S, V)
		local r, g, b = to255(c.R), to255(c.G), to255(c.B)
		local a = H * math.pi * 2
		cursor.Position = UDim2.new(0.5, math.cos(a) * S * WHEEL_R, 0.5, math.sin(a) * S * WHEEL_R)
		shade.BackgroundTransparency = V
		valGrad.Color = ColorSequence.new(Color3.fromHSV(H, S, 1), Color3.new(0, 0, 0))
		valHandle.Position = UDim2.fromOffset(VAL_X + 12, VAL_Y + (1 - V) * WHEEL_R * 2)
		infoV.Text = (currentLang == "ru" and "Яркость: " or "Brightness: ") .. math.floor(V * 100 + 0.5) .. "%"
		infoC.Text = ("RGB %d,%d,%d  #%02X%02X%02X"):format(r, g, b, r, g, b)
		wheelPrev.BackgroundColor3 = c
		if fromWheel then
			syncing = true
			rBox.Text, gBox.Text, bBox.Text = tostring(r), tostring(g), tostring(b)
			syncing = false
		end
	end

	onRGBChanged = function(r, g, b)
		local h, s, v = Color3.fromRGB(r, g, b):ToHSV()
		if v > 0 and s > 0 then H = h end
		if v > 0 then S = s end
		V = v
		updateWheelUI(false)
	end

	local function guiMouse()
		return UIS:GetMouseLocation() - game:GetService("GuiService"):GetGuiInset()
	end

	local function pickWheel()
		local d = guiMouse() - (wheelArea.AbsolutePosition + wheelArea.AbsoluteSize / 2)
		H = (math.atan2(d.Y, d.X) / (math.pi * 2)) % 1
		S = math.min(d.Magnitude, WHEEL_R) / WHEEL_R
		updateWheelUI(true)
	end

	local function pickVal()
		V = 1 - math.clamp((guiMouse().Y - valBar.AbsolutePosition.Y) / valBar.AbsoluteSize.Y, 0, 1)
		updateWheelUI(true)
	end

	local dragging = nil
	local function isPress(i)
		return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch
	end

	connect(wheelHit, "InputBegan", function(i) if isPress(i) then dragging = "wheel"; pickWheel() end end)
	connect(valHit, "InputBegan", function(i) if isPress(i) then dragging = "val"; pickVal() end end)
	connect(UIS, "InputChanged", function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			if dragging == "wheel" then pickWheel() else pickVal() end
		end
	end)
	connect(UIS, "InputEnded", function(i) if isPress(i) then dragging = nil end end)

	connect(darkBtn, "MouseButton1Click", function() V = math.clamp(V - 0.1, 0, 1); updateWheelUI(true) end)
	connect(lightBtn, "MouseButton1Click", function() V = math.clamp(V + 0.1, 0, 1); updateWheelUI(true) end)

	connect(wheelApplyBtn, "MouseButton1Click", function()
		local c = Color3.fromHSV(H, S, V)
		local r, g, b = to255(c.R), to255(c.G), to255(c.B)
		syncing = true
		rBox.Text, gBox.Text, bBox.Text = tostring(r), tostring(g), tostring(b)
		syncing = false
		applyToGame(r, g, b)
	end)

	connect(plusBtn, "MouseButton1Click", function()
		wheelFrame.Visible = not wheelFrame.Visible
		plusBtn.Text = wheelFrame.Visible and "−" or "+"
		if layoutSidePanels then layoutSidePanels() end
		if wheelFrame.Visible then
			local r, g, b = parseChannel(rBox.Text), parseChannel(gBox.Text), parseChannel(bBox.Text)
			if r and g and b then onRGBChanged(r, g, b) else updateWheelUI(false) end
		end
	end)

	updateWheelUI(false)

	------------------------------------------------------------
	-- ПРИМЕРКА (манекен с 2-3 цветами и контуром) и СПИСОК ВСЕХ ЦВЕТОВ
	------------------------------------------------------------
	local GuiService = game:GetService("GuiService")

	local addFavFn, refreshFavBar -- заполняются в разделе списка цветов

	local tryToggleBtn = button("", UDim2.fromOffset(8, 286), UDim2.fromOffset(112, 24), frame, Color3.fromRGB(60, 120, 100))
	local listToggleBtn = button("", UDim2.fromOffset(124, 286), UDim2.fromOffset(108, 24), frame, Color3.fromRGB(60, 120, 100))
	local learnToggleBtn = button("", UDim2.fromOffset(8, 314), UDim2.fromOffset(224, 24), frame, Color3.fromRGB(60, 120, 100))
	local instrBtn = button("", UDim2.fromOffset(8, 342), UDim2.fromOffset(224, 24), frame, Color3.fromRGB(110, 90, 160))

	-- ===== панель «Примерка» =====
	local tryFrame = Instance.new("Frame")
	tryFrame.Size = UDim2.fromOffset(300, 420)
	tryFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	tryFrame.BorderSizePixel = 0
	tryFrame.Active = true
	tryFrame.Visible = false
	tryFrame.Parent = frame
	round(tryFrame, 8)

	local tryTitle = label(t("tryTitle"), UDim2.fromOffset(10, 6), UDim2.fromOffset(200, 18), tryFrame, 12)
	regTranslatable(tryTitle, "tryTitle")
	local tryModeBtn = button("+", UDim2.new(1, -36, 0, 4), UDim2.fromOffset(26, 22), tryFrame, Color3.fromRGB(60, 120, 100))
	local modeLbl = label("", UDim2.fromOffset(10, 24), UDim2.new(1, -20, 0, 14), tryFrame, 11)
	modeLbl.TextColor3 = Color3.fromRGB(160, 160, 160)

	local CATS = { "hair", "top", "pants", "shoes", "acc" }
	local CAT_KEY = { hair = "catHair", top = "catTop", pants = "catPants", shoes = "catShoes", acc = "catAcc" }
	local CAT_FULL = { hair = "catHairFull", top = "catTopFull", pants = "catPantsFull", shoes = "catShoesFull", acc = "catAccFull" }
	local curCat = "top"
	local catBtns = {}
	for i, c in ipairs(CATS) do
		local b = button(t(CAT_KEY[c]), UDim2.fromOffset(10 + (i - 1) * 56, 42), UDim2.fromOffset(52, 26), tryFrame, Color3.fromRGB(50, 50, 62))
		b.TextSize = 11
		regTranslatable(b, CAT_KEY[c])
		catBtns[c] = b
	end

	-- манекен: сначала слой контура (чуть крупнее), поверх - цветные слои
	local dummy = Instance.new("Frame")
	dummy.Position = UDim2.fromOffset(10, 78)
	dummy.Size = UDim2.fromOffset(150, 150)
	dummy.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
	dummy.BorderSizePixel = 0
	dummy.Parent = tryFrame
	round(dummy, 6)

	local function shape(cx, cy, w, h, rot, corner, z)
		local f = Instance.new("Frame")
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Position = UDim2.fromOffset(cx, cy)
		f.Size = UDim2.fromOffset(w, h)
		f.Rotation = rot
		f.BorderSizePixel = 0
		f.ZIndex = z
		f.Parent = dummy
		round(f, corner)
		return f
	end

	-- иконки категорий. Строка: { слой, x, y, ширина, высота, поворот, скругление, [слой, если режим не 3 цвета] }
	-- слой 0 = не красится, 1/2/3 = цвет 1/2/3 (вокруг них рисуется контур «Контур»), 8 = блик, 9 = тень (полупрозрачные, не красятся)
	-- слой 3 в режиме «2 цвета» скрывается, если не указан запасной слой в конце строки
	local ICONS = {
		-- волосы: пушистая шапка с острыми прядями (целиком помещается в рамку). Слой 10 = плавный переход цвета 1 (верх) -> цвет 2 (низ), смешиваются по центру;
		-- чёлка длиной до боковых прядей, слегка смещена вправо; цвет 3 = уменьшенная копия тех же волос внутри (блик) (3 цвета + контур)
		hair = {
			{ 10, 75, 59, 85, 45, 0, 21 }, { 10, 45, 68, 36, 40, -8, 14 }, { 10, 106, 68, 36, 40, 8, 14 }, { 10, 75, 43, 61, 29, 0, 14 },
			{ 10, 31, 57, 9, 17, -80, 2 }, { 10, 33, 48, 9, 24, -64, 2 }, { 10, 42, 42, 9, 19, -49, 2 }, { 10, 49, 34, 9, 28, -34, 2 },
			{ 10, 61, 32, 9, 21, -19, 2 }, { 10, 72, 27, 9, 29, -4, 2 }, { 10, 83, 30, 9, 22, 10, 2 }, { 10, 95, 31, 9, 26, 25, 2 },
			{ 10, 105, 38, 9, 19, 40, 2 }, { 10, 115, 43, 9, 28, 55, 2 }, { 10, 119, 51, 9, 21, 70, 2 }, { 10, 119, 59, 9, 17, 84, 2 },
			{ 10, 33, 53, 7, 22, -64, 2 }, { 10, 45, 39, 7, 26, -34, 2 }, { 10, 66, 30, 7, 29, -4, 2 }, { 10, 89, 32, 7, 26, 26, 2 },
			{ 10, 109, 42, 7, 24, 56, 2 }, { 10, 118, 55, 7, 21, 85, 2 }, { 10, 36, 92, 22, 54, 5, 9 }, { 10, 114, 92, 22, 54, -5, 9 },
			{ 10, 30, 120, 7, 21, 18, 2 }, { 10, 37, 126, 7, 24, 8, 2 }, { 10, 44, 123, 6, 19, -6, 2 }, { 10, 120, 120, 7, 21, -18, 2 },
			{ 10, 113, 126, 7, 24, -8, 2 }, { 10, 106, 123, 6, 19, 6, 2 }, { 10, 75, 78, 74, 17, 0, 8 }, { 10, 45, 98, 7, 43, -2, 2 },
			{ 10, 49, 98, 7, 43, 10, 2 }, { 10, 56, 102, 7, 52, -8, 2 }, { 10, 60, 102, 7, 52, 4, 2 }, { 10, 67, 100, 7, 47, -13, 2 },
			{ 10, 70, 100, 7, 47, -1, 2 }, { 10, 81, 100, 7, 47, -19, 2 }, { 10, 84, 100, 7, 47, -7, 2 }, { 10, 91, 102, 7, 52, -24, 2 },
			{ 10, 94, 102, 7, 52, -12, 2 }, { 10, 102, 98, 7, 43, -30, 2 }, { 10, 106, 98, 7, 43, -18, 2 }, { 3, 100, 50, 37, 20, 0, 10 },
			{ 3, 87, 54, 16, 17, -8, 6 }, { 3, 113, 54, 16, 17, 8, 6 }, { 3, 100, 43, 27, 13, 0, 6 }, { 3, 81, 49, 3, 8, -80, 1 },
			{ 3, 81, 45, 3, 10, -64, 1 }, { 3, 86, 43, 3, 9, -49, 1 }, { 3, 88, 39, 3, 12, -34, 1 }, { 3, 94, 38, 3, 10, -19, 1 },
			{ 3, 99, 36, 3, 13, -4, 1 }, { 3, 104, 37, 3, 10, 10, 1 }, { 3, 109, 38, 3, 11, 25, 1 }, { 3, 113, 41, 3, 9, 40, 1 },
			{ 3, 118, 43, 3, 12, 55, 1 }, { 3, 119, 47, 3, 10, 70, 1 }, { 3, 119, 50, 3, 8, 84, 1 }, { 3, 81, 48, 3, 10, -64, 1 },
			{ 3, 87, 42, 3, 11, -34, 1 }, { 3, 96, 37, 3, 13, -4, 1 }, { 3, 106, 38, 3, 11, 26, 1 }, { 3, 115, 43, 3, 10, 56, 1 },
			{ 3, 119, 49, 3, 10, 85, 1 }, { 3, 83, 64, 10, 23, 5, 3 }, { 3, 118, 64, 10, 23, -5, 3 }, { 3, 81, 77, 3, 10, 18, 1 },
			{ 3, 84, 80, 3, 10, 8, 1 }, { 3, 87, 78, 3, 9, -6, 1 }, { 3, 120, 77, 3, 10, -18, 1 }, { 3, 117, 80, 3, 10, -8, 1 },
			{ 3, 114, 78, 3, 9, 6, 1 }, { 3, 100, 58, 33, 8, 0, 3 }, { 3, 87, 67, 3, 19, -2, 1 }, { 3, 88, 67, 3, 19, 10, 1 },
			{ 3, 92, 69, 3, 22, -8, 1 }, { 3, 93, 69, 3, 22, 4, 1 }, { 3, 97, 68, 3, 21, -13, 1 }, { 3, 98, 68, 3, 21, -1, 1 },
			{ 3, 103, 68, 3, 21, -19, 1 }, { 3, 104, 68, 3, 21, -7, 1 }, { 3, 107, 69, 3, 22, -24, 1 }, { 3, 109, 69, 3, 22, -12, 1 },
			{ 3, 113, 67, 3, 19, -30, 1 }, { 3, 113, 67, 3, 19, -18, 1 }, { 9, 75, 81, 73, 3, 0, 2 }, { 9, 45, 99, 3, 22, 12, 2 },
			{ 9, 106, 99, 3, 22, -12, 2 },
		},
		-- кофта: свитшот с резинками и горловиной (2 цвета + контур)
		top = {
			{ 1, 37, 92, 22, 88, 12, 10 }, { 1, 113, 92, 22, 88, -12, 10 }, { 1, 52, 56, 30, 24, 0, 12 },
			{ 1, 98, 56, 30, 24, 0, 12 }, { 1, 75, 92, 60, 80, 0, 12 }, { 2, 75, 131, 62, 12, 0, 5 },
			{ 2, 29, 134, 22, 10, 12, 4 }, { 2, 121, 134, 22, 10, -12, 4 }, { 2, 75, 48, 38, 12, 0, 6 },
			{ 0, 75, 50, 24, 8, 0, 4 }, { 8, 56, 86, 6, 44, 0, 3 }, { 8, 45, 100, 4, 40, 10, 2 },
			{ 9, 98, 100, 6, 40, 0, 3 }, { 9, 121, 104, 4, 34, -12, 2 }, { 9, 75, 125, 56, 3, 0, 1 },
		},
		-- штаны: пояс, карманы, строчка и манжеты (2 цвета + контур)
		pants = {
			{ 1, 58, 104, 34, 88, 3, 7 }, { 1, 92, 104, 34, 88, -3, 7 }, { 1, 75, 66, 62, 34, 0, 8 },
			{ 2, 75, 50, 70, 14, 0, 4 }, { 2, 75, 50, 10, 10, 0, 5 }, { 2, 75, 72, 3, 26, 0, 1 },
			{ 2, 50, 70, 16, 4, -28, 2 }, { 2, 100, 70, 16, 4, 28, 2 }, { 2, 41, 95, 3, 7, 0, 1 },
			{ 2, 41, 108, 3, 7, 0, 1 }, { 2, 41, 121, 3, 7, 0, 1 }, { 2, 109, 95, 3, 7, 0, 1 },
			{ 2, 109, 108, 3, 7, 0, 1 }, { 2, 109, 121, 3, 7, 0, 1 }, { 2, 56, 143, 34, 8, 0, 3 },
			{ 2, 94, 143, 34, 8, 0, 3 }, { 8, 52, 100, 5, 40, 2, 2 }, { 8, 86, 100, 5, 40, -2, 2 },
			{ 9, 67, 110, 5, 50, 0, 2 }, { 9, 83, 110, 5, 50, 0, 2 },
		},
		-- обувь: ботинок со шнуровкой, носком и подошвой (2 цвета + контур)
		shoes = {
			{ 1, 48, 74, 36, 44, 0, 10 }, { 1, 66, 100, 76, 34, -3, 14 }, { 1, 108, 111, 40, 26, 0, 13 },
			{ 2, 78, 127, 108, 13, 0, 6 }, { 2, 32, 120, 20, 24, 0, 6 }, { 2, 52, 60, 26, 12, 0, 5 },
			{ 2, 64, 80, 22, 5, 22, 2 }, { 2, 70, 91, 22, 5, 22, 2 }, { 2, 76, 102, 22, 5, 22, 2 },
			{ 2, 114, 108, 6, 26, 0, 3 }, { 8, 48, 70, 4, 26, 0, 2 }, { 8, 84, 95, 36, 4, -4, 2 },
			{ 9, 70, 124, 100, 3, 0, 1 },
		},
		-- аксессуар: бант. 2 цвета: петли и узел, хвосты цвета 1; 3 цвета: хвосты получают цвет 3
		acc = {
			{ 1, 48, 64, 46, 38, -22, 17 }, { 1, 102, 64, 46, 38, 22, 17 }, { 3, 60, 106, 20, 46, 14, 6, 1 },
			{ 3, 90, 106, 20, 46, -14, 6, 1 }, { 2, 75, 68, 20, 26, 0, 8 }, { 8, 42, 56, 22, 5, -22, 3 },
			{ 8, 108, 56, 22, 5, 22, 3 }, { 9, 58, 74, 16, 4, 28, 2 }, { 9, 92, 74, 16, 4, -28, 2 },
			{ 9, 58, 112, 5, 30, 14, 2 }, { 9, 92, 112, 5, 30, -14, 2 },
		},
	}
	local CAT_MODE = { hair = 3, top = 2, pants = 2, shoes = 2 } -- у аксессуара режим 2/3 переключается кнопкой
	local accMode = 2
	local LAYER_Z = { [0] = 3, [1] = 2, [2] = 4, [3] = 5, [8] = 6, [9] = 6, [10] = 2 }
	local iconObjs = {}
	local function buildIcon(cat)
		for _, o in ipairs(iconObjs) do
			o.obj:Destroy()
			if o.line then o.line:Destroy() end
		end
		iconObjs = {}
		for _, d in ipairs(ICONS[cat]) do
			local o = { part = d }
			if (d[1] >= 1 and d[1] <= 3) or d[1] == 10 then
				o.line = shape(d[2], d[3], d[4] + 6, d[5] + 6, d[6], d[7] + 3, 1)
			end
			o.obj = shape(d[2], d[3], d[4], d[5], d[6], d[7], LAYER_Z[d[1]])
			if d[1] == 0 then
				o.obj.BackgroundColor3 = (cat == "hair") and Color3.fromRGB(235, 200, 170) or Color3.fromRGB(30, 30, 38)
			elseif d[1] == 8 then
				o.obj.BackgroundColor3 = Color3.new(1, 1, 1)
				o.obj.BackgroundTransparency = 0.72
			elseif d[1] == 9 then
				o.obj.BackgroundColor3 = Color3.new(0, 0, 0)
				o.obj.BackgroundTransparency = 0.72
			elseif d[1] == 10 then
				-- деталь с градиентом: направление «вниз» на экране, высота считается по общему диапазону волос
				o.obj.BackgroundColor3 = Color3.new(1, 1, 1)
				o.grad = Instance.new("UIGradient")
				o.grad.Rotation = 90 - d[6]
				o.grad.Parent = o.obj
				local rad = math.rad(d[6])
				local ext = (d[4] * math.abs(math.sin(rad)) + d[5] * math.abs(math.cos(rad))) / 2
				o.gy0, o.gy1 = d[3] - ext, d[3] + ext
			end
			table.insert(iconObjs, o)
		end
	end

	local function defaultColors()
		return {
			[1] = Color3.fromRGB(20, 20, 20),
			[2] = Color3.fromRGB(220, 30, 30),
			[3] = Color3.fromRGB(150, 60, 200),
			[4] = Color3.fromRGB(60, 220, 60),
		}
	end
	local catColors = {}
	for _, c in ipairs(CATS) do catColors[c] = defaultColors() end
	local slotColors = catColors[curCat]
	buildIcon(curCat)
	local tryMode = 2        -- 2 = два цвета + контур, 3 = три цвета + контур
	local activeSlot = 1
	local tryLoading = false -- true, пока слот сам пишет цвет в поля R/G/B
	local walking = false    -- true, пока идёт обход предметов
	local refreshAuto        -- заполняется в разделе «Авто и рандом»
	local autoFrame, instrFrame
	local PAL = { same = false, darkOutline = true, mode = nil, scope = "one", style = "near", sample = nil, sampleSlot = nil } -- общие настройки «Похожие / Рандом всех»; функции заполняются ниже

	local slotKeys = { "slot1", "slot2", "slot3", "slotOutline" }
	local function slotName(i) return t(slotKeys[i]) end

	local slotBtns = {}
	for i = 1, 4 do
		local b = button(t(slotKeys[i]), UDim2.fromOffset(170, 78), UDim2.fromOffset(120, 30), tryFrame, Color3.fromRGB(50, 50, 62))
		b.TextXAlignment = Enum.TextXAlignment.Left
		local pd = Instance.new("UIPadding")
		pd.PaddingLeft = UDim.new(0, 8)
		pd.Parent = b
		regTranslatable(b, slotKeys[i])
		local sw = Instance.new("Frame")
		sw.AnchorPoint = Vector2.new(1, 0.5)
		sw.Position = UDim2.new(1, -6, 0.5, 0)
		sw.Size = UDim2.fromOffset(26, 20)
		sw.BorderSizePixel = 0
		sw.Parent = b
		round(sw, 4)
		local st = Instance.new("UIStroke")
		st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		st.Thickness = 2
		st.Color = Color3.new(1, 1, 1)
		st.Enabled = false
		st.Parent = b
		slotBtns[i] = { btn = b, sw = sw, stroke = st }
	end

	local infoLbl = label("", UDim2.fromOffset(10, 268), UDim2.new(1, -20, 0, 32), tryFrame, 11)
	infoLbl.TextWrapped = true

	local applyAllBtn = button(t("applyAll"), UDim2.fromOffset(10, 306), UDim2.new(1, -20, 0, 30), tryFrame, Color3.fromRGB(70, 140, 90))
	regTranslatable(applyAllBtn, "applyAll")
	local autoBtn = button(t("autoBtn"), UDim2.fromOffset(10, 344), UDim2.fromOffset(136, 28), tryFrame)
	regTranslatable(autoBtn, "autoBtn")
	local resetColorsBtn = button(t("resetColors"), UDim2.fromOffset(154, 344), UDim2.fromOffset(136, 28), tryFrame, Color3.fromRGB(150, 90, 60))
	regTranslatable(resetColorsBtn, "resetColors")

	-- быстрые слоты избранного: «+★» сохраняет цвет активного слота, квадраты - последние 6 избранных
	local favBarAdd = button("+★", UDim2.fromOffset(10, 382), UDim2.fromOffset(34, 28), tryFrame, Color3.fromRGB(150, 120, 40))
	local favBarBtns, favBarColor = {}, {}
	for i = 1, 6 do
		local b = button("☆", UDim2.fromOffset(48 + (i - 1) * 40, 382), UDim2.fromOffset(36, 28), tryFrame, Color3.fromRGB(44, 44, 54))
		favBarBtns[i] = b
		connect(b, "MouseButton1Click", function()
			local c = favBarColor[i]
			if c then rBox.Text, gBox.Text, bBox.Text = tostring(c[1]), tostring(c[2]), tostring(c[3]) end
		end)
	end

	local function renderDummy()
		local three = (tryMode == 3)
		for _, o in ipairs(iconObjs) do
			local d = o.part
			local eff = d[1]
			if eff == 3 and not three then eff = d[8] end
			o.obj.Visible = (eff ~= nil)
			if o.line then
				o.line.Visible = (eff ~= nil)
				o.line.BackgroundColor3 = slotColors[4]
			end
			if eff and eff >= 1 and eff <= 3 then o.obj.BackgroundColor3 = slotColors[eff] end
			if o.grad then
				local c1, c2 = slotColors[1], slotColors[2]
				local kps, N = {}, 8
				for k = 0, N do
					local f = k / N
					local y = o.gy0 + (o.gy1 - o.gy0) * f
					local m = math.clamp(((y - 12) / 126 - 0.38) / 0.24, 0, 1) -- 12..138 = высота волос на иконке
					m = m * m * (3 - 2 * m)
					kps[#kps + 1] = ColorSequenceKeypoint.new(f, c1:Lerp(c2, m))
				end
				o.grad.Color = ColorSequence.new(kps)
			end
		end
	end

	local function refreshTry()
		renderDummy()
		local order = (tryMode == 3) and { 1, 2, 3, 4 } or { 1, 2, 4 }
		for i = 1, 4 do slotBtns[i].btn.Visible = false end
		for pos, i in ipairs(order) do
			slotBtns[i].btn.Visible = true
			slotBtns[i].btn.Position = UDim2.fromOffset(170, 78 + (pos - 1) * 36)
		end
		for i = 1, 4 do
			slotBtns[i].sw.BackgroundColor3 = slotColors[i]
			slotBtns[i].stroke.Enabled = (i == activeSlot)
		end
		local c = slotColors[activeSlot]
		infoLbl.Text = ("%s: %s   RGB %d, %d, %d"):format(slotName(activeSlot), hexOf(c), to255(c.R), to255(c.G), to255(c.B))
		modeLbl.Text = t(CAT_FULL[curCat]) .. "  ·  " .. t(tryMode == 3 and "modeThree" or "modeTwo")
		for _, c in ipairs(CATS) do
			catBtns[c].BackgroundColor3 = (c == curCat) and Color3.fromRGB(80, 100, 170) or Color3.fromRGB(50, 50, 62)
		end
		tryModeBtn.Text = (tryMode == 3) and "−" or "+"
		tryModeBtn.Visible = (curCat == "acc")
		if refreshAuto then refreshAuto() end
	end

	local function selectSlot(i)
		if tryMode ~= 3 and i == 3 then return end
		activeSlot = i
		local c = slotColors[i]
		tryLoading = true
		rBox.Text, gBox.Text, bBox.Text = tostring(to255(c.R)), tostring(to255(c.G)), tostring(to255(c.B))
		tryLoading = false
		refreshTry()
	end

	-- любое изменение R/G/B (ввод, круг, код, список) красит активный слот
	onTryOnColor = function(r, g, b)
		if tryLoading or not tryFrame.Visible then return end
		local cur = slotColors[activeSlot]
		local changed = to255(cur.R) ~= r or to255(cur.G) ~= g or to255(cur.B) ~= b
		slotColors[activeSlot] = Color3.fromRGB(r, g, b)
		if changed then PAL.sample, PAL.sampleSlot = Color3.fromRGB(r, g, b), activeSlot end -- образец для «Похожие»
		refreshTry()
	end

	for i = 1, 4 do
		connect(slotBtns[i].btn, "MouseButton1Click", function() selectSlot(i) end)
	end

	connect(tryModeBtn, "MouseButton1Click", function()
		if curCat ~= "acc" then return end -- у остальных категорий режим фиксированный
		tryMode = (tryMode == 2) and 3 or 2
		accMode = tryMode
		if tryMode == 2 and activeSlot == 3 then activeSlot = 1 end
		refreshTry()
	end)

	connect(resetColorsBtn, "MouseButton1Click", function()
		local d = defaultColors()
		for i = 1, 4 do slotColors[i] = d[i] end
		PAL.sample, PAL.sampleSlot = nil, nil
		selectSlot(activeSlot)
	end)

	local function setCategory(cat)
		if not ICONS[cat] or walking then return end
		curCat = cat
		slotColors = catColors[cat]
		PAL.sample, PAL.sampleSlot = nil, nil
		tryMode = CAT_MODE[cat] or accMode
		if tryMode ~= 3 and activeSlot == 3 then activeSlot = 1 end
		buildIcon(cat)
		selectSlot(activeSlot)
	end
	for _, c in ipairs(CATS) do
		connect(catBtns[c], "MouseButton1Click", function() setCategory(c) end)
	end

	-- «умное» определение категории по тексту, который сейчас виден в меню игры
	local CAT_STEMS = {
		hair = { "^волос", "^hair", "^причес" },
		top = { "^кофт", "^куртк", "^толстов", "^свитер", "^jacket", "^hoodie", "^shirt", "^sweater", "^top$" },
		pants = { "^штан", "^брюк", "^шорт", "^pants", "^trousers", "^shorts", "^jeans" },
		shoes = { "^обув", "^ботин", "^туфл", "^кроссов", "^shoes", "^boots", "^sneaker" },
		acc = { "^аксессуар", "^шапк", "^кепк", "^accessor", "^hat$", "^cap$" },
	}
	local function detectCategory()
		local found, n = {}, 0
		for _, d in ipairs(pg:GetDescendants()) do
			if (d:IsA("TextButton") or d:IsA("TextLabel")) and not d:IsDescendantOf(gui) and isShown(d) then
				local tx = norm(d.Text)
				if tx ~= "" and #tx < 30 then
					for _, c in ipairs(CATS) do
						if not found[c] then
							for _, stem in ipairs(CAT_STEMS[c]) do
								if string.find(tx, stem) then
									found[c] = true
									n = n + 1
									break
								end
							end
						end
					end
				end
			end
		end
		local names = {}
		for _, c in ipairs(CATS) do if found[c] then table.insert(names, t(CAT_FULL[c])) end end
		if n == 1 then
			for _, c in ipairs(CATS) do if found[c] then return c, names end end
		end
		return nil, names
	end

	-- ===== поиск вкладок слотов в игре и нажатие на них =====
	local SLOT_NAMES = {
		{ "цвет1", "основной", "color1", "primary" },
		{ "цвет2", "вторичный", "color2", "secondary" },
		{ "цвет3", "дополнительно", "color3", "additional" },
		{ "контур", "outline" },
	}

	local function findTabByNames(names)
		local want = {}
		for _, n in ipairs(names) do want[n] = true end
		for _, d in ipairs(pg:GetDescendants()) do
			if (d:IsA("TextButton") or d:IsA("TextLabel")) and not d:IsDescendantOf(gui) and isShown(d) then
				if want[norm(d.Text)] then
					local btn = d
					if not d:IsA("TextButton") then
						local cur = d.Parent
						while cur and cur ~= pg do
							if cur:IsA("GuiButton") then
								btn = cur
								break
							end
							cur = cur.Parent
						end
					end
					return btn
				end
			end
		end
		return nil
	end

	local function clickGui(btn)
		local did = false
		if firesignal then
			for _, sigName in ipairs({ "MouseButton1Down", "MouseButton1Click", "Activated", "MouseButton1Up" }) do
				local okS, sig = pcall(function() return btn[sigName] end)
				if okS and sig and pcall(firesignal, sig) then did = true end
			end
		end
		if VIM then
			local c = center(btn)
			local sg = btn:FindFirstAncestorOfClass("ScreenGui")
			local dy = (sg and sg.IgnoreGuiInset) and 0 or GuiService:GetGuiInset().Y
			local okV = pcall(function()
				VIM:SendMouseButtonEvent(c.X, c.Y + dy, 0, true, game, 1)
				VIM:SendMouseButtonEvent(c.X, c.Y + dy, 0, false, game, 1)
			end)
			if okV then did = true end
		end
		if not did then
			for _, sigName in ipairs({ "MouseButton1Click", "Activated" }) do
				local okS, sig = pcall(function() return btn[sigName] end)
				if okS and sig then fireConns(sig) end
			end
		end
	end

	local applyingAll = false
	local smartSkip = false -- «Пропускать подходящие»

	-- два цвета сочетаются: соседние оттенки (до 30°), треугольник (120°) или противоположные (180°).
	-- Серые, белые и чёрные подходят ко всему.
	local function colorsFit(c1, c2)
		local h1, s1, v1 = c1:ToHSV()
		local h2, s2, v2 = c2:ToHSV()
		if s1 < 0.15 or v1 < 0.15 or s2 < 0.15 or v2 < 0.15 then return true end
		local d = math.abs(h1 - h2)
		d = math.min(d, 1 - d) * 360
		return d <= 30 or math.abs(d - 120) <= 15 or d >= 165
	end

	-- числа, которые сейчас стоят в полях R/G/B игры
	local function readGameColor()
		local f = findFields()
		if not (f.R and f.G and f.B) then return nil end
		local r, g, b = parseChannel(f.R.Text), parseChannel(f.G.Text), parseChannel(f.B.Text)
		if r and g and b then return r, g, b end
		return nil
	end

	-- красит все слоты по очереди; возвращает: сделано, всего, не найдены вкладки, не подтверждены, оставлены
	local function applyAllSlotsSync()
		local order = (tryMode == 3) and { 1, 2, 3, 4 } or { 1, 2, 4 }
		local done = 0
		local missing, unsure, kept = {}, {}, {}
		for _, i in ipairs(order) do
			local tab = findTabByNames(SLOT_NAMES[i])
			if tab then
				clickGui(tab)
				task.wait(0.35)
				local c = slotColors[i]
				local pr, pgc, pb = to255(c.R), to255(c.G), to255(c.B)
				local keep = false
				if smartSkip then
					local gr, gg, gb = readGameColor()
					if gr then
						if math.abs(gr - pr) <= 3 and math.abs(gg - pgc) <= 3 and math.abs(gb - pb) <= 3 then
							keep = true -- в игре уже почти такой цвет
						else
							local cur = Color3.fromRGB(gr, gg, gb)
							local fits, refs = true, 0
							for _, j in ipairs(order) do
								if j ~= i and j ~= 4 then
									refs += 1
									if not colorsFit(cur, slotColors[j]) then fits = false break end
								end
							end
							keep = fits and refs > 0
						end
					end
				end
				if keep then
					done += 1
					table.insert(kept, slotName(i))
				elseif applyToGame(pr, pgc, pb, slotName(i), true) then
					done += 1
				else
					table.insert(unsure, slotName(i))
				end
			else
				table.insert(missing, slotName(i))
			end
		end
		return done, #order, missing, unsure, kept
	end

	local function applyAllSlots()
		if applyingAll then return end
		applyingAll = true
		task.spawn(function()
			local done, total, missing, unsure, kept = applyAllSlotsSync()
			local msg = string.format(t("msgSlotsApplied"), done, total)
			if #kept > 0 then msg = msg .. string.format(t("msgSlotKept"), table.concat(kept, ", ")) end
			if #unsure > 0 then msg = msg .. string.format(t("msgSlotUnsure"), table.concat(unsure, ", ")) end
			if #missing > 0 then msg = msg .. string.format(t("msgSlotMissing"), table.concat(missing, ", ")) end
			say(msg, done > 0, 12)
			applyingAll = false
		end)
	end
	connect(applyAllBtn, "MouseButton1Click", applyAllSlots)

	-- «Авто»: старая настройка показывает вкладку «Цвет 3» только у предметов с тремя цветами
	connect(autoBtn, "MouseButton1Click", function()
		local cat, names = detectCategory()
		local catMsg
		if cat then
			setCategory(cat)
			catMsg = string.format(t("msgCatFound"), t(CAT_FULL[cat]))
		elseif #names > 1 then
			catMsg = string.format(t("msgCatMany"), table.concat(names, ", "))
		else
			catMsg = t("msgCatNone")
		end
		if findTabByNames({ "цвет1" }) then
			local gameMode = findTabByNames({ "цвет3" }) and 3 or 2
			if curCat == "acc" then
				tryMode = gameMode
				accMode = gameMode
				if tryMode == 2 and activeSlot == 3 then activeSlot = 1 end
			end
			refreshTry()
			say(t(gameMode == 3 and "msgAutoThree" or "msgAutoTwo") .. catMsg, true, 8)
		elseif findTabByNames({ "основной" }) then
			say(t("msgAutoNew") .. catMsg, false, 9)
		else
			say(t("msgAutoFail") .. catMsg, false, 9)
		end
	end)

	-- ===== панель «Все цвета»: виртуальный список =====
	-- Вместо тысяч элементов интерфейса создаётся VIS строк, которые переиспользуются при прокрутке.
	local listFrame = Instance.new("Frame")
	listFrame.Size = UDim2.fromOffset(300, 392)
	listFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	listFrame.BorderSizePixel = 0
	listFrame.Active = true
	listFrame.Visible = false
	listFrame.Parent = frame
	round(listFrame, 8)

	local listTitle = label(t("listTitle"), UDim2.fromOffset(10, 6), UDim2.fromOffset(180, 18), listFrame, 12)
	regTranslatable(listTitle, "listTitle")
	local countLbl = label("", UDim2.new(1, -110, 0, 6), UDim2.fromOffset(100, 18), listFrame, 11)
	countLbl.TextXAlignment = Enum.TextXAlignment.Right
	countLbl.TextColor3 = Color3.fromRGB(160, 160, 160)

	local searchBox = box(t("searchPh"), UDim2.fromOffset(10, 30), UDim2.new(1, -86, 0, 26), listFrame)
	local favFilterBtn = button(t("favFilter"), UDim2.new(1, -72, 0, 30), UDim2.fromOffset(62, 26), listFrame, Color3.fromRGB(150, 120, 40))
	regTranslatable(favFilterBtn, "favFilter")
	regTranslatable(searchBox, "searchPh", true)

	local ROW_H, VIS = 39, 6
	local VP_H = 236
	local ROWS_W = 258

	local viewport = Instance.new("Frame")
	viewport.Position = UDim2.fromOffset(10, 62)
	viewport.Size = UDim2.new(1, -20, 0, VP_H)
	viewport.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	viewport.BorderSizePixel = 0
	viewport.ClipsDescendants = true
	viewport.Parent = listFrame
	round(viewport, 6)

	local pool = {}
	for i = 1, VIS do
		local btn = Instance.new("TextButton")
		btn.Position = UDim2.fromOffset(3, 1 + (i - 1) * ROW_H)
		btn.Size = UDim2.fromOffset(ROWS_W, ROW_H - 3)
		btn.BackgroundColor3 = Color3.fromRGB(44, 44, 54)
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.Visible = false
		btn.Parent = viewport
		round(btn, 4)
		local sw = Instance.new("Frame")
		sw.Position = UDim2.fromOffset(4, 4)
		sw.Size = UDim2.fromOffset(30, ROW_H - 11)
		sw.BorderSizePixel = 0
		sw.Parent = btn
		round(sw, 4)
		local ttl = label("", UDim2.fromOffset(40, 3), UDim2.fromOffset(ROWS_W - 74, 17), btn, 12)
		ttl.Font = Enum.Font.GothamBold
		ttl.TextTruncate = Enum.TextTruncate.AtEnd
		local inf = label("", UDim2.fromOffset(40, 20), UDim2.fromOffset(ROWS_W - 74, 13), btn, 11)
		inf.TextColor3 = Color3.fromRGB(170, 170, 180)
		local star = Instance.new("TextButton")
		star.Position = UDim2.fromOffset(ROWS_W - 30, 3)
		star.Size = UDim2.fromOffset(26, ROW_H - 9)
		star.BackgroundTransparency = 1
		star.BorderSizePixel = 0
		star.Text = "☆"
		star.TextSize = 22
		star.Font = Enum.Font.SourceSansBold
		star.TextColor3 = Color3.fromRGB(150, 150, 160)
		star.AutoButtonColor = false
		star.Parent = btn
		pool[i] = { btn = btn, swatch = sw, title = ttl, info = inf, star = star }
	end

	-- своя полоса прокрутки: список слишком длинный для обычного ScrollingFrame
	local track = Instance.new("TextButton")
	track.Position = UDim2.new(1, -13, 0, 2)
	track.Size = UDim2.new(0, 10, 1, -4)
	track.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
	track.BorderSizePixel = 0
	track.Text = ""
	track.AutoButtonColor = false
	track.Parent = viewport
	round(track, 5)
	local thumb = Instance.new("TextButton")
	thumb.Size = UDim2.new(1, 0, 0, 20)
	thumb.BackgroundColor3 = Color3.fromRGB(90, 110, 180)
	thumb.BorderSizePixel = 0
	thumb.Text = ""
	thumb.AutoButtonColor = false
	thumb.Parent = track
	round(thumb, 5)

	local pickSw = Instance.new("Frame")
	pickSw.Position = UDim2.fromOffset(10, 306)
	pickSw.Size = UDim2.fromOffset(36, 36)
	pickSw.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	pickSw.BorderSizePixel = 0
	pickSw.Parent = listFrame
	round(pickSw, 4)
	local pickLbl = label("", UDim2.fromOffset(52, 304), UDim2.fromOffset(152, 40), listFrame, 11)
	pickLbl.TextWrapped = true
	local listApplyBtn = button(t("listApply"), UDim2.fromOffset(212, 308), UDim2.fromOffset(78, 32), listFrame, Color3.fromRGB(70, 140, 90))
	regTranslatable(listApplyBtn, "listApply")
	local favSaveBtn = button(t("favSaveCur"), UDim2.fromOffset(10, 354), UDim2.new(1, -20, 0, 28), listFrame, Color3.fromRGB(150, 120, 40))
	regTranslatable(favSaveBtn, "favSaveCur")

	-- данные списка: ваши цвета, двуязычная таблица, цвета Roblox (BrickColor), затем цвета с get-color.ru
	local LIST = {}
	local function pushEntry(en, ru, rgb)
		table.insert(LIST, { en = en, ru = ru, r = rgb[1], g = rgb[2], b = rgb[3] })
	end
	for name, rgb in pairs(CUSTOM) do pushEntry(name, "—", rgb) end
	for _, e in ipairs(PALETTE) do pushEntry(e[1], e[2], hex(e[3])) end
	pcall(function()
		local seen = {}
		for i = 1, 1100 do
			local ok, bc = pcall(BrickColor.new, i)
			if ok and bc and bc.Number == i and not seen[bc.Name] then
				seen[bc.Name] = true
				local c = bc.Color
				local rgb = { to255(c.R), to255(c.G), to255(c.B) }
				local own = CODES[norm(bc.Name)]
				local shown = bc.Name
				if own and (own[1] ~= rgb[1] or own[2] ~= rgb[2] or own[3] ~= rgb[3]) then
					shown = bc.Name .. " [Roblox]"
					addCode(bc.Name .. " Roblox", rgb)
				end
				pushEntry(shown, "—", rgb)
			end
		end
	end)
	for _, e in ipairs(SITE) do table.insert(LIST, e) end

	local function prettyEn(s) return (string.gsub(s, "(%l)(%u)", "%1 %2")) end
	local function entryTitle(e)
		local en = e.raw and e.en or prettyEn(e.en) -- у названий с сайта пробелы уже расставлены
		if e.ru and e.ru ~= "—" then
			if en == "" then return e.ru end
			return e.ru .. "  ·  " .. en
		end
		return en
	end
	local function entryKey(e)
		local en = e.raw and e.en or prettyEn(e.en)
		return norm(en .. ((e.ru and e.ru ~= "—") and e.ru or "")) .. ("%02x%02x%02x"):format(e.r, e.g, e.b)
	end

	local keys, keysBuilt = {}, false
	local view = nil       -- nil = показывать все, иначе массив индексов найденных
	local total = #LIST
	local top = 1          -- номер первой видимой позиции
	local selected
	local rowItem = {}

	-- ===== избранное: хранится в файле (если executor умеет writefile), иначе только до перезапуска =====
	local FAV_FILE = "chroma_favorites.txt"
	local favs, favSet, favEntry = {}, {}, {} -- порядок добавления, ключ -> true, ключ -> запись списка
	local favOnly = false
	local function favKey(e)
		return ("%02X%02X%02X"):format(e.r, e.g, e.b) .. "|" .. (e.en or "") .. "|" .. (e.ru or "")
	end
	local function saveFavs()
		if not writefile then return end
		pcall(writefile, FAV_FILE, table.concat(favs, "\n"))
	end
	local function loadFavs()
		if not (readfile and isfile) then return end
		local okF, txt = pcall(function() return isfile(FAV_FILE) and readfile(FAV_FILE) or nil end)
		if not okF or not txt then return end
		local byKey = {}
		for _, e in ipairs(LIST) do byKey[favKey(e)] = e end
		for line in string.gmatch(txt, "[^\n]+") do
			local hs, en, ru = string.match(line, "^(%x%x%x%x%x%x)|(.-)|(.*)$")
			if hs and not favSet[line] then
				local e = byKey[line]
				if not e then
					local hv = tonumber(hs, 16)
					e = { en = en, ru = ru, r = hv // 65536, g = (hv // 256) % 256, b = hv % 256, raw = true }
					table.insert(LIST, e)
				end
				favSet[line] = true
				favEntry[line] = e
				table.insert(favs, line)
			end
		end
	end
	loadFavs()
	local function isFav(e) return favSet[favKey(e)] == true end

	local function maxTop() return math.max(1, total - VIS + 1) end

	local function refreshList()
		total = view and #view or #LIST
		top = math.clamp(top, 1, maxTop())
		for i = 1, VIS do
			local row = pool[i]
			local pos = top + i - 1
			if pos <= total then
				local e = LIST[view and view[pos] or pos]
				rowItem[i] = e
				row.btn.Visible = true
				row.swatch.BackgroundColor3 = Color3.fromRGB(e.r, e.g, e.b)
				row.title.Text = entryTitle(e)
				row.info.Text = ("#%02X%02X%02X  ·  RGB %d, %d, %d"):format(e.r, e.g, e.b, e.r, e.g, e.b)
				row.btn.BackgroundColor3 = (e == selected) and Color3.fromRGB(80, 100, 170) or Color3.fromRGB(44, 44, 54)
				local fav = isFav(e)
				row.star.Text = fav and "★" or "☆"
				row.star.TextColor3 = fav and Color3.fromRGB(255, 205, 60) or Color3.fromRGB(150, 150, 160)
			else
				rowItem[i] = nil
				row.btn.Visible = false
			end
		end
		local trackH = VP_H - 4
		if total > VIS then
			local th = math.max(20, trackH * VIS / total)
			thumb.Visible = true
			thumb.Size = UDim2.new(1, 0, 0, th)
			thumb.Position = UDim2.fromOffset(0, (top - 1) / (maxTop() - 1) * (trackH - th))
		else
			thumb.Visible = false
		end
		countLbl.Text = total .. " / " .. #LIST
		if refreshFavBar then refreshFavBar() end
	end

	local function selectEntry(e)
		if not e then return end
		selected = e
		-- сначала цвет попадает в поля R/G/B (и в активный слот примерки), применить можно кнопкой
		rBox.Text, gBox.Text, bBox.Text = tostring(e.r), tostring(e.g), tostring(e.b)
		pickSw.BackgroundColor3 = Color3.fromRGB(e.r, e.g, e.b)
		pickLbl.Text = string.format(t("listPicked"), entryTitle(e)) .. "\n" .. ("#%02X%02X%02X"):format(e.r, e.g, e.b)
		refreshList()
	end
	for i = 1, VIS do
		connect(pool[i].btn, "MouseButton1Click", function() selectEntry(rowItem[i]) end)
	end

	local applyFilter
	local function setFav(e, on)
		local k = favKey(e)
		if on and not favSet[k] then
			favSet[k] = true
			favEntry[k] = e
			table.insert(favs, k)
		elseif not on and favSet[k] then
			favSet[k] = nil
			favEntry[k] = nil
			for idx = #favs, 1, -1 do
				if favs[idx] == k then table.remove(favs, idx) end
			end
		end
		saveFavs()
	end
	for i = 1, VIS do
		connect(pool[i].star, "MouseButton1Click", function()
			local e = rowItem[i]
			if not e then return end
			setFav(e, not isFav(e))
			if favOnly then
				local keepTop = top
				applyFilter()
				top = keepTop
			end
			refreshList()
		end)
	end

	-- вызывается при открытии панели: один раз готовит ключи поиска
	local function buildRows()
		if not keysBuilt then
			keysBuilt = true
			for i, e in ipairs(LIST) do keys[i] = entryKey(e) end
		end
		refreshList()
	end

	-- поиск по названию или HEX (с небольшой задержкой, чтобы не искать на каждую букву)
	local searchToken = 0
	function applyFilter()
		if not keysBuilt then return end
		local q = norm((string.gsub(searchBox.Text, "#", "")))
		if q == "" and not favOnly then
			view = nil
		else
			local res, n = {}, 0
			for i = 1, #LIST do
				if (not favOnly or isFav(LIST[i])) and (q == "" or string.find(keys[i], q, 1, true)) then
					n = n + 1
					res[n] = i
				end
			end
			view = res
		end
		top = 1
		refreshList()
	end
	connect(searchBox, "GetPropertyChangedSignal", function()
		searchToken = searchToken + 1
		local my = searchToken
		task.delay(0.2, function()
			if my == searchToken then applyFilter() end
		end)
	end, "Text")

	-- прокрутка: колесо мыши над списком, перетаскивание ползунка, клик по полосе
	local thumbDrag, dragOff = false, 0
	connect(thumb, "InputBegan", function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			thumbDrag = true
			dragOff = guiMouse().Y - thumb.AbsolutePosition.Y
		end
	end)
	connect(track, "InputBegan", function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		local my = guiMouse().Y
		local ty = thumb.AbsolutePosition.Y
		if my >= ty and my <= ty + thumb.AbsoluteSize.Y then return end -- попали в сам ползунок
		top = top + ((my < ty) and -VIS or VIS)
		refreshList()
	end)
	connect(UIS, "InputEnded", function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then thumbDrag = false end
	end)

	local function mouseOverList()
		if not (listFrame.Visible and frame.Visible and gui.Enabled) then return false end
		local m = guiMouse()
		local p, s = viewport.AbsolutePosition, viewport.AbsoluteSize
		return m.X >= p.X and m.X <= p.X + s.X and m.Y >= p.Y and m.Y <= p.Y + s.Y
	end

	connect(UIS, "InputChanged", function(i)
		if not listFrame.Visible then return end
		if i.UserInputType == Enum.UserInputType.MouseMovement then
			if thumbDrag and total > VIS then
				local trackH = VP_H - 4
				local th = thumb.AbsoluteSize.Y
				local y = guiMouse().Y - dragOff - track.AbsolutePosition.Y
				local frac = math.clamp(y / (trackH - th), 0, 1)
				top = math.floor(1 + frac * (maxTop() - 1) + 0.5)
				refreshList()
			end
		elseif i.UserInputType == Enum.UserInputType.MouseWheel then
			if mouseOverList() then
				top = top - ((i.Position.Z > 0) and 3 or -3)
				refreshList()
			end
		end
	end)

	-- пока курсор над списком, колесо не должно приближать камеру игры
	local CAS = game:GetService("ContextActionService")
	local function setWheelBinding(on)
		pcall(function() CAS:UnbindAction("ColorListWheel") end)
		if on then
			pcall(function()
				CAS:BindActionAtPriority("ColorListWheel", function()
					if mouseOverList() then return Enum.ContextActionResult.Sink end
					return Enum.ContextActionResult.Pass
				end, false, Enum.ContextActionPriority.High.Value, Enum.UserInputType.MouseWheel)
			end)
		end
	end
	closeLibFn = function() setWheelBinding(false) end
	connect(listFrame, "GetPropertyChangedSignal", function() setWheelBinding(listFrame.Visible) end, "Visible")

	connect(listApplyBtn, "MouseButton1Click", function()
		if not selected then say(t("listNone"), false, 4) return end
		applyToGame(selected.r, selected.g, selected.b, entryTitle(selected))
	end)

	connect(favFilterBtn, "MouseButton1Click", function()
		favOnly = not favOnly
		favFilterBtn.BackgroundColor3 = favOnly and Color3.fromRGB(220, 170, 40) or Color3.fromRGB(150, 120, 40)
		if not keysBuilt then buildRows() end
		applyFilter()
		if favOnly and #favs == 0 then say(t("msgFavEmpty"), false, 4) end
	end)

	-- сохранить произвольный цвет (из полей R/G/B или из слота примерки) как «Мой цвет #HEX»
	function addFavFn(r, g, b)
		r, g, b = math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)
		local probe = { r = r, g = g, b = b, en = "", ru = "" }
		local hs = ("#%02X%02X%02X"):format(r, g, b)
		probe.ru, probe.en = t("myColor") .. " " .. hs, ""
		local existing
		for _, e in ipairs(LIST) do
			if e.raw and e.en == probe.en and e.ru == probe.ru then existing = e break end
		end
		local e = existing or { en = "", ru = probe.ru, r = r, g = g, b = b, raw = true }
		if isFav(e) then say(t("msgFavHave"), false, 3) return end
		if not existing then
			table.insert(LIST, e)
			if keysBuilt then keys[#LIST] = entryKey(e) end
		end
		setFav(e, true)
		say(string.format(t("msgFavAdded"), hs), true, 3)
		if keysBuilt then applyFilter() else refreshList() end
	end
	connect(favSaveBtn, "MouseButton1Click", function()
		addFavFn(tonumber(rBox.Text) or 0, tonumber(gBox.Text) or 0, tonumber(bBox.Text) or 0)
	end)
	connect(favBarAdd, "MouseButton1Click", function()
		local c = slotColors[activeSlot]
		addFavFn(to255(c.R), to255(c.G), to255(c.B))
	end)

	function refreshFavBar()
		for i = 1, 6 do
			local e = favEntry[favs[#favs - i + 1] or ""]
			local btn = favBarBtns[i]
			if e then
				favBarColor[i] = { e.r, e.g, e.b }
				btn.BackgroundColor3 = Color3.fromRGB(e.r, e.g, e.b)
				btn.Text = ""
			else
				favBarColor[i] = nil
				btn.BackgroundColor3 = Color3.fromRGB(44, 44, 54)
				btn.Text = "☆"
			end
		end
	end

	refreshList()
	refreshFavBar()

	-- ===== режимы под слотами «Примерки»: «+ Похожие» / «+ Рандом» (только включить; запуск и настройки - в 🎲) =====
	;(function()
		local btnSim = button("", UDim2.fromOffset(10, 234), UDim2.fromOffset(136, 28), tryFrame, Color3.fromRGB(110, 70, 70))
		btnSim.TextSize = 11
		local btnRnd = button("", UDim2.fromOffset(154, 234), UDim2.fromOffset(136, 28), tryFrame, Color3.fromRGB(110, 70, 70))
		btnRnd.TextSize = 11

		local function slotOrder() return (tryMode == 3) and { 1, 2, 3, 4 } or { 1, 2, 4 } end

		-- какие слоты можно менять: отмечены [x] в панели 🎲 (остальные не трогаем)
		PAL.changeable = function()
			local cfg = PAL.cfg and PAL.cfg[curCat]
			local out = {}
			for _, i in ipairs(slotOrder()) do
				if not cfg or cfg.slots[i] then table.insert(out, i) end
			end
			return out
		end

		-- каждому цвету списка один раз считается точка в «конусе» HSV: близкие точки = близкие на вид цвета
		local function cone(e)
			if not e.cz then
				local h, sat, v = Color3.fromRGB(e.r, e.g, e.b):ToHSV()
				local a2 = h * math.pi * 2
				e.cx, e.cy, e.cz = math.cos(a2) * sat * v, math.sin(a2) * sat * v, v
			end
			return e.cx, e.cy, e.cz
		end
		local function pointOf(h, sat, v)
			local a2 = h * math.pi * 2
			return math.cos(a2) * sat * v, math.sin(a2) * sat * v, v
		end
		-- K ближайших к точке цветов из ВСЕГО списка, из них выбирается случайный
		local function nearestK(used, K, tx, ty, tz)
			local top = {}
			for i = 1, #LIST do
				local e = LIST[i]
				if not used[e] then
					local x, y, z = cone(e)
					local d = (x - tx) ^ 2 + (y - ty) ^ 2 + (z - tz) ^ 2
					if #top < K or d < top[#top].d then
						local pos = #top + 1
						while pos > 1 and top[pos - 1].d > d do pos -= 1 end
						table.insert(top, pos, { d = d, e = e })
						if #top > K then table.remove(top) end
					end
				end
			end
			if #top == 0 then return nil end
			return top[math.random(1, #top)].e
		end

		-- «Похожие»: образец - цвет, который вы задали последним (иначе Цвет 1). Похожие на него цвета ищутся
		-- в ВСЁМ списке и ставятся только в слоты, отмеченные [x] в 🎲. Три стиля: near / light / mix.
		PAL.genSimilar = function()
			local order = slotOrder()
			local ch = PAL.changeable()
			if #ch == 0 then return false end
			local chSet, posOf = {}, {}
			for _, i in ipairs(ch) do chSet[i] = true end
			for p, i in ipairs(order) do posOf[i] = p end
			local sSlot = PAL.sampleSlot
			if not (sSlot and posOf[sSlot]) then sSlot = 1 end
			local base = PAL.sample or slotColors[sSlot]
			local h, sat, v = base:ToHSV()
			local neutral = sat < 0.12
			local used = {}
			local pool = { 0.02, -0.02, 0.045, -0.045, 0.07, -0.07 }
			for k = #pool, 2, -1 do
				local j = math.random(1, k)
				pool[k], pool[j] = pool[j], pool[k]
			end
			local pk = 0
			local function near(ds, dv, K)
				pk += 1
				local hh = neutral and math.random() or ((h + pool[((pk - 1) % #pool) + 1] + 1) % 1)
				local ss = neutral and sat or math.clamp(sat * ds, 0.04, 1)
				local vv = math.clamp(v * dv, 0.08, 1)
				local e = nearestK(used, K or 6, pointOf(hh, ss, vv))
				if e then used[e] = true end
				return e
			end
			local function dark()
				local e = nearestK(used, 5, pointOf(h, neutral and 0 or sat * 0.8, math.max(0.08, v * 0.3)))
				if e then used[e] = true end
				return e
			end
			local function put(i, e)
				if e then slotColors[i] = Color3.fromRGB(e.r, e.g, e.b) end
			end
			local function jit() return 0.9 + 0.2 * math.random() end

			local style = PAL.style
			if style == "light" then
				-- Цвет 1 ярче образца, Цвет 2 темнее, Цвет 3 ещё темнее, контур тёмный; все цвета из списка
				local f = { 1.2, 0.72, 0.5 }
				for _, i in ipairs(order) do
					if chSet[i] then
						if i == 4 then
							put(4, dark())
						else
							local fct = f[i] or 0.5
							put(i, near(fct > 1 and 0.9 or 1.05, fct, 5))
						end
					end
				end
			elseif style == "mix" then
				-- образец и похожие цвета раскладываются по слотам в случайном порядке
				local slots = {}
				for _, i in ipairs(order) do
					if i ~= 4 and chSet[i] then table.insert(slots, i) end
				end
				local cols = {}
				if chSet[sSlot] and sSlot ~= 4 then table.insert(cols, base) end
				for _ = #cols + 1, #slots do
					local e = near(jit(), jit(), 8)
					if e then table.insert(cols, Color3.fromRGB(e.r, e.g, e.b)) end
				end
				for k = #cols, 2, -1 do
					local j = math.random(1, k)
					cols[k], cols[j] = cols[j], cols[k]
				end
				for k, i in ipairs(slots) do
					if cols[k] then slotColors[i] = cols[k] end
				end
				if chSet[4] then put(4, dark()) end
			else
				-- рядом: образец остаётся на своём слоте, похожие идут в следующие слоты по кругу
				if chSet[sSlot] then slotColors[sSlot] = base end
				local n, p0 = #order, posOf[sSlot]
				for d = 1, n - 1 do
					local i = order[((p0 - 1 + d) % n) + 1]
					if chSet[i] then
						if i == 4 then put(4, dark()) else put(i, near(jit(), jit(), 6)) end
					end
				end
			end
			selectSlot(activeSlot)
			return true
		end

		-- «Рандом»: случайная палитра из ВСЕГО списка только для меняемых слотов; цвета не слишком похожи друг на друга
		PAL.roll = function()
			if #LIST == 0 then return false end
			local ch = PAL.changeable()
			if #ch == 0 then return false end
			local chSet = {}
			for _, i in ipairs(ch) do chSet[i] = true end
			local picks = {}
			for _, i in ipairs(slotOrder()) do
				if i ~= 4 and not chSet[i] then
					local c = slotColors[i]
					table.insert(picks, { r = to255(c.R), g = to255(c.G), b = to255(c.B) })
				end
			end
			local function far(e)
				for _, p in ipairs(picks) do
					local dr, dg, db = e.r - p.r, e.g - p.g, e.b - p.b
					if dr * dr + dg * dg + db * db < 3600 then return false end
				end
				return true
			end
			for _, i in ipairs(ch) do
				local e
				for _ = 1, 80 do
					local c = LIST[math.random(1, #LIST)]
					if i == 4 then
						if not PAL.darkOutline or math.max(c.r, c.g, c.b) < 90 then e = c break end
					elseif far(c) then
						e = c break
					end
				end
				e = e or LIST[math.random(1, #LIST)]
				if i ~= 4 then table.insert(picks, e) end
				slotColors[i] = Color3.fromRGB(e.r, e.g, e.b)
			end
			selectSlot(activeSlot)
			return true
		end

		-- новая палитра по включённому режиму (если режим не включён - случайная)
		PAL.gen = function(mode)
			if (mode or PAL.mode) == "similar" then return PAL.genSimilar() end
			return PAL.roll()
		end

		PAL.refresh = function()
			local sim, rnd = (PAL.mode == "similar"), (PAL.mode == "random")
			btnSim.Text = t(sim and "palSimOn" or "palSimOff")
			btnSim.BackgroundColor3 = sim and Color3.fromRGB(70, 140, 90) or Color3.fromRGB(110, 70, 70)
			btnRnd.Text = t(rnd and "palRndOn" or "palRndOff")
			btnRnd.BackgroundColor3 = rnd and Color3.fromRGB(70, 140, 90) or Color3.fromRGB(110, 70, 70)
		end

		local function setMode(m)
			-- повторное нажатие выключает; режимы друг друга исключают
			-- (запись «x and nil or m» в Lua не работает: nil считается ложью, и режим всегда оставался бы включённым)
			if PAL.mode == m then
				PAL.mode = nil
			else
				PAL.mode = m
			end
			PAL.refresh()
			if refreshAuto then refreshAuto() end
		end
		connect(btnSim, "MouseButton1Click", function() setMode("similar") end)
		connect(btnRnd, "MouseButton1Click", function() setMode("random") end)
		PAL.refresh()
	end)()

	-- ===== «Разметка предметов»: вы сами показываете, какие предметы игры считать кофтой, штанами и т.д. =====
	local refreshLearn
	local learnFrame = Instance.new("Frame")
	learnFrame.Size = UDim2.fromOffset(300, 366)
	learnFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	learnFrame.BorderSizePixel = 0
	learnFrame.Active = true
	learnFrame.Visible = false
	learnFrame.Parent = frame
	round(learnFrame, 8)

	local learnTitle = label(t("learnTitle"), UDim2.fromOffset(10, 6), UDim2.fromOffset(280, 18), learnFrame, 12)
	regTranslatable(learnTitle, "learnTitle")
	local learnAutoBtn = button("", UDim2.fromOffset(10, 28), UDim2.fromOffset(280, 26), learnFrame, Color3.fromRGB(60, 120, 100))
	local learnHint = label(t("learnHint"), UDim2.fromOffset(10, 58), UDim2.fromOffset(280, 40), learnFrame, 10)
	learnHint.TextWrapped = true
	learnHint.TextColor3 = Color3.fromRGB(160, 160, 170)
	regTranslatable(learnHint, "learnHint")

	local CAT_FILE = "chroma_categories.txt"
	local catSets = {}                 -- категория -> { [ключ названия] = показанное название }
	for _, c in ipairs(CATS) do catSets[c] = {} end
	local learningCat, learnTmp = nil, {}
	local learnAuto = true
	local learnRows = {}

	local function saveCats()
		if not writefile then return end
		local out = {}
		for _, c in ipairs(CATS) do
			for k, nm in pairs(catSets[c]) do table.insert(out, c .. "|" .. k .. "|" .. nm) end
		end
		pcall(writefile, CAT_FILE, table.concat(out, "\n"))
	end
	local function loadCats()
		if not (readfile and isfile) then return end
		local okF, txt = pcall(function() return isfile(CAT_FILE) and readfile(CAT_FILE) or nil end)
		if not okF or not txt then return end
		for line in string.gmatch(txt, "[^\n]+") do
			local c, k, nm = string.match(line, "^(%a+)|([^|]+)|(.*)$")
			if c and catSets[c] then catSets[c][k] = nm end
		end
	end
	loadCats()

	-- вкладки меню игры (👤 / 👕 0 / 👕 1): запоминаем, на какой вкладке лежит отмеченный предмет
	local TABS = { file = "chroma_tabs.txt", item = {}, last = nil, tmp = {} }
	function TABS.nm(n) return (string.gsub(n, "[/#|]", "_")) end
	function TABS.path(b)
		local parts, cur = {}, b
		while cur and cur ~= pg do
			local idx, par = 1, cur.Parent
			if par then
				for i2, ch in ipairs(par:GetChildren()) do
					if ch == cur then idx = i2 break end
				end
			end
			table.insert(parts, 1, TABS.nm(cur.Name) .. "#" .. idx)
			cur = par
		end
		if cur ~= pg then return nil end
		return table.concat(parts, "/")
	end
	function TABS.resolve(path)
		local cur = pg
		for seg in string.gmatch(path, "[^/]+") do
			local nm, idx = string.match(seg, "^(.*)#(%d+)$")
			if not nm then return nil end
			local kids = cur:GetChildren()
			local ch = kids[tonumber(idx)]
			if not (ch and TABS.nm(ch.Name) == nm) then
				ch = nil
				for _, k in ipairs(kids) do
					if TABS.nm(k.Name) == nm then ch = k break end
				end
			end
			if not ch then return nil end
			cur = ch
		end
		return (cur ~= pg and cur:IsA("GuiButton")) and cur or nil
	end
	function TABS.save()
		if not writefile then return end
		local out = {}
		for k, pth in pairs(TABS.item) do table.insert(out, k .. "|" .. pth) end
		pcall(writefile, TABS.file, table.concat(out, "\n"))
	end
	if readfile and isfile then
		local okF, txt = pcall(function() return isfile(TABS.file) and readfile(TABS.file) or nil end)
		if okF and txt then
			for line in string.gmatch(txt, "[^\n]+") do
				local k, pth = string.match(line, "^([^|]+)|(.+)$")
				if k then TABS.item[k] = pth end
			end
		end
	end

	local function countOf(tb)
		local n = 0
		for _ in pairs(tb) do n = n + 1 end
		return n
	end
	local function namesOf(tb)
		local arr = {}
		for _, nm in pairs(tb) do table.insert(arr, nm) end
		table.sort(arr)
		return table.concat(arr, ", ")
	end

	for i, c in ipairs(CATS) do
		local y = 104 + (i - 1) * 52
		local pick = button("", UDim2.fromOffset(10, y), UDim2.fromOffset(212, 26), learnFrame, Color3.fromRGB(50, 50, 62))
		local clr = button(t("learnReset"), UDim2.fromOffset(226, y), UDim2.fromOffset(64, 26), learnFrame, Color3.fromRGB(150, 90, 60))
		regTranslatable(clr, "learnReset")
		local nm = label("", UDim2.fromOffset(10, y + 28), UDim2.fromOffset(280, 16), learnFrame, 10)
		nm.TextColor3 = Color3.fromRGB(170, 170, 180)
		nm.TextTruncate = Enum.TextTruncate.AtEnd
		learnRows[c] = { pick = pick, clr = clr, names = nm }
	end

	function refreshLearn()
		learnAutoBtn.Text = t(learnAuto and "learnAutoOn" or "learnAutoOff")
		learnAutoBtn.BackgroundColor3 = learnAuto and Color3.fromRGB(60, 120, 100) or Color3.fromRGB(110, 70, 70)
		for _, c in ipairs(CATS) do
			local r = learnRows[c]
			if learningCat == c then
				r.pick.Text = string.format(t("learnDone"), t(CAT_FULL[c]))
				r.pick.BackgroundColor3 = Color3.fromRGB(70, 140, 90)
				r.names.Text = namesOf(learnTmp)
			else
				r.pick.Text = string.format(t("learnPick"), t(CAT_FULL[c]), countOf(catSets[c]))
				r.pick.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
				r.names.Text = namesOf(catSets[c])
			end
		end
		if refreshAuto then refreshAuto() end
	end

	local function catOf(key)
		for _, c in ipairs(CATS) do
			if catSets[c][key] then return c end
		end
		return nil
	end

	connect(learnAutoBtn, "MouseButton1Click", function()
		learnAuto = not learnAuto
		refreshLearn()
	end)
	for _, c in ipairs(CATS) do
		local r = learnRows[c]
		connect(r.pick, "MouseButton1Click", function()
			if learningCat == nil then
				learningCat, learnTmp = c, {}
				TABS.tmp, TABS.last = {}, nil
				say(t("msgLearnStart"), true, 6)
			elseif learningCat == c then
				for k, nm in pairs(learnTmp) do
					for _, cc in ipairs(CATS) do catSets[cc][k] = nil end -- у предмета только одна категория
					catSets[c][k] = nm
					if TABS.tmp[k] then TABS.item[k] = TABS.tmp[k] end
				end
				local n = countOf(learnTmp)
				learningCat, learnTmp = nil, {}
				TABS.tmp, TABS.last = {}, nil
				saveCats()
				TABS.save()
				say(string.format(t("msgLearnSaved"), n), true, 4)
			else
				say(t("msgLearnBusy"), false, 5)
			end
			refreshLearn()
		end)
		connect(r.clr, "MouseButton1Click", function()
			if learningCat == c then
				learnTmp = {}
			elseif learningCat ~= nil then
				say(t("msgLearnBusy"), false, 5)
				return
			else
				catSets[c] = {}
				saveCats()
				say(string.format(t("msgLearnCleared"), t(CAT_FULL[c])), true, 3)
			end
			refreshLearn()
		end)
	end

	-- название предмета под курсором: ближайшая кнопка-плитка и самая длинная подпись на ней (не число и не «?»)
	-- кнопка под курсором (в том числе без названия, например вкладка меню с иконкой)
	function TABS.navUnder(pos)
		local okG, objs = pcall(function() return pg:GetGuiObjectsAtPosition(pos.X, pos.Y) end)
		if not okG then return nil end
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
		for _, o in ipairs(objs) do
			if not o:IsDescendantOf(gui) then
				local b = o
				while b and b ~= pg and not b:IsA("GuiButton") do b = b.Parent end
				if b and b ~= pg and b:IsA("GuiButton") and b.AbsoluteSize.X < vp.X * 0.35 and b.AbsoluteSize.Y < vp.Y * 0.35 then
					return b
				end
			end
		end
		return nil
	end

	local function tileUnder(pos)
		local okG, objs = pcall(function() return pg:GetGuiObjectsAtPosition(pos.X, pos.Y) end)
		if not okG then return nil end
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
		for _, o in ipairs(objs) do
			if not o:IsDescendantOf(gui) then
				local tile = o
				while tile and tile ~= pg and not tile:IsA("GuiButton") do tile = tile.Parent end
				if tile and tile ~= pg and tile:IsA("GuiButton")
					and tile.AbsoluteSize.X < vp.X * 0.35 and tile.AbsoluteSize.Y < vp.Y * 0.35 then
					local bestKey, bestName
					local function consider(d)
						if (d:IsA("TextLabel") or d:IsA("TextButton")) and isShown(d) then
							local raw = (string.gsub(d.Text, "%s+", " "))
							if string.find(raw, "[^%d%?%s]") then
								local k = norm(raw)
								if k ~= "" and (not bestKey or #k > #bestKey) then bestKey, bestName = k, (string.gsub(raw, "^%s+", "")) end
							end
						end
					end
					consider(tile)
					for _, d in ipairs(tile:GetDescendants()) do consider(d) end
					if bestKey then return bestKey, string.gsub(bestName, "|", "/") end
				end
			end
		end
		return nil
	end

	connect(UIS, "InputBegan", function(i)
		local ut = i.UserInputType
		if ut ~= Enum.UserInputType.MouseButton1 and ut ~= Enum.UserInputType.Touch then return end
		if not (learningCat or learnAuto) then return end
		local pos = (ut == Enum.UserInputType.Touch) and (Vector2.new(i.Position.X, i.Position.Y) - game:GetService("GuiService"):GetGuiInset()) or guiMouse()
		for _, pn in ipairs({ frame, wheelFrame, tryFrame, autoFrame, learnFrame, listFrame, instrFrame }) do
			if pn and pn.Visible then
				local a, sz = pn.AbsolutePosition, pn.AbsoluteSize
				if pos.X >= a.X and pos.X <= a.X + sz.X and pos.Y >= a.Y and pos.Y <= a.Y + sz.Y then return end
			end
		end
		local key, name = tileUnder(pos)
		if learningCat then
			if not key then
				-- клик не по плитке с названием: это может быть вкладка меню игры - запоминаем её для следующих предметов
				local nb = TABS.navUnder(pos)
				local pth = nb and TABS.path(nb)
				if pth then
					TABS.last = pth
					say(t("msgLearnTab"), true, 3)
				end
				return
			end
			key = (string.gsub(key, "|", "/"))
			if learnTmp[key] then
				learnTmp[key] = nil
				TABS.tmp[key] = nil
				say(string.format(t("msgLearnUnmark"), name), true, 2)
			else
				learnTmp[key] = name
				TABS.tmp[key] = TABS.last
				say(string.format(t("msgLearnMark"), name), true, 2)
			end
			refreshLearn()
		elseif key then
			local cat = catOf((string.gsub(key, "|", "/")))
			if cat and cat ~= curCat then
				setCategory(cat)
				say(string.format(t("msgLearnAuto"), t(CAT_FULL[cat])), true, 3)
			end
		end
	end)
	refreshLearn()

	-- ===== «Авто и рандом»: рандомайзер слотов, умный пропуск, обход предметов =====
	;(function()
	local myGui = gui
	local randCfg = {} -- настройки у каждой категории свои
	for _, c in ipairs(CATS) do randCfg[c] = { on = false, slots = { true, true, true, true } } end
	local walkDelay = 0.6
	PAL.cfg = randCfg -- «Рандом всех» и «Похожие» читают отсюда, какие слоты менять

	autoFrame = Instance.new("Frame")
	autoFrame.Size = UDim2.fromOffset(220, 500)
	autoFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	autoFrame.BorderSizePixel = 0
	autoFrame.Active = true
	autoFrame.Visible = false
	autoFrame.Parent = frame
	round(autoFrame, 8)

	local autoTitleLbl = label("", UDim2.fromOffset(10, 6), UDim2.new(1, -20, 0, 18), autoFrame, 12)
	local randToggle = button("", UDim2.fromOffset(10, 30), UDim2.new(1, -20, 0, 26), autoFrame)
	local swapLbl = label(t("swapLbl"), UDim2.fromOffset(10, 62), UDim2.new(1, -20, 0, 14), autoFrame, 11)
	regTranslatable(swapLbl, "swapLbl")
	local swapBtns = {}
	for i = 1, 4 do
		local b = button("", UDim2.fromOffset(10, 80), UDim2.fromOffset(96, 24), autoFrame, Color3.fromRGB(50, 50, 62))
		b.TextSize = 11
		swapBtns[i] = b
	end
	local shuffleBtn = button(t("shuffleNow"), UDim2.fromOffset(10, 136), UDim2.new(1, -20, 0, 26), autoFrame, Color3.fromRGB(140, 90, 160))
	regTranslatable(shuffleBtn, "shuffleNow")
	local rollBtn = button(t("palRollBtn"), UDim2.fromOffset(10, 166), UDim2.new(1, -20, 0, 26), autoFrame, Color3.fromRGB(140, 90, 160))
	regTranslatable(rollBtn, "palRollBtn")
	local sameBtn = button("", UDim2.fromOffset(10, 196), UDim2.new(1, -20, 0, 26), autoFrame)
	sameBtn.TextSize = 11
	local darkBtn = button("", UDim2.fromOffset(10, 226), UDim2.new(1, -20, 0, 26), autoFrame)
	darkBtn.TextSize = 11
	local styleBtn = button("", UDim2.fromOffset(10, 256), UDim2.new(1, -20, 0, 26), autoFrame)
	styleBtn.TextSize = 11
	local scopeBtn = button("", UDim2.fromOffset(10, 286), UDim2.new(1, -20, 0, 26), autoFrame, Color3.fromRGB(70, 90, 130))
	scopeBtn.TextSize = 11
	local smartBtn = button("", UDim2.fromOffset(10, 316), UDim2.new(1, -20, 0, 26), autoFrame)
	smartBtn.TextSize = 11
	local smartHint = label(t("smartHint"), UDim2.fromOffset(10, 346), UDim2.new(1, -20, 0, 40), autoFrame, 10)
	smartHint.TextWrapped = true
	smartHint.TextColor3 = Color3.fromRGB(160, 160, 170)
	regTranslatable(smartHint, "smartHint")
	local walkInfo = label("", UDim2.fromOffset(10, 390), UDim2.new(1, -20, 0, 14), autoFrame, 11)
	local dMinus = button("−", UDim2.fromOffset(10, 408), UDim2.fromOffset(28, 24), autoFrame, Color3.fromRGB(60, 60, 75))
	local delayLbl = label("", UDim2.fromOffset(42, 412), UDim2.fromOffset(136, 16), autoFrame, 11)
	delayLbl.TextXAlignment = Enum.TextXAlignment.Center
	local dPlus = button("+", UDim2.fromOffset(182, 408), UDim2.fromOffset(28, 24), autoFrame, Color3.fromRGB(60, 60, 75))
	local walkBtn = button("", UDim2.fromOffset(10, 438), UDim2.new(1, -20, 0, 30), autoFrame, Color3.fromRGB(70, 140, 90))
	local walkNote = label(t("walkNote"), UDim2.fromOffset(10, 472), UDim2.new(1, -20, 0, 24), autoFrame, 10)
	walkNote.TextWrapped = true
	walkNote.TextColor3 = Color3.fromRGB(160, 160, 170)
	regTranslatable(walkNote, "walkNote")

	local autoToggleBtn = button("🎲", UDim2.new(1, -66, 0, 4), UDim2.fromOffset(26, 22), tryFrame, Color3.fromRGB(140, 90, 160))

	refreshAuto = function()
		local cfg = randCfg[curCat]
		autoTitleLbl.Text = t("autoTitle") .. ": " .. t(CAT_KEY[curCat])
		randToggle.Text = t(cfg.on and "randOn" or "randOff")
		randToggle.BackgroundColor3 = cfg.on and Color3.fromRGB(70, 140, 90) or Color3.fromRGB(110, 70, 70)
		local order = (tryMode == 3) and { 1, 2, 3, 4 } or { 1, 2, 4 }
		for i = 1, 4 do swapBtns[i].Visible = false end
		for pos, i in ipairs(order) do
			local b = swapBtns[i]
			b.Visible = true
			b.Position = UDim2.fromOffset(10 + ((pos - 1) % 2) * 104, 80 + math.floor((pos - 1) / 2) * 28)
			b.Text = (cfg.slots[i] and "[x] " or "[  ] ") .. slotName(i)
			b.BackgroundColor3 = cfg.slots[i] and Color3.fromRGB(70, 100, 170) or Color3.fromRGB(50, 50, 62)
		end
		smartBtn.Text = t(smartSkip and "smartOn" or "smartOff")
		smartBtn.BackgroundColor3 = smartSkip and Color3.fromRGB(70, 140, 90) or Color3.fromRGB(110, 70, 70)
		sameBtn.Text = t(PAL.same and "palSameOn" or "palSameOff")
		sameBtn.BackgroundColor3 = PAL.same and Color3.fromRGB(70, 140, 90) or Color3.fromRGB(70, 90, 130)
		darkBtn.Text = t(PAL.darkOutline and "palDarkOn" or "palDarkOff")
		darkBtn.BackgroundColor3 = PAL.darkOutline and Color3.fromRGB(70, 140, 90) or Color3.fromRGB(110, 70, 70)
		walkInfo.Text = string.format(t("walkInfo"), countOf(catSets[curCat]))
		delayLbl.Text = string.format(t("delayLbl"), walkDelay)
		local mname = t(PAL.mode == "similar" and "palModeSim" or (PAL.mode == "random" and "palModeRnd" or "palModeNone"))
		walkBtn.Text = walking and t("walkStop") or string.format(t("palRunWith"), mname)
		styleBtn.Text = t(PAL.style == "light" and "palStyleLight" or (PAL.style == "mix" and "palStyleMix" or "palStyleNear"))
		scopeBtn.Text = t(PAL.scope == "all" and "palScopeAll" or "palScopeOne")
		walkBtn.BackgroundColor3 = walking and Color3.fromRGB(190, 70, 70) or Color3.fromRGB(70, 140, 90)
		if PAL.refresh then PAL.refresh() end
	end

	-- поменять местами цвета выбранных слотов (результат всегда отличается от прежнего, если это возможно)
	local function shuffleSlots()
		local cfg = randCfg[curCat]
		local order = (tryMode == 3) and { 1, 2, 3, 4 } or { 1, 2, 4 }
		local picked = {}
		for _, i in ipairs(order) do
			if cfg.slots[i] then table.insert(picked, i) end
		end
		if #picked < 2 then return false, "msgShuffleFew" end
		local vals = {}
		for k, i in ipairs(picked) do vals[k] = slotColors[i] end
		local function same(c1, c2)
			return to255(c1.R) == to255(c2.R) and to255(c1.G) == to255(c2.G) and to255(c1.B) == to255(c2.B)
		end
		local perm
		for _ = 1, 30 do
			local p = {}
			for k = 1, #picked do p[k] = k end
			for k = #p, 2, -1 do
				local j = math.random(1, k)
				p[k], p[j] = p[j], p[k]
			end
			for k = 1, #picked do
				if not same(vals[p[k]], vals[k]) then perm = p break end
			end
			if perm then break end
		end
		if not perm then return false, "msgShuffleSame" end
		for k, i in ipairs(picked) do slotColors[i] = vals[perm[k]] end
		selectSlot(activeSlot)
		return true
	end

	connect(randToggle, "MouseButton1Click", function()
		local cfg = randCfg[curCat]
		cfg.on = not cfg.on
		if cfg.on then
			local ok, why = shuffleSlots()
			if ok then say(t("msgShuffled"), true, 3) else say(t(why), false, 4) end
		end
		refreshAuto()
	end)
	connect(shuffleBtn, "MouseButton1Click", function()
		local ok, why = shuffleSlots()
		if ok then say(t("msgShuffled"), true, 3) else say(t(why), false, 4) end
	end)
	for i = 1, 4 do
		connect(swapBtns[i], "MouseButton1Click", function()
			local cfg = randCfg[curCat]
			cfg.slots[i] = not cfg.slots[i]
			refreshAuto()
		end)
	end
	connect(smartBtn, "MouseButton1Click", function()
		smartSkip = not smartSkip
		refreshAuto()
	end)
	connect(rollBtn, "MouseButton1Click", function()
		if walking or applyingAll then say(t("msgPalBusy"), false, 4) return end
		if PAL.gen and PAL.gen() then say(t("msgPalRolled"), true, 3) else say(t("msgPalNoSlots"), false, 5) end
	end)
	connect(sameBtn, "MouseButton1Click", function()
		PAL.same = not PAL.same
		refreshAuto()
	end)
	connect(darkBtn, "MouseButton1Click", function()
		PAL.darkOutline = not PAL.darkOutline
		refreshAuto()
	end)
	connect(styleBtn, "MouseButton1Click", function()
		PAL.style = (PAL.style == "near") and "light" or ((PAL.style == "light") and "mix" or "near")
		refreshAuto()
	end)
	connect(scopeBtn, "MouseButton1Click", function()
		PAL.scope = (PAL.scope == "all") and "one" or "all"
		refreshAuto()
	end)
	connect(dMinus, "MouseButton1Click", function()
		walkDelay = math.clamp(math.floor((walkDelay - 0.1) * 10 + 0.5) / 10, 0.2, 3)
		refreshAuto()
	end)
	connect(dPlus, "MouseButton1Click", function()
		walkDelay = math.clamp(math.floor((walkDelay + 0.1) * 10 + 0.5) / 10, 0.2, 3)
		refreshAuto()
	end)
	connect(autoToggleBtn, "MouseButton1Click", function()
		autoFrame.Visible = not autoFrame.Visible
		layoutSidePanels()
		refreshAuto()
	end)

	-- плитка предмета в меню игры по ключу из «Разметки предметов»
	local function findItemTile(key)
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
		for _, d in ipairs(pg:GetDescendants()) do
			if (d:IsA("TextButton") or d:IsA("TextLabel")) and not d:IsDescendantOf(gui) and isShown(d) then
				local k = (string.gsub(norm(d.Text), "|", "/"))
				if k == key then
					local tile = d
					while tile and tile ~= pg and not tile:IsA("GuiButton") do tile = tile.Parent end
					if tile and tile ~= pg and tile:IsA("GuiButton")
						and tile.AbsoluteSize.X < vp.X * 0.35 and tile.AbsoluteSize.Y < vp.Y * 0.35 then
						return tile
					end
				end
			end
		end
		return nil
	end

	-- если плитка спрятана прокруткой - прокрутить список к ней
	local function ensureVisible(tile)
		local sf = tile:FindFirstAncestorWhichIsA("ScrollingFrame")
		if not sf then return end
		pcall(function()
			local tp, tsz = tile.AbsolutePosition, tile.AbsoluteSize
			local sp, ssz = sf.AbsolutePosition, sf.AbsoluteSize
			local cp = sf.CanvasPosition
			local nx, ny = cp.X, cp.Y
			if tp.X < sp.X or tp.X + tsz.X > sp.X + ssz.X then
				nx = math.max(0, cp.X + (tp.X - sp.X) - (ssz.X - tsz.X) / 2)
			end
			if tp.Y < sp.Y or tp.Y + tsz.Y > sp.Y + ssz.Y then
				ny = math.max(0, cp.Y + (tp.Y - sp.Y) - (ssz.Y - tsz.Y) / 2)
			end
			sf.CanvasPosition = Vector2.new(nx, ny)
		end)
		task.wait(0.15)
	end

	-- прокручивает списки игры сверху вниз и ищет плитку (если игра рисует только видимые плитки)
	local function scrollSearch(key)
		local cands = {}
		for _, d in ipairs(pg:GetDescendants()) do
			if d:IsA("ScrollingFrame") and not d:IsDescendantOf(gui) and isShown(d) and d.AbsoluteSize.Y > 60 then
				local n = 0
				for _, b in ipairs(d:GetDescendants()) do
					if b:IsA("GuiButton") then
						n += 1
						if n >= 3 then break end
					end
				end
				if n >= 3 then table.insert(cands, d) end
			end
		end
		for _, sf in ipairs(cands) do
			if not walking then return nil end
			local maxY = math.max(0, sf.AbsoluteCanvasSize.Y - sf.AbsoluteWindowSize.Y)
			local startPos = sf.CanvasPosition
			local y = 0
			pcall(function() sf.CanvasPosition = Vector2.new(startPos.X, 0) end)
			task.wait(0.12)
			for _ = 1, 60 do
				local tile = findItemTile(key)
				if tile then return tile end
				if y >= maxY or not walking then break end
				y = math.min(maxY, y + math.max(60, sf.AbsoluteWindowSize.Y * 0.8))
				pcall(function() sf.CanvasPosition = Vector2.new(startPos.X, y) end)
				task.wait(0.12)
			end
		end
		return nil
	end

	-- ищем плитку: на экране -> на запомненной вкладке меню -> листая список
	local function locateTile(key)
		local tile = findItemTile(key)
		if tile then return tile end
		local pth = TABS.item[key]
		local tb = pth and TABS.resolve(pth)
		if tb then
			clickGui(tb)
			task.wait(math.max(0.4, walkDelay))
			tile = findItemTile(key)
			if tile then return tile end
		end
		return scrollSearch(key)
	end

	local function startWalk(mode)
		if walking then
			walking = false -- мягкая остановка: цикл завершится после текущего предмета
			return
		end
		if applyingAll then say(t("msgLearnBusy"), false, 4) return end
		if learningCat then say(t("msgLearnBusy"), false, 5) return end
		local cat = curCat
		if (mode == "random" or mode == "similar") and #PAL.changeable() == 0 then say(t("msgPalNoSlots"), false, 5) return end
		local items = {}
		for k, nm in pairs(catSets[cat]) do table.insert(items, { key = k, name = nm }) end
		table.sort(items, function(x, y)
			local tx, ty = TABS.item[x.key] or "", TABS.item[y.key] or ""
			if tx ~= ty then return tx < ty end -- сначала предметы одной вкладки, чтобы реже переключаться
			return x.name < y.name
		end)
		if #items == 0 then
			say(string.format(t("msgWalkNoItems"), t(CAT_FULL[cat])), false, 8)
			return
		end
		walking = true
		applyingAll = true
		refreshAuto()
		task.spawn(function()
			local painted, missed = 0, 0
			local genMode = (mode == "random" or mode == "similar")
			if genMode and PAL.same then PAL.gen(mode) end -- одна палитра на все предметы
			for idx, it in ipairs(items) do
				if not walking or myGui.Parent == nil then break end
				local tile = locateTile(it.key)
				if not tile then
					missed += 1
				else
					ensureVisible(tile)
					clickGui(tile)
					task.wait(walkDelay)
					if genMode then
						if not PAL.same then PAL.gen(mode) end
					elseif randCfg[cat].on then
						shuffleSlots()
					end
					applyAllSlotsSync()
					painted += 1
					say(string.format(t("msgWalkProgress"), idx, #items, it.name), true, 4)
				end
			end
			local stopped = not walking
			walking = false
			applyingAll = false
			if myGui.Parent == nil then return end
			refreshAuto()
			say(string.format(t(stopped and "msgWalkStopped" or "msgWalkDone"), painted, #items, missed), missed == 0, 10)
		end)
	end
	-- «▶ Запуск»: режим берётся из «Примерки» (+ Похожие / + Рандом), область - выше (1 предмет / все предметы)
	local function runNow()
		if walking then startWalk() return end -- повторное нажатие = стоп
		if applyingAll then say(t("msgPalBusy"), false, 4) return end
		local mode = PAL.mode
		if PAL.scope == "all" then
			startWalk(mode or "same")
			return
		end
		if mode then
			if not PAL.gen(mode) then say(t("msgPalNoSlots"), false, 5) return end
			say(t(mode == "similar" and "msgPalSimilar" or "msgPalRolled"), true, 4)
		elseif randCfg[curCat].on then
			shuffleSlots()
		end
		applyAllSlots()
	end
	connect(walkBtn, "MouseButton1Click", runNow)
	refreshAuto()

	-- ===== «Инструкция» =====
	instrFrame = Instance.new("Frame")
	instrFrame.Size = UDim2.fromOffset(560, 520)
	instrFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	instrFrame.BorderSizePixel = 0
	instrFrame.Active = true
	instrFrame.Visible = false
	instrFrame.Parent = frame
	round(instrFrame, 8)
	local instrTitle = label(t("instrTitle"), UDim2.fromOffset(12, 8), UDim2.new(1, -140, 0, 28), instrFrame, 22)
	regTranslatable(instrTitle, "instrTitle")
	local scrollUp = button("▲", UDim2.new(1, -116, 0, 6), UDim2.fromOffset(48, 30), instrFrame, Color3.fromRGB(70, 90, 160))
	scrollUp.TextSize = 18
	local scrollDown = button("▼", UDim2.new(1, -62, 0, 6), UDim2.fromOffset(48, 30), instrFrame, Color3.fromRGB(70, 90, 160))
	scrollDown.TextSize = 18
	local instrScroll = Instance.new("ScrollingFrame")
	instrScroll.Position = UDim2.fromOffset(12, 82)
	instrScroll.Size = UDim2.new(1, -24, 1, -94)
	instrScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	instrScroll.BorderSizePixel = 0
	instrScroll.ScrollBarThickness = 12
	instrScroll.ScrollBarImageColor3 = Color3.fromRGB(120, 140, 210)
	instrScroll.ScrollingEnabled = true
	instrScroll.ScrollingDirection = Enum.ScrollingDirection.Y
	instrScroll.CanvasSize = UDim2.fromOffset(0, 2000)
	instrScroll.Parent = instrFrame
	round(instrScroll, 6)
	local instrText = Instance.new("TextLabel")
	instrText.BackgroundTransparency = 1
	instrText.Position = UDim2.fromOffset(8, 6)
	instrText.Size = UDim2.new(1, -30, 0, 0)
	instrText.AutomaticSize = Enum.AutomaticSize.Y
	instrText.TextWrapped = true
	instrText.RichText = true
	instrText.TextXAlignment = Enum.TextXAlignment.Left
	instrText.TextYAlignment = Enum.TextYAlignment.Top
	instrText.TextColor3 = Color3.fromRGB(225, 225, 235)
	instrText.Font = Enum.Font.Gotham
	instrText.TextSize = 22
	instrText.Text = t("instrS1")
	instrText.Parent = instrScroll

	-- высота прокрутки = высота текста (считаем сами, чтобы список листался надёжно)
	local function fitCanvas()
		local h = math.max(instrText.AbsoluteSize.Y, instrText.TextBounds.Y)
		instrScroll.CanvasSize = UDim2.fromOffset(0, h + 24)
	end
	connect(instrText, "GetPropertyChangedSignal", fitCanvas, "AbsoluteSize")
	connect(instrText, "GetPropertyChangedSignal", fitCanvas, "TextBounds")
	connect(instrFrame, "GetPropertyChangedSignal", fitCanvas, "Visible")

	-- вкладки инструкции: короткие разделы вместо одной длинной простыни
	local GUIDE_TABS = 6
	local guideTab = 1
	local tabBtns = {}
	local function refreshGuide()
		for i = 1, GUIDE_TABS do
			tabBtns[i].Text = t("instrT" .. i)
			tabBtns[i].BackgroundColor3 = (i == guideTab) and Color3.fromRGB(80, 100, 170) or Color3.fromRGB(50, 50, 62)
		end
		instrText.Text = t("instrS" .. guideTab)
		fitCanvas()
	end
	for i = 1, GUIDE_TABS do
		local b = button("", UDim2.fromOffset(12 + (i - 1) * 90, 44), UDim2.fromOffset(86, 30), instrFrame, Color3.fromRGB(50, 50, 62))
		b.TextSize = 14
		tabBtns[i] = b
		connect(b, "MouseButton1Click", function()
			guideTab = i
			refreshGuide()
			instrScroll.CanvasPosition = Vector2.new(0, 0)
		end)
	end
	PAL.guideRefresh = refreshGuide
	refreshGuide()
	local function scrollBy(dy)
		local maxY = math.max(0, instrScroll.CanvasSize.Y.Offset - instrScroll.AbsoluteWindowSize.Y)
		instrScroll.CanvasPosition = Vector2.new(0, math.clamp(instrScroll.CanvasPosition.Y + dy, 0, maxY))
	end
	connect(scrollUp, "MouseButton1Click", function() scrollBy(-260) end)
	connect(scrollDown, "MouseButton1Click", function() scrollBy(260) end)

	connect(instrBtn, "MouseButton1Click", function()
		instrFrame.Visible = not instrFrame.Visible
		refreshExtraTexts()
		layoutSidePanels()
	end)
	end)()

	-- ===== открытие панелей и раскладка =====
	function layoutSidePanels()
		local x = 8
		for _, pn in ipairs({ wheelFrame, tryFrame, autoFrame, learnFrame, listFrame, instrFrame }) do
			if pn and pn.Visible then
				pn.Position = UDim2.new(1, x, 0, 0)
				x = x + pn.Size.X.Offset + 8
			end
		end
	end

	function refreshExtraTexts()
		tryToggleBtn.Text = (tryFrame.Visible and "− " or "+ ") .. (NEW_GUI and "👗 " or "") .. t("tryName")
		listToggleBtn.Text = (listFrame.Visible and "− " or "+ ") .. (NEW_GUI and "🌈 " or "") .. t("listName")
		learnToggleBtn.Text = (learnFrame.Visible and "− " or "+ ") .. (NEW_GUI and "🏷 " or "") .. t("learnName")
		instrBtn.Text = (instrFrame.Visible and "− " or "+ ") .. (NEW_GUI and "❔ " or "") .. t("instrName")
		if PAL.refresh then PAL.refresh() end
		if PAL.guideRefresh then PAL.guideRefresh() end
		refreshTry()
		if refreshLearn then refreshLearn() end
	end

	connect(tryToggleBtn, "MouseButton1Click", function()
		tryFrame.Visible = not tryFrame.Visible
		refreshExtraTexts()
		layoutSidePanels()
	end)
	connect(learnToggleBtn, "MouseButton1Click", function()
		learnFrame.Visible = not learnFrame.Visible
		refreshExtraTexts()
		layoutSidePanels()
	end)
	connect(listToggleBtn, "MouseButton1Click", function()
		listFrame.Visible = not listFrame.Visible
		refreshExtraTexts()
		layoutSidePanels()
		if listFrame.Visible then buildRows() end
	end)

	refreshExtraTexts()

	------------------------------------------------------------
	-- ИСТОРИЯ
	------------------------------------------------------------
	local function refreshHistory()
		for i, hb in ipairs(histBtns) do
			local h = history[i]
			if h then
				hb.Visible = true
				hb.BackgroundColor3 = Color3.fromRGB(h[1], h[2], h[3])
			else
				hb.Visible = false
			end
		end
		histLabel.Text = history[1] and (currentLang == "ru" and ("Прошлый: " .. history[1][4]) or ("History: " .. history[1][4])) or t("historyLabel")
	end

	recordApplied = function(r, g, b, name)
		if currentApplied and not (currentApplied[1] == r and currentApplied[2] == g and currentApplied[3] == b) then
			table.insert(history, 1, currentApplied)
		end
		for i = #history, 1, -1 do
			local h = history[i]
			if h[1] == r and h[2] == g and h[3] == b then table.remove(history, i) end
		end
		while #history > #histBtns do table.remove(history) end
		currentApplied = { r, g, b, name or ("%d,%d,%d"):format(r, g, b) }
		refreshHistory()
	end

	for i, hb in ipairs(histBtns) do
		connect(hb, "MouseButton1Click", function()
			local h = history[i]
			if not h then return end
			local r, g, b, name = h[1], h[2], h[3], h[4]
			rBox.Text, gBox.Text, bBox.Text = tostring(r), tostring(g), tostring(b)
			applyToGame(r, g, b, name)
		end)
	end

	------------------------------------------------------------
	-- ДИАГНОСТИКА
	------------------------------------------------------------
	local report = {}
	local function out(s) table.insert(report, s); print("[ColorPanel] " .. s) end

	local function connInfo(c)
		local f = c.Function
		if not f then return "(func N/A)" end
		local _, src, line, name = pcall(debug.info, f, "sln")
		local scr; pcall(function() scr = getfenv(f).script end)
		return ("scr=%s | line=%s | fn=%s"):format(scr and scr:GetFullName() or tostring(src), tostring(line), tostring(name))
	end

	local function dumpSignal(inst, label_, sig)
		if not getconnections then out("  " .. label_ .. ": getconnections N/A"); return end
		local ok, conns = pcall(getconnections, sig)
		if not ok then out("  " .. label_ .. ": error"); return end
		out(("  %s: %d conns"):format(label_, #conns))
		for i, c in ipairs(conns) do out(("    [%d] %s"):format(i, connInfo(c))) end
	end

	local function sourceOfOwner(inst, owners)
		if not getconnections then return end
		for _, sigName in ipairs({ "FocusLost", "MouseButton1Click", "Focused" }) do
			local okS, sig = pcall(function() return inst[sigName] end)
			if okS and sig then
				local ok, conns = pcall(getconnections, sig)
				if ok then
					for _, c in ipairs(conns) do
						local f = c.Function
						if f then pcall(function() local s = getfenv(f).script; if s then owners[s] = true end end) end
					end
				end
			end
		end
	end

	connect(diagBtn, "MouseButton1Click", function()
		report = {}
		local fields = findFields()
		if not (fields.R or fields.G or fields.B) then say(t("msgDiagNoFields"), false); return end
		out("=== DIAG ===")
		local owners = {}
		for _, ch in ipairs({ "R", "G", "B" }) do
			local f = fields[ch]
			if f then
				out(("Field %s: %s | %s | '%s'"):format(ch, f:GetFullName(), f.ClassName, f.Text))
				dumpSignal(f, "Text", f:GetPropertyChangedSignal("Text"))
				if f:IsA("TextBox") then dumpSignal(f, "FocusLost", f.FocusLost); dumpSignal(f, "Focused", f.Focused) end
				if f:IsA("TextButton") then dumpSignal(f, "Click", f.MouseButton1Click) end
				sourceOfOwner(f, owners)
			else
				out("Field " .. ch .. ": NOT found")
			end
		end

		out("--- Scripts ---")
		local kw = { "color", "colour", "palette", "customiz", "outfit", "wheel", "wardrobe" }
		for _, d in ipairs(game:GetDescendants()) do
			if d:IsA("LocalScript") or d:IsA("ModuleScript") then
				local nm = d.Name:lower()
				for _, k in ipairs(kw) do
					if nm:find(k, 1, true) then out("  " .. d:GetFullName()); break end
				end
			end
		end

		local saved = 0
		if decompile and writefile then
			for scr in pairs(owners) do
				local ok, src = pcall(decompile, scr)
				if ok and type(src) == "string" then
					saved += 1
					local fname = ("palette_script_%d.txt"):format(saved)
					pcall(writefile, fname, "-- " .. scr:GetFullName() .. "\n" .. src)
					out(string.format(t("msgDiagSaved"), fname))
				end
			end
		else
			out(t("msgDiagNoDecompile"))
		end

		if writefile then pcall(writefile, "palette_info.txt", table.concat(report, "\n")) end
		say(t("msgDiagReady"), true, 8)
	end)

	------------------------------------------------------------
	-- REMOTE SPY
	------------------------------------------------------------
	local function ser(v, depth)
		depth = depth or 0
		local t2 = typeof(v)
		if t2 == "Color3" then return ("Color3(%d,%d,%d)"):format(v.R*255, v.G*255, v.B*255)
		elseif t2 == "string" then return '"' .. v .. '"'
		elseif t2 == "table" then
			if depth >= 2 then return "{...}" end
			local parts = {}
			for k, x in pairs(v) do table.insert(parts, tostring(k) .. "=" .. ser(x, depth + 1)) end
			return "{" .. table.concat(parts, ", ") .. "}"
		elseif t2 == "Instance" then return v:GetFullName()
		else return tostring(v) end
	end

	connect(spyBtn, "MouseButton1Click", function()
		local canRaw = getrawmetatable and (setreadonly or make_writeable)
		if not (getnamecallmethod and (hookmetamethod or canRaw)) then
			say(t("msgSpyNoHook"), false, 10); return
		end
		if spyActive then return end
		spyLog = {}; spyActive = true
		if not spyHooked then
			spyHooked = true
			local oldNc
			local function handler(self, ...)
				local m = getnamecallmethod()
				if spyActive and (m == "FireServer" or m == "InvokeServer") then
					local args = table.pack(...)
					local parts = {}
					for i = 1, args.n do parts[i] = ser(args[i]) end
					local line = ("%s:%s(%s)"):format(self:GetFullName(), m, table.concat(parts, ", "))
					table.insert(spyLog, line); print("[Spy] " .. line)
				end
				return oldNc(self, ...)
			end
			local wrapped = newcclosure and newcclosure(handler) or handler
			local okHook = false
			if hookmetamethod then okHook = pcall(function() oldNc = hookmetamethod(game, "__namecall", wrapped) end) end
			if not okHook and canRaw then
				okHook = pcall(function()
					local mt = getrawmetatable(game)
					if setreadonly then setreadonly(mt, false) else make_writeable(mt) end
					oldNc = mt.__namecall; mt.__namecall = wrapped
					if setreadonly then setreadonly(mt, true) end
				end)
			end
			if not okHook then spyHooked = false; spyActive = false; say(t("msgSpyFail"), false, 8); return end
		end
		say(t("msgSpyStart"), true, 25)
		task.delay(25, function()
			spyActive = false
			if writefile then pcall(writefile, "palette_remotes.txt", table.concat(spyLog, "\n")) end
			say(string.format(t("msgSpyEnd"), #spyLog), true, 10)
		end)
	end)

	------------------------------------------------------------
	-- ОБНОВЛЕНИЕ ТЕКСТОВ
	------------------------------------------------------------
	function updateAllTexts()
		for _, item in ipairs(translatable) do
			if item.isPlaceholder then
				item.obj.PlaceholderText = t(item.key)
			else
				item.obj.Text = t(item.key)
			end
		end
		methodBtn.Text = (currentLang == "ru" and "Метод " or "Method ") .. method
		histLabel.Text = history[1] and (currentLang == "ru" and ("Прошлый: " .. history[1][4]) or ("History: " .. history[1][4])) or t("historyLabel")
		if colorNameHintLabel then
			colorNameHintLabel.Text = t("colorNameHint")
		end
		if refreshExtraTexts then refreshExtraTexts() end
	end

	------------------------------------------------------------
	-- K и кнопка
	------------------------------------------------------------
	connect(toggleBtn, "MouseButton1Click", function() frame.Visible = not frame.Visible end)
	connect(UIS, "InputBegan", function(input, processed)
		if processed or UIS:GetFocusedTextBox() then return end
		if input.KeyCode == TOGGLE_KEY then frame.Visible = not frame.Visible end
	end)

	-- ===== новый GUI (только если NEW_GUI = true): тёмная тема с рамкой, градиентные кнопки; панели открываются вместе =====
	if NEW_GUI then
		local okTheme, errTheme = pcall(function()
			local ACCENT = Color3.fromRGB(124, 104, 255)
			local ACCENT2 = Color3.fromRGB(0, 205, 175)
			local PANEL_BG = Color3.fromRGB(18, 20, 32)
			local sidePanels = { wheelFrame, tryFrame, autoFrame, listFrame, learnFrame, instrFrame }
			local allPanels = { frame, wheelFrame, tryFrame, autoFrame, listFrame, learnFrame, instrFrame }

			for _, pn in ipairs(allPanels) do
				pn.BackgroundColor3 = PANEL_BG
				local cr = pn:FindFirstChildOfClass("UICorner")
				if cr then cr.CornerRadius = UDim.new(0, 12) end
				local st = Instance.new("UIStroke")
				st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				st.Color = ACCENT
				st.Transparency = 0.5
				st.Thickness = 1.5
				st.Parent = pn
			end

			-- цветная полоса сверху главного окна и жирный заголовок
			local bar = Instance.new("Frame")
			bar.Position = UDim2.fromOffset(14, 0)
			bar.Size = UDim2.new(1, -28, 0, 3)
			bar.BorderSizePixel = 0
			bar.BackgroundColor3 = Color3.new(1, 1, 1)
			bar.ZIndex = 5
			bar.Parent = frame
			local barGrad = Instance.new("UIGradient")
			barGrad.Color = ColorSequence.new(ACCENT, ACCENT2)
			barGrad.Parent = bar
			titleLabel.Font = Enum.Font.GothamBold

			-- строка состояния внизу - тёмная плашка
			status.BackgroundColor3 = Color3.fromRGB(10, 11, 20)
			status.BackgroundTransparency = 0.2
			local stCorner = Instance.new("UICorner")
			stCorner.CornerRadius = UDim.new(0, 6)
			stCorner.Parent = status
			local stPad = Instance.new("UIPadding")
			stPad.PaddingLeft = UDim.new(0, 5)
			stPad.PaddingTop = UDim.new(0, 3)
			stPad.Parent = status

			-- кнопки: мягкий градиент, рамка, подсветка при наведении (кнопки-образцы цвета не трогаем)
			local skip = {}
			for _, b in ipairs(histBtns) do skip[b] = true end
			for _, m in ipairs(matchBtns) do skip[m.btn] = true end
			for _, b in ipairs(favBarBtns) do skip[b] = true end
			for _, d in ipairs(gui:GetDescendants()) do
				if d:IsA("TextButton") and not skip[d] and d.BackgroundTransparency < 1 then
					local cr = d:FindFirstChildOfClass("UICorner")
					if cr then cr.CornerRadius = UDim.new(0, 8) end
					if not d:FindFirstChildOfClass("UIStroke") then
						local st = Instance.new("UIStroke")
						st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
						st.Color = Color3.new(1, 1, 1)
						st.Transparency = 0.85
						st.Thickness = 1
						st.Parent = d
					end
					local gr = Instance.new("UIGradient")
					gr.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 205))
					gr.Rotation = 90
					gr.Parent = d
					connect(d, "MouseEnter", function() d.BackgroundTransparency = 0.15 end)
					connect(d, "MouseLeave", function() d.BackgroundTransparency = 0 end)
				end
			end

			-- одна боковая панель за раз («Примерка» и 🎲 могут быть вместе); активная кнопка подсвечивается
			local navBase = Color3.fromRGB(60, 120, 100)
			local function paintNav()
				plusBtn.BackgroundColor3 = wheelFrame.Visible and ACCENT or navBase
				tryToggleBtn.BackgroundColor3 = tryFrame.Visible and ACCENT or navBase
				listToggleBtn.BackgroundColor3 = listFrame.Visible and ACCENT or navBase
				learnToggleBtn.BackgroundColor3 = learnFrame.Visible and ACCENT or navBase
				instrBtn.BackgroundColor3 = instrFrame.Visible and ACCENT or Color3.fromRGB(110, 90, 160)
			end
			local function closeOthers(open)
				for _, pn in ipairs(sidePanels) do
					if pn ~= open and pn.Visible then
						local pair = (open == tryFrame and pn == autoFrame) or (open == autoFrame and pn == tryFrame)
						if not pair then pn.Visible = false end
					end
				end
			end
			for _, pn in ipairs(sidePanels) do
				connect(pn, "GetPropertyChangedSignal", function()
					-- панели открываются вместе (как раньше): «Цвета», «Примерка» и другие можно держать открытыми одновременно
					plusBtn.Text = wheelFrame.Visible and "−" or "+"
					layoutSidePanels()
					refreshExtraTexts()
					paintNav()
				end, "Visible")
			end
			paintNav()
		end)
		if not okTheme then warn("NEW_GUI: " .. tostring(errTheme)) end
	end

	updateAllTexts()
	say(t("msgReady"), true)
end

-- Запуск
init()
host = "Cyanny#0000" -- /!\ very important note to replace this including hash
game = {ui={bgColor1=0x48311d,brColor1=0x060404,bgColor2=0x6d5d2d,brColor2=0xa38b44,bgColor3=0x5aa581,brColor3=0x3d8763,bgColor4=0x4a3e35},score=50,time=30}

items = {{33,false,"chicken"},{10,false,"anvil"},{54,true,"ice cube"}} -- {id,ghost,name}
game.item = items[1]

map = '<C><P F="0" Ca="" /><Z><S><S X="400" Y="260" P="0,0,0.3,0.2,0,0,0,0" H="200" T="6" L="560" c="4" /><S X="400" Y="-5" P="0,0,0.3,0.2,0,0,0,0" H="10" T="12" L="800" o="324650" /><S X="785" Y="-50" P="0,0,0,0.2,0,0,0,0" H="100" T="1" L="30" /><S X="15" Y="-50" P="0,0,0,0.2,0,0,0,0" H="100" T="1" L="30" /><S X="400" Y="380" P="0,0,0.3,0.2,0,0,0,0" H="40" T="6" L="800" c="3" /><S X="220" Y="165" o="" H="10" T="12" L="160" P="0,0,0.3,0.2,0,0,0,0" c="3" /><S X="400" Y="165" o="" H="10" T="12" L="550" P="0,0,0.3,0.2,0,0,0,0" c="3" /></S><D><DS X="400" Y="345" /><P X="185" Y="164" T="0" P="0,0" /><P X="267" Y="169" T="5" P="0,0" /><P X="537" Y="163" T="3" P="0,0" /><P X="565" Y="178" T="5" P="0,0" /><P X="618" Y="169" T="12" P="0,0" /><P X="322" Y="360" T="1" P="1,0" /><P X="133" Y="372" T="0" P="0,0" /><P X="452" Y="381" T="5" P="0,0" /><P X="421" Y="362" T="0" P="0,1" /><P X="93" Y="361" T="3" P="0,0" /><P X="53" Y="388" T="5" P="0,1" /><P X="706" Y="364" T="0" P="0,0" /><P X="752" Y="384" T="5" P="0,1" /></D><O /></Z></C>'
page = 1

function length(tbl) -- get table length because lua is a crap language
	local i = 0
	for k,v in pairs(tbl) do
		i = i + 1
	end
	return i
end

function assignPlayer(player)
	if player then
		game.player[player] = {selected=false,present=true,count=0,page=0,textArea={bgColor=game.ui.bgColor2,brColor=game.ui.brColor2,text="<a href='event:select" .. player .. "'>" .. player .. "</a>"}}
	else
		game.player = {}
		for k,v in pairs(tfm.get.room.playerList) do
			game.player[k] = {selected=false,present=true,count=0,page=0,textArea={bgColor=game.ui.bgColor2,brColor=game.ui.brColor2,text="<a href='event:select" .. k .. "'>" .. k .. "</a>"}}
			tfm.exec.setPlayerScore(k, 0)
		end
	end
	generateStartScreen()
end

function changePage(evt, player)
	if (evt == "prev" and page > 1) or (evt == "next" and page < pages) then
		for i=1000+(page-1)*30,1000+(page*30) do
			ui.removeTextArea(i, nil)
		end
		if evt == "prev" then
			page = page - 1
		elseif evt == "next" then
			page = page + 1
		end
		updateStartScreen()
	end
end

function selectPlayer(player)
	if game.player[player].present then
		if game.player[player].selected then
			game.player[player].selected = false
			game.player[player].textArea.bgColor, game.player[player].textArea.brColor = game.ui.bgColor2, game.ui.brColor2
		elseif not game.player[player].selected then
			game.player[player].selected = true
			game.player[player].textArea.bgColor, game.player[player].textArea.brColor = game.ui.bgColor3, game.ui.brColor3
		end
	end
	updateStartScreen()
	for k,v in pairs(game.player) do
		if v.page == 2 then
			ui.updateTextArea(909, "<font face='sans' size='28'>The Chosen Ones</font>\n\n" .. listSelectedPlayer(), k)
		end
	end
end

function listSelectedPlayer() -- returns a string with new lines
	local str = ""
	for k,v in pairs(game.player) do
		if v.selected then
			str = str .. "[*] " .. k .. "\n"
		end
	end
	return str
end

function numberOfSelected()
	local i = 0
	for k,v in pairs(game.player) do
		if v.selected then
			i = i + 1
		end
	end
	return i
end

function numberOfMiceInRoom()
	local i = 0
	for k,v in pairs(tfm.get.room.playerList) do
		if v.present then
			i = i + 1
		end
	end
	return i
end

function numberOfMax()
	if numberOfMiceInRoom() < 2 then
		return 2
	elseif numberOfMiceInRoom() < 8 then
		return numberOfMiceInRoom()
	else
		return 8
	end
end

function tooMuchChicken() -- :D
	local str = ""
	for i=1,200 do
		str = str .. "&lt;(' ) "
	end
	return "<font face='mono'>" .. str .. "</font>"
end

function startScreen(player)
	if math.ceil((length(game.player))/30) > 1 then
		ui.addTextArea(900, "<a href='event:prev'>p\nr\ne\nv</a>", host, 96, 88, 24, 96, game.ui.bgColor1, game.ui.brColor1, 1, true)
		ui.addTextArea(901, "<a href='event:next'>n\ne\nx\nt</a>", host, 96, 203, 24, 96, game.ui.bgColor1, game.ui.brColor1, 1, true)
	end
	ui.addTextArea(902, "", host, 116, 74, 560, 260, game.ui.bgColor1, game.ui.brColor1, 1, true)
	ui.addTextArea(903, "<font size='28' face='sans'>please, select players..</font>", host, 116, 46, 400, 50, nil, nil, 0, true)
	ui.addTextArea(904, numberOfSelected() .. " / " .. numberOfMax(), host, 630, 60, 50, 20, nil, nil, 0, true)
	ui.addTextArea(905, "<p align='center'><a href='event:start'>start</a></p>", host, 620, 348, 50, 20, game.ui.bgColor1, game.ui.brColor1, 1, true)
	ui.addTextArea(910, "<p align='center'><a href='event:settings-open'>settings</a></p>", host, 545, 348, 60, 20, game.ui.bgColor1, game.ui.brColor1, 1, true)
	ui.addTextArea(906, "<font size='9' color='#6d4a2c'>" .. tooMuchChicken() .. "</font>", player, 512, 60, 256, 300, game.ui.bgColor1, game.ui.brColor1, 1, true)
	ui.addTextArea(907, "<p align='right'><font face='sans' size='36'>\nChicken \nPooping \nGame </font></p>", player, 512, 60, 256, 240, nil, nil, 0, true)
	ui.addTextArea(920, "<p align='right'><a href='event:prevHelp'>prev</a>  |  <a href='event:nextHelp'>next</a></p>", player, 512, 340, 256, 60, nil, nil, 0, true)
	ui.removeTextArea(906, host) -- to show the previous text areas to everyone, but the host
	ui.removeTextArea(907, host)
	ui.removeTextArea(920, host)
end

function generateStartScreen()
	local count = 1
	for k,v in pairs(game.player) do
		v.textArea.id = 1000+count
		count = count + 1
	end
	pages = math.ceil(length(game.player)/30)
	for i=1,pages do
		local x = 128
		local y = 96
		for j=1001+(i-1)*30,1000+i*30 do
			for k,v in pairs(game.player) do
				if v.textArea.id == j then
					v.textArea.x = x
					v.textArea.y = y
					x = x + 96 + 15
					if x > 680 then
						x = 128
						y = y + 24 + 15
					end
					break
				end
			end
		end
	end
end

function updateStartScreen()
	for i=1001+(page-1)*30,1000+page*30 do
		for k,v in pairs(game.player) do
			if v.textArea.id == i then
				local a = v.textArea
				ui.addTextArea(a.id, a.text, host, a.x, a.y, 96, 24, a.bgColor, a.brColor, 1, true)
			elseif v.textArea.id > i then
				break
			end
		end
	end
	if game.settings then
		showSettings(true)
	end
end

function updateHelpScreen(evt, player)
	if evt == "prevHelp" then
		game.player[player].page = (game.player[player].page - 1) % 3
	elseif evt == "nextHelp" then
		game.player[player].page = (game.player[player].page + 1) % 3
	end
	if game.player[player].page == 0 then
		ui.removeTextArea(908, player)
		ui.removeTextArea(909, player)
		ui.addTextArea(907, "<p align='right'><font face='sans' size='36'>\nChicken \nPooping \nGame </font></p>", player, 512, 60, 256, 260, nil, nil, 0, true)
	elseif game.player[player].page == 1 then
		ui.removeTextArea(907, player)
		ui.removeTextArea(909, player)
		ui.addTextArea(908, "<font face='sans' size='28'>Goal</font>\n\nYour sole goal is to achieve a higher score than your opponents by pooping chicken! To poop chicken, simply duck as fast as you can.\n\nTo play, the host should select you", player, 512, 60, 256, 260, nil, nil, 0, true)
	elseif game.player[player].page == 2 then
		ui.removeTextArea(907, player)
		ui.removeTextArea(908, player)
		ui.addTextArea(909, "<font face='sans' size='28'>The Chosen Ones</font>\n\n" .. listSelectedPlayer(), player, 512, 60, 256, 260, nil, nil, 0, true)
	end
	ui.updateTextArea(920, "<p align='right'><a href='event:prevHelp'>prev</a>  |  <a href='event:nextHelp'>next</a></p>", player)
end

function startGame()
	showSettings(false)
	if numberOfSelected() > 1 then
		game.t = 2
		for i=900,910 do
			ui.removeTextArea(i, nil)
		end
		for i=1001+(page-1)*30,1000+page*30 do
			ui.removeTextArea(i, nil)
		end
		tfm.exec.newGame(map)
		local diff_x = 480 / (numberOfSelected() - 1)
		local x = 160
		for k,v in pairs(game.player) do
			if v.selected then
				v.x = x
				v.y = 145
				tfm.exec.movePlayer(k, x, 145, false, 0, 0, false)
				x = x + diff_x
			else
				v.x = 400
				v.y = -15
				tfm.exec.movePlayer(k, 400, -15, false, 0, 0, false)
			end
		end
		game.run = true
		updateNav("running!")
	else
		ui.addPopup(999, 0, "<p align='center'>Not enough players. Please try again.</p>", host, 200, 180, 400, true)
	end
end

function endGame()
	game.run = false
	game.t = 3
	for k,v in pairs(game.player) do
		if game.player[k].selected then
			tfm.exec.bindKeyboard(k, 3, true, false)
		end
	end
	if game.winner then
		ui.addTextArea(950, "<p align='center'><font face='sans' size='32'>" .. game.winner .. "\nhas won the game!</font></p>", nil, 0, 180, 800, 100, nil, nil, 0, true)
	elseif not game.winner and game.time ~= 0 then
		ui.addTextArea(950, "<p align='center'><font face='sans' size='32' color='#ff0000'>Time's up!</font></p>", nil, 0, 180, 800, 40, nil, nil, 0, true)
	end
	game.ended = true
	updateNav("ended.")
end

function showSettings(bool) -- all textarea ids here range from 800 to 899
	game.settings = bool
	if bool then
		ui.updateTextArea(903, "", host) -- hide title behind
		ui.updateTextArea(904, "", host)
		ui.updateTextArea(910, "<p align='center'><a href='event:settings-close'>close</a></p>", host)
		ui.addTextArea(800, "", host, 116, 74, 560, 260, game.ui.bgColor1, game.ui.brColor1, 1, true)
		ui.addTextArea(801, "<font face='sans' size='28'>game settings</font>", host, 116, 46, 400, 96, nil, nil, 0, true)
		ui.addTextArea(802, "target score\t\t\t<a href='event:setscore'>" .. game.score .. "</a>\nround time\t\t\t<a href='event:settime'>" .. game.time .. "</a>\t(set as zero for infinite time)\npoop type\t\t\t<a href='event:setitem'>" .. game.item[3] .. "</a>", host, 120, 100, 400, 260, nil, nil, 0, true)
	else
		for i=800,899 do
			ui.removeTextArea(i, nil)
		end
		ui.updateTextArea(903, "<font face='sans' size='28'>please, select players..", host) -- return title behind settings window
		ui.updateTextArea(904, numberOfSelected() .. " / " .. numberOfMax(), host)
		ui.updateTextArea(910, "<p align='center'><a href='event:settings-open'>settings</a></p>", host)
	end
end

function showItems()
	local x = 125
	local y = 160
	for k,v in pairs(items) do
		ui.addTextArea(802 + k, "<p align='center'><a href='event:item" .. k  ..  "'>" .. v[3] .. "</a></p>", host, x, y, 50, 20, game.ui.bgColor1, game.ui.brColor1, 1, true)
		x = x + 65
	end
end	

function changeTime(t)
	if t == 0 then
		tfm.exec.disableAutoTimeLeft(true)
	else
		tfm.exec.disableAutoTimeLeft(false)
		tfm.exec.setGameTime(t, false)	
	end
end

function updateNav(status)
	local t
	if game.time == 0 then
		t = "-"
	else
		t = game.time
	end
	tfm.exec.setUIMapName("Status: " .. status ..  " | Target: " .. game.score .. " | Round time: " .. t)
end

function eventNewPlayer(player)
	if not game.player[player] then
		assignPlayer(player)
	end
	if not game.run then
		startScreen(player)
		updateStartScreen()
	end
end

function eventPlayerLeft(player)
	game.player[player].present = false
	game.player[player].selected = false
	game.player[player].textArea.text = player
	game.player[player].textArea.bgColor, game.player[player].textArea.brColor = game.ui.bgColor4, game.ui.bgColor4
	if not game.run then
		updateStartScreen()
	end
end

function eventPlayerDied(player)
	tfm.exec.respawnPlayer(player)
	if game.player[player].x and game.player[player].y then
		tfm.exec.movePlayer(player, game.player[player].x, game.player[player].y, false, 0, 0, false)
	end
end

function eventTextAreaCallback(textArea, player, callback)
	if player == host then
		if string.sub(callback, 1, 6) == "select" then
			selectPlayer(string.sub(callback, 7))
			ui.updateTextArea(904, numberOfSelected() .. " / " .. numberOfMax(), nil)
		elseif callback == "prev" or callback == "next" then
			changePage(callback)
		elseif callback == "start" then
			startGame()
		elseif callback == "settings-open" then
			showSettings(true)
		elseif callback == "settings-close" then
			showSettings(false)
		elseif string.sub(callback, 1, 3) == "set" then
			local cb = string.sub(callback, 4)
			if cb == "score" then
				ui.addPopup(899, 2, "Enter the new target score.", host, 200, 180, 400, true)
			elseif cb == "time" then
				ui.addPopup(898, 2, "Enter the new round time limit.", host, 200, 180, 400, true)
			elseif cb == "item" then
				showItems()
			end
		elseif string.sub(callback, 1, 4) == "item" then
			game.item = items[tonumber(string.sub(callback, 5))]
			for i=803, 802+length(items) do
				ui.removeTextArea(i, nil)
			end
			ui.updateTextArea(802, "target score\t\t\t<a href='event:setscore'>" .. game.score .. "</a>\nround time\t\t\t<a href='event:settime'>" .. game.time .. "</a>\t(set as zero for infinite time)\npoop type\t\t\t<a href='event:setitem'>" .. game.item[3] .. "</a>", host)
			updateNav("selecting..")
		end
			
	else
		if callback == "prevHelp" or callback == "nextHelp" then
			updateHelpScreen(callback, player)
		end
	end
end

function eventKeyboard(player, key, down, x, y)
	if key == 3 then
		game.player[player].count = game.player[player].count + 1
		if game.player[player].count >= game.score then
			game.winner = player
			endGame()
		end
		tfm.exec.setPlayerScore(player, game.player[player].count, false)
		tfm.exec.addShamanObject(game.item[1], x, y + 20, 0, 0, 20, game.item[2])
		tfm.exec.displayParticle(3, math.random(-20,20) + x, math.random(10,25) + y, 0, 0, 0, 0, nil)
	elseif key == 0 or 2 then
		tfm.exec.movePlayer(player, game.player[player].x, game.player[player].y, false, 0, 0, false)
	end
end

function eventPopupAnswer(popup, player, answer)
	local n = tonumber(answer)
	if popup == 899 then
		if n then
			game.score = math.floor(math.abs(n))
			ui.updateTextArea(802, "target score\t\t\t<a href='event:setscore'>" .. game.score .. "</a>\nround time\t\t\t<a href='event:settime'>" .. game.time .. "</a>\t(set as zero for infinite time)\npoop type\t\t\t<a href='event:setitem'>" .. game.item[3] .. "</a>", host)
			updateNav("selecting..")
		else
			ui.addPopup(899, 2, "Invalid number. Enter the new target score again.", host, 200, 180, 400, true)
		end
	elseif popup == 898 then
		if n then
			game.time = math.floor(math.abs(n))
			ui.updateTextArea(802, "target score\t\t\t<a href='event:setscore'>" .. game.score .. "</a>\nround time\t\t\t<a href='event:settime'>" .. game.time .. "</a>\t(set as zero for infinite time)\npoop type\t\t\t<a href='event:setitem'>" .. game.item[3] .. "</a>", host)
			updateNav("selecting..")
		else
			ui.addPopup(898, 2, "Invalid number. Enter the new round time limit again.", host, 200, 180, 400, true)
		end
	end
end

function eventLoop(ct, tr)
	if game.run then
		if game.t then
			if game.t > 0 then
				game.t = game.t - 0.5
			elseif game.t == 0 then
				for k,v in pairs(game.player) do
					tfm.exec.bindKeyboard(k, 0, false, true)
					tfm.exec.bindKeyboard(k, 2, false, true)
					if game.player[k].selected then
						tfm.exec.bindKeyboard(k, 3, true, true)
					end
				end
				changeTime(game.time)
				game.t = -1
			end
		end
		if game.time > 0 and tr <= 0 then
			endGame()
		end
	elseif game.ended then
		if game.t > 0 then
			game.t = game.t - 0.5
		elseif game.t == 0 then
			ui.removeTextArea(950, nil) -- text area for winner
			game.ended = false
			game.winner = nil
			game.t = -1
			assignPlayer()
			startScreen()
			updateStartScreen()
		end
	end
end

tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAfkDeath(true)

assignPlayer()
startScreen()
updateStartScreen()
updateNav("selecting..")

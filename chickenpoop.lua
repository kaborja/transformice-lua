host = "Iililililil#2525"
game = {ui={bgColor1=0x48311d,brColor1=0x060404,bgColor2=0x6d5d2d,brColor2=0xa38b44,bgColor3=0x5aa581,brColor3=0x3d8763,bgColor4=0x4a3e35},goal=10}
game.score = 50

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
		game.player[player] = {selected=false,present=true,count=0,page=0,textArea={bgColor=game.ui.bgColor2,brColor=game.ui.brColor2,text="<a href='event:select'>" .. player .. "</a>"}}
	else
		game.player = {}
		for k,v in pairs(tfm.get.room.playerList) do
			game.player[k] = {selected=false,present=true,count=0,page=0,textArea={bgColor=game.ui.bgColor2,brColor=game.ui.brColor2,text="<a href='event:select'>" .. k .. "</a>"}}
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
			ui.updateTextArea(909, "<font face='Soopafresh' size='28'>The Chosen Ones</font>\n\n" .. listSelectedPlayer(), k)
		end
	end
	ui.updateTextArea(920, "<p align='right'><a href='event:prevHelp'>prev</a>  |  <a href='event:nextHelp'>next</a></p>", nil) -- a very weird glitch removes the clickability off it each time it's triggered
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
		i = i + 1
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
	ui.addTextArea(903, "<font size='28' face='Soopafresh'>please, select players..</font>", host, 116, 46, 400, 96, nil, nil, 0, true)
	ui.addTextArea(904, numberOfSelected() .. " / " .. numberOfMax(), host, 630, 60, 50, 20, nil, nil, 0, true)
	ui.addTextArea(905, "<p align='center'><a href='event:start'>start</a></p>", host, 620, 348, 50, 20, game.ui.bgColor1, game.ui.brColor1, 1, true)
	ui.addTextArea(906, "<font size='9' color='#6d4a2c'>" .. tooMuchChicken() .. "</font>", player, 512, 60, 256, 300, game.ui.bgColor1, game.ui.brColor1, 1, true)
	ui.addTextArea(907, "<p align='right'><font face='Soopafresh' size='36'>\nChicken \nPooping \nGame </font></p>", player, 512, 60, 256, 300, nil, nil, 0, true)
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
end

function updateHelpScreen(evt, player)
	if evt == "prevHelp" then
		game.player[player].page = (game.player[player].page - 1) % 3
	elseif evt == "nextHelp" then
		game.player[player].page = (game.player[player].page + 1) % 3
	end
	print(game.player[player].page)
	if game.player[player].page == 0 then
		ui.removeTextArea(908, player)
		ui.removeTextArea(909, player)
		ui.addTextArea(907, "<p align='right'><font face='Soopafresh' size='36'>\nChicken \nPooping \nGame </font></p>", player, 512, 60, 256, 300, nil, nil, 0, true)
	elseif game.player[player].page == 1 then
		ui.removeTextArea(907, player)
		ui.removeTextArea(909, player)
		ui.addTextArea(908, "<font face='Soopafresh' size='28'>Goal</font>\n\nYour sole goal is to achieve a higher score than your opponents by pooping chicken! To poop chicken, simply duck as fast as you can.\n\nTo play, the host (script runner) should select you", player, 512, 60, 256, 300, nil, nil, 0, true)
	elseif game.player[player].page == 2 then
		ui.removeTextArea(907, player)
		ui.removeTextArea(908, player)
		ui.addTextArea(909, "<font face='Soopafresh' size='28'>The Chosen Ones</font>\n\n" .. listSelectedPlayer(), player, 512, 60, 256, 300, nil, nil, 0, true)
	end
	ui.updateTextArea(920, "<p align='right'><a href='event:prevHelp'>prev</a>  |  <a href='event:nextHelp'>next</a></p>", player)
end

function startGame()
	if numberOfSelected() > 1 then
		game.t = 3
		for i=900,910 do
			ui.removeTextArea(i, nil)
		end
		for i=1001+(page-1)*30,1000+page*30 do
			ui.removeTextArea(i, nil)
		end
		tfm.exec.newGame(3720251)
		local diff_x = 480 / numberOfSelected()
		local x = 400 - (diff_x * (numberOfSelected() / (numberOfSelected() * 2)))
		for k,v in pairs(game.player) do
			if v.selected then
				v.x = x
				tfm.exec.movePlayer(k,x,145,false,0,0,false)
				x = x + diff_x
			end
		end
		game.run = true
	else
		ui.addPopup(999, 0, "<p align='center'>Not enough players. Please try again.</p>", host, 200, 180, 400, true)
	end
end

function endGame()
	for k,v in pairs(game.player) do
		if game.player[k].selected then
			tfm.exec.bindKeyboard(k, 40, true, false)
			tfm.exec.bindKeyboard(k, 83, true, false)
		end
	end
	game.run = false
	ui.addTextArea(950, "<p align='center'><font size='28'>" .. game.winner .. " has won the game!</font></p>", nil, 0, 180, 800, 40, nil, nil, 0, true)
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

function eventTextAreaCallback(textArea, player, callback)
	if player == host then
		if callback == "select" then
			for k,v in pairs(game.player) do
				if v.textArea.id == textArea then
					selectPlayer(k)
					break
				end
			end
			ui.updateTextArea(904, numberOfSelected() .. " / " .. numberOfMax(), nil)
		elseif callback == "prev" or callback == "next" then
			changePage(callback)
		elseif callback == "start" then
			startGame()
		end
	else
		if callback == "prevHelp" or callback == "nextHelp" then
			updateHelpScreen(callback, player)
		end
	end
end

function eventKeyboard(player, key, down, x, y)
	tfm.exec.addShamanObject(33, x, y + 20, 0, 0, 20, false)
	tfm.exec.displayParticle(3, math.random(-20,20) + x, math.random(10,25) + y, 0, 0, 0, 0, nil)
	game.player[player].count = game.player[player].count + 1
	tfm.exec.setPlayerScore(player, 1, true)
	if game.player[player].count == game.score then
		game.winner = player
		game.t = 3
		endGame()
	end
end

function eventLoop(ct, tr)
	if game.run then
		for k,v in pairs(game.player) do
			if v.selected then
				 tfm.exec.movePlayer(k,v.x,145,false,0,0,false)
			end
		end
		if game.t then
			if game.t > 0 then
				game.t = game.t - 0.5
			elseif game.t == 0 then
				for k,v in pairs(game.player) do
					if game.player[k].selected then
						tfm.exec.bindKeyboard(k, 40, true, true)
						tfm.exec.bindKeyboard(k, 83, true, true)
					end
				end
				game.t = -1
			end
		end
	elseif game.winner then
		if game.t > 0 then
			game.t = game.t - 0.5
		elseif game.t == 0 then
			ui.removeTextArea(950, nil) -- text area for winner
			game.winner = nil
			game.t = -1
			assignPlayer()
			startScreen()
			updateStartScreen()
		end
	end
end

tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAfkDeath(true)

assignPlayer()
startScreen()
updateStartScreen()


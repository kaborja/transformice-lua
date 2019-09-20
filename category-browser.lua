maps = {}
mapType = "#1"
categories={0,1,2,3,4,5,6,7,8,9,10,11,13,17,18,19,20,21,22,23,24,32,34,38,41,42,44,87}
vanilla={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,109,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,200,201,202,203,204,205,206,207,208,209,210}

game = {}
mapNo = 0

tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAfkDeath(true)

function newGame(type)
	if type == "#87" then
		vanillaMap = vanilla[math.ceil(math.random() * #vanilla)]
		tfm.exec.newGame(vanillaMap)
	else
		tfm.exec.newGame(type)
	end
end

function regenTextArea(opacity, target)
	local opacity = opacity / 10
	ui.addTextArea(0,"<p align='center'>Map: <a href='event:prev'>prev</a> | <a href='event:reload'>↺</a> | <a href='event:next'>next</a></p>",target,645,380,135,40,0x324650,0x212F36,opacity,true)
	ui.addTextArea(1,"<p align='center'><a href='event:showPerm'>▼</a></p>",target,750,40,30,20,0x324650,0x212F36,opacity,true)
	ui.addTextArea(2,"<p align='center'>Opacity: <a href='event:opacityUp'>+</a> | <a href='event:opacityDown'>-</a></p>",target,645,40,90,20,0x324650,0x212F36,opacity,true)
	if game[target].showPerm then
		local x = math.ceil(#categories / 8) * 45
		local y = 35
		for k,v in pairs(categories) do
			if (k - 1) % 8 == 0 then
				x = x - 45
				y = 35
			end
			ui.addTextArea(k + 2,"<p align='center'><a href='event:" .. "p" .. v .. "'>" .. "p" .. v .. "</a></p>",target,750 - x, 40 + y, 30, 20,0x324650,0x212F36,opacity,true)
			y = y + 35
		end
	end
end

function eventTextAreaCallback(textArea, player, callback)
	if textArea == 0 then
		if callback == "next" then
			mapNo = mapNo + 1
			if playback then
				tfm.exec.newGame(maps[mapNo])
				if mapNo == #maps then
					playback = false
				end
			else 
				newGame(mapType)
			end
		elseif callback == "reload" and tfm.get.room.xmlMapInfo then
			reload = true
			tfm.exec.newGame(tfm.get.room.xmlMapInfo.mapCode)
		elseif callback == "prev" and mapNo > 1 then
			if not playback then
				mapNo = #maps
			end
			playback = true
			mapNo = mapNo - 1
			tfm.exec.newGame(maps[mapNo])
		end
	elseif textArea == 2 then
		local opacity = game[player].opacity
		if callback == "opacityUp" and opacity < 10 then
			opacity = opacity + 1
		elseif callback == "opacityDown" and opacity > 5 then
			opacity = opacity - 1
		end
		game[player].opacity = opacity
		regenTextArea(opacity, player)
	elseif callback == "showPerm" then
		if game[player].showPerm then
			game[player].showPerm = false
			for i=3,#categories+3 do
				ui.removeTextArea(i, player)
			end
			ui.updateTextArea(1, "<p align='center'><a href='event:showPerm'>▲</a></p>", player)
		elseif not game[player].showPerm then
			game[player].showPerm = true
			regenTextArea(game[player].opacity, player)
			ui.updateTextArea(1, "<p align='center'><a href='event:showPerm'>▼</a></p>", player)
		end
	else
		for k,v in pairs(categories) do
			if string.gsub(callback, "p", "") == tostring(v) then
				mapType = "#" .. v
			end
		end
	end
end

t = 3
function eventLoop(ct, tr)
	if t < 3 then
		t = t + 0.5
		ui.updateTextArea(0, "<p align='center'>Reloading in " .. 3 - math.floor(t) .. "..</p>", nil)
	elseif t == 3 then
		ui.updateTextArea(0, "<p align='center'>Map: <a href='event:prev'>prev</a> | <a href='event:reload'>↺</a> | <a href='event:next'>next</a></p>", nil)
	end
	for player,tbl in pairs(game) do -- counter for respawing player
		for label,value in pairs(tbl) do
			if label == "respawn_t" then
				if value > 0 then
					tbl[label] = value - 0.5
				elseif value == 0 then
					tfm.exec.respawnPlayer(player)
					value = -1
				end
			end
		end
	end
end

function eventNewGame()
	t = 0
	if mapNo == #maps + 1 then
		playback = false
	end
	if not playback and not reload then
		if not vanillaMap and tfm.get.room.xmlMapInfo.mapCode then
			table.insert(maps, tfm.get.room.xmlMapInfo.mapCode)
		elseif mapType == "#87" then
			table.insert(maps, vanillaMap)
		end
	end
	reload = false
	
end

function eventPlayerWon(player,timeElapsed)
	game[player].respawn_t = 2
end
	
function eventPlayerDied(player)
	game[player].respawn_t = 2
end

function eventNewPlayer(player)
	if not game[player] then
		game[player] = {showPerm=false,opacity=10,respawn_t=0.5,hasPower=true}
	end
	game[player].respawn_t = 0.5
	regenTextArea(game[player].opacity, player)
end

for k,v in pairs(tfm.get.room.playerList) do
	game[k] = {showPerm=false,opacity=10,respawn_t=-1,hasPower=true}
	regenTextArea(game[k].opacity, k)
end

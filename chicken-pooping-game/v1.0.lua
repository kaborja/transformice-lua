host="Cyanny" -- Only host should be changed. /!\ QUOTATION MARKS ARE IMPORTANT.
time=60
ducks=50
itemID=33
ghostItem=false

function waiting()
  ui.removeTextArea(99,nil)
  ui.removeTextArea(66,nil)
  tfm.exec.disableAutoNewGame(true)
  tfm.exec.disableAutoShaman(true)
  tfm.exec.disableAutoScore(true)
  tfm.exec.disableAfkDeath(true)
  tfm.exec.newGame(3720251)
  tfm.exec.setUIMapName("Chicken Pooping Game: Waiting.. <font color='#6C77C1'>|</font> <font color='#C2C2DA'>Host: </font><font color='#98E2EB'>" ..host.. "</font>")
  tfm.exec.setGameTime(0, false)
end

function picking()
  ui.addTextArea(97, "<p align='center'>Wait until the players are picked by the host.</p>" ,player,200,200,400,0,0x324650,0x212F36,1,true)
  ui.addPopup(96,2," Choose <b><font color='#2E72CB'>Player 2</font></b> (must be exact):",host,200,150,400,true)
  ui.addPopup(97,2," Choose <b><font color='#EB1D51'>Player 1</font></b> (must be exact):",host,200,150,400,true)
  ui.addTextArea(5, "<a href='event:reset'>Reset</a>" ,host,740,324,80,15,0x324650,0x212F36,1,true)
  ui.addTextArea(6, "<a href='event:help'>Help</a>" ,nil,740,370,80,15,0x324650,0x212F36,1,true)
  ui.addTextArea(7, "<a href='event:settings'>Settings</a>" ,host,740,347,80,15,0x324650,0x212F36,1,true)
end

function settings()
  ui.addPopup(73,1," Do you want the item to be a ghost item?\n ",host,200,150,400,true)
  ui.addPopup(72,2," Type in an item ID to replace chicken:",host,200,150,400,true)
  ui.addPopup(71,2," Choose amount of ducks required to win:",host,200,150,400,true)
  ui.addPopup(70,2," Pick time (range: 0-117):",host,200,150,400,true)
end

function loadGame()
  n = 0
  m = 0
  ui.removeTextArea(97,nil)
  tfm.exec.disableAutoNewGame(false)
  tfm.exec.setUIMapName("Chicken Pooping Game! <font color='#6C77C1'>|</font> <font color='#C2C2DA'>Host: </font><font color='#98E2EB'>" ..host.. "</font>")
  tfm.exec.setGameTime(time+3, true)
  tfm.exec.setNameColor(player1,0xEB1D51)
  tfm.exec.setNameColor(player2,0x2E72CB)
  ui.addTextArea(1, "<b>Player 1:\n" ..player1.. "</b>",nil,160,208,120,0,0x324650,0x212F36,0,true)
  ui.addTextArea(2, "<b>Chicken pooped:\n" ..n.. "</b>",nil,160,253,120,0,0x324650,0x212F36,0,true)
  ui.addTextArea(3, "<b>Player 2:\n" ..player2.. "</b>",nil,520,208,120,0,0x324650,0x212F36,0,true)
  ui.addTextArea(4, "<b>Chicken pooped:\n" ..m.. "</b>",nil,520,253,120,0,0x324650,0x212F36,0,true)
  tfm.exec.movePlayer(player1,220,145,false,0,0,false)
  tfm.exec.movePlayer(player2,580,145,false,0,0,false)
  tfm.exec.bindKeyboard(player1, 40, true, true)
  tfm.exec.bindKeyboard(player2, 83, true, true)
  function eventPlayerLeft(player)
    if player==player1 then
      tfm.exec.setGameTime(5, false)
      ui.addTextArea(66,"<p align='center'><font size='72' color='#EB1D51'>" ..player1.. "</font><font size='72' color='#C2C2DA'> has left the game. Game will restart.</p></font>",nil,0,50,800,0,0x324650,0x212F36,0,true)
      roundWon()
    elseif player==player2 then
      tfm.exec.setGameTime(5, false)
      ui.addTextArea(66,"<p align='center'><font size='72' color='#2E72CB'>" ..player2.. "</font><font size='72' color='#C2C2DA'> has left the game. Game will restart.</p></font>",nil,0,50,800,0,0x324650,0x212F36,0,true)
      roundWon()
    end
  end
end

function roundWon()
  ui.removeTextArea(1,nil)
  ui.removeTextArea(2,nil)
  ui.removeTextArea(3,nil)
  ui.removeTextArea(4,nil)
  tfm.exec.bindKeyboard(player1, 40, true, false)
  tfm.exec.bindKeyboard(player2, 83, true, false)
end

function update(id1,id2,number,playerName,var,loser,x,y)
  xFart = math.random(-20,20)+x
  yFart = math.random(10,25)+y
  ui.updateTextArea(id1,"<b>Player "..number..":\n" ..playerName.. "</b>",nil)
  ui.updateTextArea(id2,"<b>Chicken pooped:\n" ..var.. "</b>",nil)
  tfm.exec.addShamanObject(itemID, x, y+20, 0, 0, 20, ghostItem)
  tfm.exec.displayParticle(3, xFart, yFart, 0, 0, 0, 0, nil)
  if var==ducks then
    ui.addTextArea(99,"<p align='center'><font size='72' color='#BABD2F'>" ..playerName.. " won the game!</p></font>",nil,0,200,800,0,0x324650,0x212F36,0,true)
    tfm.exec.displayParticle(6, xFart, yFart, 0, 0, 0, 0, loser)
    tfm.exec.movePlayer(loser,400,-30,false,0,0,false)
    tfm.exec.setGameTime(5, false)
    roundWon()
  end 
end

function eventTextAreaCallback(textArea, player, callback)
  if textArea==5 then
    waiting()
    roundWon()
    picking()
  elseif textArea==6 then
    ui.addPopup(98,0,"<p align='center'><font size='32'>Instructions</font></p><font color='#EB1D51'>\n Player 1</font> presses on down arrow.\n<font color='#2E72CB'> Player 2</font> presses on 's' button.\n Goal is to reach " ..ducks.. " ducks in " ..time.. " seconds. Good luck!\n\n<p align='center'><font size='8'></a>Game made by Cyanny.</font>",player,200,130,400,true)
  elseif textArea==7 then
    tfm.exec.disableAutoNewGame(true)
    picking()
    settings()
  end
end

function eventKeyboard(player, key, down, x, y)
  if key==40 then
    n = n + 1
    update(1,2,1,player1,n,player2,x,y)
  elseif key==83 then
    m = m + 1
    update(3,4,2,player2,m,player1,x,y)
  end
end

function eventPopupAnswer(popUpId, host, answer)
  if popUpId==70 then
    time = tonumber(answer)
    if answer=="" then
      time = tonumber(60)
    end
  end
  if popUpId==71 then
    ducks = tonumber(answer)
    if answer=="" then
      ducks = tonumber(50)
    end
  end
  if popUpId==72 then
    itemID = answer
    if answer=="" then
      itemID = 33
    end
  end
  if popUpId==73 then
    if answer=="yes" then
      ghostItem = true
    elseif answer=="no" then
      ghostItem = false
    end
  end
  if popUpId==97 then 
    player1 = answer
  end
  if popUpId==96 then
    player2 = answer
    loadGame()
  end
end

function eventNewGame()
  waiting()
  roundWon()
  picking()
end 

function eventNewPlayer(player)
  tfm.exec.respawnPlayer(player)
end

waiting()
picking()

function love.load()
    fontz= {}
    fontz.xillapro= lg.newFont('wares/Xilla Pro Regular Italic.otf', 29)
    fontz.digidisco= lg.newFont('wares/DigitalDisco-Thin.ttf', 16)
    fontz.credits2= lg.newFont('wares/2Credits.ttf', 16)
    fontz.cursive= lg.newFont('wares/Cursive.ttf', 17*2*2)
    --lg.setFont(fontz.cursive)
    icons={}
    icons.icons=lg.newImage('wares/icons.png')
    icons.miner=stamp48(icons.icons,0,0)
    icons.cardback=stamp48(icons.icons,1,0)
    audio={}
    audio.bgm=love.audio.newSource('wares/stockpile.ogg','stream')
    audio.bgm:setLooping(true)
end

function stamp48(img,x,y)
    local out=lg.newCanvas(48,64)
    lg.setCanvas(out)
    fg(1,1,1,1)
    lg.draw(img,-x*48,-y*64)
    lg.setCanvas()
    return out
end
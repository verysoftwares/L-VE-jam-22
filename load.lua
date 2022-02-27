function love.load()
    fontz= {}
    fontz.xillapro= lg.newFont('wares/Xilla Pro Regular Italic.otf', 29)
    fontz.digidisco= lg.newFont('wares/DigitalDisco-Thin.ttf', 16)
    fontz.credits2= lg.newFont('wares/2Credits.ttf', 16)
    fontz.cursive= lg.newFont('wares/Cursive.ttf', 17*2*2)
    --lg.setFont(fontz.cursive)
    icons={}
    icons.icons=lg.newImage('wares/icons.png')
    icons.miner=stamp12(icons.icons,0,0)
end

function stamp12(img,x,y)
    local out=lg.newCanvas(12,12)
    lg.setCanvas(out)
    fg(1,1,1,1)
    lg.draw(img,-x*12,-y*12)
    lg.setCanvas()
    return out
end
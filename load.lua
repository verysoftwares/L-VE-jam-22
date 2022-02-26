function love.load()
    fontz= {}
    fontz.xillapro= lg.newFont('wares/Xilla Pro Regular Italic.otf', 29)
    fontz.digidisco= lg.newFont('wares/DigitalDisco-Thin.ttf', 16)
    fontz.credits2= lg.newFont('wares/2Credits.ttf', 16)
    fontz.cursive= lg.newFont('wares/Cursive.ttf', 17*2*2)
    lg.setFont(fontz.xillapro)
    --lg.setFont(fontz.cursive)
end
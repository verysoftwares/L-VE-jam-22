--[[  love.draw functionality.  ]]--


-- draw setup
    lg.setDefaultFilter('nearest')
    main= lg.newCanvas(sw,sh)
    logo= lg.newCanvas(sw,sh)
    --logofade= lg.newCanvas(sw,sh)

function logodraw()
    lg.setCanvas(main)
    bg(.9 +.4* ( t     *.1 *.2 *.6) %1, 
       .8 +.4* ((t+16) *.1 *.2 *.6) %1, 
       .6 +.4* ((t+24) *.1 *.2 *.6) %1, 
       1)

    lg.setCanvas(logo)
      bg(1,1,1,0)
      --fg(1,1,1,0.1)
        --rect('fill',0,0,sw,sh)
    lg.setFont(fontz.xillapro)
    local msg= 'verysoftwares'
    local fnt= lg.getFont()
    local fw,fh= fnt:getWidth(msg),fnt:getHeight(msg)
    local mx,my= 0,0
    for c=1,#msg do
    local char= sub(msg,c,c)
    local shine= 0.2--+.2*sin(c+t*0.02)

    fg(shine+ .4+.2* sin(.14 *t      +.8*c),
       shine+ .4+.2* sin(.14 *(t+16) +.8*c),
       shine+ .4+.2* sin(.14 *(t+24) +.8*c),
       1)
        lg.print(char,1+ sw/2-fw/2+mx,1+sh/2-fh/2 
                  +  12* sin(12*5+ 1.1* (.1*t + .4*c)) 
                    + 6* sin(12*5+ 1.1* (.2*t + .6*c)))
    fg(shine+ .8+.2* sin(.14 *t      +.8*c),
       shine+ .8+.2* sin(.14 *(t+16) +.8*c),
       shine+ .8+.2* sin(.14 *(t+24) +.8*c),
       1)
        lg.print(char,sw/2-fw/2+mx,sh/2-fh/2 
                  +  12* sin(12*5+ 1.1* (.1*t + .4*c)) 
                    + 6* sin(12*5+ 1.1* (.2*t + .6*c)))

    mx= mx+fnt:getWidth(char)
    end

    lg.setCanvas()
        lg.draw(main,0,0,0,scale,scale)

    --lg.setCanvas(logofade)
      --fg(1,1,1,.1)
        --lg.draw(logo,0,0,0,2,2)

    lg.setCanvas()
        fg(1,1,1,1)
          --lg.draw(logofade,0,0,0,1.2,1.2)
            lg.draw(logo    ,0,0,0,scale,scale)

    -- screenshots 60 FPS to appdata folder
      -- lg.captureScreenshot(fmt('%d.png',t))
    if t>110 then
      love.draw = gamedraw
    end
end

function gamedraw()
    lg.setCanvas(main)
    bg(0.64,0.32,0.32)
    for k,b in pairs(board) do
        if b.type~='stack' then
            carddraw(b)
        end
    end
    local keys={}
    for k,b in pairs(board) do ins(keys,k) end
    table.sort(keys,function(a,b) return tonumber(sub(a,string.find(a,':')+1,#a))<tonumber(sub(b,string.find(b,':')+1,#b)) end)
    for i,k in ipairs(keys) do
        local b=board[k]
        if b.type=='stack' then
        for i,v in ipairs(b[1]) do
            carddraw(v,i,b[1][1])
        end
        end
    end
    if active then
        if active.type=='stack' then
        for i,v in ipairs(active[1]) do
        carddraw(v,i,{x=mox,y=moy})
        end
        else
        carddraw(active,nil,{x=mox,y=moy})
        end
    end
    lg.setCanvas()
    fg(1,1,1,1)
    lg.draw(main,0,0,0,2,2)
end

function carddraw(v,i,orig)
    orig=orig or v
    i=i or 1
    fg(0.32,0.16,0.16,1)
    rect('fill',orig.x,orig.y-(i-1)*2,48,64)
    fg(0.8,0.8,0.8,1)
    if v.type=='miner' then fg(0.4,0.8,0.4,1) end
    rect('fill',orig.x+1,orig.y+1-(i-1)*2,48-2,64-2)
    if v.type=='miner' then lg.draw(icons.miner,orig.x+24-6,orig.y+20) end
    fg(0.32,0.16,0.16,1)
    if v.type~='miner' then 
        lg.setFont(fontz.credits2)
        lg.print(v.type,orig.x+24-fontz.credits2:getWidth(v.type)/2,orig.y+20) 
    end
end

love.draw= logodraw
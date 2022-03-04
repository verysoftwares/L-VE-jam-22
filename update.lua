--[[  managing game flow updates.  ]]--

function strpos(pos)
    local delim=string.find(pos,':')
    local x=sub(pos,1,delim-1)
    local y=sub(pos,delim+1)
    --important tonumber calls
    --Lua will handle a string+number addition until it doesn't
    return tonumber(x),tonumber(y)
end

function posstr(x,y)
    return fmt('%d:%d',x,y)
end

function reset()
    score=0
    step=0
    goal=50
    goaladd=100

    board = {}
    local h=0
    for i=1,7,2 do
    for j=1,i do
        local pos=posstr(flr(-i/2+j),h)
        board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24,flip=true}
        board[pos].type=randomchoice({'20','20','20','50','50','100'})
        if pos=='0:3' then
            board[pos].type='miner'
            board[pos].flip=false
        end
    end
    h=h+1
    end
    for i=5,1,-2 do
    for j=1,i do
        local pos=posstr(flr(-i/2+j),h)
        board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24,flip=true}
        board[pos].type=randomchoice({'20','20','20','50','50','100'})
    end
    h=h+1
    end
end

reset()

function update(dt)
    if tapped('escape') then love.event.push('quit') end

    leftheld=leftclick
    leftclick=love.mouse.isDown(1)
    rightheld=rightclick
    rightclick=love.mouse.isDown(2)
    mox,moy=love.mouse.getPosition()
    mox=mox/scale; moy=moy/scale

    if rightclick and not rightheld then
        if active then board[active.oldpos]=active; active=nil end
    end
    if leftclick and not leftheld then
        local h=0
        for i=1,7,2 do
        for j=1,i do
            if AABB(mox,moy,1,1,sw/2-12-i/2*48+j*48,h*64+24,48,64) then
            click(i,j,h)
            end
        end
        h=h+1
        end
        for i=5,1,-2 do
        for j=1,i do
            if AABB(mox,moy,1,1,sw/2-12-i/2*48+j*48,h*64+24,48,64) then
            click(i,j,h)
            end
        end
        h=h+1
        end
    end

    t = t+1
end

function miner_adjacent(pos)
    local sx,sy=strpos(pos)
    for i,v in ipairs({posstr(sx+1,sy),posstr(sx-1,sy),posstr(sx,sy+1),posstr(sx,sy-1)}) do
    if board[v] and board[v].type=='miner' then
        local sx2,sy2=strpos(v)
        cur_miner_nb={posstr(sx2+1,sy2),posstr(sx2-1,sy2),posstr(sx2,sy2+1),posstr(sx2,sy2-1)}
        return true
    end
    end
    return false
end

function oldpos_adjacent(pos)
    local px,py=strpos(active.oldpos)
    places={posstr(px,py),posstr(px+1,py),posstr(px-1,py),posstr(px,py+1),posstr(px,py-1)}
    if board[posstr(px+1,py)] then ins(places,posstr(px+2,py)) end
    if board[posstr(px-1,py)] then ins(places,posstr(px-2,py)) end
    if board[posstr(px,py+1)] then ins(places,posstr(px,py+2)) end
    if board[posstr(px,py-1)] then ins(places,posstr(px,py-2)) end
    return find(places,pos)
end

function leaped(pos)
    local px,py=strpos(active.oldpos)
    return find({posstr(px+2,py),posstr(px-2,py),posstr(px,py+2),posstr(px,py-2)},pos)
end

function collect(pos)
    if board[pos].type=='stack' then
        score=score+tonumber(board[pos][1][#board[pos][1]].type)*#board[pos][1]
    else
        score=score+tonumber(board[pos].type)
    end
    audio.cashin:play()
    board[pos]=nil
end

function click(i,j,h)
    local pos=posstr(flr(-i/2+j),h)
    if not active then
        if board[pos] and miner_adjacent(pos) then
            if board[pos].flip then 
            board[pos].flip=false; board[pos].flipanim=1; inc_step() 
            else
            active=board[pos]
            active.oldpos=pos
            board[pos]=nil
            end
        elseif board[pos] and board[pos].type=='miner' then
        active=board[pos]
        active.oldpos=pos
        board[pos]=nil
        end
    else
    if board[pos] then
        if active.type~='miner' then
            if cur_miner_nb and not find(cur_miner_nb,pos) then return end
            if board[pos].type=='stack' then
                if active.type=='stack' then
                for i,v in ipairs(active[1]) do
                ins(board[pos][1],v)
                end
                else
                ins(board[pos][1],active)
                end
                if active.oldpos~=pos then inc_step() end
                active=nil
            else
                if not board[pos].flip then
                if active.type=='stack' then
                board[pos]={type='stack',{board[pos]}}
                for i,v in ipairs(active[1]) do
                    ins(board[pos][1],v)
                end
                if active.oldpos~=pos then inc_step() end
                active=nil
                else
                board[pos]={type='stack',{board[pos],active}}
                if active.oldpos~=pos then inc_step() end
                active=nil
                end
                end
            end
        end
    else
        if cur_miner_nb and active.type~='miner' and not find(cur_miner_nb,pos) then return end
        if active.type=='stack' then
        board[pos]={type='stack',{board[pos]}}
        for u,v in ipairs(active[1]) do
            ins(board[pos][1],v)
            v.x=sw/2-12-i/2*48+j*48; v.y=h*64+24
        end
        if active.oldpos~=pos then inc_step() end
        active=nil
        else
        if active.type~='miner' or (active.type=='miner' and oldpos_adjacent(pos)) then
        local l=leaped(pos)
        if active.type=='miner' and leaped(pos) then
            local ox,oy=strpos(active.oldpos)
            if l==1 then collect(posstr(ox+1,oy)) end
            if l==2 then collect(posstr(ox-1,oy)) end
            if l==3 then collect(posstr(ox,oy+1)) end
            if l==4 then collect(posstr(ox,oy-1)) end
        end
        board[pos]=active
        active.x=sw/2-12-i/2*48+j*48; active.y=h*64+24
        if active.oldpos~=pos then inc_step() end
        active=nil
        end
        end
    end
    end
end

function earthquake()
    c=c or 1
    d=0
    e=e or 1
    if (t-sc_t)>30 and (t-sc_t)<=102 and (t-sc_t)%3==0 then
        local h=0
        for i=1,7,2 do
        for j=1,i do
            local pos=posstr(flr(-i/2+j),h)
            if board[pos] and board[pos].type~='miner' then board[pos]=nil end
            d=d+1
            if d>c then goto skip end
        end
        h=h+1
        end
        for i=5,1,-2 do
        for j=1,i do
            local pos=posstr(flr(-i/2+j),h)
            if board[pos] and board[pos].type~='miner' then board[pos]=nil end
            d=d+1
            if d>c then goto skip end
        end
        h=h+1
        end
        ::skip::
        c=c+1
    end
    if (t-sc_t)>102 and (t-sc_t)%3==0 then
        local h=0
        for i=1,7,2 do
        for j=1,i do
            local pos=posstr(flr(-i/2+j),h)
            if not board[pos] then
            board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24,flip=true}
            board[pos].type=randomchoice({'20','20','20','50','50','100'})
            end
            d=d+1
            if d>e then goto skip end
        end
        h=h+1
        end
        for i=5,1,-2 do
        for j=1,i do
            local pos=posstr(flr(-i/2+j),h)
            if not board[pos] then
            board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24,flip=true}
            board[pos].type=randomchoice({'20','20','20','50','50','100'})
            end
            d=d+1
            if d>e then goto skip end
        end
        h=h+1
        end
        ::skip::
        e=e+1
    end
    if e==25 then
    c=nil; e=nil; step=0; love.update=postquake; sc_t=t+1
    end
    t=t+1
end

function inc_step()
    step=step+1
    if step==25 then love.update=earthquake; sc_t=t+1 end
end

function postquake()
    if t-sc_t>=180 then
        if goal>score then
            if love.keyboard.isDown('r') then reset(); love.update=update end
        else
            leftheld=leftclick
            leftclick=love.mouse.isDown(1)
            if leftclick and not leftheld then 
                love.update=update
                goal=score+50+goaladd
                goaladd=goaladd+100
            end
        end
    end
    t=t+1
end

love.update= update

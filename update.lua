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

board = {}
local h=0
for i=1,7,2 do
for j=1,i do
    local pos=posstr(flr(-i/2+j),h)
    board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24}
    board[pos].type=randomchoice({'20','50','100'})
    if pos=='0:3' then
        board[pos].type='miner'
    end
end
h=h+1
end
for i=5,1,-2 do
for j=1,i do
    local pos=posstr(flr(-i/2+j),h)
    board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24}
    board[pos].type=randomchoice({'20','50','100'})
end
h=h+1
end

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

function click(i,j,h)
    local pos=posstr(flr(-i/2+j),h)
    if not active then
    active=board[pos]
    active.oldpos=pos
    board[pos]=nil
    else
    if board[pos] then
        if board[pos].type=='stack' then
            if active.type=='stack' then
            for i,v in ipairs(active[1]) do
            ins(board[pos][1],v)
            end
            else
            ins(board[pos][1],active)
            end
        else
            if active.type=='stack' then
            board[pos]={type='stack',{board[pos]}}
            for i,v in ipairs(active[1]) do
                ins(board[pos][1],v)
            end
            else
            board[pos]={type='stack',{board[pos],active}}
            end
        end
        active=nil
    end
    end
end

love.update= update

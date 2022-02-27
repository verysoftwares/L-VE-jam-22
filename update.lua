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
end
h=h+1
end
for i=5,1,-2 do
for j=1,i do
    local pos=posstr(flr(-i/2+j),h)
    board[pos]={x=sw/2-12-i/2*48+j*48,y=h*64+24}
end
h=h+1
end

function update(dt)
    if tapped('escape') then love.event.push('quit') end

    leftheld=leftclick
    leftclick=love.mouse.isDown(1)
    mox,moy=love.mouse.getPosition()
    mox=mox/scale; moy=moy/scale

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
    board[pos]=nil
    else
    if board[pos] then
        if board[pos].type=='stack' then
            ins(board[pos][1],active)
        else
            board[pos]={type='stack',{board[pos],active}}
        end
        active=nil
    end
    end
end

love.update= update

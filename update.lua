--[[  managing game flow updates.  ]]--

board = {}
local h=0
for i=1,7,2 do
for j=1,i do
    ins(board,{x=sw/2-12-i/2*48+j*48,y=h*64+24})
end
h=h+1
end
for i=5,1,-2 do
for j=1,i do
    ins(board,{x=sw/2-12-i/2*48+j*48,y=h*64+24})
end
h=h+1
end

function update(dt)
    if tapped('escape') then love.event.push('quit') end

    t = t+1
end

love.update= update

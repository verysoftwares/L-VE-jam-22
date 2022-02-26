--[[  managing game flow updates.  ]]--

function update(dt)
    if tapped('escape') then love.event.push('quit') end

    t = t+1
end

love.update= update

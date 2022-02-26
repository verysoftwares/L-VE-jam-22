--[[  file linking.  ]]--

-- load engine internals.
    -- conf.lua is first included by Löve.
    require 'load'
    require 'alias'
    require 'utility'
    require 'deep'
-- manage Löve state:
    require 'draw'
    require 'update'


--[[  runtime.  ]]--

t = 0
print(fmt('build no. %d',build))
print(fmt('.-* made by verysoftwares with LOVE %d.%d .-*', love.getVersion()))

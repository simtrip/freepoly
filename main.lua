class = require('lib.middleclass')
require('placer')

local placer = Placer:new()

function love.load(arg)
end

function love.update(dt)
end

function love.draw()
    placer:draw()
end

function love.mousepressed(mx,my,btn)
    placer:mousepressed(mx,my,btn)
end

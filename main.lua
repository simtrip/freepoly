camera = require('lib.camera')
vector = require('lib.vector')
class = require('lib.middleclass')
utility = require('lib.utility')
imgMan = require ('lib.image_manager')

require('placer')

local placer = Placer:new()

function love.load(arg)
    local data = {1,3,4,6,8,9,15,12}
    local insert = 11
    local result,pos = utility.binarySearch(data,insert)
end

function love.update(dt)
    placer:update(dt)
end

function love.draw()
    placer:draw()

    love.graphics.setColor(255,255,255,255)
    love.graphics.print(love.timer.getFPS(),10,10)
    love.graphics.print(collectgarbage('count'),10,30)
end

function love.mousepressed(mx,my,btn)
    placer:mousepressed(mx,my,btn)
end

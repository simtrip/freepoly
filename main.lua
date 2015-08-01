camera = require('lib.camera')
vector = require('lib.vector')
class = require('lib.middleclass')
utility = require('lib.utility')
imgMan = require ('lib.image_manager')

local l = require('logger')
--Set log level here (debug) till we have a more elegant way
l.level = 4

local vMajor, vMinor, revision, name = love.getVersion()
l.log(string.format("Running love2d version %d.%d.%d - %s", vMajor, vMinor, revision, name), l.INFO)
assert(vMinor >= 9, "love2d version too old, 0.9 or higher required")

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

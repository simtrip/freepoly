camera = require('lib.camera')
vector = require('lib.vector')
class = require('lib.middleclass')
utility = require('lib.utility')
imgMan = require ('lib.image_manager')
Gamestate = require('lib.gamestate')

--Gamestates
require('editor')



function love.load(arg)
    --Pass love2d events and callbacks to Gamestate
    Gamestate.registerEvents()
    Gamestate.switch(editor)
end

function love.update(dt)
end

function love.draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.print(love.timer.getFPS(),10,10)
    love.graphics.print(collectgarbage('count'),10,30)
end

function love.mousepressed(mx,my,btn)
end

--Gamestate declaration
editor = {}
--Class requirements
require ('shape')
require('combo')
require('placer')
--First-time state initialization
function editor:init()
    self.settings = {
        drawMode = 1,
        selectedShape =1,
        gridSize = 32
    }
    self.shapes = {}
    self.states = {}


    --Widgets come after all declarations since we pass our table to it
    self.widgets = {
        modeSelector = Combo:new(self,10,650,2),
        placer = Placer:new(self,10,10)
    }
end

--Update callback
function editor:update(dt)
    for i,v in pairs(self.widgets) do
        if v.update then v:update(dt) end
    end
end

--Draw callback
function editor:draw()
    for i,v in pairs(self.widgets) do
        if v.draw then v:draw() end
    end
end

--Mousepressed
function editor:mousepressed(mx,my,btn)
    for i,v in pairs(self.widgets) do
        if v.mousepressed then v:mousepressed(mx,my,btn) end
    end
end
--Mousereleased
function editor:mousereleased(mx,my,btn)
    for i,v in pairs(self.widgets) do
        if v.mousereleased then v:mousepressed(mx,my,btn) end
    end
end

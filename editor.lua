--Gamestate declaration
editor = {}
--Class requirements
require ('shape')
require('combo')
require('placer')
--Logger
local l = require('logger')
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
        modeSelector = Combo:new(10,650,5),
        placer = Placer:new(10,10)
    }
end

--Gets & Sets
function editor:getSelectedShape()
    local s = self.shapes[self.settings.selectedShape]
    if s then return s else l.log("There is no selection!",4) end
end

function editor:selectShapeByIndex(index)
    if self.shapes[index] then
        self.settings.selectedShape = index
    else l.log("Select: Shape at index "..index.." does not exist!",4) end
end

function editor:selectShapeAt(x,y)
    --This is lazy right now. If two shapes have the same bounds it only grabs the oldest.
    for i,v in ipairs(self.shapes) do
        if utility.point2Box(x,y,v.bounds.pos.x,v.bounds.pos.y,v.bounds.size.x,v.bounds.size.y)
        then
            self:selectShapeByIndex(i)
            break
        end
    end
end

function editor:newShape(select)
    local select = select or true
    --if select, select the new shape immediately
    table.insert(self.shapes,Shape:new())
    if select then self:selectShapeByIndex(table.getn(self.shapes)) end
end

function editor:deleteShape(index)
    index = index or self.settings.selectedShape
    table.remove(self.shapes,index)
    self:selectShapeByIndex(table.getn(self.shapes))
end

function editor:deleteShapeAt(x,y)
    self:selectShapeAt(x,y)
    self:deleteShape()
end

function editor:addVertexAt(x,y)
    self:getSelectedShape():addVertex(x,y)
end

function editor:deleteVertexAt(x,y)
    --Searches vertices of selected shape to attempt a removal at specified coords
    local shape = self:getSelectedShape()
    local found = false

    for i,v in ipairs(shape.vertices) do
        if v.pos.x == x and v.pos.y == y then
            found = true
            shape:deleteVertexByIndex(i)
            break
        end
    end
    if not found then l.log("Removal: Vertex at: "..x..", "..y.." not found!",2) end
end

---CALLBACKS
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

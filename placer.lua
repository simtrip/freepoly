Placer = class('Placer')
require ('Shape')

function Placer:initialize()
    self.shapes = {}
    self.curIndex = 0
    self.drawing = false
    self:startDrawing()
end

function Placer:startDrawing()
    local s = Shape:new()
    table.insert(self.shapes,s)
    self.drawing = true
    self.curIndex = self.curIndex+1
end

function Placer:mousepressed(mx,my,btn)
    if btn=='l' then
        if not self.drawing then
            self:startDrawing()
        end
        self.shapes[self.curIndex]:addVertex(mx,my)
    end

    if btn=='r' then
        if self.drawing then
            self:stopDrawing()
        end
    end
end


function Placer:stopDrawing()
    self.drawing = false
end

function Placer:draw()
    for i=1,table.getn(self.shapes) do
        self.shapes[i]:draw()
    end
end

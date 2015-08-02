Combo = class('Combo')

function Combo:initialize(editor,x,y,numItems)
    --Handle editor args
    self.settings = editor.settings
    --Handle class-specific args
    self.pos = vector(x,y)
    self.numItems = numItems

    --Grab settings from editor
    self.selectedItem = self.settings.drawMode

    self.itemSize = 32
    self.size = vector(self.itemSize*self.numItems,self.itemSize)
    self.colors = {
        unselected = {150,150,150,255},
        selected = {255,255,255,255}
    }
end

function Combo:setSelected(sIndex)
    self.selectedItem = sIndex
    self.settings.drawMode = self.selectedItem
end

function Combo:mousepressed(mx,my,btn)
    for i=0,self.numItems-1 do
        if utility.point2Box(mx,my,self.pos.x+i*self.itemSize,self.pos.y,self.itemSize,self.itemSize) then
            self:setSelected(i+1)
            break
        end
    end
end

function Combo:draw()
    for i=0,self.numItems-1 do
        if self.selectedItem == i+1 then
            love.graphics.setColor(self.colors.selected)
        else
            love.graphics.setColor(self.colors.unselected)
        end
        love.graphics.rectangle('fill',self.pos.x+i*self.itemSize,self.pos.y,self.itemSize,self.itemSize)
        love.graphics.rectangle('line',self.pos.x+i*self.itemSize,self.pos.y,self.itemSize,self.itemSize)
    end
end

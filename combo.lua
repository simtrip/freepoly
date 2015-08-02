Combo = class('Combo')
local editor = editor

function Combo:initialize(x,y,numItems)
    --Handle class-specific args
    self.pos = vector(x,y)
    self.numItems = numItems

    --Grab settings from editor
    self.selectedItem = editor.settings.drawMode

    self.itemSize = 32
    self.size = vector(self.itemSize*self.numItems,self.itemSize)
    self.colors = {
        unselected = {150,150,150,255},
        selected = {255,255,255,255},
        outline = {50,50,50,255}
    }
    self.images = {
        imgMan:load('select_shape'),
        imgMan:load('add_shape'),
        imgMan:load('delete_shape'),
        imgMan:load('add_vertex'),
        imgMan:load('delete_vertex')
    }

end

function Combo:setSelected(sIndex)
    self.selectedItem = sIndex
    editor.settings.drawMode = self.selectedItem
end

function Combo:mousepressed(mx,my,btn)
    for i=0,self.numItems-1 do
        if utility.point2Box(mx,my,self.pos.x+i*self.itemSize,self.pos.y,self.itemSize,self.itemSize) then
            self:setSelected(i+1)
            break
        end
    end
end

function Combo:update(dt)
    self.selectedItem = editor.settings.drawMode
end

function Combo:draw()
    for i=0,self.numItems-1 do
        if self.selectedItem == i+1 then
            love.graphics.setColor(self.colors.selected)
        else
            love.graphics.setColor(self.colors.unselected)
        end
        love.graphics.rectangle('fill',self.pos.x+i*self.itemSize,self.pos.y,self.itemSize,self.itemSize)
        love.graphics.setColor(self.colors.outline)
        love.graphics.rectangle('line',self.pos.x+i*self.itemSize,self.pos.y,self.itemSize,self.itemSize)
        --Draw images
        love.graphics.setColor(255,255,255,255)
        love.graphics.draw(self.images[i+1],self.pos.x+i*self.itemSize,self.pos.y)
    end
end

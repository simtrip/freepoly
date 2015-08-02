Placer = class('Placer')
local editor = editor
 -- this line is OK as long as Editor requires Placer.


function Placer:initialize(x,y)
    self.pos = vector(x,y) --The position to display the placer

    --Class specific variables
    self.size = vector(1240,600) -- The size of the placer's viewport
    self.canvas = love.graphics.newCanvas(self.size.x,self.size.y)
    self.camera = camera(0,0)
    self.drawing = false
end

function Placer:snapToGrid(wx,wy)
    gx = utility.round(wx / editor.settings.gridSize,0) * editor.settings.gridSize
    gy = utility.round(wy / editor.settings.gridSize,0) * editor.settings.gridSize
    return gx,gy
end

function Placer:mousepressed(mx,my,btn)
    if utility.point2Box(mx,my,self.pos.x,self.pos.y,self.size.x,self.size.y) then
        wx,wy = self.camera:worldCoords(mx,my)
        gx,gy = self:snapToGrid(wx,wy)

        --HAHA MAGIC NUMBERS! YOU LOVE IT CHEESE
        if editor.settings.drawMode == 1 then
            --select
            editor:selectShapeAt(gx,gy)
        end
        if editor.settings.drawMode == 2 then
            --new shape
            editor:newShape(true)
            editor:addVertexAt(gx,gy)
            editor.settings.drawMode = 4
        end
        if editor.settings.drawMode == 3 then
            --delete shape
            editor:deleteShapeAt(gx,gy)
        end
        if editor.settings.drawMode == 4 then
            --add vertex
            editor:addVertexAt(gx,gy)
        end
        if editor.settings.drawMode == 5 then
            --delete vertex
            editor:deleteVertexAt(gx,gy)
        end
    end
end

function Placer:update(dt)
    local cameraSpeed = 200
    --KEYBOARD CAMERA MOVEMENT
    if love.keyboard.isDown('w') then self.camera:move(0,-cameraSpeed*dt) end
    if love.keyboard.isDown('s') then self.camera:move(0,cameraSpeed*dt) end
    if love.keyboard.isDown('a') then self.camera:move(-cameraSpeed*dt,0) end
    if love.keyboard.isDown('d') then self.camera:move(cameraSpeed*dt,0) end
end

function Placer:draw()
    local mx,my = love.mouse.getX(),love.mouse.getY()
    local mgx,mgy = self:snapToGrid(self.camera:worldCoords(mx,my))
    --SET canvas
    love.graphics.setCanvas(self.canvas)
    self.canvas:clear(0,0,0,0)
    --ATTACH CAMERA
    self.camera:attach()
    --Draw grid

    --Draw shapes


    for i,v in ipairs(editor.shapes) do
        if i == editor.settings.selectedShape then
            love.graphics.setColorMask(false,true,true,true)
        else
            love.graphics.setColorMask(true,true,true,true)
        end
        v:draw()
    end
    love.graphics.setColorMask(true,true,true,true)

    --Draw grid-snapped cursor
    love.graphics.circle('fill',mgx,mgy,2)

    --UNSET CANVAS
    love.graphics.setCanvas()
    --DETACH CAMERA
    self.camera.detach()
    --UI
    love.graphics.print("mouse (Screen): "..love.mouse.getX()..", "..love.mouse.getY(),0,70)
    love.graphics.print("mouse (Grid): "..mgx..", "..mgy,0,90)

    --draw canvas
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.canvas,self.pos.x,self.pos.y)
    --Draw bounds of canvas
    love.graphics.setColor(70,70,70,255)
    love.graphics.rectangle('line',self.pos.x,self.pos.y,self.size.x,self.size.y)

end

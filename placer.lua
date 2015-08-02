Placer = class('Placer')

function Placer:initialize(editor,x,y)

    --Handle args
    self.settings = editor.settings
    self.shapes = editor.shapes
    self.pos = vector(x,y) --The position to display the placer

    --Class specific variables
    self.size = vector(800,600) -- The size of the placer's viewport
    self.canvas = love.graphics.newCanvas(self.size.x,self.size.y)
    self.camera = camera(0,0)
    self.drawing = false
    self:startDrawing()
end

function Placer:snapToGrid(wx,wy)
    gx = utility.round(wx / self.settings.gridSize,0) * self.settings.gridSize
    gy = utility.round(wy / self.settings.gridSize,0) * self.settings.gridSize
    return gx,gy
end


function Placer:startDrawing()
    local s = Shape:new()
    table.insert(self.shapes,s)
    self.drawing = true
    self.curIndex = self.settings.selectedShape+1
end

function Placer:mousepressed(mx,my,btn)
    --check for click within canvas area
    if utility.point2Box(mx,my,self.pos.x,self.pos.y,self.size.x,self.size.y)
    then
        mx,my = self.camera:worldCoords(mx,my)
        if btn=='l' then
            if not self.drawing then
                self:startDrawing()
            end

            self.shapes[self.settings.selectedShape]:addVertex(self:snapToGrid(mx,my))
        end

        if btn=='r' then
            if self.drawing then
                self:stopDrawing()
            end
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

function Placer:stopDrawing()
    self.drawing = false
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
    for i=1,table.getn(self.shapes) do
        self.shapes[i]:draw()
    end
    --SELECTED
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

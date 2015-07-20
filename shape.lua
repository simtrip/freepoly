Shape = class('Shape')
local lmath = love.math
local graphics = love.graphics
local mouse = love.mouse

function Shape:initialize()
    self.vertices = {}
    self.vertexCount = 0
    self.triangles = {}
    self.complete = false
    self.maxVertices = 8
end

function Shape:addVertex(vx,vy)
    vx=vx or 1
    vy=vy or 1
    if not self.complete then
        table.insert(self.vertices,vx)
        table.insert(self.vertices,vy)
        self.vertexCount=self.vertexCount+1

        if self.vertexCount >= self.maxVertices then
            self.complete = true
        end
    end

    if self.complete then
        self:finish()
    end



end

function Shape:finish()
    self.complete = true
    self:buildTriangles()
end

function Shape:removeLastVertex()
    local vn = table.getn(self.vertices)
    if vn > 2 then
        table.remove(self.vertices,vn)
        table.remove(self.vertices,vn-1)
        self.vertexCount=self.vertexCount-1
        return true
    else
        return false
    end
end

function Shape:buildTriangles()
    if self.vertexCount > 2 then
        self.triangles = lmath.triangulate(self.vertices)
        return true
    else
        return false
    end
end



function Shape:draw()
    love.graphics.setLineJoin('bevel')
    local mx,my = mouse.getX(),mouse.getY()
    love.graphics.setColor(255,255,255,255)
    local r,g,b,a = graphics.getColor()

    if self.vertexCount >= 2 then
        --2 or more vertices ALREADY PLACED. Resulting mouseclick will create at least a triangle with the mouse preview
        if self.complete then
            --We're not drawing the mouse preview if it's complete already.
            for i=1,table.getn(self.triangles) do
                graphics.setColor(r,g,b,a-15)
                graphics.polygon('fill',self.triangles[i])
                love.graphics.setColor(200,0,0,255)
                graphics.polygon('line',self.triangles[i])
            end
        else
            local prev = {unpack(self.vertices)}
            table.insert(prev,mx)
            table.insert(prev,my)
            graphics.polygon('fill',prev)
            love.graphics.setColor(200,0,0,255)
            graphics.polygon('line',prev)

        end
    else
        if self.vertexCount < 2 then
                graphics.line(mx,my,unpack(self.vertices))
        end
    end
end

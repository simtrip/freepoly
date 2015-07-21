Shape = class('Shape')
local lmath = love.math
local graphics = love.graphics
local mouse = love.mouse

function Shape:initialize()
    self.vertices = {}
    self.angles = {}
    self.centre = vector(0,0)
    self.bounds = {pos=vector(0,0),size=vector(0,0)}
    self.vertexCount = 0
    self.triangles = {}
    self.complete = false
end

function Shape:addVertex(vx,vy)
    local vertex = {pos=vector(vx,vy),angle=0}
    table.insert(self.vertices,vertex)
    self:calculateCentre()
    self:sortVertices()
    self:buildTriangles()
end

function Shape:calculateCentre(vertices)
    --highX,lowX,highY,lowY
    lx = math.huge
    ly = math.huge
    hx = 0
    hy = 0

    for i,v in ipairs(self.vertices) do
        if v.pos.x < lx then lx = v.pos.x end
        if v.pos.x > hx then hx = v.pos.x end
        if v.pos.y < ly then ly = v.pos.y end
        if v.pos.y > hy then hy = v.pos.y end
    end
    local cx = math.floor((lx+hx+1)/2)
    local cy = math.floor((ly+hy+1)/2)

    self.centre = vector(cx,cy)
    self.bounds.pos = vector(lx,ly)
    self.bounds.size = vector(hx-lx,hy-ly)
end


function Shape:sortVertices()
    --Calculate angle to centre for each vertex
    for i,v in ipairs(self.vertices) do
        v.angle = math.atan2(self.centre.y-v.pos.y, self.centre.x-v.pos.x)
    end
    --Function to sort vertices by angle
    function byAngle (a,b)
        if a.angle == b.angle then
            --Vertices are on the same line. return the closest vertices
            return a.pos:len() < b.pos:len()
        else
            return a.angle < b.angle
        end
    end
    table.sort(self.vertices,byAngle)


    for i,v in ipairs(self.vertices) do
        --print (i.." -".." X: "..v.pos.x.." Y: "..v.pos.y.." A: "..v.angle)
    end
    --print("\n")

end

function Shape:finish()
    self.complete = true
    self:buildTriangles()
end

function Shape:buildTriangles()
    local rawvert = {}
    if table.getn(self.vertices) >= 3 then
        for i,v in ipairs(self.vertices) do
            table.insert(rawvert,v.pos.x)
            table.insert(rawvert,v.pos.y)
        end
        self.triangles = lmath.triangulate(rawvert)
    end

end



function Shape:removeLastVertex()
end

function Shape:draw()
    --mousecoords
    local mx,my = love.mouse.getX(), love.mouse.getY()
    --Draw bounds
    love.graphics.setColor(0,150,50,255)
    love.graphics.rectangle('line',self.bounds.pos.x,self.bounds.pos.y,self.bounds.size.x,self.bounds.size.y)
    --Draw Polys
    local counter = 0
    for i,v in ipairs(self.triangles) do
        love.graphics.setColor(255,255,255,255)
        love.graphics.polygon('fill',v)
        love.graphics.setColor(200,0,0,255)
        love.graphics.polygon('line',v)
        counter=counter+1
    end
    --Draw centre
    --love.graphics.setColor(0,150,50,255)
    --love.graphics.circle('fill',self.centre.x,self.centre.y,3)

    local vcount = table.getn(self.vertices)
    if vcount == 1 then
        love.graphics.setColor(255,255,255,255)
        love.graphics.setLineJoin('bevel')
        love.graphics.line(mx,my,self.vertices[1].pos:unpack())
    end
end

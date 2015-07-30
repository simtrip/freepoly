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
    self:build()
end

function Shape:build()
    self:calculateCentre()
    self:sortVertices()
    self:removeRedundantVertices()
    self:buildTriangles()
end

function Shape:calculateCentre(vertices)
    --highX,lowX,highY,lowY
    lx = math.huge
    ly = math.huge
    hx = -math.huge
    hy = -math.huge

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
end

--mmmmm ghetto
function Shape:sortVertices()
end

function Shape:removeRedundantVertices()
    --Assumes sorted vertices
    local deletion = {}

    for i,v in ipairs(self.vertices) do
        local next1 = self.vertices[i+1] or self.vertices[i+1-table.getn(self.vertices)]
        local next2 = self.vertices[i+2] or self.vertices[i+2-table.getn(self.vertices)]


        if next1 then
            if next1.pos.x == v.x and next1.pos.y == v.y then
                table.insert(deletion,i+1)
                print("duplicate vertex")
            end
        end

        if next1 and next2 then
            local angleN1 = math.atan2(v.pos.y-next1.pos.y,v.pos.x-next1.pos.x)
            local angleN2 = math.atan2(v.pos.y-next2.pos.y,v.pos.x-next2.pos.x)
            if angleN1 == angleN2 then
                table.insert(deletion,i+1)
                print("adjacent angle")
            end
        end
    end

    for i,v in ipairs(deletion) do
        table.remove(self.vertices,v)
    end
end

function Shape:finish()
    self.complete = true
    self:buildTriangles()
end

function Shape:buildTriangles()
    --clear triangles, fuck em all
    for i,v in ipairs(self.triangles) do
        v = nil
    end

    local rawvert = {}
    if table.getn(self.vertices) >= 3 then
        for i,v in ipairs(self.vertices) do
            table.insert(rawvert,v.pos.x)
            table.insert(rawvert,v.pos.y)
        end
        result,tempTriangles = pcall(function() return lmath.triangulate(rawvert); end)
		if result then
			self.triangles = tempTriangles
		end
    end
end


function Shape:join(joinShape)
    for i,v in joinShape.vertices do
        table.insert(self.vertices,v)
    end
    self:build()
end


function Shape:removeLastVertex()
end

function Shape:draw()
    --Draw bounds
    love.graphics.setColor(0,150,50,255)
    love.graphics.rectangle('line',self.bounds.pos.x,self.bounds.pos.y,self.bounds.size.x,self.bounds.size.y)
    --Draw Polys
    local counter = 0
    for i,v in ipairs(self.triangles) do
        love.graphics.setColor(255,255,255,255)
        love.graphics.polygon('fill',v)
        love.graphics.setColor(200,0,0,255)
        love.graphics.setLineJoin('none')
        love.graphics.polygon('line',v)
        counter=counter+1
    end

    --Draw all vertices
    for i,v in ipairs(self.vertices) do
        love.graphics.setColor(200,0,0,255)
        love.graphics.circle('fill',v.pos.x,v.pos.y,4)
        love.graphics.print(i,v.pos.x,v.pos.y)
    end

    --Draw centre
    love.graphics.setColor(0,150,50,255)
    love.graphics.circle('fill',self.centre.x,self.centre.y,3)
end

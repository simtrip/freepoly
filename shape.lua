Shape = class('Shape')
local lmath = love.math
local graphics = love.graphics
local mouse = love.mouse

local l = require('logger')

function Shape:initialize()
    self.vertices = {}
    self.angles = {}
    self.centre = vector(0,0)
    self.bounds = {pos=vector(0,0),size=vector(0,0)}
    self.vertexCount = 0
    self.triangles = {}
	self.freeVertices = {}
    self.complete = false

end

function Shape:addVertex(vx,vy)
    local vertex = {pos=vector(vx,vy),angle=0}
    table.insert(self.vertices,vertex)
    self:build()
end

function Shape:deleteVertexByIndex(index)
	--Get index relative to free vertex list
	fIndex = index - (table.getn(self.vertices) - table.getn(self.freeVertices))
	--If it's less than 1 it's not in the list
	if fIndex > 0 then
		table.remove(self.freeVertices,fIndex)
	end
	table.remove(self.vertices,index)
    self:build()
end

function Shape:build()
    self:calculateCentre()
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

function Shape:removeRedundantVertices()
    --Assumes sorted vertices
    local deletion = {}

    for i,v in ipairs(self.vertices) do
        local next1 = self.vertices[i+1] or self.vertices[i+1-table.getn(self.vertices)]
        local next2 = self.vertices[i+2] or self.vertices[i+2-table.getn(self.vertices)]

        if next1 then
            if next1.pos.x == v.x and next1.pos.y == v.y then
                table.insert(deletion,i+1)
                l.log("Duplicate vertex at " .. v.x .. "x" .. v.y .. ", removing", l.DEBUG)
            end
        end

        if next1 and next2 then
            local angleN1 = math.atan2(v.pos.y-next1.pos.y,v.pos.x-next1.pos.x)
            local angleN2 = math.atan2(v.pos.y-next2.pos.y,v.pos.x-next2.pos.x)
            if angleN1 == angleN2 then
                table.insert(deletion,i+1)
                l.log("Adjacent angled vertex at " .. next1.pos.x .. "x" .. next1.pos.y .. ", removing", l.DEBUG)
            end
        end
    end

    for i,v in ipairs(deletion) do
        --Get index relative to free vertex list, -1 because a new free vertex
		--wouldn't be in the list yet - self.build() is called after this function
		i = v - (table.getn(self.vertices) - table.getn(self.freeVertices) - 1)
		--If it's less than 1 it's not in the list
		if i > 0 then
			table.remove(self.freeVertices,i)
		end

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

        local errorStatus,value = pcall(function() return lmath.triangulate(rawvert) end)

		--Assumes this is only called once each time a vertex is added
		--No errors, polygon is valid and tessellated
		if errorStatus then
			self.triangles = value
			--No free vertices!
			self.freeVertices = {}

		--Not a valid polygon, the latest vertex will not be connected
		else
			table.insert(self.freeVertices,self.vertices[table.getn(self.vertices)])
		end
    end
end

function Shape:join(joinShape)
    for i,v in joinShape.vertices do
        table.insert(self.vertices,v)
    end
    self:build()
end

function Shape:draw()
    --Draw bounds
    --love.graphics.setColor(0,150,50,255)
    --love.graphics.rectangle('line',self.bounds.pos.x,self.bounds.pos.y,self.bounds.size.x,self.bounds.size.y)
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
	love.graphics.setColor(200,0,0,255)
    for i,v in ipairs(self.vertices) do
        love.graphics.circle('fill',v.pos.x,v.pos.y,4)
        love.graphics.print(i,v.pos.x,v.pos.y)
    end

	--Draw free vertices
	love.graphics.setColor(255,255,0,255)
    for i,v in ipairs(self.freeVertices) do
        love.graphics.circle('fill',v.pos.x,v.pos.y,4)
    end

	--Draw connecting lines for free vertices
	local numFreeVertices = table.getn(self.freeVertices)
	if numFreeVertices > 0 then
		love.graphics.setColor(255,255,255,255)
		for i=1,numFreeVertices,1 do
			local p1,p2 = self.freeVertices[i],nil

			--Connect the first free vertex to the last non-free one
			if i == 1 then
				p2 = self.vertices[table.getn(self.vertices) - table.getn(self.freeVertices)]
			else
				p2 = self.freeVertices[i-1]
			end
			love.graphics.line(p1.pos.x,p1.pos.y, p2.pos.x,p2.pos.y)
		end
	end

    --Draw centre
    love.graphics.setColor(0,150,50,255)
    love.graphics.circle('fill',self.centre.x,self.centre.y,3)
end

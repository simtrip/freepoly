button = class('button')

function button:initialize(x,y,label,imagefile)
	self.x = x or 1
	self.y = y or 1
	self.label = label or ""
	self.xpad = 10
	self.ypad = 10
	self.width = fonts.fixed:getWidth(self.label) + self.xpad*2
	self.height = fonts.fixed:getHeight() + self.ypad*2
	self.image = nil or imgMan:load(imagefile)
end

function button:mousepressed(mx,my,btn)
	if mx >= self.x and mx <= self.x+self.width
	and my >= self.y and my <= self.y+self.height
	then
		self:pressed()
	end
end

function button:pressed()
	--Overwrite this on a per-instance basis. How fucking weird and not-OOP!
end


function button:draw()
	if self.image then
		love.graphics.draw(self.image,self.x,self.y)
	end
	love.graphics.setColor(200,200,200,255)
	love.graphics.rectangle('line',self.x,self.y,self.width,self.height)
	love.graphics.setColor(150,150,150,255)
	love.graphics.rectangle('fill',self.x,self.y,self.width,self.height)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(self.label,self.x+self.xpad,self.y+self.ypad)
end

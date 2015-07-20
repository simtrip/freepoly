image_manager = class('image_manager')
local imagepath = "assets/images/"
local imageformat = ".png"

function image_manager:initialize()
	self.images = {}
	setmetatable(self.images,{__mode="v"})
end

function image_manager:load(filename)
	if not self.images[filename] then 
		self.images[filename] = love.graphics.newImage(imagepath..filename..imageformat)
		self.images[filename]:setFilter('nearest','nearest')
	end
	

	return self.images[filename]
end

function image_manager:getFilename(image)
	for i,v in pairs(images) do
		if image == v then return i end
	end
	print("getFilename: Image not found in list")
end

return image_manager:new()
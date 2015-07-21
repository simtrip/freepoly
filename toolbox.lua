Toolbox = class('Toolbox')

function Toolbox:initialize(x,y)
    self.pos = vector(x,y)
    imgMan:newImage()
end

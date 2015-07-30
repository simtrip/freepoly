Enum = class('Enum')

function enum:initialize(...)
    self.names = {} -- indexed table storing names
    self.indices = {} --dictionary storing index of name

    for i,v in args do
        table.insert(self.names,tostring(v))
        self.indices[v] = i
    end
end

function enum:at(arg)
    if type(arg) == 'string' then
        return self.indices[arg]
    end
    if type(arg) == 'number' then
        return self.names[arg]
    end
end

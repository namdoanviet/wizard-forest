Player=Class{__includes=Entity}

function Player:init(def,world,userData)
    Entity.init(self,def,world,userData)
end

function Player:update(dt)
    Entity.update(self,dt)
end

function Player:render()
    Entity.render(self)
end
Entity=Class{}

function Entity:init(def,world,userData)
    self.texture=def.texture
    self.x=def.x
    self.y=def.y
    self.width=def.width
    self.height=def.height
    self.stateMachine=def.stateMachine
    self.direction='left'
    self.world=world
    self.body=love.physics.newBody(self.world,self.x,self.y,'dynamic')
    self.shape=love.physics.newRectangleShape(40, 70)
    self.fixture=love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(userData)
end

function Entity:changeState(state,params)
    self.stateMachine:change(state,params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end



function Entity:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
    math.floor(self.body:getX()), math.floor(self.body:getY()), 0, 
    self.direction == 'right' and 1 or -1, 1, self.width/2, self.height/2)
end
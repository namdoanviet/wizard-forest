Mossy=Class{}

function Mossy:init(world,type,x,y,userData,bodyType)
    self.world=world
    self.x=x 
    self.y=y 
    self.body=love.physics.newBody(self.world,self.x,self.y,bodyType)
    --self.body:setMass(2000)
    self.type=type
    if type == 2 then
        self.width=256
        self.height=128
        self.shape=love.physics.newRectangleShape(180, 90)
        self.fixture=love.physics.newFixture(self.body, self.shape,40)
    else 
        self.width=128
        self.height=128
        self.shape=love.physics.newRectangleShape(90, 90)
        self.fixture=love.physics.newFixture(self.body, self.shape,20)
    end
    self.fixture:setUserData(userData)
end

function Mossy:render()
    love.graphics.draw(gTextures['mossy'], gFrames['mossy'][self.type],
        math.floor(self.body:getX()), math.floor(self.body:getY()), self.body:getAngle(),
        1, 1, self.width/2, self.height/2)
end
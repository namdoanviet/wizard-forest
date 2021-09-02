StartState=Class{__includes=BaseState}

function StartState:init()
    self.world=love.physics.newWorld(0, 0)
    self.background=Background(1)
    self.aliens={}
    self.edgeGroundShape=love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH, 0)
    self.edgeWallShape=love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT*5)
    self.groundBody=love.physics.newBody(self.world,0,VIRTUAL_HEIGHT-64,'static')
    self.wallLeftBody=love.physics.newBody(self.world,0,0,'static')
    self.wallRightBody=love.physics.newBody(self.world,VIRTUAL_WIDTH,0,'static')
    self.groundFixture=love.physics.newFixture(self.groundBody, self.edgeGroundShape)
    self.leftWallFixture=love.physics.newFixture(self.wallLeftBody,self.edgeWallShape)
    self.RightWallFixture=love.physics.newFixture(self.wallRightBody,self.edgeWallShape)
    self.isStarted=false
    Timer.after(0.5,function()
        self.isStarted=true
    end)
end

function StartState:enter(params)
    self.highscore=params.highscore
end

function StartState:update(dt)
    self.world:update(dt)
    Timer.update(dt)
    local touchNumbers=howManyTouches()
    if self.isStarted then
        if  love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') or touchNumbers~=0 then
            gStateMachine:change('begin-game',{
                level=1,
                highscore=self.highscore
            })
        end
    end
    

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    self.background:render()
    
    love.graphics.setColor(100, 200, 150, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.print('Highest Level: '..tostring(self.highscore), 10,10)
    
    love.graphics.setColor(64, 64, 64, 200)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 260, VIRTUAL_HEIGHT / 2-20 ,
        540, 120, 3)

    love.graphics.setColor(200, 200, 200, 255)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Wizard Forest', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    
    
    love.graphics.setColor(200, 200, 200, 255)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Click to start!', 0, VIRTUAL_HEIGHT / 2 + 55, VIRTUAL_WIDTH, 'center')
    for i=0,15 do
        love.graphics.draw(gTextures['mossy'], gFrames['mossy'][1],
        i*96,VIRTUAL_HEIGHT-96)
    end

    love.graphics.draw(gTextures['vietnamflag'],gFrames['vietnamflag'][1],VIRTUAL_WIDTH-32,0)
end
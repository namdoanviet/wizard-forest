Level=Class{}

function Level:init(currentLevel,highscore)
    self.currentLevel=currentLevel
    self.highscore=highscore
    self.world=love.physics.newWorld(0, 600)
    self.player=Player({
        texture='blue-wizard',
        x=VIRTUAL_WIDTH/2-64,y=VIRTUAL_HEIGHT-256,
        width=128,height=128,
        stateMachine=StateMachine{
            ['idle']=function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player) end,
            ['falling'] = function() return PlayerFallingState(self.player) end
        },
    },self.world,'Player')
    self.player:changeState('idle')
    self.destroyedBodies={}
    self.isDead=false
    
    self.mossies={}
    self.timeGap=self.currentLevel*0.1
    self.timeGapMax=math.max(0.5,1.1-self.currentLevel*0.1)
    Timer.every(self.timeGapMax,function()
        table.insert(self.mossies,Mossy(self.world,math.random(2,3),math.random(116)*10-10,-128,'Mossy','dynamic'))
    end)

    function beginContact(a,b,coll)
        self.types={}
        self.types[a:getUserData()]=true
        self.types[b:getUserData()]=true

        if self.types['Player'] and self.types['Mossy'] then
            local playerFixture=a:getUserData()=='Player' and a or b 
            local mossyFixture=a:getUserData()=='Mossy' and a or b 
            local velocityX,velocityY=playerFixture:getBody():getLinearVelocity()
            local playerX,playerY=playerFixture:getBody():getPosition()
            local mossyX,mossyY=mossyFixture:getBody():getPosition()
            local mossyVelX,mossyVelY=mossyFixture:getBody():getLinearVelocity()
            local playerWidth,playerHeight=40,70
            local q,w,mass,r=mossyFixture:getMassData()
            local mossyWidth,mossyHeight=mass*9,90
            if playerX+playerWidth/2>mossyX-mossyWidth/2 and playerX-playerWidth/2<mossyX+mossyWidth/2 and playerY+playerHeight/2>mossyY+mossyHeight/2 and mossyVelY>20  then
                self.isDead=true
                gSounds['death']:play()
            elseif playerX+playerWidth/2>mossyX-mossyWidth/2 and playerX-playerWidth/2<mossyX+mossyWidth/2 and playerY-playerHeight/2<mossyY-mossyHeight/2 then
                if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
                    self.player:changeState('walking')
                else
                    self.player:changeState('idle')
                end
                if playerX+playerWidth/2+25>=VIRTUAL_WIDTH and playerY-playerHeight/2<200 then
                    for k,mossy in pairs(self.mossies) do
                        mossy.body:destroy()
                    end
                    self.mossies={}
                    Timer.clear()
                    gSounds['victory']:play()
                    gStateMachine:change('victory',{
                        background=self.background,
                        level=self.currentLevel,
                        highscore=self.highscore
                    })
                end
                gSounds['bounce']:stop()
                gSounds['bounce']:play()
            end
        end
        
        if self.types['Player'] and self.types['Wall'] then
            gSounds['bounce']:stop()
            gSounds['bounce']:play()
            -- local playerFixture=a:getUserData()=='Player' and a or b 
            -- local obstacleFixture=a:getUserData()=='Wall' and a or b 
            -- local xPos,yPos=playerFixture:getBody():getLinearVelocity()
            -- playerFixture:getBody():setLinearVelocity(0,100)
            self.player:changeState('falling',{
                canInput=false
            })
        end

        if self.types['Player'] and self.types['Ground'] then
            gSounds['bounce']:stop()
            gSounds['bounce']:play()
        end

        if self.types['Mossy'] and self.types['Ground'] then
            local mossyFixture=a:getUserData()=='Mossy' and a or b 
            local velX1,velY1=mossyFixture:getBody():getLinearVelocity()
            if velY1+velX1>600 then
                gSounds['collision']:stop()
                gSounds['collision']:play()
            end
        end


        if self.types['Mossy'] and not self.types['Player'] and not self.types['Ground'] and not self.types['Wall'] then
            local velX1,velY1=a:getBody():getLinearVelocity()
            local velX2,velY2=b:getBody():getLinearVelocity()
            if velY1+velY2>600 then
                gSounds['collision']:stop()
                gSounds['collision']:play()
            end
        end
    end

    function endContact(a,b,coll)

    end

    function preSolve(a,b,coll)

    end

    function postSolve(a,b,coll,normalImpulse,tangentImpulse)

    end

    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    
    
    
    self.edgeGroundShape=love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH, 0)
    self.edgeWallShape=love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT*5)
    self.groundBody=love.physics.newBody(self.world,0,VIRTUAL_HEIGHT-64,'static')
    self.wallLeftBody=love.physics.newBody(self.world,0,-VIRTUAL_HEIGHT,'static')
    self.wallRightBody=love.physics.newBody(self.world,VIRTUAL_WIDTH,-VIRTUAL_HEIGHT,'static')
    self.groundFixture=love.physics.newFixture(self.groundBody, self.edgeGroundShape)
    self.leftWallFixture=love.physics.newFixture(self.wallLeftBody,self.edgeWallShape)
    self.RightWallFixture=love.physics.newFixture(self.wallRightBody,self.edgeWallShape)
    self.groundFixture:setUserData('Ground')
    self.leftWallFixture:setUserData('Wall')
    self.RightWallFixture:setUserData('Wall')
    self.groundFixture:setFriction(0.4)
    -- self.RightWallFixture:setFriction(0.4)
    -- self.leftWallFixture:setFriction(0.4)
    self.background = Background(self.currentLevel)
    self.endMossy=Mossy(self.world,3,VIRTUAL_WIDTH-20,250,'Mossy','static')
    baseX,baseY=180,VIRTUAL_HEIGHT-120
    shiftedX,shiftedY=baseX,baseY
    self.aiming=false
    self.frameFlag=1
    self.isPaused=false
    self.isStared=false
    self.offset=false
    Timer.every(0.5,function()
        self.offset= not self.offset
    end)
    :limit(8)
    :finish(function()
        self.isStared=true
    end)
    Timer.every(0.1,function()
        self.frameFlag=math.max(1,(self.frameFlag+1)%6)
    end)
    -- table.insert(self.mossies,Mossy(self.world,math.random(2,3),(math.random(103)-1)*10,-128,'Mossy'))
end


function Level:update(dt)
    
    
    local xMouse,yMouse=push:toGame(love.mouse.getPosition())
    if love.mouse.wasPressed(1) and xMouse>=VIRTUAL_WIDTH-36 and yMouse<=36 then
        self.isPaused=not self.isPaused
    elseif not self.isPaused then 
        self.world:update(dt)

        if love.mouse.wasPressed(1) then
            self.aiming=true
        elseif love.mouse.wasReleased(1) and self.aiming then
            shiftedX=baseX
            shiftedY=baseY
            self.aiming=false
        elseif self.aiming then
            shiftedX = math.min(baseX + 41, math.max(xMouse,baseX - 41))
            shiftedY = math.min(baseY + 41, math.max(yMouse,baseY - 41))
            
            if shiftedY<baseY-25 then
                love.keyboard.keysPressed['space']=true
            end
        end

        self.player:update(dt)
        if self.isDead or #self.mossies>=50 then
            Timer.clear()
            for k,mossy in pairs(self.mossies) do
                mossy.body:destroy()
            end
            self.mossies={}
            self.player.body:destroy()
            gStateMachine:change('game-over',{
                background=self.background,
                currentLevel=self.currentLevel,
                highscore=self.highscore
            })
        end
    end
    

    
    
    
end

function Level:render()
    self.background:render()
    self.player:render()
    for i=0,15 do
        love.graphics.draw(gTextures['mossy'], gFrames['mossy'][1],
        i*96,VIRTUAL_HEIGHT-96)
    end
    for k,mossy in pairs(self.mossies) do
        mossy:render()
    end
    if self.isPaused then
        love.graphics.draw(gTextures['pause'],gFrames['pause'][1],VIRTUAL_WIDTH-36,0)
    else 
        love.graphics.draw(gTextures['resume'],gFrames['resume'][1],VIRTUAL_WIDTH-36,0)
    end

    love.graphics.draw(gTextures['flag'],gFrames['flag'][self.frameFlag],VIRTUAL_WIDTH-40,140)
    if not self.isStared then
        if not self.offset then
            love.graphics.draw(gTextures['cursor'],gFrames['cursor'][1],VIRTUAL_WIDTH-45,105)
        else
            love.graphics.draw(gTextures['cursor'],gFrames['cursor'][1],VIRTUAL_WIDTH-40,110)
        end
    end
    self.endMossy:render()
    love.graphics.draw(gTextures['menu-control'],gFrames['menu-control'][1],baseX-41-15,baseY-41-15)
    love.graphics.draw(gTextures['main-control'],gFrames['main-control'][1],shiftedX-15,shiftedY-15)
    

   
end
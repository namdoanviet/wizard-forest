PlayerWalkingState=Class{__includes=BaseState}

function PlayerWalkingState:init(player)
    self.player=player
    self.animation=Animation{
        frames={1,2,3,4,5},
        interval=0.05
    }
    self.player.currentAnimation=self.animation

end

function PlayerWalkingState:update(dt)
    self.player.currentAnimation:update(dt)
    local velX,velY=self.player.body:getLinearVelocity()
    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') and math.abs(shiftedX-baseX)<=15 and math.abs(shiftedY-baseY)<=15 then
        self.player:changeState('idle')
    else
        if velY>3 then
            self.player:changeState('falling',{
                canInput=true
            })
        elseif love.keyboard.isDown('left') or shiftedX<baseX-15 then
            self.player.body:setLinearVelocity( -260, 0)
            self.player.direction = 'left'
        elseif love.keyboard.isDown('right') or shiftedX>baseX+15 then
            self.player.body:setLinearVelocity( 260, 0)
            self.player.direction = 'right'
        end
        
    end
    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

end


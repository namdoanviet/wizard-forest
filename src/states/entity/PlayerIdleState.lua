PlayerIdleState=Class{__includes=BaseState}

function PlayerIdleState:init(player) 
    self.player=player
    self.animation=Animation{
        frames={6},
        interval=1
    }
    self.player.body:setLinearVelocity(0, 0)
    self.player.currentAnimation=self.animation
end

function PlayerIdleState:enter()

end

function PlayerIdleState:update(dt)
    self.player.currentAnimation:update(dt)
    local velX,velY=self.player.body:getLinearVelocity()
    if velY>3 then
        self.player:changeState('falling',{
            canInput=true
        })
    else
        if love.keyboard.isDown('left') or love.keyboard.isDown('right') or math.abs(shiftedX-baseX) >15  then
            self.player:changeState('walking')
        end
        if love.keyboard.wasPressed('space') then
            self.player:changeState('jump')
        end
    end
    
    
end
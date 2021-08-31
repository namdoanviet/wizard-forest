PlayerFallingState=Class{__includes=BaseState}

function PlayerFallingState:init(player,canInput)
    self.player=player
    self.animation=Animation{
        frames={10},
        interval=1
    }
    self.player.currentAnimation=self.animation
end

function PlayerFallingState:enter(params)
    self.canInput=params.canInput
end



function PlayerFallingState:update(dt)
    self.player.currentAnimation:update(dt)
    local velX,velY=self.player.body:getLinearVelocity()
    if self.canInput then
        if love.keyboard.isDown('left') or shiftedX<baseX-15  then
            self.player.direction='left'
            self.player.body:setLinearVelocity( -240, velY)
        elseif love.keyboard.isDown('right') or shiftedX>baseX+15  then
            self.player.direction='right'
            self.player.body:setLinearVelocity( 240, velY)
        end
    end
    
    if math.abs(velY)<=3 then 
        self.player:changeState('idle')
    end
end
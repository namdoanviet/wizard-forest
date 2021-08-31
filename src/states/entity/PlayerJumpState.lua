PlayerJumpState=Class{__includes=BaseState}

function PlayerJumpState:init(player)
    self.player=player
    self.animation=Animation{
        frames={8},
        interval=1
    }
    self.player.currentAnimation=self.animation
end

function PlayerJumpState:enter(params)
    gSounds['jump']:play()
    self.player.body:setLinearVelocity( 0, -500)

end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)
    local velX,velY=self.player.body:getLinearVelocity()
    if velY>=0 then
        self.player:changeState('falling',{
            canInput=true
        })
    else
        if love.keyboard.isDown('left') or shiftedX<baseX-15 then
            self.player.direction = 'left'
            self.player.body:setLinearVelocity( -240, velY)
        elseif love.keyboard.isDown('right') or shiftedX>baseX+15 then
            self.player.direction = 'right'
            self.player.body:setLinearVelocity( 240, velY)
        end
    end

   

end
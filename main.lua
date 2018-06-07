-- Joystick configs
LEFT_X = 1
LEFT_Y = 2
RIGHT_X = 3
RIGHT_Y = 4

-- Drawing parameters
margin = 10
text_padding_top = 20
block_width = 400
block_height = 460
axis_radius = 30
joy_reach = axis_radius * 0.8
axis_point_radius = 5
visual_stick_margin = 250

function love.load()
  joysticks = love.joystick.getJoysticks()
  vibration = { 
    left = 0,
    right = 0,
    state_left = 0,
    state_right = 0
  }
  if joysticks and #joysticks ~= 0 then
    love.window.setMode(block_width * #joysticks, 600)
  end
end

function resetColor()
  love.graphics.setColor(1, 1, 1, 1)
end

function love.draw()
  if joysticks then
    for i, j in ipairs(joysticks) do
      --[[ Axii ]]
      local x = block_width * (i-1) + margin
      local y = margin

      local lx = j:getAxis(LEFT_X)
      local ly = j:getAxis(LEFT_Y)
      local rx = j:getAxis(RIGHT_X)
      local ry = j:getAxis(RIGHT_Y)

      -- Left stick stats
      resetColor()
      love.graphics.print("Joystick "..i.." (ID: "..j:getID()..")", x, y)
      y = y + text_padding_top
      love.graphics.print("Name: "..j:getName(), x, y)
      y = y + text_padding_top
      love.graphics.print("Axii:", x, y)
      y = y + text_padding_top
      love.graphics.print("Left Stick:", x + 20, y)
      y = y + text_padding_top
      love.graphics.print("X: "..lx, x + 40, y)
      y = y + text_padding_top
      -- Left stick visual
      love.graphics.setColor(1, 1, 1, 0.3)
      love.graphics.circle("fill", x + visual_stick_margin, y, axis_radius)
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.circle("fill", x + visual_stick_margin + lx*joy_reach, y + ly*joy_reach, axis_point_radius)
      --
      resetColor()
      love.graphics.print("Y: "..ly, x + 40, y)
      y = y + text_padding_top

      -- Right stick stats
      resetColor()
      love.graphics.print("Right Stick:", x + 20, y)
      y = y + text_padding_top
      love.graphics.print("X: "..rx, x + 40, y)
      y = y + text_padding_top
      -- Right stick visual
      love.graphics.setColor(1, 1, 1, 0.3)
      love.graphics.circle("fill", x + visual_stick_margin, y, axis_radius)
      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.circle("fill", x + visual_stick_margin + rx*joy_reach, y + ry*joy_reach, axis_point_radius)
      --
      resetColor()
      love.graphics.print("Y: "..ry, x + 40, y)
      y = y + text_padding_top
      -------

      --[[ Buttons ]]
      love.graphics.print("Buttons:", x, y)
      for i=1, j:getButtonCount() do
        y = y + text_padding_top
        if j:isDown(i) then
          love.graphics.setColor(0, 1, 0, 1)
        else
          love.graphics.setColor(0, 0, 1, 1)
        end
        love.graphics.print(i, x + 20, y)
      end

      resetColor()

      --[[ Vibration ]]
      y = y + text_padding_top
      if not j:isVibrationSupported() then
        love.graphics.setColor(1, 0.1, 0, 1)
        love.graphics.print("Vibration not supported", x, y)
      else
        love.graphics.setColor(0.1, 1, 0, 1)
        love.graphics.print("Vibration supported", x, y)
        y = y + text_padding_top

        -- Left motor status
        if vibration.state_left == 1 then
          love.graphics.setColor(0, 1, 0, 1)
        else
          love.graphics.setColor(0.9, 0.9, 0.9, 1)
        end
        love.graphics.print("Left motor vibration (LEFT): "..vibration.left, x, y)
        y = y + text_padding_top

        -- Right motor status
        if vibration.state_right == 1 then
          love.graphics.setColor(0, 1, 0, 1)
        else
          love.graphics.setColor(0.9, 0.9, 0.9, 1)
        end
        love.graphics.print("Right motor vibration (RIGHT): "..vibration.right, x, y)
        resetColor()
      end
    end
  else
    love.graphics.print("Plug in joysticks and restart (R)")
  end
end

function love.update(dt)
  if joysticks then
    vibration.state_left = 0
    vibration.state_right = 0

    if love.keyboard.isDown("left") then
      vibration.state_left = 1
    end
    if love.keyboard.isDown("right") then
      vibration.state_right = 1
    end

    if love.keyboard.isDown("up") then
      vibration.left = vibration.left + 0.01
      vibration.right = vibration.right + 0.01

      if vibration.left > 1 then vibration.left = 1 end
      if vibration.right > 1 then vibration.right = 1 end
    end

    if love.keyboard.isDown("down") then
      vibration.left = vibration.left - 0.01
      vibration.right = vibration.right - 0.01

      if vibration.left < 0 then vibration.left = 0 end
      if vibration.right < 0 then vibration.right = 0 end
    end

    for i, j in ipairs(joysticks) do
      if vibration.state_left == 1 or vibration.state_right == 1 then
        j:setVibration(vibration.state_left * vibration.left, vibration.state_right * vibration.right)
      end
    end
  end
end

function love.keypressed(k)
  if k == "r" then

    joysticks = {}
    love.load()
  end

  if k == "escape" then
    love.event.quit()
  end
end
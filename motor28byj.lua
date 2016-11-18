-- motor28byj.lua

-- simple stepper driver for controlling a stepper motor with a ULN2003 driver

local module = {}  

local stepper_pins = nil

-- half or full stepping
local step_states4 = {
 {1,0,0,1},
 {1,1,0,0},
 {0,1,1,0},
 {0,0,1,1}
}
local step_states8 = {
 {1,0,0,0},
 {1,1,0,0},
 {0,1,0,0},
 {0,1,1,0},
 {0,0,1,0},
 {0,0,1,1},
 {0,0,0,1},
 {1,0,0,1},
}

local step_states = step_states8 -- choose stepping mode
local steps_per_circle = nil -- steps per 360°
local step_numstates = nil -- change to match number of rows in step_states
local step_delay = nil -- choose speed
local step_state = 0 -- updated by step_take-function
local step_direction = 1 -- choose step direction -1, 1
local step_stepsleft = 0 -- number of steps to move, will de decremented
local step_timerid = 4 -- which timer to use for the steps

-- make stepper take one step
local function step_take()
    -- jump to the next state in the direction, wrap
    step_state = step_state + step_direction
    if step_state > step_numstates then
        step_state = 1;
    elseif step_state < 1 then
        step_state = step_numstates
    end

    --print("step " .. step_state)
    -- write the current state to the pins
    for i = 1, #stepper_pins do
        gpio.write(stepper_pins[i], step_states[step_state][i])
    end

    -- might take another step after step_delay
    step_stepsleft = step_stepsleft-1
    if step_stepsleft > 0 then
        tmr.alarm(step_timerid, step_delay, 0, step_take )
    else
        module.stop()
    end
end

function module.rotate(degree)
    local direction = 1
    if degree < 0 then
        direction = -1
    end
    local steps = math.abs(degree) * steps_per_circle / 360
    --print(steps,direction)
    module.move(steps, direction)
end

function module.move(steps, direction)
    tmr.stop(step_timerid)
    step_stepsleft = steps
    step_direction = direction
    step_take()
end

function module.stop()
    tmr.stop(step_timerid)
    step_stepsleft = 0
    for idx,pin in pairs(stepper_pins) do
        gpio.write(pin, 0)
    end
end

function module.init(pins, delay)
    stepper_pins = pins
    step_delay = delay
    step_numstates = table.getn(step_states)
    steps_per_circle = step_numstates * 8 * 64
    for idx,pin in pairs(pins) do
      gpio.mode(pin,gpio.OUTPUT)
    end
end

return module
-- file : lcdHD44780.lua
local module = {}  

_lcd = nil

NIBBLE_LEN = 4

LCD_CHR = gpio.HIGH
LCD_CMD = gpio.LOW

-- Timing constants
E_PULSE = 5000
E_DELAY = 5000

CMD_CLEAR_DISPLAY = 1

CMD_CURSOR_TO_START = 2

CMD_ENTRY_MODE = 4
ENTRY_MODE_CURSOR_LEFT = 2
ENTRY_MODE_SHIFT_ON = 1

CMD_DISPLAY = 8
DISPLAY_ON = 4
DISPLAY_CURSOR_ON = 2
DISPLAY_CURSOR_BLINK = 1

CMD_SHIFT = 16
SHIFT_DISPLAY = 8
SHIFT_RIGHT = 4

CMD_FUNCTION = 32
FUNCTION_8BIT = 16
FUNCTION_2LINES = 8
FUNCTION_POINT_5X11 = 4

CMD_CG_RAM_ADDRESS = 64

CMD_DD_RAM_ADDRESS = 128
DD_RAM_LINE_2 = 64

CURSOR_SETTING = CMD_ENTRY_MODE + ENTRY_MODE_CURSOR_LEFT
DISPLAY_SETTING = CMD_DISPLAY + DISPLAY_ON
INTERFACE_8BIT = 3
INTERFACE_4BIT = 2
FUNCTION_2LINES_POINT5X8 = CMD_FUNCTION + FUNCTION_2LINES

module.AddrLine1 = CMD_DD_RAM_ADDRESS 
module.AddrLine2 = CMD_DD_RAM_ADDRESS + DD_RAM_LINE_2

function initLcd()
    for i=1,3 do
        writeCommand(INTERFACE_8BIT)
    end
    writeCommand(INTERFACE_4BIT)
    writeByte(CURSOR_SETTING, LCD_CMD)
    writeByte(DISPLAY_SETTING, LCD_CMD)
    writeByte(FUNCTION_2LINES_POINT5X8, LCD_CMD)
    writeByte(CMD_CLEAR_DISPLAY, LCD_CMD)
    tmr.delay(E_DELAY)
end

function writeByte(bits, mode)
    gpio.write(_lcd.pinRS, mode)
    highNibble = bit.arshift(bits, NIBBLE_LEN)
    writeNibble(highNibble)
    writeNibble(bits)
end

function writeCommand(bits)
    gpio.write(_lcd.pinRS, LCD_CMD)
    writeNibble(bits)
end

function writeNibble(bits)
    if #_lcd.pinData < NIBBLE_LEN then
        error("less pin count defined")
        return
    end

    for i = 1, NIBBLE_LEN do
        gpio.write(_lcd.pinData[i], gpio.LOW)
        if bit.isset(bits, i-1) then
            gpio.write(_lcd.pinData[i], gpio.HIGH)
        end
    end

    toggleEnable()
end

function toggleEnable()
  tmr.delay(E_DELAY)
  gpio.write(_lcd.pinEn, gpio.HIGH)
  tmr.delay(E_PULSE)
  gpio.write(_lcd.pinEn, gpio.LOW)
  tmr.delay(E_DELAY)
end

function module.init(lcd)
    _lcd = lcd
    gpio.mode(lcd.pinRS, gpio.OUTPUT)
    gpio.mode(lcd.pinEn, gpio.OUTPUT)
    for idx, pin in pairs(lcd.pinData) do
        gpio.mode(pin, gpio.OUTPUT)
    end
    
    initLcd()
end

function module.setText(text, line)
  message = text:sub(1, _lcd.maxLen)
  message = message .. string.rep(" ", _lcd.maxLen - #message)

  writeByte(line, LCD_CMD)

  for i = 1, _lcd.maxLen do
    writeByte(message:byte(i), LCD_CHR)
  end
end

return module

--
-- A FRSKY SPort/FPort/FPort2 and TBS CRSF telemetry widget for the Ethos OS
-- based on ArduPilot's passthrough telemetry protocol
--
-- Author: Alessandro Apostoli, https://github.com/yaapu
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation; either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY, without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, see <http://www.gnu.org/licenses>.

local HUD_W = 400
local HUD_H = 240
local HUD_X = (800 - HUD_W)/2
local HUD_Y = 36

local function getTime()
  -- os.clock() resolution is 0.01 secs
  return os.clock()*100 -- 1/100th
end

local function getBitmapsPath()
  -- local path from script root
  return "./../../bitmaps/"
end

local function getLogsPath()
  -- local path from script root
  return "./../../logs/"
end

local function getYaapuBitmapsPath()
  -- local path from script root
  return "./bitmaps/"
end

local function getYaapuAudioPath()
  -- local path from script root
  return "./audio/"
end

local function getYaapuLibPath()
  -- local path from script root
  return "./lib/"
end


local panel = {}
local status = nil
local libs = nil












function panel.draw(widget)
  widget.centerPanel.draw(widget)
  widget.leftPanel.draw(widget, 0)
  widget.rightPanel.draw(widget, 600)

  -- home directory arrow
  libs.drawLib.drawRArrow(400, 314, 28, math.floor(status.telemetry.homeAngle - status.telemetry.yaw),status.colors.white)
  libs.drawLib.drawRArrow(400, 314, 35, math.floor(status.telemetry.homeAngle - status.telemetry.yaw),status.colors.black)

  -- RPM 1
  if status.conf.enableRPM == 2  or status.conf.enableRPM == 3 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(170, 280, "RPM 1", RIGHT)
    libs.drawLib.drawBar("rpm1", 15, 305, 150, 42, status.colors.rpmBar, math.abs(status.telemetry.rpm1), FONT_XXL)
  end

  -- RPM 2
  if status.conf.enableRPM == 3 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(335, 280, "RPM 2", RIGHT)
    libs.drawLib.drawBar("rpm2", 180, 305, 150, 42, status.colors.rpmBar, math.abs(status.telemetry.rpm2), FONT_XXL)
  end

  -- throttle %
  lcd.color(status.colors.panelLabel)
  lcd.font(FONT_STD)
  lcd.drawText(520, 280, "THR(%)", RIGHT)
  libs.drawLib.drawNumber(520, 306, status.telemetry.throttle, 0, FONT_XXL, status.colors.hudText, RIGHT)

  -- efficiency (check if hidden by another panel)
  if status.hideEfficiency == 0 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(656, 280, "EFF(mAh)", RIGHT)
    local speed = libs.utils.getMaxValue(status.telemetry.hSpeed,14)
    -- efficiency for indipendent batteries makes sense only for battery 1
    local eff = speed > 2 and status.battery[7]*1000/(speed*status.conf.horSpeedMultiplier) or 0
    libs.drawLib.drawNumber(656, 306, eff, 0, FONT_XXL, status.colors.white, RIGHT)
  end

  -- power (check if hidden by another panel)
  if status.hidePower == 0 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(794, 280, "PWR(W)", RIGHT)
    local power = status.battery[4]*status.battery[7]*0.01
    libs.drawLib.drawNumber(794, 306, power, 0, FONT_XXL, status.colors.white, RIGHT)
  end

  libs.drawLib.drawTopBar(widget)

  libs.drawLib.drawStatusBar(widget, nil, 4)

  local nextX = libs.drawLib.drawTerrainStatus(205,38)
  libs.drawLib.drawFenceStatus(nextX,38)

  lcd.font(FONT_XS)
  lcd.color(status.colors.green)
  lcd.drawText(800, 480-16, "default", RIGHT)
end

function panel.background(widget)
end

function panel.init(param_status, param_libs)
  status = param_status
  libs = param_libs
  return panel
end

panel.showArmingStatus = true
panel.showFailsafe = true

return panel

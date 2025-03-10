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

local HUD_W = 240
local HUD_H = 150
local HUD_X = (480 - HUD_W)/2
local HUD_Y = 18

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
  widget.rightPanel.draw(widget, 360)

  -- home directory arrow
  libs.drawLib.drawRArrow(240, 194, 18, math.floor(status.telemetry.homeAngle - status.telemetry.yaw),status.colors.white)
  libs.drawLib.drawRArrow(240, 194, 22, math.floor(status.telemetry.homeAngle - status.telemetry.yaw),status.colors.black)

  -- RPM 1
  if status.conf.enableRPM == 2  or status.conf.enableRPM == 3 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(110, 170, "RPM 1", RIGHT)
    libs.drawLib.drawBar("rpm1", 5, 184, 100, 29, status.colors.rpmBar, math.abs(status.telemetry.rpm1), FONT_XXL)
  end

  -- RPM 2
  if status.conf.enableRPM == 3 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(212, 170, "RPM 2", RIGHT)
    libs.drawLib.drawBar("rpm2", 110, 184, 100, 29, status.colors.rpmBar, math.abs(status.telemetry.rpm2), FONT_XXL)
  end

  -- throttle %
  lcd.color(status.colors.panelLabel)
  lcd.font(FONT_STD)
  lcd.drawText(310, 170, "THR(%)", RIGHT)
  libs.drawLib.drawNumber(310, 183, status.telemetry.throttle, 0, FONT_XXL, status.colors.hudText, RIGHT)

  -- efficiency (check if hidden by another panel)
  if status.hideEfficiency == 0 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(390, 170, "EFF(mAh)", RIGHT)
    local speed = libs.utils.getMaxValue(status.telemetry.hSpeed,14)
    -- efficiency for indipendent batteries makes sense only for battery 1
    local eff = speed > 2 and status.battery[7]*1000/(speed*status.conf.horSpeedMultiplier) or 0
    libs.drawLib.drawNumber(390, 183, eff, 0, FONT_XXL, status.colors.white, RIGHT)
  end

  -- power (check if hidden by another panel)
  if status.hidePower == 0 then
    lcd.color(status.colors.panelLabel)
    lcd.font(FONT_STD)
    lcd.drawText(476, 170, "PWR(W)", RIGHT)
    local power = status.battery[4]*status.battery[7]*0.01
    libs.drawLib.drawNumber(476, 183, power, 0, FONT_XXL, status.colors.white, RIGHT)
  end

  libs.drawLib.drawTopBar(widget)

  libs.drawLib.drawStatusBar(widget, nil, 6)

  local nextX = libs.drawLib.drawTerrainStatus(121,19)
  libs.drawLib.drawFenceStatus(nextX,19)

  lcd.font(FONT_XS)
  lcd.color(status.colors.green)
  lcd.drawText(480, 320-16, "default", RIGHT)
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

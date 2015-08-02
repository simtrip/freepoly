camera = require('lib.camera')
vector = require('lib.vector')
class = require('lib.middleclass')
utility = require('lib.utility')
imgMan = require ('lib.image_manager')
Gamestate = require('lib.gamestate')

--Gamestates
require('editor')

local l = require('logger')
--Set log level here till we have a more elegant way
l.level = l.DEBUG

local vMajor, vMinor, revision, name = love.getVersion()
l.log(string.format("Running LÖVE version %d.%d.%d - %s on %s",
	vMajor, vMinor, revision, name, love._os), l.INFO)

local frameStart, frameTime = nil, 0
local fpsCap = 60 --0 for uncapped fps


function love.load(arg)
    --Pass love2d events and callbacks to Gamestate
    Gamestate.registerEvents()
    Gamestate.switch(editor)
end


function love.update(dt)
end


function love.draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.print("FPS: " .. love.timer.getFPS(),10,10)
    if frameTime > 0 then
    	love.graphics.print("Frame time: " .. utility.round(frameTime / 1000, 2) .. " ms", 10, 25)
    end
    love.graphics.print("Memory: " .. utility.round(collectgarbage('count'), 2) .. " KB", 10, 40)
end


function love.mousepressed(mx,my,btn)
end


--Main loop
function love.run()
	if frameStart == nil then frameStart = love.timer.getTime() end

	if love.math then
		love.math.setRandomSeed(os.time())
		for i=1,3 do love.math.random() end
	end

	if love.event then
		love.event.pump()
	end

	if love.load then love.load(arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for e,a,b,c,d in love.event.poll() do
				if e == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return
					end
				end
				love.handlers[e](a,b,c,d)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		if love.window and love.graphics and love.window.isCreated() then
			love.graphics.clear()
			love.graphics.origin()
			if love.draw then love.draw() end
			love.graphics.present()
		end

		--Cap fps
		frameTime = love.timer.getTime() - frameStart
		if fpsCap > 0 and frameTime < 1 / fpsCap then
			love.timer.sleep(1 / fpsCap - frameTime)
		end
		frameStart = love.timer.getTime()
	end

end

utility = {}

function utility.clamp(val, lower, upper)
    assert(val and lower and upper, "not very useful error message here")
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function utility.round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function utility.xor(cond1,cond2)
	if cond1 and cond2 then return false end
	if cond1 and not cond2 then return true end
	if not cond1 and cond2 then return true end
	if not cond1 and not cond2 then return false end
end

function utility.angleTo(v1,v2)
	local d = v2 - v1
	local angle = atan2(d.y,d.x)
	return angle
end

function utility.boxCollide(b1p,b1s,b2p,b2s) -- check if box 1 intersects box 2
	if b1p.y + b1s.y <= b2p.y
	or b1p.y >= b2p.y + b2s.y
	or b1p.x + b1s.x <= b2p.x
	or b1p.x >= b2p.x + b2s.x
	then
		return false
	else
		return true
	end
end

function utility.point2Box(px,py,bx,by,bw,bh)
	if px >= bx and px <= bx+bw
	and py >= by and py <= by+bh
	then
		return true
	else
		return false
	end
end

function utility.draw_debug()
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(love.timer.getFPS(),1,1)
end

return utility

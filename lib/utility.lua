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

function utility.binarySearch(data,searchValue)
    local size = table.getn(data) -- the max size of the table
    local high = size
    local mid = 1
    local count = 0
    local low = 1
    local lastMid = mid

    repeat
        lastMid = mid
        mid = math.ceil((high+low)/2)
        if data[mid] == searchValue then
            return true,mid
        else

            if data[mid] > searchValue then
                high = mid-1
            end
            if data[mid] < searchValue then
                low = mid+1
            end
        end

    until mid == lastMid
    return false,mid
end

--[[ Implementation of MergeSort --]]

-- main mergesort algorithm
function mergeSort(A, p, r)
        -- return if only 1 element
	if p < r then
		local q = math.floor((p + r)/2)
		mergeSort(A, p, q)
		mergeSort(A, q+1, r)
		merge(A, p, q, r)
	end
end

-- merge an array split from p-q, q-r
function utility.merge(A, p, q, r)
    p = 1
    q = math.floor((1+table.getn(A))/2)
    r = table.getn(A)


	local n1 = q-p+1
	local n2 = r-q
	local left = {}
	local right = {}

	for i=1, n1 do
		left[i] = A[p+i-1]
	end
	for i=1, n2 do
		right[i] = A[q+i]
	end

	left[n1+1] = math.huge
	right[n2+1] = math.huge

	local i=1
	local j=1

	for k=p, r do
		if left[i]<=right[j] then
			A[k] = left[i]
			i=i+1
		else
			A[k] = right[j]
			j=j+1
		end
	end
end

function utility.spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


return utility

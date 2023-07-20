local module = {}

-- includes --
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(game.ReplicatedStorage.inputs)
local fontrom = require(game.ReplicatedStorage.fontrom)

-- compile vars --
local folder = game.ReplicatedStorage.compileSettings
---
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value

-- services --
local twns = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

-- replace later --
local textspeed = "slow"
local txtbox = 1

-- triggers --
local inDialogue = script.Parent.Triggers.inDialogue.Value

module.clearGraphics = function()
	for i, v in ipairs(script.Parent.Parent.game.loadedassets:GetChildren()) do
		v:Destroy()
	end
end

module.genericColorTween = function(obj, newclr, clk, callback)
	local base = {} base.r = obj.BackgroundColor3.R
	base.g = obj.BackgroundColor3.G
	base.b = obj.BackgroundColor3.B
	for i=1, clk do
		wait()
		local cx = (newclr.R-base.r)/clk
		local cy = (newclr.G-base.g)/clk
		local cz = (newclr.B-base.b)/clk
		obj.BackgroundColor3 = Color3.new(base.r+(cx*i), base.g+(cy*i), base.b+(cz*i))
	end
	pcall(callback)
end

module.genericPosTween = function(obj, newx, newy, timeToSpend, callback)
	local a = coroutine.create(function()
		local new = UDim2.new(newx/maxX, 0, newy/maxY, 0)
		local tweeninfo = TweenInfo.new(timeToSpend, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local g = {}
		g.Position = new
		local tween = twns:Create(obj, tweeninfo, g)
		tween:Play()
		wait(timeToSpend)
		pcall(function() callback() end)
	end)
	coroutine.resume(a)
end

module.genericOpacityTween = function(obj, newopac, clk, callback)
	coroutine.resume(coroutine.create(function()
		if obj:IsA("Frame") then
			local base = {} base.opac = obj.BackgroundTransparency
			for i=1, clk do
				wait()
				local c = (newopac - base.opac)/clk
				obj.BackgroundTransparency += c
			end
		elseif obj:IsA("ImageLabel") then
			local base = {} base.opac = obj.ImageTransparency
			for i=1, clk do
				wait()
				local c = (newopac - base.opac)/clk
				obj.ImageTransparency += c
			end
		end
		pcall(callback)
	end))
end

module.batchGenericOpacityTween = function(objs, oldopac, newopac, clk, callback)
	for i=1, clk do
		for ii, obj in ipairs(objs) do
			if obj:IsA("Frame") then
				local c = (newopac - oldopac)/clk
				obj.BackgroundTransparency += c
			elseif obj:IsA("ImageLabel") then
				local c = (newopac - oldopac)/clk
				obj.ImageTransparency += c
			end
		end
		wait()
	end
	pcall(callback)
end

module.playSFX = function(sfxnameinfolder, vol)
	local newsfx = Instance.new("Sound")
	newsfx.SoundId = pbu.."/soundeffects/"..sfxnameinfolder
	newsfx.Parent = script.Parent
	newsfx.PlayOnRemove = true
	newsfx:Destroy()
end

module.renderImg = function(filepathinpatch, x, y, sizex, sizey, anchor, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.Parent.game.loadedassets
	newimg.AnchorPoint = anchor
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newimg.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newimg)
	end)
	return newimg
end

module.renderMaskImg = function(filepathinpatch, x, y, sizex, sizey, anchor, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newf = Instance.new("Frame")
	newf.Name = filepathinpatch
	newf.BackgroundTransparency = 1
	newf.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newf.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newf.AnchorPoint = anchor
	newf.ClipsDescendants = true
	newf.Parent = script.Parent.Parent.game.loadedassets
	local newimg = Instance.new("ImageLabel")
	newimg.Name = "maskedwithinframe"
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = newf
	newimg.AnchorPoint = Vector2.new(0.5, 0.5)
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.Position = UDim2.new(0.5, 0, 0.5, 0)
	newimg.Size = UDim2.new(1, 0, 1, 0)
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newf)
	end)
	return newf
end

module.renderImgInBounds = function(filepathinpatch, x, y, sizex, sizey, anchor, frameRectOffset, frameRectSize, callback) --returns img, x in bounds of game and out of 240. y in bounds of game and out of 160, same for sizes
	local newimg = Instance.new("ImageLabel")
	newimg.Image = pbu..filepathinpatch
	newimg.Parent = script.Parent.Parent.game.loadedassets
	newimg.AnchorPoint = anchor
	newimg.BorderSizePixel = 0
	newimg.BackgroundTransparency = 1
	newimg.ImageRectOffset = frameRectOffset
	newimg.ImageRectSize = frameRectSize
	newimg.Position = UDim2.new((x/maxX), 0, (y/maxY), 0)
	newimg.Size = UDim2.new((sizex/maxX), 0, (sizey/maxY), 0)
	newimg.ResampleMode = Enum.ResamplerMode.Pixelated
	pcall(function()
		callback(newimg)
	end)
	return newimg
end

module.batchRenderFromSameLinkInBounds = function(list, link) --each entry follows the same as renderImgInBounds
	local allReturned = {}
	for i, v in ipairs(list) do 
		table.insert(allReturned, module.renderImgInBounds(link, v.x, v.y, v.sizex, v.sizey, v.anchor, v.frameRectOffset, v.frameRectSize, v.callback))
	end
	return allReturned
end

module.createElemFromBatchImgs = function(list, link)
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Position = UDim2.new(0,0,0,0)
	frame.AnchorPoint = Vector2.new(0,0)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Parent = script.Parent.Parent.game.loadedassets
	local elems = module.batchRenderFromSameLinkInBounds(list, link)
	for i, v in ipairs(elems) do
		v.Parent = frame
	end
	return frame
end

module.createMenuBox = function(link, x, y, lengthofmiddlex, lengthofmiddley, imgColour) --x&y is origin at top left
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Parent =  script.Parent.Parent.game.loadedassets
	local dictionary = {
		["topleft"] = Vector2.new(0, 0), ["topmiddle"] = Vector2.new(8, 0), ["topright"] = Vector2.new(16, 0), ["middleleft"] = Vector2.new(0, 8), ["middlemiddle"] = Vector2.new(8, 8), ["middleright"] = Vector2.new(16, 8), ["bottomleft"] = Vector2.new(0, 16), ["bottommiddle"] = Vector2.new(8, 16), ["bottomright"] = Vector2.new(16, 16), }
	local size = 8
	local function addToRender(listToRender, cx, cy, offset)
		table.insert(listToRender, {
			["x"] = cx, ["y"] = cy, ["sizex"] = size, ["sizey"] = size, ["anchor"] = Vector2.new(0, 0), ["frameRectOffset"] = offset, ["frameRectSize"] = Vector2.new(size, size), ["callback"] = function(ni) ni.ImageColor3 = imgColour ni.Parent = newf end,
		})
	end
	local function addToRenderInvis(listToRender, cx, cy, offset)
		table.insert(listToRender, {
			["x"] = cx, ["y"] = cy, ["sizex"] = size, ["sizey"] = size, ["anchor"] = Vector2.new(0, 0), ["frameRectOffset"] = offset, ["frameRectSize"] = Vector2.new(size, size), ["callback"] = function(ni) ni.ImageColor3 = imgColour ni.Parent = newf ni.ImageTransparency = 1 end,
		})
	end
	local listToRender = {}
	local cx = x+size
	local cy = y
	addToRender(listToRender, x, y, dictionary.topleft)
	for ii=1, lengthofmiddlex do addToRender(listToRender, cx, cy, dictionary.topmiddle) cx += size end
	addToRender(listToRender, cx, cy, dictionary.topright) cy += size
	for i=1, lengthofmiddley do
		cx = x
		addToRender(listToRender, cx, cy, dictionary.middleleft)
		for ii=0, lengthofmiddlex do
			cx += size
			if ii == lengthofmiddlex then
				addToRenderInvis(listToRender, cx, cy, dictionary.middlemiddle)
			else
				addToRender(listToRender, cx, cy, dictionary.middlemiddle)
			end
		end
		addToRender(listToRender, cx, cy, dictionary.middleright) cy+=size
	end
	cx = x addToRender(listToRender, cx, cy, dictionary.bottomleft) cx += size
	for ii=1, lengthofmiddlex do addToRender(listToRender, cx, cy, dictionary.bottommiddle) cx += size end
	addToRender(listToRender, cx, cy, dictionary.bottomright)
	module.batchRenderFromSameLinkInBounds(listToRender, link)
	return newf
end

module.drawText = function(font, txt, x, y, colour)
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local cx = x
	local cy = y
	for i, v in ipairs(txt:split(`\n`)) do
		if v == "nw" then
			cy += font3Height+1
			cx = x-font3Width
		else
			module.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
				ni.Parent = newf
				ni.ImageColor3 = colour
			end)
			cx+=font3[v].w -1
		end
	end
	newf.Parent = script.Parent.Parent.game.loadedassets
	return newf
end

module.drawScrollingText = function(font, txt, x, y, colour, endable, callback)
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local scrollTxt = coroutine.create(function()
		local cx = x
		local cy = y
		local str = txt:split(`\n`)
		for i, v in ipairs(str) do
			if v == "nw" then
				cy += font3Height+1
				cx = x
			else
				module.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = colour
				end)
				cx+=font3[v].w -1
			end

			task.wait(fontrom.scrollspeeds[textspeed])
		end
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.Parent.game.loadedassets
	return newf
end

module.dialogueBox = function(font, txt, endable, speed, callback)
	inDialogue = true
	local font3Height = fontrom.font3.height
	local font3Width = fontrom.font3.width
	local font3 = fontrom.font3.offsets
	local box = module.createMenuBox("/assets/ui/"..txtbox..".png", 16, maxY-48, 24, 4, Color3.new(1,1,1)) --l = 208px
	local x = 24
	local y = maxY-40
	local clr = Color3.new(1,1,1)
	local newf = Instance.new("Frame")
	newf.Size = UDim2.new(1,0,1,0)
	newf.Position = UDim2.new(0,0,0,0)
	newf.AnchorPoint = Vector2.new(0,0)
	newf.BackgroundTransparency = 1
	newf.Name = txt
	local scrollTxt = coroutine.create(function()
		local cx = x
		local cy = y
		local str = txt:split(`\n`)
		for i, v in ipairs(str) do
			if v == "nw" then
				cy += font3Height+1
				cx = x
			else
				module.renderImgInBounds("/assets/fonts/"..font..".png", cx, cy, 7, 16, Vector2.new(0,0), Vector2.new(font3[v].x, font3[v].y), Vector2.new(7, 16), function(ni)
					ni.Parent = newf
					ni.ImageColor3 = clr
				end)
				cx+=font3[v].w -1
			end

			if uis:IsKeyDown(inputs.scheme1.cancel) then
				task.wait(fontrom.scrollspeeds[textspeed]/2)
			else
				task.wait(fontrom.scrollspeeds[textspeed])
			end
		end
		pcall(function()
			if endable == false then
				module.renderImgInBounds("/assets/fonts/down_arrow.png", cx+1, cy, 7, 16, Vector2.new(0,0), Vector2.new(0, 0), Vector2.new(8, 16), function(ni)
					ni.Parent = newf
					local a = 1
					local b = {[1] = Vector2.new(0, 0),[2] = Vector2.new(0, 16),[3] = Vector2.new(0, 32),[4] = Vector2.new(0, 48)}
					local anim = coroutine.create(function()
						while wait(0.08) do
							a+=1
							if a > 4 then a = 1 end
							ni.ImageRectOffset = b[a]
						end
					end)
					coroutine.resume(anim)
				end)
				local connect
				connect = uis.InputBegan:Connect(function(inp)
					if inp.KeyCode == inputs.scheme1.interact or inp.KeyCode == inputs.scheme1.cancel then
						module.playSFX("sel.wav")
						connect:Disconnect()
						callback(newf, box)
					end
				end)
			else
				local connect
				connect = uis.InputBegan:Connect(function(inp)
					if inp.KeyCode == inputs.scheme1.interact then
						connect:Disconnect()
						inDialogue = false
						callback(newf, box)
					end
				end)
			end
		end)
	end)
	coroutine.resume(scrollTxt)
	newf.Parent = script.Parent.Parent.game.loadedassets
end

return module
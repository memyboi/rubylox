local proftalk = {}
local pbu = require(game.ReplicatedStorage.patchbaseurl)
local inputs = require(script.Parent.Parent.Parent.Engines.inputEngine)
local scenes = require(script.Parent.Parent.Parent.Engines.sceneEngine)
local rendering = require(script.Parent.Parent.Parent.Engines.renderingEngine)
local savefile = require(script.Parent.Parent.Parent.Engines.savingEngine)
local engine = require(script.Parent.Parent.Parent.Engines.gameEngine)
local ctrls = require(game.ReplicatedStorage.inputs)
local dialogue = require(game.ReplicatedStorage.talkscript)
local folder = game.ReplicatedStorage.compileSettings
local maxX = folder.maxX.Value
local maxY = folder.maxY.Value

local twns = game:GetService("TweenService")

local tlp
local blp
local trp
local brp
local bir
local azur
proftalk.run = function()
	local newsound = Instance.new("Sound")
	newsound.Volume = 1

	newsound.SoundId = pbu.."/music/4.mp3"
	newsound.Parent = game.Players.LocalPlayer.PlayerGui.gameplay
	newsound:Play()
	newsound.Looped = true
	
	script.Parent.Parent.Parent.Parent.gry.overlay.BackgroundTransparency = 1
	
	local top1 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 0, maxX, 4, Vector2.new(0,0), Vector2.new(8,0), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top2 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 4, maxX, 4, Vector2.new(0,0), Vector2.new(8,4), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top3 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 8, maxX, 4, Vector2.new(0,0), Vector2.new(16,0), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top4 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 12, maxX, 4, Vector2.new(0,0), Vector2.new(16,4), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top5 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 16, maxX, 4, Vector2.new(0,0), Vector2.new(24,0), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top6 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 20, maxX, 4, Vector2.new(0,0), Vector2.new(24,4), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top7 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 24, maxX, 4, Vector2.new(0,0), Vector2.new(32,0), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	local top8 = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", 0, 28, maxX, 4, Vector2.new(0,0), Vector2.new(32,4), Vector2.new(8, 4), function(ni) ni.ImageTransparency = 1 end)
	rendering.batchGenericOpacityTween({top1, top2, top3, top4, top5, top6, top7, top8}, 1, 0, 10)
	wait(3.5)
	print("fade in prof")
	--fade clk=10, very slow
	--1/4 = 64*16
	local top = maxY/2+10
	local left = maxX/2
	tlp = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", left, top, 64, 16, Vector2.new(1,1), Vector2.new(0, 8), Vector2.new(64, 16), function(ni) ni.ImageTransparency = 1 end)
	blp = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", left, top, 64, 16, Vector2.new(1,0), Vector2.new(64, 8), Vector2.new(64, 16), function(ni) ni.ImageTransparency = 1 end)
	trp = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", left, top, 64, 16, Vector2.new(0,1), Vector2.new(64, 8), Vector2.new(-64, 16), function(ni) ni.ImageTransparency = 1 end)
	brp = rendering.renderImgInBounds("/assets/prenewgame/shadow.png", left, top, 64, 16, Vector2.new(0,0), Vector2.new(128, 8), Vector2.new(-64, 16), function(ni) ni.ImageTransparency = 1 end)
	bir = rendering.renderImg("/assets/prenewgame/birch.png", left, top-1, 64, 64, Vector2.new(.31,.95), function(ni) ni.ImageTransparency = 1 end)
	azur = rendering.renderImg("/assets/creatures/front/298.png", 0, 0, 0, 0,Vector2.new(0,0), function(ni) ni.ImageTransparency = 1 end)
	
	for i=1, 10 do
		tlp.ImageTransparency-= .1
		blp.ImageTransparency-= .1
		trp.ImageTransparency-= .1
		brp.ImageTransparency-= .1
		bir.ImageTransparency-= .1
		wait(.25)
	end
	wait(1.25)
	local txtbox = savefile.pullFromSaveData("options.txtbx", 1)
	local y = maxY-46
	engine.dialogueBox("font3_dark", true, "", dialogue.birch.a, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
		engine.dialogueBox("font3_dark", true, "", dialogue.birch.b, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
			engine.dialogueBox("font3_dark", true, "", dialogue.birch.c, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
				engine.dialogueBox("font3_dark", true, "", dialogue.birch.d, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
					engine.dialogueBox("font3_dark", true, "", dialogue.birch.e, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
						engine.dialogueBox("font3_dark", true, "", dialogue.birch.f, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
							engine.dialogueBox("font3_dark", true, "", dialogue.birch.g, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
								engine.dialogueBox("font3_dark", true, dialogue.birch.g:split("|`nw|")[2], dialogue.birch.h, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
									engine.dialogueBox("font3_dark", true, "", dialogue.birch.i, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
										engine.dialogueBox("font3_dark", true, "", dialogue.birch.j, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
											engine.dialogueBox("font3_dark", true, "", dialogue.birch.k, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
												engine.dialogueBox("font3_dark", true, "", dialogue.birch.l, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
													engine.dialogueBox("font3_dark", true, dialogue.birch.l:split("|`nw|")[2], dialogue.birch.m, false, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
														engine.dialogueBox("font3_dark", false, "", dialogue.birch.n, true, y, txtbox, function(newf, bx) newf:Destroy() bx:Destroy()
															inputs.wipeAllFuncs()
															scenes.openscene("ProfTalkSections.GenderChoose")
														end)
													end)
												end)
											end)
										end)
									end)
								end)
							end)
						end)
					end)
				end)
			end)
		end)
	end)
end

proftalk.retrieveAssets = function()
	return {tlp, blp, trp, brp, bir, azur}
end

return proftalk

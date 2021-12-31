-- nft screenshot script where nfts come for you and you have to screenshot them

local tool = Instance.new('Tool',owner.Backpack)
local handle = Instance.new("Part",tool)
local handleMesh = Instance.new("SpecialMesh",handle)
handleMesh.MeshId = "rbxassetid://515752158"
handleMesh.TextureId = "rbxassetid://515752160"
handleMesh.Scale = Vector3.new(.015,.015,.015)
handle.Name = "Handle"
tool.Grip = CFrame.new(1,0,0)
tool.Name = "nft screenshotter 3000"

script.Parent = tool

local sound = Instance.new("Sound",handle)
sound.SoundId = "rbxassetid://2260538021"
sound.Volume = 1
local flash = Instance.new("SpotLight")
flash.Enabled = false
flash.Parent = handle
flash.Brightness = 5
local equipped = false

local debounce = false

local started = false

local HandleBill = Instance.new("BillboardGui",handle)
HandleBill.Size = UDim2.new(10,0,2,0)
HandleBill.ExtentsOffsetWorldSpace = Vector3.new(0,2,0)
HandleBill.AlwaysOnTop = true
local handleTxt = Instance.new("TextLabel",HandleBill)
handleTxt.Size = UDim2.new(1,0,1,0)
handleTxt.BackgroundTransparency = 1
handleTxt.TextColor3 = Color3.new(.8,.8,.2)
handleTxt.TextScaled = true
handleTxt.Font = "Fantasy"
handleTxt.Text = "Click to start: Screenshot NFT Simulator"
local music
local speed = .01

local NFTS = {}
local bossNFTS = {}
local nftsScreenshotted = 0

function snap()
	HandleBill.Enabled = false
	local orig = started
	if started == false then
		music = Instance.new("Sound",game:GetService("Players"):GetPlayerFromCharacter(tool.Parent).PlayerGui)
		music.Volume = 0
		music.SoundId = "rbxassetid://4560072450"
		music.Looped = true
		game:GetService("TweenService"):Create(music,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,.01),{Volume = 1}):Play()
		music:Play()
	end
	started = true
	if orig == false then return end
	if debounce then return end
	debounce = true
	flash.Enabled = true
	task.delay(.2,function()
		flash.Enabled = false
	end)
	task.delay(2,function()
		debounce = false
	end)
	sound:Play()
	local TABS = {NFTS,bossNFTS}
	
	for _,v2 in pairs(TABS) do
		for _,v in pairs(v2) do
			local mag = (handle.Position-v.Position).magnitude
			if mag < 30 then
				spawn(function()
					v:WaitForChild("bill")
					table.remove(NFTS,table.find(NFTS,v))
					game:GetService("TweenService"):Create(v.bill,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,.01),{Size = UDim2.new(0,0,0,0),ExtentsOffsetWorldSpace = Vector3.new(0,-6,0)}):Play()
					game:GetService("TweenService"):Create(v.Sound,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,.01),{Volume = 0}):Play()
					game:GetService("Debris"):AddItem(v,2)
					speed = speed+.01
					nftsScreenshotted+=1
				end)
			end
		end
	end
	
end

function makeNFT(pos)
	local boss = false
	local part = Instance.new("Part",workspace)
	part.Name = "screenshot me!"
	part.Size = (boss == false and Vector3.new(6,6,6) or Vector3.new(12,12,12))
	part.Transparency = 1
	part.CanCollide = false
	part.Anchored = true
	
	
	part.Touched:Connect(function(t)
		if table.find(NFTS,part) then
			pcall(function()
				t.Parent.Humanoid.Health = 0
				if tool.Parent == t.Parent then
					tool.Parent = workspace
				end
				pcall(function()
					game:GetService('Debris'):AddItem(music,1.5)
					game:GetService("TweenService"):Create(music,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,.01),{Volume = 0}):Play()
				end)
			end)
		end
	end)
	
	
	local snd = Instance.new("Sound",part)
	snd.SoundId = "rbxassetid://3145176337"
	snd.Volume = (boss == false and 3 or 5)
	snd.Looped = true
	snd:Play()
	
	local bill = Instance.new("BillboardGui",part)
	bill.Size = (boss == false and UDim2.new(6,0,6,0) or UDim2.new(12,0,12,0))
	bill.Name = "bill"
	local image = Instance.new("ImageLabel",bill)
	image.Size = UDim2.new(1,0,1,0)
	image.Image = getNFTPicture(boss)
	image.BackgroundTransparency = 1
	part.Position = pos+(boss == true and Vector3.new(0,((pos+pos)-pos).magnitude,0)or Vector3.new(0,0,0))
	table.insert((boss == false and NFTS or bossNFTS),part)
end


function getNFTPicture()
	local boss = false
	local pics = {"http://www.roblox.com/asset/?id=8374223909","http://www.roblox.com/asset/?id=8021823500","http://www.roblox.com/asset/?id=8089073988","http://www.roblox.com/asset/?id=8268886379","http://www.roblox.com/asset/?id=8157807163"}
	return pics[math.random(1,#pics)]
end

local del = 5
local DELAYED = false

game:GetService("RunService").Stepped:Connect(function()
	if equipped and started then
		for _,v in pairs(NFTS) do
			v.Position = v.Position:lerp(tool.Parent.HumanoidRootPart.Position,.01+(speed/500))
		end
		if DELAYED == false then
			DELAYED = true
			task.delay(del,function()
				DELAYED = false
			end)
			local plusvec = Vector3.new(math.random(100,200)*(math.random(1,2) == 1 and -1 or 1),3,math.random(100,200)*(math.random(1,2) == 1 and -1 or 1))
			makeNFT(tool.Parent.HumanoidRootPart.Position+plusvec,false)
		end
	end
end)
tool.Activated:Connect(snap)
tool.Equipped:Connect(function()equipped=true end)
tool.Unequipped:Connect(function()
	speed = .01
	equipped=false
	for _,v in pairs(NFTS) do
		v:Remove()
	end
	for _,v in pairs(bossNFTS) do
		v:Remove()
	end
	started = false 
	HandleBill.Enabled = true
	nftsScreenshotted = 0
	pcall(function()
		game:GetService('Debris'):AddItem(music,1.5)
		game:GetService("TweenService"):Create(music,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,.01),{Volume = 0}):Play()
	end)
end)

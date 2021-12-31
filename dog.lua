local char = owner.Character

local dog = Instance.new("Part",char)
script.Parent = dog
dog.Name = "dog :("
local dogmesh = Instance.new("SpecialMesh",dog)
dog.Anchored = true
dogmesh.MeshId = "rbxassetid://7663971288"
dogmesh.TextureId = "rbxassetid://7663971360"
dog.Massless = true
dogmesh.Scale = Vector3.new(2,2,2)

dog.Size = Vector3.new(2,3,5)
dog.CanCollide = false

local target = nil
local killmode = false

local ninjaTarget = nil

local hitt = 0
local multi = 0

dog.Touched:Connect(function(t)
	if killmode then
		if char ~= t.Parent then
			if t.Parent:FindFirstChild("Humanoid") then
				t.Parent.Humanoid.Health -= 10+multi
				if t.Parent:FindFirstChild(target.Name) and t.Parent[target.Name] == target then
					hitt+=1
					if hitt >= 20 then
						multi +=1
					end
					if hitt == 40 then
						pcall(function()
							t.Parent.Humanoid:Remove()
						end)
					end
				end
			end
		end
	end
end)

local remote = Instance.new("RemoteFunction",script)
NLS([[
local plr = game:GetService'Players'.LocalPlayer
local remote = script.Parent
local mouse = plr:GetMouse()

local tab = {}
local going = false
local ninjaKill = false

function enableBoxes()
	going = true
end
function disableBoxes()
	going = false
end

local gunKill = false

mouse.KeyDown:Connect(function(e)
	if e == "e" then
		going = true
		ninjaKill = false
	end
	if e == "r" then
		remote:InvokeServer("target",nil)
	end
	if e == "t" then
		remote:InvokeServer("kill all",mouse.Hit)
	end
	if e == "f" then
		enableBoxes()
		ninjaKill = true
	end
	if e == "g" then
		gunKill = true
		enableBoxes()
	end
	if e == "n" then
		remote:InvokeServer("hide")
	end
	if e == "m" then
		remote:InvokeServer("clownmode")
	end
end)
mouse.KeyUp:Connect(function(e)
	if e == "e" then
		disableBoxes()
	end
	if e == "f" then
		disableBoxes()
		ninjaKill = false
	end
	if e == "g" then
		gunKill = false
		disableBoxes()
	end
end)

mouse.Button1Down:Connect(function()
	if not ninjaKill and not gunKill and going and mouse.Target and mouse.Target.Parent and mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
		remote:InvokeServer("target",mouse.Target)
	end
	if ninjaKill and mouse.Target and mouse.Target.Parent and mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
		remote:InvokeServer("ninjaKill",mouse.Target)
	end
	if gunKill and mouse.Target and mouse.Target.Parent and mouse.Target.Parent:FindFirstChildOfClass("Humanoid") then
		remote:InvokeServer("gunKill",mouse.Target)
	end
end)

game:GetService"RunService".RenderStepped:Connect(function()
	for _,v in pairs(tab) do
		v:Remove()
	end
	if going then
		local part = mouse.Target
		if part then
			if part.Parent:FindFirstChildOfClass("Humanoid") then
				local hei = Instance.new("SelectionBox",part.Parent)
				hei.Adornee = part.Parent
				table.insert(tab,hei)
			end
		end
	end
end)
]],remote)
local music = Instance.new("Sound",dog)
music.SoundId = "rbxassetid://4560072450"
music.Volume = 5
music.Looped = true
music:Play()
local bark = Instance.new("Sound",dog)
bark.SoundId = "rbxassetid://4601957187"
bark.Volume = 5
bark.Looped = true
local emitter = Instance.new("ParticleEmitter",dog)
emitter.Texture = "http://www.roblox.com/asset/?id=2542432117"
emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(.3,3),NumberSequenceKeypoint.new(.6,4),NumberSequenceKeypoint.new(1,0)})
emitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(.3,.3),NumberSequenceKeypoint.new(.7,.5),NumberSequenceKeypoint.new(1,1)})
emitter.Speed = NumberRange.new(0)
emitter.Rate = 2
emitter.Acceleration = Vector3.new(0,-2,0)
emitter.Enabled = false
local blood = Instance.new("Sound",dog)
blood.SoundId = "rbxassetid://7837537174"
blood.Volume = 5
blood.Looped = true

local busy = false

local getBig = false


local killAllCF = false

local fireBall = nil

local gunPos = CFrame.new(0,0,0)

local gun = Instance.new("Part",dog)
local gunMesh = Instance.new("SpecialMesh",gun)
gunMesh.MeshId = "rbxassetid://4716331174"
gunMesh.TextureId = "rbxassetid://4716331467"
gunMesh.Scale = Vector3.new(.03,.03,.03)
gun.Size = Vector3.new(.2,1,1)
gun.CanCollide = false
gun.Anchored = true
gun.Transparency = 1

local overWrite = false

local knife = Instance.new("Part",dog)
knife.Transparency = 0
knifeMesh = Instance.new("SpecialMesh",knife)
knifeMesh.Scale = Vector3.new(.2,.2,.2)
knifeMesh.TextureId = "rbxassetid://442337993"
knifeMesh.MeshId = "rbxassetid://442337985"
knife.Anchored = true
knife.CanCollide = false

local knifeSound = Instance.new("Sound",knife)
knifeSound.SoundId = "rbxassetid://7837521624"
knifeSound.Volume = 6

local moveKnife = true
local knifeAnimation = nil


local gunTarget = nil
local gunProperties = {Transparency = 1}
local gunTorso = nil

local hide = true

function setProperties(a,b)
	for i,v in pairs(b) do
		if typeof(v) ~= "number" then
			a[i] = a[i]:lerp(v,.1)
		else
			a[i]=a[i] + (v - a[i]) * .1
		end
	end
end

local fireballToPosition = CFrame.new(0,0,0)

local clownmode = false

remote.OnServerInvoke = function(plr,typ,a)
	if plr == owner and not busy then
		if typ == "hide" then
			hide = not hide
		end
	end
	if plr == owner and not busy then
		if hide then return end
		if typ == "target" then
			target = a
			if a == nil then
				bark:Stop()
			end
			if target ~= a then
				bark:Play()
			end
		end
		if typ == "target" and a == nil and busy == false then
			killmode = false
			bark:Stop()
			blood:Stop()
			emitter.Enabled = false
		end
		if typ == "gunKill" and gunTarget == nil then
			if a.Parent:FindFirstChildOfClass("Humanoid") then
				if a.Parent:FindFirstChild("HumanoidRootPart") or a.Parent:FindFirstChild("Torso")then
					local snd = Instance.new("Sound",gun)
					snd.SoundId = "rbxassetid://5747279744"
					snd.Volume = 6
					snd.PlayOnRemove = true
					gunTarget = a.Parent
					gunTorso = gunTarget:FindFirstChild("HumanoidRootPart") or gunTarget:FindFirstChild("Torso")
					gunTorso.Anchored = true
					gun.CFrame = gunTarget.Head.CFrame*CFrame.new(1.5,-.2,0)*CFrame.Angles(0,math.rad(90),0)
					gunProperties = {Transparency = 0}
					busy = true
					overWrite = true
					spawn(function()
						wait(1)
						snd:Remove()
						gunTarget:FindFirstChildOfClass("Humanoid").Health = 0
						local cl = emitter:Clone()
						cl.Enabled = true
						cl.Parent = gunTarget.Head
						wait(1)
						busy = false
						overWrite = false
						gunProperties = {Transparency = 1}
						gunTarget = nil
						gunTorso = nil
					end)
				end
			end
		end
		if typ == "ninjaKill" and ninjaTarget == nil then
			if a.Parent:FindFirstChildOfClass("Humanoid") then
				if a.Parent:FindFirstChild("HumanoidRootPart") or a.Parent:FindFirstChild("Torso")then
					ninjaTarget = a.Parent
					busy = true
					overWrite = true
					knifeAnimation = ninjaTarget.Head.CFrame*CFrame.new(1,-.5,-.5)*CFrame.Angles(math.rad(90),0,math.rad(180))
					moveKnife = false
					spawn(function()
						wait(1)
						local cl = emitter:Clone()
						cl.Enabled = true
						cl.Parent = ninjaTarget.Head
						knifeAnimation = ninjaTarget.Head.CFrame*CFrame.new(-1,-.5,-.5)*CFrame.Angles(math.rad(90),0,math.rad(180))
						knifeSound:Play()
						pcall(function()
							ninjaTarget:FindFirstChildOfClass("Humanoid").Health = 0
						end)
						wait(2)
						busy = false
						overWrite = false
						knifeAnimation = nil
						moveKnife = true
						ninjaTarget = nil
					end)
				end
			end
		end
		if typ == "clownmode" then
			clownmode = not clownmode
			music.SoundId = (clownmode == false and "rbxassetid://4560072450" or "rbxassetid://5686847925")
		end
		if typ == "kill all" then
			fireballToPosition = a
			target = nil
			killmode = false
			busy = true
			spawn(function()
				getBig = true
				wait()
				killAllCF = true
				wait(3)
				local fireball = Instance.new("Part",dog)
				fireball.Anchored = true
				fireBall = fireball
				fireball.CanCollide = false
				fireBall.Color = Color3.new(1,.5,0)
				fireBall.Material = "Neon"
				local particle = Instance.new("ParticleEmitter",fireBall)
				particle.Speed = NumberRange.new(0)
				particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,4),NumberSequenceKeypoint.new(1,4)})
				particle.Texture = "http://www.roblox.com/asset/?id=4836320920"
				fireBall.Shape = "Ball"
				fireBall.CFrame = dog.CFrame*CFrame.new(0,45,-100)
				music.Volume = 10
				fireBall.Size = Vector3.new(30,30,30)
				local fireSound = Instance.new("Sound",fireball)
				fireSound.Volume = 10
				fireSound.SoundId = "rbxassetid://747419660"
				fireSound.Looped = true
				fireSound:Play()
				local function END()
					music.Volume = 5
				end
				fireBall.Destroying:Connect(END)
			end)
		end
	end
end


local meesh = nil
local fireeNext = nil


local r = 0
function random()
	local x = 1*(math.random(1,2) == 1 and 1 or -1)
	local y = 1*(math.random(1,2) == 1 and 1 or -1)
	local z = 1*(math.random(1,2) == 1 and 1 or -1)
	return {x,y,z}
end


game:GetService("RunService").Stepped:Connect(function()
	r+=1
	local ran = random()
	if not killAllCF and not overWrite then
		if target ~= nil and not overWrite then
			dog.CFrame = dog.CFrame:Lerp((target.CFrame*CFrame.Angles(math.cos(r)*10,math.rad((r*10)%360),0)*CFrame.new(0,-2,0))*CFrame.new(ran[1],ran[2],ran[3]),.1)
			emitter.Enabled = true
			killmode = true
			if blood.Playing == false then blood:Play() end
		elseif target == nil and not overWrite then
			if not clownmode then
				dog.CFrame = dog.CFrame:Lerp(char.HumanoidRootPart.CFrame*CFrame.new(2,-1.8,0)*CFrame.new(ran[1],ran[2],ran[3]),.1)
			else
				dog.CFrame = dog.CFrame:Lerp(char.HumanoidRootPart.CFrame*CFrame.new(2,2+math.sin(r),0)*CFrame.Angles(0,math.rad(r%360),0),.1)
			end
			hitt = 0
			multi = 0
		end
	elseif killAllCF and not overWrite then
		dog.CFrame = dog.CFrame:Lerp(CFrame.new(0,100,200),.1)
	end
	if hide then
		dog.Transparency = (math.min(dog.Transparency+.1,1))
		knife.Transparency = dog.Transparency
		music.Volume = 5-(dog.Transparency*5)
	else
		dog.Transparency = (math.max(dog.Transparency-.1,0))
		knife.Transparency = dog.Transparency
		music.Volume = 5-(dog.Transparency*5)
	end
	if moveKnife then
		knife.CFrame = dog.CFrame * CFrame.new(-.4,.8,-2)
	end
	if knifeAnimation ~= nil then
		knife.CFrame = knife.CFrame:Lerp(knifeAnimation,.1)
	end
	if getBig then
		dogmesh.Scale = dogmesh.Scale:lerp(Vector3.new(100,100,100),.1)
	else
		dogmesh.Scale = dogmesh.Scale:lerp(Vector3.new(2,2,2),.1)
	end
	if meesh ~= nil and not overWrite then
		meesh.Scale = meesh.Scale:lerp(Vector3.new(140*2,80,100*2),.01)
		meesh.Parent.Size = meesh.Scale+meesh.Scale
	end
	if fireeNext ~= nil and not overWrite then
		fireeNext.Size = fireeNext.Size:lerp(Vector3.new(200,200,200),.01)
	end
	setProperties(gun,gunProperties)
	if gunTarget ~= nil then
		dog.CFrame = dog.CFrame:Lerp(gunTorso.CFrame*CFrame.Angles(math.rad(90),0,0)*CFrame.new(0,2,0),.1)
	end
	if ninjaTarget ~= nil then
		local tors = ninjaTarget:FindFirstChild("HumanoidRootPart") or ninjaTarget:FindFirstChild("Torso")
		tors.CanCollide = false
		tors.Anchored = true
		dog.CFrame = dog.CFrame:Lerp(tors.CFrame*CFrame.Angles(math.rad(90),0,0)*CFrame.new(0,2,0),.1)
	end
	if fireBall ~= nil and not overWrite then
		fireBall.CFrame = CFrame.new(fireBall.Position,fireballToPosition.Position)*CFrame.new(0,0,-1)
		if (fireBall.Position-fireballToPosition.Position).magnitude <= 5 then
			local snd = Instance.new("Sound",fireBall)
			snd.SoundId = "rbxassetid://5801257793"
			snd.Volume = 10
			snd.PlayOnRemove = true
			fireBall:Remove()
			fireBall = nil
			local wave = Instance.new("Part",dog)
			wave.Position = fireballToPosition.Position
			wave.Anchored = true
			wave.Material = "Neon"
			wave.Size = Vector3.new(0,0,0)
			meesh = Instance.new("SpecialMesh",wave)
			meesh.MeshId = "rbxassetid://6880874299"
			meesh.Scale = Vector3.new(0,0,0)
			wave.Material = "Neon"
			wave.Color = Color3.new(1,.3,0)
			fireeNext = Instance.new("Part",dog)
			fireeNext.Position = fireballToPosition.Position
			fireeNext.Color = Color3.new(1,.5,0)
			fireeNext.Anchored = true
			fireeNext.Material = "Neon"
			fireeNext.Shape = "Ball"
			wave.CanCollide = false
			fireeNext.CanCollide = false
			local function touchfunc(a)
				pcall(function()
					if a.Parent == char then return end
					a.Parent:FindFirstChildOfClass'Humanoid'.Health = 0
				end)
			end
			fireeNext.Touched:Connect(touchfunc)
			wave.Touched:Connect(touchfunc)
			wait(4)
			game:GetService("TweenService"):Create(wave,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
			game:GetService("TweenService"):Create(fireeNext,TweenInfo.new(1,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,0,false,0),{Transparency = 1}):Play()
			wait(1)
			wave:Remove()
			fireeNext:Remove()
			meesh = nil
			fireeNext = nil
			wait(2)
			getBig = false
			busy = false
			killAllCF = false
		end
	end
end)

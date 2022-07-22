local scriptversion = "0.0.4"
local screenColor = Color3.new(.9,.9,.9)
local TextColor = Color3.new(1,1,1)

local tweenTime = 1
local tweenInfo = TweenInfo.new(tweenTime,Enum.EasingStyle.Back,Enum.EasingDirection.InOut,0,false,0)



local hrp = owner.Character.HumanoidRootPart
local hum = owner.Character:FindFirstChildOfClass("Humanoid")
local plrs = game:GetService("Players")

local folder = Instance.new("Folder",script)
folder.Name = "Screens"

-- Functions
function GetPlayerFromName(nam)
	if type(nam) ~= "string" or nam=="" then return {owner} end
	local plrs = game:GetService("Players"):GetChildren()

	if table.find({"me","all","others","random"},nam) then
		nam = nam:lower()
		if nam == "me" then
			return {owner}
		elseif nam == "random" then
			return {plrs[math.random(1,#plrs)]}
		elseif nam == "all" then
			return plrs
		elseif nam == "others" then
			local r = {}
			table.foreach(plrs,function(i,v)
				if v ~= owner then
					table.insert(r,v)
				end
			end)
			return r
		end
	end

	local isDisplay = (nam:find("@")and true or false)
	local ending = (isDisplay and nam:split("@")[2] or nam)
	for _,v in pairs(plrs) do
		local sort = (isDisplay and v.DisplayName or v.Name)
		if (sort:lower()):sub(1,#ending) == ending:lower() then
			return {v}
		end
	end
end
local screens = {}


function HumanoidSetup()
	local char = owner.Character or owner.CharacterAdded:wait()
	hum = char:FindFirstChildOfClass("Humanoid")
	hum.Died:Connect(function()
		for _,v in pairs(screens) do
			v.Anchored = true
		end
	end)
end
HumanoidSetup()
function createScreen(size,offset)
	local CodeScreen = Instance.new("Part",folder)
	CodeScreen.Name = "CodeScreen"
	CodeScreen.Size = Vector3.new(1,1,1)
	CodeScreen.CFrame = hrp.CFrame
	CodeScreen.CanCollide = false
	CodeScreen.Massless = true

	local drawbox = Instance.new("SelectionBox",CodeScreen)
	drawbox.Adornee = CodeScreen

	game:GetService("TweenService"):Create(CodeScreen,tweenInfo,{
		Size = size,
		Color =screenColor,
		Transparency = .6
	}):Play()
	game:GetService("TweenService"):Create(drawbox,tweenInfo,{
		Color3 = screenColor,
		Transparency = .6,
		LineThickness = .02,
	}):Play()

	table.insert(screens,{CodeScreen,offset,createAlign(CodeScreen,offset)})

	CodeScreen:SetNetworkOwner(owner)

	local SurfaceGui = Instance.new("SurfaceGui",CodeScreen)
	SurfaceGui.Face = "Back"
	SurfaceGui.Name = "UI"


	return CodeScreen 	
end

function text(par,type,txt)
	local e = Instance.new(type,par)
	e.Name = "Box"
	e.Text = txt or "nothing"
	e.BackgroundTransparency = 1
	e.TextSize = 20
	e.Size = UDim2.new(1,0,1,0)
	e.TextColor3 = TextColor
	e.TextXAlignment = Enum.TextXAlignment.Left
	e.TextYAlignment = Enum.TextYAlignment.Top
	return e
end

function createAlign(part,cf)
	local alignPos = Instance.new("AlignPosition",part)
	local alignOri = Instance.new("AlignOrientation",part)

	local att1 = Instance.new("Attachment",hrp)
	local att0= Instance.new("Attachment",part)

	table.foreach({alignOri,alignPos},function(i,v)
		v.Attachment0 = att0
		v.Attachment1 = att1
	end)

	alignPos.RigidityEnabled = true
	alignOri.MaxTorque = 3000
	alignOri.Responsiveness = 12

	att1.CFrame = cf
	return att1
end

local Remote = Instance.new("RemoteFunction",owner.PlayerGui)
local ScreenObjValue = Instance.new("ObjectValue",Remote)
ScreenObjValue.Name = "Screens"
ScreenObjValue.Value = folder

local CodeScreen = createScreen(Vector3.new(7,5,.001),CFrame.new(0,1,-5))
local InfoScreen = createScreen(Vector3.new(6,3.5,.001),CFrame.new(-6,1,-3)*CFrame.Angles(0,math.rad(45),0))
local CommandScreen = createScreen(Vector3.new(6,3.5,.001),CFrame.new(6,1,-3)*CFrame.Angles(0,math.rad(-45),0))

owner.CharacterAdded:Connect(function(c)	
	hrp = c:WaitForChild("HumanoidRootPart",10)
	HumanoidSetup()
	for _,v in pairs(screens) do
		v.Anchored = true
	end
	if not hrp then
		script:Remove()
		error("Stopped script.")
	end
	for _,scr in pairs(screens) do
		local v = scr[1]
		local att = Instance.new("Attachment",hrp)
		if not v:FindFirstChild("Attachment") then
			Instance.new("Attachment",v)
		end
		for _,v2 in pairs({v.AlignOrientation,v.AlignPosition}) do
			v2.Attachment0 = v.Attachment
			v2.Attachment1 = att
		end
		att.CFrame = scr[2]
	end
end)

local CodeScreenTextbox = text(CodeScreen.UI,"TextBox","coding screen go brrr")
local CommandScreenTextbox = text(CommandScreen.UI,"TextBox")
local CommandScreenOutput = Instance.new("Frame",CommandScreen.UI)
local InfoScreenTextbox = text(InfoScreen.UI,"TextBox","haha nothing yet") 

InfoScreenTextbox.TextEditable = false
InfoScreenTextbox.Size = UDim2.new(1,0,1,0)
InfoScreenTextbox.TextSize = 30

local Outputs = {}

CommandScreenTextbox.PlaceholderText = "Command Here!"
CommandScreenTextbox.BackgroundTransparency = .9
CommandScreenTextbox.BorderSizePixel = 0
CommandScreenTextbox.Size = UDim2.new(1,0,.055,0)
CommandScreenTextbox.TextScaled = true

CommandScreenOutput.Size = UDim2.new(1,0,1-CommandScreenTextbox.Size.Y.Scale,0)
CommandScreenOutput.Position = UDim2.new(0,0,CommandScreenTextbox.Size.Y.Scale,0)
CommandScreenOutput.BackgroundTransparency = 1


CodeScreenTextbox.MultiLine = true

table.foreach({CodeScreenTextbox,CommandScreenTextbox},function(_,v)
	v.ClearTextOnFocus = false
end)

CodeScreen.Name = "Code"
CommandScreen.Name = "Command"
InfoScreen.Name = "Info"


function OutputLog(txtt,notime)
	local time = os.date("*t")
	local TEXT = (notime and "" or "<font size=\"16\">"..table.concat({time.hour,time.min,time.sec},":").." - </font>")..tostring(txtt)

	local txt
	if #Outputs > 0 and Outputs[#Outputs].Name == TEXT then
		txt = Outputs[#Outputs]
		txt.TIMES.Value+=1
		txt.Text = txt.Name..(" (%s)"):format(txt.TIMES.Value+1)
	else
		for _,v in pairs(Outputs) do
			v.Position += UDim2.new(0,0,0,35)
		end
		txt = Instance.new("TextBox",CommandScreenOutput)
		local times = Instance.new("NumberValue",txt)
		times.Name = "TIMES"
		txt.TextEditable = false
		txt.Size = UDim2.new(1,0,0,29)
		txt.Text = TEXT
		txt.Name = TEXT
		txt.BackgroundTransparency = 1
		txt.TextColor3 = TextColor
		txt.TextXAlignment = Enum.TextXAlignment.Left
		txt.TextSize = 30
		txt.RichText = true
		txt.AutomaticSize = Enum.AutomaticSize.X
		table.insert(Outputs,txt)
		if #Outputs == 18 then
			local op = Outputs[1]
			table.remove(Outputs,1)
			op:Remove()
		end
	end
	return txt
end

local jailed = {}

local prefix = "~"

local exeVariables = {
	owner = owner,
	this = CodeScreen,
	text = CommandScreenTextbox,
	log = OutputLog,
}
local commands
commands = {
	{"clear",{Args=0,"Clears the console.",function()
		for i,v in pairs(Outputs) do
			v:Remove()
			table.remove(Outputs,i)
		end
	end,}},
	{"help",{Args = 1,"Gets help.",function(args,after)
		if after == "" then
			OutputLog("Welcome to Techa v"..scriptversion.."! This is a script where you can",true).TextColor3 = Color3.new(0,1,0)
		end
	end,}},
	{"exe",{Args = 1,"Executes code, or the middle screen. Ex: exe log(\"Hello World!\")",function(args,after)
		local txt = (after == "" and CodeScreenTextbox.Text or after)

		local succ,errormsg = pcall(function()
			spawn(function()
				local func = loadstring(txt)
				if func then
					local env = getfenv(func)
					for i,v in pairs(exeVariables) do
						env[i] = v
					end
					setfenv(func,env)
					func()
				else
					print("There was a syntax error inside of the script.")
				end
			end)
		end)
		if not succ then
			print("Error in script! "..errormsg)
		end
	end,}},
	{"steal",{Args = 1,"Steals a tool from a player(s) hand.",function(args,after)
		local stealfrom = GetPlayerFromName(after)
		for _,v in pairs(stealfrom) do
			local char = v.Character
			if char then
				local tool = char:FindFirstChildOfClass("Tool")
				if tool then
					tool.Parent = owner.Backpack
				end
			end
		end
	end,}},
	{"stealbp",{Args = 1,"Steals tools from a player(s) backpack.",function(args,after)
		local stealfrom = GetPlayerFromName(after)
		for _,v in pairs(stealfrom) do
			for _,tool in pairs(v.Backpack:GetChildren()) do
				if tool:IsA("Tool") then
					tool.Parent = owner.Backpack
				end
			end
		end
	end,}},
	{"kill",{Args = 1,"Kills a player(s)",function(args,after)
		local plrs = GetPlayerFromName(after)
		for _,plr in pairs(plrs) do
			local char = plr.Character
			if char then
				local hum = char:FindFirstChildOfClass("Humanoid")
				if hum then
					hum.Health = 0
				end
			end
		end
	end,}},
	{"respawn",{Args = 1,"Respawns player(s)",function(args,after)
		local plrs = GetPlayerFromName(after)
		for _,plr in pairs(plrs) do
			plr:LoadCharacter()
		end
	end,}},
	{"tp",{Args = 2,"Tp a player(s) to another player. Ex: tp player1 player2",function(args,after)
		local plr1 = GetPlayerFromName(args[1])
		local plr2 = GetPlayerFromName(args[2])[1]
		if plr2 and #args == 2 then
			local char2 = plr2.Character
			if char2 then
				local hrp2 = char2.PrimaryPart
				if hrp2 then
					for _,v in pairs(plr1) do
						local char1 = v.Character
						if char1 then
							local hrp1 = char1.PrimaryPart
							if hrp1 then
								char1:SetPrimaryPartCFrame(hrp2.CFrame)
							end
						end
					end
				end
			end
		elseif plr2 and #args == 1 and #plr1 == 1 then
			local char1 = plr1[1].Character
			if char1 then
				if char1.PrimaryPart then
					owner.Character:SetPrimaryPartCFrame(char1.PrimaryPart.CFrame)
				end
			end
		end
	end,}},
	{"freeze",{Args = 1,"Freezes players.",function(args,after)
		local plrs = GetPlayerFromName(after)
		for _,v in pairs(plrs) do
			if v.Character then
				for _,prt in pairs(v.Character:GetDescendants()) do
					if prt:IsA("BasePart") then
						prt.Anchored = true
					end
				end
			end
		end
	end,}},
	{"unfreeze",{Args = 1,"Unfreezes players.",function(args,after)
		local plrs = GetPlayerFromName(after)
		for _,v in pairs(plrs) do
			if v.Character then
				for _,prt in pairs(v.Character:GetDescendants()) do
					if prt:IsA("BasePart") then
						prt.Anchored = false
					end
				end
			end
		end
	end,}},
	{"speed",{Args = 2,"Changes someones speed. Ex: speed player 50",function(args,after)
		local plr = GetPlayerFromName(args[1])
		local hums = {}
		if #args == 1 then
			hums = {owner.Character:FindFirstChildOfClass("Humanoid")}
		else
			for _,v in pairs(plr) do
				if v.Character then
					local hum = v.Character:FindFirstChildOfClass("Humanoid")
					if hum then
						table.insert(hums,hum)
					end
				end
			end
		end
		for _,v in pairs(hums) do
			if tonumber(args[#args]) then
				v.WalkSpeed = tonumber(args[#args])
			end
		end
	end,}},
	{"jump",{Args = 2,"Changes someones jump. Ex: jump player 100",function(args,after)
		local plr = GetPlayerFromName(args[1])
		local hums = {}
		if #args == 1 then
			hums = {owner.Character:FindFirstChildOfClass("Humanoid")}
		else
			for _,v in pairs(plr) do
				if v.Character then
					local hum = v.Character:FindFirstChildOfClass("Humanoid")
					if hum then
						table.insert(hums,hum)
					end
				end
			end
		end
		for _,v in pairs(hums) do
			if tonumber(args[#args]) then
				v.JumpPower = tonumber(args[#args])
			end
		end
	end,}},
	{"god",{Args = 1,"Makes someone almost invincible.",function(args,after)
		local plr = GetPlayerFromName(args[1])
		local hums = {}
		for _,v in pairs(plr) do
			if v.Character then
				local hum = v.Character:FindFirstChildOfClass("Humanoid")
				if hum and not v.Parent:FindFirstChild("ForceField") then
					table.insert(hums,hum)
				end
			end
		end
		for _,v in pairs(hums) do
			v.Changed:Connect(function(h)
				if h == "Health" then
					if v.MaxHealth == math.huge then
						v.Health = math.huge
					end
				end
			end)
			v.MaxHealth = math.huge
			v.Health = math.huge
			local FF = Instance.new("ForceField",v.Parent)
			FF.Visible = false
		end
	end,}},
	{"ungod",{Args = 1,"Revokes invincibility.",function(args,after)
		local plr = GetPlayerFromName(args[1])
		local hums = {}
		for _,v in pairs(plr) do
			if v.Character then
				local hum = v.Character:FindFirstChildOfClass("Humanoid")
				if hum then
					table.insert(hums,hum)
				end
			end
		end
		for _,v in pairs(hums) do
			v.MaxHealth = 100
			v.Health = 100
			if v.Parent:FindFirstChild("ForceField") then
				v.Parent:FindFirstChild("ForceField"):Remove()
			end
		end
	end,}},
	{"jail",{Args = 1,"Jails somebody.",function(args,after)
		local plr = GetPlayerFromName(after)
		for _,v in pairs(plr) do
			table.insert(jailed,{v.UserId,CFrame.new(hrp.Position+Vector3.new(0,0,-7))})
		end
	end,}},
	{"unjail",{Args = 1,"Unjails a player.",function(args,after)
		local plr = GetPlayerFromName(after)
		for _,v in pairs(plr) do
			for i,b in pairs(jailed) do
				if b[1] == v.UserId then
					table.remove(jailed,i)
				end
			end
		end
	end,}},
}

function runcommand(c)
	local lower = c:lower()

	local split = c:split(" ") or {c}
	local args = {}
	table.foreach(split,function(i,v)
		if i ~= 1 then
			table.insert(args,v)
		end
	end)

	for _,v in pairs(commands) do
		if c:sub(1,#v[1]) == v[1] then
			v[2][2](args,table.concat(args," "))
			OutputLog("<font color=\"rgb(0,255,255)\">Used command: "..v[1].."</font>",true).RichText = true
			break
		end
	end
end

Remote.OnServerInvoke = function(plr,type,a,b)
	if type == "code_changetext" then
		CodeScreenTextbox.Text = a
	elseif type == "command_changetext" then
		CommandScreenTextbox.Text = a
	elseif type == "command_enter" then
		runcommand(CommandScreenTextbox.Text)
	end
end
owner.Chatted:Connect(function(c)
	if c:sub(1,1) == prefix then
		runcommand(c:sub(2,#c))
	end
end)

OutputLog("Welcome to <font color=\"rgb(255,127,0)\">Techa!</font>",true).RichText = true

plrs.PlayerAdded:Connect(function(p)
	OutputLog("<font color=\"rgb(0,255,0)\">"..p.Name.."</font> has <font color=\"rgb(0,255,0)\">joined</font> the server").RichText = true
end)
plrs.PlayerRemoving:Connect(function(p)
	OutputLog("<font color=\"rgb(0,255,0)\">"..p.Name.."</font> has <font color=\"rgb(255,0,0)\">left</font> the server").RichText = true
end)

NLS([[
	local UIS = game:GetService'UserInputService'
	local Remote = script.Parent
	local Screens = script.Parent.Screens.Value
	local CodeScreen,CommandScreen = Screens.Code,Screens.Command

	local CodeScreenBox = CodeScreen:WaitForChild("UI"):WaitForChild("Box")
	local CodeScreenText = CodeScreenBox:Clone()
	local CommandScreenBox = CommandScreen:WaitForChild("UI"):WaitForChild("Box")
	local CommandScreenText = CommandScreenBox:Clone()

	CodeScreenText.Parent = CodeScreenBox.Parent
	CommandScreenText.Parent = CommandScreenBox.Parent

	table.foreach({CommandScreenText.Parent,CodeScreenText.Parent},function(_,v)
		v.Adornee = v.Parent
		v.Parent = owner.PlayerGui
	end)
	table.foreach({CodeScreenBox,CommandScreenBox},function(i,v)
		v.Visible = false
		
		v.Changed:Connect(function(c)
			if not table.find({"Text","Visible"},c) then
				pcall(function()
					if i == 1 then
						CodeScreenText[c] = v[c]
					else
						CommandScreenText[c] = v[c]
					end
				end)
			end
		end)
		
	end)

	CodeScreenText.Changed:Connect(function(t)
		if t == "Text" then
			Remote:InvokeServer("code_changetext",CodeScreenText.Text)
		end
	end)
	CommandScreenText.Changed:Connect(function(t)
		if t == "Text" then
			Remote:InvokeServer("command_changetext",CommandScreenText.Text)
		end
	end)
	CommandScreenText.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			Remote:InvokeServer("command_enter")
			CommandScreenText.Text = ""
		end
	end)

	local changed = {}
	local entries = owner.PlayerGui.SB_OutputGUI.Main.Output.Entries
	entries.ChildAdded:Connect(function()
		for _,b in pairs(changed) do
			for i,v in pairs(b[2]) do
				b[1][i] = v
			end
		end
	end)
	function ChangedPrint(msg,tab)
		local c
		task.spawn(function()
			c = entries.ChildAdded:Wait()
		end)
		print(msg)
		table.insert(changed,{c,tab})
		for _,b in pairs(changed) do
			for i,v in pairs(b[2]) do
				b[1][i] = v
			end
		end
	end
	ChangedPrint("\nstopped script.\n",{Text="Techa - By Wapplee1",TextSize = 40,TextColor3 = Color3.new(1,.5,0)})
	ChangedPrint("You can type in commands inside the right console! To start, type help.",{})
	ChangedPrint("Version ]]..scriptversion..[[",{TextSize = 10})
	]],Remote)

while true do
	for i,JAILED in pairs(jailed) do
		local plr = game:GetService("Players"):GetChildren()
		for _,v in pairs(plr) do
			if v.UserId == JAILED[1] then
				plr = v
				break
			end
		end
		if plr then
			local char = plr.Character
			if char then
				if not JAILED[3] or not JAILED[3].Parent then
					local jail = Instance.new("Folder",script)
					jail.Name = "JAIL: "..plr.Name
					local cf = JAILED[2]
					local jailprt1 = Instance.new("Part",jail)
					jailprt1.Size = Vector3.new(8,7,.5)
					jailprt1.Anchored = true
					jailprt1.Material = "Neon"
					jailprt1.Locked = true
					jailprt1.CFrame = cf*CFrame.new(-(jailprt1.Size.X/2),0,0)
					char:SetPrimaryPartCFrame(cf)
					table.insert(jailed[i],jail)
				end
			else
				plr:LoadCharacter()
			end
		end
	end
	local maxplrs = plrs.MaxPlayers
	local plrs = plrs:GetChildren()

	local sfps = math.round(2/wait())
	local pfps = math.round(workspace:GetRealPhysicsFPS())

	local items = workspace:GetDescendants()
	local scripts = 0
	local pparts = 0

	for _,v in pairs(items) do
		if v:IsA("BasePart") and v.Anchored == false then
			pparts+=1
		elseif v:IsA("Script") then
			scripts+=1
		end
	end

	InfoScreenTextbox.Text = ([[Version: %s
Server FPS: %s
Physics FPS: %s
Players: %s
Instances: %s
Scripts (workspace): %s
Unanchored Parts: %s]]):format(scriptversion,sfps,pfps,#plrs.."/"..maxplrs,#items,scripts,pparts)
end

-- Better instance.new
local Instance = {new = function(a,b)
	
	local Parent = nil
	local prt = Instance.new(a)
	if typeof(b) == "Instance" then
		Parent = b
		prt.Parent = b
	else
		for i,v in pairs(b) do
			if i ~= "Parent" then
				prt[i] = v
			else
				Parent = v
			end
		end
	end
	prt.Parent = Parent
	return prt
end,}
-- Main board
local board = Instance.new("Part",{Parent = script,Name = "Board",Anchored = true,CanCollide = false,Size = Vector3.new(6,3.5,1),Position = owner.Character.Torso.Position+Vector3.new(0,0,3)})

-- Custom buttons
local boardExecute = Instance.new("Part",{Parent = board,Anchored = true,CanCollide = false,Size = Vector3.new(1,1,1),CFrame = board.CFrame*CFrame.new(board.Size.X/2-.5,board.Size.Y/2+.5,0),Color = Color3.new(0,1,0)})
local boardexecuteEveryone = Instance.new("Part",{Parent = board,Anchored = true,CanCollide = false,Size = Vector3.new(1,1,1),CFrame = board.CFrame*CFrame.new(board.Size.X/2-1.5,board.Size.Y/2+.5,0),Color = Color3.new(0,0,.3)})
local boardInvisible = Instance.new("Part",{Parent = board,Anchored = true,CanCollide = false,Size = Vector3.new(1,1,1),CFrame = board.CFrame*CFrame.new(board.Size.X/2-2.5,board.Size.Y/2+.5,0),Color = Color3.new(1,1,1)})
local boardRemove = Instance.new("Part",{Parent = board,Anchored = true,CanCollide = false,Size = Vector3.new(1,1,1),CFrame = board.CFrame*CFrame.new((board.Size.X/2)*-1+.5,board.Size.Y/2+.5,0),Color = Color3.new(1,0,0)})

-- Button workers?
local executeClick = Instance.new("ClickDetector",{Parent = boardExecute})
local executeEveryone = Instance.new("ClickDetector",boardexecuteEveryone)
local boardInvisibleClick = Instance.new("ClickDetector",boardInvisible)
local boardRemoveClick = Instance.new("ClickDetector",boardRemove)

-- Guis
local surface = Instance.new("SurfaceGui",{Parent = board,Adornee = board,Name = "Surface",AlwaysOnTop = true})
local scroll = Instance.new("ScrollingFrame",{Name="Scroll",Parent = surface,AutomaticCanvasSize = "XY",Size = UDim2.new(1,0,1,0),ClipsDescendants = true,CanvasSize = UDim2.new(0,0,0,0)})
local txtBox = Instance.new("TextBox",{ClearTextOnFocus = false,Name="Txt",Parent = scroll,Size = UDim2.new(1,0,1,0),TextXAlignment = "Left",TextYAlignment = "Top",MultiLine = true,TextWrapped = false,AutomaticSize = "XY",BackgroundTransparency = 1,TextSize = 20,Text = "dont type anything innopropriate people can see this"})


-- variables
local executingEveryone = false
local boardInvisibleStat = false

local remote = Instance.new("RemoteFunction",owner.PlayerGui)


-- Work button workers
boardRemoveClick.MouseClick:Connect(function(p)
	if p ~= owner then return end
	remote:InvokeClient(owner,true)
	wait(1)
	board:Remove()
end)
boardInvisibleClick.MouseClick:Connect(function(p)
	if p ~= owner then return end
	boardInvisibleStat = not boardInvisibleStat
	boardInvisible.Color = (boardInvisibleStat == true and Color3.new(.5,.5,.5) or Color3.new(1,1,1))
	txtBox.TextTransparency = (boardInvisibleStat == true and 1 or 0)
end)
executeEveryone.MouseClick:Connect(function(p)
	if p ~= owner then return end
	
	executingEveryone = not executingEveryone
	boardexecuteEveryone.Color = (executingEveryone == true and Color3.new(0,0,1) or Color3.new(0,0,.3))
end)
executeClick.MouseClick:Connect(function(p)
	if not executingEveryone then
		if p ~= owner then return end
	end
	loadstring("local owner = game:GetService'Players'['"..p.Name.."']"..txtBox.Text)()
end)


-- Displaying for everyone

remote.OnServerInvoke = function(plr,t)
	if plr ~= owner then return end
	txtBox.Text = t
end

local value = Instance.new("ObjectValue",{Parent = remote,Value = surface})
NLS([[
local plr = game:GetService'Players'.LocalPlayer


local remote = script.Parent.Parent

local surface = script.Parent.Value
local oldSurface = surface
surface = surface:Clone()
oldSurface:Remove()

remote.OnClientInvoke = function(c)
	if not c then return end
	surface:Remove()
end

plr.Chatted:Connect(function(c)
	if c == "g/ns" or c == "g/nog" or c == "g/no." or c == "g/nl" then
		surface:Remove()
	end
end)

surface.Parent = plr.PlayerGui

surface.Scroll.Txt.Changed:Connect(function()
	remote:InvokeServer(surface.Scroll.Txt.Text)
end)


]],value)

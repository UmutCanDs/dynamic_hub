--Mitz Reanim
local Player = game:GetService('Players').LocalPlayer
local CustomCharacter = Player.Character
local Muse = Player:GetMouse()

local fakebody = Instance.new("Part", game:GetService('Players').LocalPlayer.Character)
fakebody.Transparency = 1
fakebody.Size = Vector3.new(1,1,1)
fakebody.Anchored = true
fakebody.CanCollide = false
fakebody.Position =  game:GetService('Players').LocalPlayer.Character.Head.Position
fakebody.Name = "FakeBodyPart"
wait()

sethiddenproperty(game.Players.LocalPlayer,"MaximumSimulationRadius",math.huge)
sethiddenproperty(game.Players.LocalPlayer,"SimulationRadius",1.0000000331814e+32)

for i,v in next, game:GetService("Players").LocalPlayer.Character:GetDescendants() do
if v:IsA("BasePart") and v.Name ~="HumanoidRootPart" then 
game:GetService("RunService").Heartbeat:connect(function()
v.Velocity = Vector3.new(0,-25.05,0)
wait(0.5)
end)
end
end

local Fling = true 
local FlingBlockInvisible = false 
local HighlightFlingBlock = false 
local FlingHighlightColor = Color3.fromRGB(255,255,255)
  
Bypass = "death"
loadstring(game:GetObjects("rbxassetid://5325226148")[1].Source)()

e = Instance.new("BodyVelocity",game.Players.LocalPlayer.Character.HumanoidRootPart)
e.Velocity = Vector3.new(0,-25.05,0)
e.P = math.huge
 
local IsDead = false
local StateMover = true
 
local playerss = workspace.non
local bbv,bullet
if Bypass == "death" then
	bullet = game.Players.LocalPlayer.Character["HumanoidRootPart"]
	bullet.Transparency = (FlingBlockInvisible ~= true and 0 or 1)
	bullet.Massless = true
	if bullet:FindFirstChildOfClass("Attachment") then
		for _,v in pairs(bullet:GetChildren()) do
			if v:IsA("Attachment") then
				v:Destroy()
			end
		end
	end
 
	bbv = Instance.new("BodyPosition",bullet)
    bbv.Position = playerss.FakeBodyPart.Position
end
 
if Bypass == "death" then
coroutine.wrap(function()
	while true do
		if not playerss or not playerss:FindFirstChildOfClass("Humanoid") or playerss:FindFirstChildOfClass("Humanoid").Health <= 0 then IsDead = true; return end
		if StateMover then
			bbv.Position = playerss.FakeBodyPart.Position
    		bullet.Position = playerss.FakeBodyPart.Position
		end
		game:GetService("RunService").RenderStepped:wait()
	end
end)()
end
 
 
if HighlightFlingBlock ~= false then
    local Highlight = Instance.new("SelectionBox")
    Highlight.Adornee = bullet
    Highlight.Color3 = (typeof(FlingHighlightColor)=="Color3" and FlingHighlightColor) or (Color3.fromRGB(255,0,0))
    Highlight.Parent = bullet
    Highlight.Name = "HighlightBox"
end
 
bbav = Instance.new("BodyAngularVelocity",bullet)
    bbav.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    bbav.P = 100000000000000000000000000000
    bbav.AngularVelocity = Vector3.new(10000000000000000000000000000000,100000000000000000000000000,100000000000000000)

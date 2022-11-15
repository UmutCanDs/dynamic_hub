--simple reanimate by iss0
local run_service,plrs,workspace,starter_gui = game:GetService('RunService'),game:GetService('Players'),game:GetService('Workspace'),game:GetService('StarterGui')

local plr = plrs.LocalPlayer
local char,fake_char = plr.Character or workspace[name]
local hum,fake_hum = char:FindFirstChildWhichIsA('Humanoid')

local netless_parts = {}
local loops = {}

local V3 = {n=Vector3.new}
local CF = {n=CFrame.new, a=CFrame.Angles}
local IT = {n=Instance.new}

local function movedir_calc(move_dir, ws)
    local abs_x = math.abs(move_dir.Z)
    local abs_z = math.abs(move_dir.X)

    return 
    V3.n(
        move_dir.X > 0 and abs_z+move_dir.X * ws or -abs_z+move_dir.X * ws
        ,15,
        move_dir.Z > 0 and abs_x+move_dir.Z * ws or -abs_x+move_dir.Z * ws
    )
end

local function rotvel_calc(rotvel)
    local abs_x = math.abs(rotvel.Z)
    local abs_y = math.abs(rotvel.Y)
    local abs_z = math.abs(rotvel.X)

    return
    V3.n(
        rotvel.X > 0 and abs_z+rotvel.X or -abs_z+rotvel.X,
        rotvel.Y > 0 and abs_y+rotvel.Y or -abs_z+rotvel.Y,
        rotvel.Z > 0 and abs_x+rotvel.Z or -abs_x+rotvel.Z
    )
end

local function stabilize(p, p1, cf)
    loops[#loops+1] =
    run_service['Heartbeat']:Connect(function()

        p.Position = p1.Position
        p.Orientation = p1.Orientation
        p.CFrame = p1.CFrame

        p.CFrame = cf and p1.CFrame * cf or p1.CFrame

        if fake_hum.MoveDirection == V3.n(0, 0, 0) then
            local vel = V3.n(20 , 15 + math.round(fake_char.HumanoidRootPart.Velocity.Y) ,20)

            p:ApplyImpulse(vel)
            p.AssemblyLinearVelocity = vel
       
        else
            local move_dir = movedir_calc(fake_hum.MoveDirection, fake_hum.WalkSpeed*6)

            p:ApplyImpulse(move_dir)
            p.AssemblyLinearVelocity = V3.n(move_dir.X, fake_char.HumanoidRootPart.Velocity.Y, move_dir.Z)
        end

        p.RotVelocity = rotvel_calc(p1.RotVelocity)
    end)
end

local function basepart_tweaks(p)
    p.CanTouch = false
    p.CanQuery = false
    p.RootPriority = 127
    p.Locked = false
    p.RobloxLocked = false

    sethiddenproperty(p, 'NetworkOwnershipRule', Enum.NetworkOwnership.Manual)

    setscriptable(p, 'NetworkIsSleeping', true)
end

local function collision()
    for _,v in pairs(char:GetDescendants()) do
        if not v:IsA('BasePart') then continue end

        v.CanCollide = false
    end

    hum:ChangeState(Enum.HumanoidStateType.Physics)
end

local function legacy_net()
    hum:ChangeState(Enum.HumanoidStateType.Physics)

    plr.SimulationRadius = 1e+10
    plr.MaximumSimulationRadius = 1e+10
end

local function on_reset()
    if disconnecting then return end

    disconnecting = true
    plr.Character = char

    char:Destroy()
    print('Reseted plr.')

    for i=1,#loops do
        loops[i]:Disconnect()
    end

    print('Disconnected: ' ..tostring(#loops) ..' loops.')

    starter_gui:SetCore('ResetButtonCallback' ,true)

    wait(1)
    disconnecting = false
    print('Restart function done.')
end



sethiddenproperty(workspace, 'InterpolationThrottling', Enum.InterpolationThrottlingMode.Disabled)
sethiddenproperty(hum, 'InternalBodyScale', V3.n(9e99, 9e99, 9e99))
sethiddenproperty(hum, 'InternalHeadScale', 9e99)

setscriptable(plr, 'SimulationRadius', true)
setscriptable(plr, 'MaximumSimulationRadius', true)

settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
settings().Physics.AllowSleep = false

plr.ReplicationFocus = nil

getgenv().isPrimaryOwner = true

char.Archivable = true

do
    local hat_names = {}

    for _,v in pairs(hum:GetAccessories()) do
        basepart_tweaks(v:FindFirstChildWhichIsA('BasePart'))

        if hat_names[v.Name] then
            hat_names[v.Name][#hat_names[v.Name] + 1] = v
            v.Name = v.Name .. #hat_names[v.Name]

        else
            hat_names[v.Name] = {}
        end
    end
end

for _,v in pairs(char:GetChildren()) do
    if not v:IsA('BasePart') then continue end

    basepart_tweaks(v)
end

for _,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
    if v == Enum.HumanoidStateType.Physics then continue end

    pcall(function()
        hum:SetStateEnabled(v, false)
    end)
end

--char.HumanoidRootPart:Destroy()

fake_char = char:Clone()
fake_char.Parent = char
fake_char:MoveTo(char.Head.Position)

fake_hum = fake_char.Humanoid

for _,v in pairs(hum:GetPlayingAnimationTracks()) do
    v:Stop()
end
char.Animate.Disabled = true

for _,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do
    pcall(function()
        hum:SetStateEnabled(v, true)
    end)
end

for _,v in pairs(hum:GetAccessories()) do
    if v:FindFirstChildWhichIsA('BasePart'):FindFirstChildWhichIsA('Weld') then
        v:FindFirstChildWhichIsA('BasePart'):FindFirstChildWhichIsA('Weld'):Destroy()
    end

    stabilize(v:FindFirstChildWhichIsA('BasePart'), fake_char[v.Name]:FindFirstChildWhichIsA('BasePart'))
end

for _,v in pairs(fake_hum:GetAccessories()) do
    if v:FindFirstChildWhichIsA('BasePart'):FindFirstChildWhichIsA('SpecialMesh') then
        v:FindFirstChildWhichIsA('BasePart'):FindFirstChildWhichIsA('SpecialMesh'):Destroy()
    end

    v:FindFirstChildWhichIsA('BasePart').Transparency = 1
end

for _,v in pairs(fake_char:GetChildren()) do
    if v:IsA('BasePart') then 
        if not v.Name == 'HumanoidRootPart' then
            v.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
        end

        if v:FindFirstChildWhichIsA('Motor6D') then
            for _,v in pairs(char[v.Name]:GetChildren()) do
                if v:IsA('Motor6D') and v.Name ~= 'Neck' then
                    v:Destroy()
                end
            end
        end

        stabilize(char[v.Name], fake_char[v.Name])

        print('Stabilizing: ' ..v.Name)

        v.Transparency = 1

    elseif v:IsA('Texture') or v:IsA('Decal') then
        v.Transparency = 1

    elseif v:IsA('SpecialMesh') or v:IsA('Effect') or v:IsA('ForceField') then
        v:Destroy()

        print('Destroyed: ' ..v.Name)
    end
end

starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
plr.Character = fake_char
starter_gui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, true)

workspace.CurrentCamera.CameraSubject = fake_hum

starter_gui:SetCore('ResetButtonCallback' ,on_reset)

loops[#loops+1] = plr.CharacterRemoving:Connect(on_reset)
loops[#loops+1] = run_service['Stepped']:Connect(collision)
loops[#loops+1] = run_service['Heartbeat']:Connect(legacy_net)
loops[#loops+1] = run_service['Heartbeat']:Connect(function()
    char.HumanoidRootPart.Velocity = V3.n(50,0,50)
end)

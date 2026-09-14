local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local stats = game:GetService("Stats")
local virtualInputManager = game:GetService("VirtualInputManager")
local tweenService = game:GetService("TweenService")

local localPlayer = players.LocalPlayer

getgenv().AntiVoid = true

local enabled = true
local stopped = false

local minDistance = 5
local defaultDistance = 5
local lmbDistance = 5
local keyDistance = 5
local currentDistance = defaultDistance

local belowDistance = 5
local minBelowDistance = 5
local maxBelowDistance = 30
local currentBelowDistance = belowDistance

local behindDistance = 5
local behindYOffset = 0

local groundSink = 1.5

local characterDownTilt = math.rad(7)

local meleeStickyDuration = 0.6
local combatStandoff = 5
local combatYOffset = 0

local positionSmoothness = 40
local awayDirMemory = 1.5

local damagePushBack = 1.5
local damageNudge = 0.5
local userAttackRange = 10
local damageReactionLimit = 2

local teamerDefenseEnabled = true
local teamerHostileCount = 2
local teamerHostileRadius = 22
local teamerFacingDot = 0.35
local teamerHostileMinSpeed = 2.5
local teamerMovementMemory = 0.75
local teamerParkTime = 2.5
local damageBurstWindow = 0.8
local damageBurstCount = 2
local panicParkTime = 2

local finisherHpThreshold = 15

local particleRecoveryEnabled = true
local particleRescanInterval = 0.15
local particleGracePeriod = 0.35
local particleRecoverySkipsFinisher = true
local targetDamageMemory = 0.7
local persistentParticleThreshold = 60

local particleSkipAccessories = true
local particleNameBlacklist = {
    "footstep", "dust", "ambient", "idle", "sweat", "step",
    "awaken", "wake", "aura", "buff", "glow", "shine",
    "hair", "hat", "wing", "cape", "accessory", "accessor",
    "music", "particleholder", "seizure", "flameaura",
    "footprint", "sparkle", "fart", "gas", "smoke",
}

local holdBackAmount = 4.5
local holdReleaseDelay = 2

local oneBackAmount = 0.75

local lmbCheckDelay = 0.4

local heavyDamageThreshold = 15
local lowHealthThreshold = 30

local smartTargetingEnabled = true
local smartPositionEnabled = true
local smartRecoveryEnabled = true
local adaptivePredictionEnabled = true

local victimCamEnabled = true
local sidebarEnabled = true

local macroStepDelay = 0.15
local macroGoVictimWait = 1
local macroRecoveryWait = 5

local facingDotThreshold = 0.35
local predictionHistory = 8
local threatRadius = 30
local threatCountTrigger = 2
local selfHpRecoveryPct = 0.4
local selfDpsWindow = 1.5
local selfDpsRecoveryThreshold = 25

local promptInteractDistance = 16

local parkPosition = Vector3.new(0, 2000, 0)

local vCycleRounds = 2
local vCycleDelay = 0.35

local hudEnabled = true
local helpEnabled = false

local predictionEnabled = true
local predictionStrength = 1.0
local predictionLookahead = 0.16
local predictionMoveCompensation = 1.6
local predictionMaxOffset = 38
local predictionPingScale = 1.0
local predictionPingCap = 0.28

local wallRaycastDistance = 500
local wallStopOffset = 3
local wallRetreatSpeedFallback = 20
local wallRecalcDistance = 40

local m1TeleportDistance = 4

local manualRecoveryCooldownTime = 4
local manualRecoveryCooldown = 0

local recoveryOnAttack = true
local instantInteractEnabled = true

local positionBelow = "below"
local positionBehind = "behind"
local positionAuto = "auto"
local positionMode = positionBehind

local loadingUrl = "https://raw.githubusercontent.com/fischisreal/LarpingHub/main/docs/Loading.lua"

local attackAnimationIds = {
    "rbxassetid://1234567890",
    "rbxassetid://1234567891",
    "rbxassetid://1234567892",
}

local accent = Color3.fromRGB(120, 180, 255)
local accentAlt = Color3.fromRGB(200, 130, 255)
local bgDark = Color3.fromRGB(16, 16, 20)
local bgMid = Color3.fromRGB(24, 24, 30)
local bgLight = Color3.fromRGB(36, 36, 44)
local textDim = Color3.fromRGB(160, 160, 175)
local textColor = Color3.fromRGB(240, 240, 245)
local okColor = Color3.fromRGB(110, 210, 140)
local warnColor = Color3.fromRGB(240, 200, 90)
local badColor = Color3.fromRGB(240, 100, 100)
local infoColor = Color3.fromRGB(140, 180, 255)
local specialColor = Color3.fromRGB(200, 130, 255)

local target
local previousTarget
local candidates = {}

local mainConnection
local inputConnection
local inputEndedConnection
local characterConnection
local trackedConnections = {}

local recoveryActive = false
local vCycleActive = false
local vCycleVersion = 0

local hud
local helpGui
local sidebar
local loadingScreen

local healthConnection = nil
local watchedHumanoid = nil
local lastHealth = 0
local damageReactionCount = 0
local lastTargetDamageTime = 0

local myHealthConnection = nil
local lastMyHealth = 0
local selfDamageTimes = {}

local keyFourHeld = false
local lmbHeld = false
local holdBackActive = false
local holdReleaseToken = 0
local lmbMissToken = 0

local velocityHistory = {}

local combatStickyUntil = 0

local cachedHeadTarget = nil
local cachedHead = nil

local killCount = 0
local lowHpCount = 0

local fpsFrames = 0
local fpsAccum = 0
local fpsDisplay = 0
local pingDisplay = 0
local statsAccum = 0

local macroActive = false
local macroToken = 0

local teamerParkUntil = 0
local teamerParkToken = 0

local cachedAwayDir = Vector3.new(0, 0, 1)
local cachedLookFlat = Vector3.new(0, 0, -1)

local cachedVictimHasParticles = false
local lastParticleCheck = 0
local lastParticleSeenAt = 0
local particleRecoveryActive = false
local particleContinuousStart = 0

local recentMovers = {}

local wallRetreatActive = false
local cachedWallCFrame = nil
local cachedWallTarget = nil
local cachedWallOrigin = nil

local m1Active = false
local ultedActive = false

local function track(connection)
    trackedConnections[#trackedConnections + 1] = connection
    return connection
end

local function getHumanoid(model)
    return model and model:FindFirstChildOfClass("Humanoid")
end

local function getRoot(model)
    return model and model:FindFirstChild("HumanoidRootPart")
end

local function getHead(model)
    if not model then return nil end
    return model:FindFirstChild("Head")
end

local function getTorso(model, fallback)
    if not model then return fallback end

    local upper = model:FindFirstChild("UpperTorso")
    if upper then return upper.Position end

    local torso = model:FindFirstChild("Torso")
    if torso then return torso.Position end

    local chest = model:FindFirstChild("Chest")
    if chest then return chest.Position end

    return fallback
end

local function isValidTarget(model)
    if not model or not model:IsA("Model") then return false end
    if model == localPlayer.Character then return false end
    if not model:IsDescendantOf(workspace) then return false end

    local humanoid = getHumanoid(model)
    local root = getRoot(model)
    if not humanoid or not root then return false end

    return humanoid.Health > 0
end

local function isTrulyDead(model)
    if not model then return true end
    if not model.Parent then return true end
    if not model:IsDescendantOf(workspace) then return true end

    local humanoid = getHumanoid(model)
    if not humanoid then return true end
    if humanoid.Health <= 0 then return true end

    return false
end

local function isFinisherTarget()
    if not target then return false end
    if not isValidTarget(target) then return false end

    local humanoid = getHumanoid(target)
    if not humanoid then return false end

    return humanoid.Health <= finisherHpThreshold
end

local function isAnchoredTarget(model)
    if not model then return false end
    local root = getRoot(model)
    if not root then return false end
    return root.Anchored == true
end

local function hasGrabbedFolder(model)
    if not model then return false end
    return model:FindFirstChild("Grabbed") ~= nil
end

local function hasM1Attribute(model)
    if not model then return false end
    local ok, attrs = pcall(function() return model:GetAttributes() end)
    if not ok or not attrs then return false end
    for name, value in pairs(attrs) do
        if type(value) == "boolean" and value == true then
            local lower = string.lower(tostring(name))
            if string.find(lower, "m1", 1, true) then
                return true
            end
        end
    end
    return false
end

local function hasUltedAttribute(model)
    if not model then return false end
    local ok, attrs = pcall(function() return model:GetAttributes() end)
    if not ok or not attrs then return false end
    for name, value in pairs(attrs) do
        if type(value) == "boolean" and value == true then
            local lower = string.lower(tostring(name))
            if string.find(lower, "ulted", 1, true) then
                return true
            end
        end
    end
    return false
end

local function isProtectedFromTeamerDetection(model)
    if not model then return true end
    if isAnchoredTarget(model) then return true end
    if hasGrabbedFolder(model) then return true end
    return false
end

local function isBlacklistedName(name)
    if not name then return false end
    local lower = string.lower(name)
    for _, keyword in ipairs(particleNameBlacklist) do
        if string.find(lower, keyword, 1, true) then
            return true
        end
    end
    return false
end

local function isUnderAccessory(obj)
    if not particleSkipAccessories then return false end
    if obj:FindFirstAncestorOfClass("Accessory") then return true end
    if obj:FindFirstAncestorOfClass("Accoutrement") then return true end
    return false
end

local function victimHasParticles()
    if not target then return false end
    if not isValidTarget(target) then return false end

    for _, obj in ipairs(target:GetDescendants()) do
        local isEffect =
            obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Beam")

        if isEffect and obj.Enabled then
            if not isUnderAccessory(obj) and not isBlacklistedName(obj.Name) then
                return true
            end
        end
    end

    return false
end

local function addCandidate(model)
    if isValidTarget(model) then
        candidates[model] = true
    end
end

local function removeCandidate(model)
    candidates[model] = nil
    if target == model then
        target = nil
    end
    if previousTarget == model then
        previousTarget = nil
    end
    recentMovers[model] = nil
end

local function getCandidates()
    local result = {}
    for model in pairs(candidates) do
        if isValidTarget(model) then
            result[#result + 1] = model
        else
            candidates[model] = nil
            recentMovers[model] = nil
        end
    end
    return result
end

local function getModelFromPart(part)
    local model = part and part:FindFirstAncestorOfClass("Model")
    while model do
        if getHumanoid(model) then
            return model
        end
        model = model:FindFirstAncestorOfClass("Model")
    end
    return nil
end

local function getMyRoot()
    local character = localPlayer.Character
    return character and getRoot(character)
end

local function scoreTarget(model)
    local myRoot = getMyRoot()
    local root = getRoot(model)
    local humanoid = getHumanoid(model)
    if not myRoot or not root or not humanoid then return math.huge end

    local dist = (root.Position - myRoot.Position).Magnitude

    local maxHp = math.max(humanoid.MaxHealth, 1)
    local hpPct = math.clamp(humanoid.Health / maxHp, 0, 1)
    local hpScore = (1 - hpPct) * 40

    local toMe = myRoot.Position - root.Position
    local flat = Vector3.new(toMe.X, 0, toMe.Z)

    local facingScore = 0
    if flat.Magnitude > 0.05 then
        local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
        if look.Magnitude > 0.05 then
            local dot = look.Unit:Dot(flat.Unit)
            facingScore = math.max(0, dot) * 25
        end
    end

    return dist - hpScore - facingScore
end

local function sortSmart(list)
    if not smartTargetingEnabled then
        local myRoot = getMyRoot()
        if myRoot then
            table.sort(list, function(a, b)
                local ra, rb = getRoot(a), getRoot(b)
                if not ra then return false end
                if not rb then return true end
                return (ra.Position - myRoot.Position).Magnitude
                    < (rb.Position - myRoot.Position).Magnitude
            end)
        end
        return list
    end

    table.sort(list, function(a, b)
        return scoreTarget(a) < scoreTarget(b)
    end)
    return list
end

local function getTargetName(model)
    local player = players:GetPlayerFromCharacter(model)
    if player then
        return player.DisplayName
    end
    return model.Name
end

local function resetParticleTracking()
    cachedVictimHasParticles = false
    lastParticleCheck = 0
    lastParticleSeenAt = 0
    particleRecoveryActive = false
    particleContinuousStart = 0
end

local function clearWallCache()
    cachedWallCFrame = nil
    cachedWallTarget = nil
    cachedWallOrigin = nil
end

local function setTarget(newTarget)
    if newTarget ~= target then
        previousTarget = target
        resetParticleTracking()
        lastTargetDamageTime = 0
        wallRetreatActive = false
        m1Active = false
        ultedActive = false
        clearWallCache()
    end
    target = newTarget
end

local function lockTargetUnderMouse()
    local mouse = localPlayer:GetMouse()
    if not mouse then return false end

    local model = getModelFromPart(mouse.Target)
    if model and isValidTarget(model) then
        setTarget(model)
        currentDistance = defaultDistance
        currentBelowDistance = belowDistance
        damageReactionCount = 0
        velocityHistory = {}
        return true
    end
    return false
end

local function setDistance(value)
    currentDistance = math.max(minDistance, value)
end

local function selectClosestTarget()
    local list = sortSmart(getCandidates())
    if #list == 0 then
        previousTarget = target
        target = nil
        return false
    end
    setTarget(list[1])
    currentDistance = defaultDistance
    currentBelowDistance = belowDistance
    damageReactionCount = 0
    velocityHistory = {}
    return true
end

local function cycleTarget()
    local list = sortSmart(getCandidates())
    if #list == 0 then return false end

    local index = 0
    for i, model in ipairs(list) do
        if model == target then
            index = i
            break
        end
    end

    setTarget(list[(index % #list) + 1])
    currentDistance = defaultDistance
    currentBelowDistance = belowDistance
    damageReactionCount = 0
    velocityHistory = {}
    return true
end

local function goToPreviousTarget()
    if not previousTarget then return false end
    if not isValidTarget(previousTarget) then
        previousTarget = nil
        return false
    end

    local temp = target
    setTarget(previousTarget)
    previousTarget = temp

    currentDistance = defaultDistance
    currentBelowDistance = belowDistance
    damageReactionCount = 0
    velocityHistory = {}

    if isValidTarget(target) then
        local tRoot = getRoot(target)
        if tRoot then
            combatStickyUntil = tick() + meleeStickyDuration
        end
    end

    return true
end

local function updateVelocityHistory(root)
    if not adaptivePredictionEnabled then return end

    velocityHistory[#velocityHistory + 1] = root.AssemblyLinearVelocity

    while #velocityHistory > predictionHistory do
        table.remove(velocityHistory, 1)
    end
end

local function getSmoothedVelocity()
    if not adaptivePredictionEnabled then return nil end
    if #velocityHistory == 0 then return nil end

    local sum = Vector3.new(0, 0, 0)
    local weightTotal = 0

    for i, v in ipairs(velocityHistory) do
        local weight = i * i
        sum += v * weight
        weightTotal += weight
    end

    if weightTotal == 0 then return nil end
    return sum / weightTotal
end

local function getPingCompensation()
    local pingSec = math.clamp(pingDisplay / 1000, 0, predictionPingCap)
    return pingSec * predictionPingScale
end

local function predictPosition(root, deltaTime)
    if not predictionEnabled then return root.Position end

    local pos = root.Position
    local vel = getSmoothedVelocity() or root.AssemblyLinearVelocity
    local humanoid = getHumanoid(root.Parent)
    local moveDir = humanoid and humanoid.MoveDirection or Vector3.new(0, 0, 0)

    local dt = deltaTime or 0
    local lookahead = predictionLookahead + dt + getPingCompensation()

    local velLead = vel * (lookahead * predictionStrength)
    local walkLead = moveDir * (predictionMoveCompensation * predictionStrength)

    local predicted = pos + velLead + walkLead
    local offset = predicted - pos

    if offset.Magnitude > predictionMaxOffset then
        predicted = pos + offset.Unit * predictionMaxOffset
    end

    return predicted
end

local function applySmoothCFrame(root, targetCF, deltaTime)
    if not root then return end

    local dt = deltaTime or 0
    if dt <= 0 then
        root.CFrame = targetCF
        return
    end

    local alpha = math.clamp(1 - math.exp(-positionSmoothness * dt), 0, 1)
    root.CFrame = root.CFrame:Lerp(targetCF, alpha)
end

local function parkCharacter()
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if root then
        root.CFrame = CFrame.new(parkPosition)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

local function faceTorsoFrom(pos, targetRoot, predicted)
    local torsoPos = getTorso(targetRoot.Parent, predicted + Vector3.new(0, 2, 0))
    local dir = torsoPos - pos

    if dir.Magnitude < 0.05 then
        dir = Vector3.new(0, 1, 0)
    end

    local base = CFrame.lookAt(pos, pos + dir.Unit)
    return base * CFrame.Angles(-characterDownTilt, 0, 0)
end

local function moveCharacterCombat(targetRoot, deltaTime)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end

    local humanoid = getHumanoid(character)
    local predicted = predictPosition(targetRoot, deltaTime or 0)
    local torsoPos = getTorso(targetRoot.Parent, predicted + Vector3.new(0, 2, 0))

    local myPos = root.Position
    local awayRaw = Vector3.new(myPos.X - predicted.X, 0, myPos.Z - predicted.Z)

    if awayRaw.Magnitude > awayDirMemory then
        cachedAwayDir = awayRaw.Unit
    end

    local awayDir = cachedAwayDir
    local standoff = math.max(combatStandoff, minDistance)

    local combatPos = Vector3.new(
        predicted.X + awayDir.X * standoff,
        torsoPos.Y + combatYOffset,
        predicted.Z + awayDir.Z * standoff
    )

    local dir = torsoPos - combatPos
    if dir.Magnitude < 0.05 then
        dir = Vector3.new(0, 1, 0)
    end

    local base = CFrame.lookAt(combatPos, combatPos + dir.Unit)
    local newCF = base * CFrame.Angles(-characterDownTilt, 0, 0)
    applySmoothCFrame(root, newCF, deltaTime)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function victimIsFacingMe(targetRoot)
    if not smartPositionEnabled then return false end

    local myRoot = getMyRoot()
    if not myRoot or not targetRoot then return false end

    local toMe = Vector3.new(
        myRoot.Position.X - targetRoot.Position.X,
        0,
        myRoot.Position.Z - targetRoot.Position.Z
    )

    if toMe.Magnitude < 0.05 then return true end

    local look = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
    if look.Magnitude < 0.05 then return false end

    local dot = look.Unit:Dot(toMe.Unit)
    return dot > facingDotThreshold
end

local function moveCharacterBelow(targetRoot, deltaTime)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end

    local humanoid = getHumanoid(character)
    local predicted = predictPosition(targetRoot, deltaTime or 0)
    local distance = math.max(currentBelowDistance, minBelowDistance)

    local belowPos = Vector3.new(
        predicted.X,
        predicted.Y - distance - groundSink,
        predicted.Z
    )

    local newCF = faceTorsoFrom(belowPos, targetRoot, predicted)
    applySmoothCFrame(root, newCF, deltaTime)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function moveCharacterBehind(targetRoot, deltaTime)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end

    local humanoid = getHumanoid(character)
    local predicted = predictPosition(targetRoot, deltaTime or 0)

    local lookFlatRaw = Vector3.new(
        targetRoot.CFrame.LookVector.X,
        0,
        targetRoot.CFrame.LookVector.Z
    )

    if lookFlatRaw.Magnitude > 0.05 then
        cachedLookFlat = lookFlatRaw.Unit
    end

    local lookFlat = cachedLookFlat
    local distance = math.max(behindDistance, minDistance)

    local behindPos = Vector3.new(
        predicted.X - lookFlat.X * distance,
        predicted.Y - behindYOffset - groundSink,
        predicted.Z - lookFlat.Z * distance
    )

    local newCF = faceTorsoFrom(behindPos, targetRoot, predicted)
    applySmoothCFrame(root, newCF, deltaTime)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function teleportBehindM1(targetRoot)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end

    local humanoid = getHumanoid(character)
    local predicted = predictPosition(targetRoot, 0)

    local lookFlatRaw = Vector3.new(
        targetRoot.CFrame.LookVector.X,
        0,
        targetRoot.CFrame.LookVector.Z
    )

    local lookFlat
    if lookFlatRaw.Magnitude > 0.05 then
        lookFlat = lookFlatRaw.Unit
        cachedLookFlat = lookFlat
    else
        lookFlat = cachedLookFlat
    end

    local behindPos = Vector3.new(
        predicted.X - lookFlat.X * m1TeleportDistance,
        predicted.Y - groundSink,
        predicted.Z - lookFlat.Z * m1TeleportDistance
    )

    local torsoPos = getTorso(targetRoot.Parent, predicted + Vector3.new(0, 2, 0))
    local dir = torsoPos - behindPos
    if dir.Magnitude < 0.05 then
        dir = Vector3.new(0, 1, 0)
    end

    local newCF = CFrame.lookAt(behindPos, behindPos + dir.Unit) * CFrame.Angles(-characterDownTilt, 0, 0)
    root.CFrame = newCF
    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function computeWallCFrame(targetRoot, character)
    local root = character and getRoot(character)
    if not root then return nil end

    local myPos = root.Position
    local targetPos = targetRoot and targetRoot.Position or myPos

    local away = Vector3.new(myPos.X - targetPos.X, 0, myPos.Z - targetPos.Z)
    if away.Magnitude < 0.05 then
        away = cachedAwayDir
    else
        away = away.Unit
        cachedAwayDir = away
    end

    local rayOrigin = myPos + Vector3.new(0, 2, 0)
    local rayDir = away * wallRaycastDistance

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { character, targetRoot and targetRoot.Parent or nil }
    params.IgnoreWater = true

    local result = workspace:Raycast(rayOrigin, rayDir, params)

    local destination
    if result then
        destination = result.Position - away * wallStopOffset
    else
        destination = myPos + away * wallRetreatSpeedFallback
    end

    destination = Vector3.new(destination.X, myPos.Y, destination.Z)

    local faceDir = Vector3.new(away.X, 0, away.Z)
    if faceDir.Magnitude < 0.05 then
        faceDir = Vector3.new(0, 0, -1)
    end

    return CFrame.lookAt(destination, destination + faceDir.Unit)
end

local function moveToWall(targetRoot, deltaTime)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end

    local humanoid = getHumanoid(character)
    local myPos = root.Position

    local validCache = cachedWallCFrame
        and cachedWallTarget == target
        and cachedWallOrigin
        and (myPos - cachedWallOrigin).Magnitude < wallRecalcDistance

    if not validCache then
        cachedWallCFrame = computeWallCFrame(targetRoot, character)
        cachedWallTarget = target
        cachedWallOrigin = myPos
    end

    if not cachedWallCFrame then return end

    local newCF = cachedWallCFrame * CFrame.Angles(-characterDownTilt, 0, 0)
    applySmoothCFrame(root, newCF, deltaTime)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function resolvePositionMode(targetRoot)
    if not smartPositionEnabled then
        return positionMode
    end

    if positionMode ~= positionAuto then
        return positionMode
    end

    if victimIsFacingMe(targetRoot) then
        return positionBehind
    end

    return positionBelow
end

local function setCameraState(cameraType, subject)
    local camera = workspace.CurrentCamera
    if not camera then return end

    pcall(function()
        if camera.CameraType ~= cameraType then
            camera.CameraType = cameraType
        end
        if subject ~= nil and camera.CameraSubject ~= subject then
            camera.CameraSubject = subject
        end
    end)
end

local function attachCameraToVictimHead(targetRoot)
    if not targetRoot then return end

    local character = targetRoot.Parent
    if not character then return end

    local currentHead = getHead(character)
    if not currentHead then
        cachedHeadTarget = character
        cachedHead = nil
        return
    end

    if cachedHeadTarget ~= character or cachedHead ~= currentHead then
        cachedHeadTarget = character
        cachedHead = currentHead
    end

    setCameraState(Enum.CameraType.Custom, cachedHead)
end

local function restoreCamera()
    local character = localPlayer.Character
    local humanoid = character and getHumanoid(character)
    if humanoid then
        setCameraState(Enum.CameraType.Custom, humanoid)
    end
end

local function snapToCombat(targetRoot)
    if not targetRoot then return end
    if not isValidTarget(targetRoot.Parent) then return end
    moveCharacterCombat(targetRoot, 0)
end

local function setRecoveryMode(enabledState)
    if enabledState and tick() < manualRecoveryCooldown then return end
    recoveryActive = enabledState

    if enabledState then
        parkCharacter()
    end
end

local function forceRecovery(enabledState)
    manualRecoveryCooldown = 0
    recoveryActive = enabledState
    if enabledState then
        particleRecoveryActive = false
        parkCharacter()
    end
end

local function exitAllRecovery()
    recoveryActive = false
    particleRecoveryActive = false
    wallRetreatActive = false
    teamerParkUntil = 0
    teamerParkToken += 1
    manualRecoveryCooldown = tick() + manualRecoveryCooldownTime
    clearWallCache()
    if macroActive then
        macroActive = false
        macroToken += 1
    end
end

local function countNearbyThreats()
    local myRoot = getMyRoot()
    if not myRoot then return 0 end

    local count = 0
    for _, model in ipairs(getCandidates()) do
        if not isProtectedFromTeamerDetection(model) then
            local root = getRoot(model)
            if root and (root.Position - myRoot.Position).Magnitude <= threatRadius then
                count += 1
            end
        end
    end

    return count
end

local function updateMoverStatus()
    local now = tick()

    for _, model in ipairs(getCandidates()) do
        if isProtectedFromTeamerDetection(model) then
            recentMovers[model] = nil
        else
            local root = getRoot(model)
            if root then
                local speed = root.AssemblyLinearVelocity.Magnitude
                local humanoid = getHumanoid(model)
                local moving = speed >= teamerHostileMinSpeed

                if not moving and humanoid then
                    local moveDir = humanoid.MoveDirection
                    if moveDir.Magnitude >= 0.1 then
                        moving = true
                    end
                end

                if moving then
                    recentMovers[model] = now
                end
            end
        end
    end
end

local function isRecentMover(model)
    if isProtectedFromTeamerDetection(model) then
        recentMovers[model] = nil
        return false
    end

    local last = recentMovers[model]
    if not last then return false end
    if tick() - last > teamerMovementMemory then
        recentMovers[model] = nil
        return false
    end
    return true
end

local function countHostilePlayers()
    local myRoot = getMyRoot()
    if not myRoot then return 0 end

    local count = 0
    for _, model in ipairs(getCandidates()) do
        if not isProtectedFromTeamerDetection(model) then
            local root = getRoot(model)
            if root then
                local toMe = myRoot.Position - root.Position
                local dist = toMe.Magnitude

                if dist <= teamerHostileRadius then
                    local toMeFlat = Vector3.new(toMe.X, 0, toMe.Z)
                    local lookFlat = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)

                    if toMeFlat.Magnitude > 0.05 and lookFlat.Magnitude > 0.05 then
                        local facing = lookFlat.Unit:Dot(toMeFlat.Unit)

                        if facing >= teamerFacingDot then
                            if isRecentMover(model) then
                                count += 1
                            end
                        end
                    end
                end
            end
        end
    end

    return count
end

local function countRecentDamageEvents()
    local now = tick()
    local count = 0

    for i = #selfDamageTimes, 1, -1 do
        local entry = selfDamageTimes[i]
        if entry.time >= now - damageBurstWindow then
            count += 1
        else
            break
        end
    end

    return count
end

local function triggerTeamerPark(duration)
    if vCycleActive then return end
    if isFinisherTarget() then return end
    if tick() < manualRecoveryCooldown then return end
    if ultedActive then return end

    local now = tick()
    local newEnd = now + (duration or teamerParkTime)

    if newEnd > teamerParkUntil then
        teamerParkUntil = newEnd
        teamerParkToken += 1
    end
end

local function checkTeamerThreat()
    if not teamerDefenseEnabled then return false end
    if vCycleActive then return false end
    if macroActive then return false end
    if isFinisherTarget() then return false end
    if tick() < manualRecoveryCooldown then return false end
    if m1Active then return false end
    if ultedActive then return false end

    local recent = countRecentDamageEvents()
    if recent >= damageBurstCount then
        triggerTeamerPark(panicParkTime)
        return true
    end

    local hostiles = countHostilePlayers()
    if hostiles >= teamerHostileCount then
        triggerTeamerPark(teamerParkTime)
        return true
    end

    return false
end

local function countLowHpCandidates()
    local count = 0
    for _, model in ipairs(getCandidates()) do
        local humanoid = getHumanoid(model)
        if humanoid and humanoid.Health < lowHealthThreshold then
            count += 1
        end
    end
    return count
end

local function getRecentSelfDps()
    local now = tick()
    local cutoff = now - selfDpsWindow
    local total = 0

    for i = #selfDamageTimes, 1, -1 do
        local entry = selfDamageTimes[i]
        if entry.time >= cutoff then
            total += entry.damage
        else
            table.remove(selfDamageTimes, i)
        end
    end

    return total / selfDpsWindow
end

local function startHoldBack()
    if holdBackActive then return end
    holdBackActive = true
    holdReleaseToken += 1
    currentBelowDistance = math.clamp(
        currentBelowDistance + holdBackAmount,
        minBelowDistance,
        maxBelowDistance
    )
end

local function endHoldBack()
    if not holdBackActive then return end
    holdBackActive = false
    holdReleaseToken += 1
    local myToken = holdReleaseToken

    task.delay(holdReleaseDelay, function()
        if stopped then return end
        if myToken ~= holdReleaseToken then return end
        if holdBackActive then return end

        currentBelowDistance = math.clamp(
            currentBelowDistance - holdBackAmount,
            minBelowDistance,
            maxBelowDistance
        )
    end)
end

local function evaluateHoldBack()
    if keyFourHeld and lmbHeld then
        startHoldBack()
    else
        endHoldBack()
    end
end

local function scheduleLMBMissCheck()
    lmbMissToken += 1
    local myToken = lmbMissToken
    local watchTarget = target

    if not isValidTarget(watchTarget) then return end

    local humanoid = getHumanoid(watchTarget)
    if not humanoid then return end

    local hpBefore = humanoid.Health

    task.delay(lmbCheckDelay, function()
        if stopped then return end
        if myToken ~= lmbMissToken then return end
        if target ~= watchTarget then return end
        if not isValidTarget(watchTarget) then return end

        local hpAfter = humanoid.Health
        if hpAfter >= hpBefore then
            if positionMode ~= positionBelow then
                positionMode = positionBehind
            end
        end
    end)
end

local function simulateKey1()
    currentBelowDistance = math.clamp(
        currentBelowDistance + oneBackAmount,
        minBelowDistance,
        maxBelowDistance
    )
    positionMode = positionBehind
    if isValidTarget(target) then
        setDistance(keyDistance)
    end
end

local function simulateKey3()
    positionMode = positionBehind
    if isValidTarget(target) then
        setDistance(keyDistance)
    end
end

local function cancelMacro()
    if not macroActive then return end
    macroActive = false
    macroToken += 1
end

local function runMacro()
    if macroActive then
        cancelMacro()
        return
    end

    macroToken += 1
    macroActive = true
    local myToken = macroToken

    task.spawn(function()
        setRecoveryMode(true)
        task.wait(macroStepDelay)
        if stopped or myToken ~= macroToken then macroActive = false return end

        simulateKey1()
        task.wait(macroGoVictimWait)
        if stopped or myToken ~= macroToken then macroActive = false return end

        setRecoveryMode(false)
        task.wait(macroStepDelay)
        if stopped or myToken ~= macroToken then macroActive = false return end

        setRecoveryMode(true)
        task.wait(macroRecoveryWait)
        if stopped or myToken ~= macroToken then macroActive = false return end

        simulateKey3()

        macroActive = false
    end)
end

local function onTargetHealthChanged(newHealth)
    if stopped then return end
    if not target or not isValidTarget(target) then return end

    local delta = newHealth - lastHealth
    lastHealth = newHealth

    if newHealth <= 0 then
        killCount += 1
        return
    end

    if delta >= 0 then return end

    lastTargetDamageTime = tick()

    if damageReactionCount >= damageReactionLimit then return end

    damageReactionCount += 1

    local myRoot = getMyRoot()
    local targetRoot = getRoot(target)

    if not myRoot or not targetRoot then return end

    local dist = (myRoot.Position - targetRoot.Position).Magnitude

    if dist <= userAttackRange then
        currentBelowDistance = math.clamp(
            currentBelowDistance + damagePushBack,
            minBelowDistance,
            maxBelowDistance
        )
    else
        local nudge = (math.random() < 0.5) and -damageNudge or damageNudge
        currentBelowDistance = math.clamp(
            currentBelowDistance + nudge,
            minBelowDistance,
            maxBelowDistance
        )
    end
end

local function attachHealthWatcher(model)
    local humanoid = model and getHumanoid(model)

    if humanoid == watchedHumanoid then return end

    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end

    watchedHumanoid = humanoid
    if not humanoid then return end

    lastHealth = humanoid.Health
    damageReactionCount = 0
    healthConnection = humanoid.HealthChanged:Connect(onTargetHealthChanged)
end

local function onMyHealthChanged(newHealth)
    if stopped then return end

    local delta = newHealth - lastMyHealth
    lastMyHealth = newHealth

    if delta >= 0 then return end

    local damage = -delta
    table.insert(selfDamageTimes, { time = tick(), damage = damage })

    if vCycleActive then return end
    if isFinisherTarget() then return end

    if damage > heavyDamageThreshold then
        triggerTeamerPark(panicParkTime)
    end

    local character = localPlayer.Character
    local humanoid = character and getHumanoid(character)
    if humanoid and humanoid.Health / math.max(humanoid.MaxHealth, 1) < selfHpRecoveryPct then
        positionMode = positionBehind
        if smartRecoveryEnabled and not recoveryActive and not lmbHeld and not macroActive then
            setRecoveryMode(true)
        end
        return
    end

    if damage > heavyDamageThreshold or newHealth < lowHealthThreshold then
        positionMode = positionBehind
    end
end

local function attachMyHealthWatcher()
    if myHealthConnection then
        myHealthConnection:Disconnect()
        myHealthConnection = nil
    end

    local character = localPlayer.Character
    local humanoid = character and getHumanoid(character)
    if not humanoid then return end

    lastMyHealth = humanoid.Health
    myHealthConnection = humanoid.HealthChanged:Connect(onMyHealthChanged)
end

local function configureInfinitePrompt(prompt)
    if not instantInteractEnabled then return end
    if not prompt or not prompt:IsA("ProximityPrompt") then return end

    pcall(function()
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = promptInteractDistance
    end)
end

local function applyInstantInteract()
    if not instantInteractEnabled then return end

    for _, descendant in ipairs(workspace:GetDescendants()) do
        configureInfinitePrompt(descendant)
    end
end

local function isPlayingAttackAnimation(character)
    local humanoid = character and getHumanoid(character)
    if not humanoid then return false end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return false end

    for _, animTrack in ipairs(animator:GetPlayingAnimationTracks()) do
        local anim = animTrack.Animation
        if anim then
            for _, attackId in ipairs(attackAnimationIds) do
                if anim.AnimationId == attackId then
                    return true
                end
            end
        end
    end

    return false
end

local function isAttacking(character)
    if not character then return false end

    local humanoid = getHumanoid(character)
    if not humanoid then return false end

    if humanoid:GetState() == Enum.HumanoidStateType.Dead then return false end

    return isPlayingAttackAnimation(character)
end

local function toolMatch(handle)
    if not handle then return nil end

    local allPlayers = players:GetPlayers()
    for i = 1, #allPlayers do
        local player = allPlayers[i]
        if player ~= localPlayer then
            local character = player.Character
            if character then
                local rightArm = character:FindFirstChild("Right Arm")
                    or character:FindFirstChild("RightHand")
                    or character:FindFirstChild("RightUpperArm")
                if rightArm then
                    local rightGrip = rightArm:FindFirstChild("RightGrip")
                    if rightGrip and rightGrip:IsA("Weld") and rightGrip.Part1 == handle then
                        return player
                    end
                end
            end
        end
    end

    return nil
end

local function onAntiVoidChildAdded(child)
    if not child:IsA("Weld") or child.Name ~= "RightGrip" then return end

    local connectedHandle = child.Part1
    if not connectedHandle then return end

    local matched = toolMatch(connectedHandle)
    if matched then
        pcall(function()
            local tool = connectedHandle.Parent
            if tool then tool:Destroy() end
        end)
    end
end

local function bindAntiVoid(character)
    if not character then return end

    task.spawn(function()
        local arm = character:FindFirstChild("Right Arm")
        if not arm then
            arm = character:WaitForChild("Right Arm", 3)
        end
        if not arm then
            arm = character:FindFirstChild("RightHand")
        end
        if not arm then
            arm = character:WaitForChild("RightHand", 3)
        end
        if not arm then return end

        track(arm.ChildAdded:Connect(onAntiVoidChildAdded))
    end)
end

local function bindIdle()
    track(localPlayer.Idled:Connect(function()
        pcall(function()
            virtualInputManager:SendMouseButtonEvent(0, 0, 2, true, nil, 0)
        end)
        task.wait(1)
        pcall(function()
            virtualInputManager:SendMouseButtonEvent(0, 0, 2, false, nil, 0)
        end)
    end))
end

local function vCycle()
    if vCycleActive then
        vCycleActive = false
        vCycleVersion += 1
        return
    end

    vCycleActive = true
    teamerParkUntil = 0
    teamerParkToken += 1
    resetParticleTracking()
    recentMovers = {}
    vCycleVersion += 1
    local myVersion = vCycleVersion

    task.spawn(function()
        for round = 1, vCycleRounds do
            local list = sortSmart(getCandidates())
            if #list == 0 then break end

            for _, model in ipairs(list) do
                if stopped or not vCycleActive or vCycleVersion ~= myVersion then
                    return
                end

                if isValidTarget(model) then
                    setTarget(model)
                    currentDistance = defaultDistance
                    currentBelowDistance = belowDistance
                    damageReactionCount = 0
                    velocityHistory = {}
                end

                task.wait(vCycleDelay)
            end
        end

        if vCycleVersion == myVersion then
            vCycleActive = false
        end
    end)
end

local function stopEverything()
    if stopped then return end

    stopped = true
    enabled = false
    recoveryActive = false
    vCycleActive = false
    vCycleVersion += 1
    holdBackActive = false
    holdReleaseToken += 1
    lmbMissToken += 1
    macroActive = false
    macroToken += 1
    teamerParkUntil = 0
    teamerParkToken += 1
    wallRetreatActive = false
    clearWallCache()
    resetParticleTracking()
    target = nil
    previousTarget = nil
    velocityHistory = {}
    combatStickyUntil = 0
    cachedHead = nil
    cachedHeadTarget = nil
    cachedAwayDir = Vector3.new(0, 0, 1)
    cachedLookFlat = Vector3.new(0, 0, -1)
    recentMovers = {}
    m1Active = false
    ultedActive = false

    pcall(function() if healthConnection then healthConnection:Disconnect() end end)
    healthConnection = nil
    watchedHumanoid = nil
    damageReactionCount = 0

    pcall(function() if myHealthConnection then myHealthConnection:Disconnect() end end)
    myHealthConnection = nil

    pcall(function() if mainConnection then mainConnection:Disconnect() end end)
    mainConnection = nil

    pcall(function() if inputConnection then inputConnection:Disconnect() end end)
    inputConnection = nil

    pcall(function() if inputEndedConnection then inputEndedConnection:Disconnect() end end)
    inputEndedConnection = nil

    pcall(function() if characterConnection then characterConnection:Disconnect() end end)
    characterConnection = nil

    for _, connection in ipairs(trackedConnections) do
        pcall(function() connection:Disconnect() end)
    end
    trackedConnections = {}

    pcall(function() if hud and hud.gui then hud.gui:Destroy() end end)
    hud = nil

    pcall(function() if helpGui and helpGui.gui then helpGui.gui:Destroy() end end)
    helpGui = nil

    pcall(function() if sidebar and sidebar.gui then sidebar.gui:Destroy() end end)
    sidebar = nil

    pcall(function() if loadingScreen and loadingScreen.gui then loadingScreen.gui:Destroy() end end)
    loadingScreen = nil

    pcall(function()
        local pg = localPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, name in ipairs({ "ParkCamHUD", "ParkCamHelp", "ParkCamSidebar", "LarpingHubLoading" }) do
                local ui = pg:FindFirstChild(name)
                if ui then ui:Destroy() end
            end
        end
    end)

    pcall(restoreCamera)
end

local function createHUD()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ParkCamHUD"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 480, 0, 44)
    frame.Position = UDim2.new(0.5, -240, 0, 18)
    frame.BackgroundColor3 = bgDark
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = bgLight
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -16)
    accentBar.Position = UDim2.new(0, 6, 0, 8)
    accentBar.BackgroundColor3 = accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = frame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accentBar

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 220, 1, 0)
    nameLabel.Position = UDim2.new(0, 18, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "No Target"
    nameLabel.TextColor3 = textColor
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = frame

    local healthTrack = Instance.new("Frame")
    healthTrack.Size = UDim2.new(0, 110, 0, 6)
    healthTrack.Position = UDim2.new(1, -200, 0.5, 0)
    healthTrack.BackgroundColor3 = bgLight
    healthTrack.BorderSizePixel = 0
    healthTrack.Parent = frame

    local htCorner = Instance.new("UICorner")
    htCorner.CornerRadius = UDim.new(1, 0)
    htCorner.Parent = healthTrack

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = okColor
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthTrack

    local hfCorner = Instance.new("UICorner")
    hfCorner.CornerRadius = UDim.new(1, 0)
    hfCorner.Parent = healthFill

    local statusPill = Instance.new("Frame")
    statusPill.Size = UDim2.new(0, 82, 0, 22)
    statusPill.Position = UDim2.new(1, -88, 0.5, -11)
    statusPill.BackgroundColor3 = bgLight
    statusPill.BorderSizePixel = 0
    statusPill.Parent = frame

    local spCorner = Instance.new("UICorner")
    spCorner.CornerRadius = UDim.new(1, 0)
    spCorner.Parent = statusPill

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "READY"
    statusLabel.TextColor3 = okColor
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = statusPill

    return {
        gui = gui,
        nameLabel = nameLabel,
        healthFill = healthFill,
        statusLabel = statusLabel,
        statusPill = statusPill,
    }
end

local function createSidebar()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ParkCamSidebar"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 148, 0, 118)
    frame.Position = UDim2.new(1, -164, 1, -134)
    frame.BackgroundColor3 = bgDark
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = bgLight
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame

    local function makeRow(yPos, labelText)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -20, 0, 20)
        row.Position = UDim2.new(0, 10, 0, yPos)
        row.BackgroundTransparency = 1
        row.Parent = frame

        local key = Instance.new("TextLabel")
        key.Size = UDim2.new(0.55, 0, 1, 0)
        key.BackgroundTransparency = 1
        key.Text = labelText
        key.TextColor3 = textDim
        key.TextSize = 11
        key.Font = Enum.Font.GothamMedium
        key.TextXAlignment = Enum.TextXAlignment.Left
        key.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.45, 0, 1, 0)
        value.Position = UDim2.new(0.55, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = "--"
        value.TextColor3 = textColor
        value.TextSize = 12
        value.Font = Enum.Font.GothamBold
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = row

        return value
    end

    local fpsValue = makeRow(12, "FPS")
    local pingValue = makeRow(38, "Ping")
    local killsValue = makeRow(64, "Kills")
    local lowHpValue = makeRow(90, "Low HP")

    return {
        gui = gui,
        fpsValue = fpsValue,
        pingValue = pingValue,
        killsValue = killsValue,
        lowHpValue = lowHpValue,
    }
end

local function getPing()
    local ok, value = pcall(function()
        return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and value then
        return math.floor(value + 0.5)
    end
    return 0
end

local function updateSidebar(deltaTime)
    if not sidebar then return end

    fpsFrames += 1
    fpsAccum += deltaTime
    if fpsAccum >= 0.5 then
        fpsDisplay = math.floor(fpsFrames / fpsAccum + 0.5)
        fpsFrames = 0
        fpsAccum = 0
    end

    statsAccum += deltaTime
    if statsAccum >= 0.25 then
        statsAccum = 0
        pingDisplay = getPing()
        lowHpCount = countLowHpCandidates()
    end

    sidebar.fpsValue.Text = tostring(fpsDisplay)

    local pingColor
    if pingDisplay <= 60 then
        pingColor = okColor
    elseif pingDisplay <= 120 then
        pingColor = warnColor
    else
        pingColor = badColor
    end
    sidebar.pingValue.Text = tostring(pingDisplay) .. "ms"
    sidebar.pingValue.TextColor3 = pingColor

    sidebar.killsValue.Text = tostring(killCount)

    local hpColor
    if lowHpCount == 0 then
        hpColor = textColor
    elseif lowHpCount <= 2 then
        hpColor = warnColor
    else
        hpColor = badColor
    end
    sidebar.lowHpValue.Text = tostring(lowHpCount)
    sidebar.lowHpValue.TextColor3 = hpColor
end

local function createHelpPanel()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ParkCamHelp"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 340, 0, 480)
    frame.Position = UDim2.new(0, 20, 0.5, -240)
    frame.BackgroundColor3 = bgDark
    frame.BackgroundTransparency = 0.12
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = bgLight
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.new(0, 12, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "KEYBINDS"
    title.TextColor3 = textColor
    title.TextSize = 14
    title.Font = Enum.Font.GothamBlack
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local function section(y, headerText, rows)
        local header = Instance.new("TextLabel")
        header.Size = UDim2.new(1, -20, 0, 14)
        header.Position = UDim2.new(0, 12, 0, y)
        header.BackgroundTransparency = 1
        header.Text = headerText
        header.TextColor3 = accent
        header.TextSize = 11
        header.Font = Enum.Font.GothamBold
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = frame

        local body = Instance.new("TextLabel")
        body.Size = UDim2.new(1, -20, 0, #rows * 15)
        body.Position = UDim2.new(0, 12, 0, y + 16)
        body.BackgroundTransparency = 1
        body.Text = table.concat(rows, "\n")
        body.TextColor3 = textColor
        body.TextSize = 11
        body.Font = Enum.Font.Gotham
        body.TextXAlignment = Enum.TextXAlignment.Left
        body.TextYAlignment = Enum.TextYAlignment.Top
        body.Parent = frame

        return y + 16 + #rows * 15 + 8
    end

    local y = 40

    y = section(y, "MOVEMENT", {
        "W/A/S/D    free movement when not locked",
        "E                previous target",
        "R                next target",
        "T                clear target",
        "U                cycle position mode",
        "0                toggle victim cam",
    })

    y = section(y, "COMBAT", {
        "LMB (hold)  melee sticky (snap into range)",
        "1                 behind + 0.75 studs back",
        "2/3             behind position",
        "4 + LMB      push back 4.5 studs",
        "9                 macro: recovery -> attack",
    })

    y = section(y, "SYSTEM", {
        "C                cancel ALL recovery (4s cooldown)",
        "M               toggle recovery (bypasses cooldown)",
        "V                toggle V-cycle",
        "P                toggle prediction",
        "I                toggle instant interact",
        "Y                toggle SMART mode",
        "H / N         toggle HUD / sidebar",
        "F1              toggle this panel",
        "O               stop script + delete UI",
    })

    return { gui = gui }
end

local function updateHUD()
    if not hud then return end

    if not isValidTarget(target) then
        hud.nameLabel.Text = "No Target"
        hud.healthFill.Size = UDim2.new(0, 0, 1, 0)
        hud.statusLabel.Text = enabled and "READY" or "PAUSED"
        hud.statusLabel.TextColor3 = enabled and okColor or warnColor
        return
    end

    local humanoid = getHumanoid(target)
    hud.nameLabel.Text = getTargetName(target)

    local statusText
    local statusColor

    if isFinisherTarget() then
        statusText = "FINISH"
        statusColor = warnColor
    elseif wallRetreatActive then
        statusText = "WALL"
        statusColor = badColor
    elseif m1Active then
        statusText = "M1"
        statusColor = badColor
    elseif ultedActive then
        statusText = "ULTED"
        statusColor = specialColor
    elseif vCycleActive then
        statusText = "CYCLE"
        statusColor = infoColor
    elseif particleRecoveryActive then
        statusText = "PARTICLE"
        statusColor = specialColor
    elseif tick() < teamerParkUntil then
        statusText = "PARK"
        statusColor = badColor
    elseif macroActive then
        statusText = "MACRO"
        statusColor = specialColor
    elseif recoveryActive then
        statusText = "RECOVERY"
        statusColor = warnColor
    elseif lmbHeld then
        statusText = "COMBAT"
        statusColor = badColor
    elseif tick() < combatStickyUntil then
        statusText = "COMBAT"
        statusColor = badColor
    elseif holdBackActive then
        statusText = "HOLD"
        statusColor = warnColor
    elseif not enabled then
        statusText = "PAUSED"
        statusColor = warnColor
    else
        statusText = "TRACKING"
        statusColor = okColor
    end

    hud.statusLabel.Text = statusText
    hud.statusLabel.TextColor3 = statusColor

    if humanoid then
        local pct = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        hud.healthFill.Size = UDim2.new(pct, 0, 1, 0)

        if pct > 0.5 then
            hud.healthFill.BackgroundColor3 = okColor
        elseif pct > 0.25 then
            hud.healthFill.BackgroundColor3 = warnColor
        else
            hud.healthFill.BackgroundColor3 = badColor
        end
    end
end

for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        if player.Character then
            addCandidate(player.Character)
        end
        track(player.CharacterAdded:Connect(function(character)
            task.defer(function()
                for _ = 1, 10 do
                    if isValidTarget(character) then break end
                    task.wait(0.1)
                end
                addCandidate(character)
            end)
        end))
    end
end

track(players.PlayerAdded:Connect(function(player)
    track(player.CharacterAdded:Connect(function(character)
        task.defer(function()
            for _ = 1, 10 do
                if isValidTarget(character) then break end
                task.wait(0.1)
            end
            addCandidate(character)
        end)
    end))
end))

track(players.PlayerRemoving:Connect(function(player)
    local character = player.Character
    if character then
        removeCandidate(character)
    end
end))

track(workspace.DescendantAdded:Connect(function(object)
    if object:IsA("Humanoid") then
        local model = object.Parent
        if model and model:IsA("Model") then
            task.defer(addCandidate, model)
        end
    end
    if object:IsA("BasePart") and object.Name == "HumanoidRootPart" then
        local model = object.Parent
        if model and model:IsA("Model") then
            task.defer(addCandidate, model)
        end
    end
end))

track(workspace.DescendantRemoving:Connect(function(object)
    if object:IsA("Model") then
        removeCandidate(object)
    end
end))

track(workspace.DescendantAdded:Connect(function(descendant)
    configureInfinitePrompt(descendant)
end))

local function getLoadingScreenBuilder()
    local ok, result = pcall(function()
        local source = game:HttpGet(loadingUrl)
        if not source or source == "" then
            error("empty response from " .. loadingUrl)
        end
        local chunk = loadstring(source)
        if not chunk then
            error("loadstring returned nil for Loading.lua")
        end
        return chunk()
    end)

    if not ok then
        warn("[LarpingHub] Failed to fetch loading screen: " .. tostring(result))
        return nil
    end

    if type(result) ~= "function" then
        warn("[LarpingHub] Loading.lua did not return a function (got " .. type(result) .. ")")
        return nil
    end

    return result
end

local createLoadingScreen = getLoadingScreenBuilder()

if createLoadingScreen then
    local ok, screen = pcall(createLoadingScreen)
    if ok and screen and screen.setProgress and screen.destroy then
        loadingScreen = screen
    else
        warn("[LarpingHub] Loading screen builder returned an invalid object")
        loadingScreen = nil
    end
end

if loadingScreen then
    local steps = {
        { 0.15, "starting up" },
        { 0.35, "loading modules" },
        { 0.55, "preparing ui" },
        { 0.75, "hooking controls" },
        { 0.90, "almost ready" },
        { 1.00, "ready" },
    }

    for _, step in ipairs(steps) do
        loadingScreen.setProgress(step[1], step[2])
        task.wait(0.16)
    end

    task.wait(0.5)

    pcall(function()
        loadingScreen.destroy()
    end)
    loadingScreen = nil

    task.wait(0.45)
end

hud = createHUD()
sidebar = createSidebar()
helpGui = createHelpPanel()

applyInstantInteract()
bindIdle()

attachMyHealthWatcher()
bindAntiVoid(localPlayer.Character)

if helpGui and helpGui.gui then
    helpGui.gui.Enabled = helpEnabled
end

characterConnection = localPlayer.CharacterAdded:Connect(function(newCharacter)
    target = nil
    previousTarget = nil
    currentDistance = defaultDistance
    currentBelowDistance = belowDistance
    vCycleActive = false
    vCycleVersion += 1
    recoveryActive = false
    holdBackActive = false
    holdReleaseToken += 1
    lmbMissToken += 1
    macroActive = false
    macroToken += 1
    teamerParkUntil = 0
    teamerParkToken += 1
    damageReactionCount = 0
    positionMode = positionBehind
    velocityHistory = {}
    combatStickyUntil = 0
    cachedHead = nil
    cachedHeadTarget = nil
    cachedAwayDir = Vector3.new(0, 0, 1)
    cachedLookFlat = Vector3.new(0, 0, -1)
    recentMovers = {}
    wallRetreatActive = false
    m1Active = false
    ultedActive = false
    clearWallCache()
    resetParticleTracking()
    lastTargetDamageTime = 0

    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    watchedHumanoid = nil

    task.wait(0.2)
    if stopped then return end

    attachMyHealthWatcher()
    bindAntiVoid(newCharacter)
    restoreCamera()
end)

mainConnection = runService.RenderStepped:Connect(function(deltaTime)
    if stopped then return end

    updateHUD()
    updateSidebar(deltaTime)
    updateMoverStatus()

    if not enabled then
        attachHealthWatcher(nil)
        restoreCamera()
        return
    end

    if target and isTrulyDead(target) then
        target = nil
        wallRetreatActive = false
        m1Active = false
        ultedActive = false
        clearWallCache()
    end

    if not target then
        if vCycleActive then
            attachHealthWatcher(nil)
            if not victimCamEnabled then restoreCamera() end
            return
        end
        if not selectClosestTarget() then
            attachHealthWatcher(nil)
            if not victimCamEnabled then restoreCamera() end
            return
        end
    end

    local targetRoot = getRoot(target)
    if not targetRoot then return end

    attachHealthWatcher(target)
    updateVelocityHistory(targetRoot)

    checkTeamerThreat()

    local finisher = isFinisherTarget()
    local grabbed = hasGrabbedFolder(target)
    local m1On = hasM1Attribute(target)
    m1Active = m1On
    ultedActive = hasUltedAttribute(target)

    if grabbed then
        if not wallRetreatActive then
            clearWallCache()
        end
        wallRetreatActive = true
        if recoveryActive then
            recoveryActive = false
        end
        if particleRecoveryActive then
            particleRecoveryActive = false
        end
    else
        if wallRetreatActive then
            clearWallCache()
        end
        wallRetreatActive = false
    end

    local manualCooldownActive = tick() < manualRecoveryCooldown

    if particleRecoveryEnabled and not vCycleActive and not macroActive and not grabbed and not manualCooldownActive then
        if particleRecoverySkipsFinisher and finisher then
            if particleRecoveryActive then
                particleRecoveryActive = false
                if recoveryActive then
                    setRecoveryMode(false)
                end
            end
            cachedVictimHasParticles = false
            particleContinuousStart = 0
        else
            local now = tick()

            if now - lastParticleCheck >= particleRescanInterval then
                lastParticleCheck = now
                cachedVictimHasParticles = victimHasParticles()
                if cachedVictimHasParticles then
                    lastParticleSeenAt = now
                    if particleContinuousStart == 0 then
                        particleContinuousStart = now
                    end
                else
                    particleContinuousStart = 0
                end
            end

            local particleWindow = (now - lastParticleSeenAt) < particleGracePeriod
            local victimRecentlyDamaged = (now - lastTargetDamageTime) < targetDamageMemory
            local persistentAura = particleContinuousStart > 0
                and (now - particleContinuousStart) >= persistentParticleThreshold

            if particleWindow and not victimRecentlyDamaged and not persistentAura then
                if not recoveryActive then
                    setRecoveryMode(true)
                end
                particleRecoveryActive = true
            else
                if particleRecoveryActive then
                    particleRecoveryActive = false
                    if recoveryActive then
                        setRecoveryMode(false)
                    end
                end
            end
        end
    else
        if particleRecoveryActive then
            particleRecoveryActive = false
        end
    end

    if not vCycleActive and not finisher and not particleRecoveryActive and smartRecoveryEnabled and not macroActive and not lmbHeld and not grabbed and not manualCooldownActive and not m1On then
        local threats = countNearbyThreats()
        local dps = getRecentSelfDps()

        if threats >= threatCountTrigger and not recoveryActive then
            setRecoveryMode(true)
        end

        if dps >= selfDpsRecoveryThreshold and not recoveryActive then
            setRecoveryMode(true)
        end
    end

    if not vCycleActive and not finisher and not particleRecoveryActive and recoveryOnAttack and target and isAttacking(target) and not macroActive and not lmbHeld and not grabbed and not manualCooldownActive and not m1On then
        if not recoveryActive then
            setRecoveryMode(true)
        end
    end

    if lmbHeld and not macroActive then
        combatStickyUntil = tick() + meleeStickyDuration
    end

    local teamerParking = (not vCycleActive) and (not finisher) and tick() < teamerParkUntil
    local activeRecovery = (not vCycleActive) and (not finisher) and recoveryActive

    if wallRetreatActive then
        moveToWall(targetRoot, deltaTime)
    elseif m1On then
        teleportBehindM1(targetRoot)
    elseif teamerParking or activeRecovery then
        parkCharacter()
    elseif tick() < combatStickyUntil then
        moveCharacterCombat(targetRoot, deltaTime)
    else
        local resolvedMode = resolvePositionMode(targetRoot)
        if resolvedMode == positionBelow then
            moveCharacterBelow(targetRoot, deltaTime)
        else
            moveCharacterBehind(targetRoot, deltaTime)
        end
    end

    if victimCamEnabled then
        attachCameraToVictimHead(targetRoot)
    else
        restoreCamera()
    end
end)

inputConnection = userInputService.InputBegan:Connect(function(input, gameProcessed)
    if stopped then return end

    if input.KeyCode == Enum.KeyCode.O then
        stopEverything()
        return
    end

    if input.KeyCode == Enum.KeyCode.C then
        exitAllRecovery()
        return
    end

    if input.KeyCode == Enum.KeyCode.M then
        forceRecovery(not recoveryActive)
        return
    end

    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.Zero then
        victimCamEnabled = not victimCamEnabled
        if not victimCamEnabled then
            restoreCamera()
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.Nine then
        runMacro()
        return
    end

    if input.KeyCode == Enum.KeyCode.N then
        sidebarEnabled = not sidebarEnabled
        if sidebar and sidebar.gui then
            sidebar.gui.Enabled = sidebarEnabled
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.Four then
        keyFourHeld = true
        evaluateHoldBack()
        positionMode = positionBehind
        if isValidTarget(target) then
            setDistance(keyDistance)
        end
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        lmbHeld = true

        local hadTarget = isValidTarget(target)

        if hadTarget then
            combatStickyUntil = tick() + meleeStickyDuration
            local tRoot = getRoot(target)
            if tRoot then
                snapToCombat(tRoot)
            end
        end

        evaluateHoldBack()

        if not (keyFourHeld and lmbHeld) then
            if hadTarget then
                setDistance(lmbDistance)
                scheduleLMBMissCheck()
            else
                if lockTargetUnderMouse() then
                    combatStickyUntil = tick() + meleeStickyDuration
                    local tRoot = getRoot(target)
                    if tRoot then
                        snapToCombat(tRoot)
                    end
                end
            end
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        enabled = not enabled
        if not enabled then restoreCamera() end
        return
    end

    if input.KeyCode == Enum.KeyCode.V then
        vCycle()
        return
    end

    if input.KeyCode == Enum.KeyCode.P then
        predictionEnabled = not predictionEnabled
        return
    end

    if input.KeyCode == Enum.KeyCode.I then
        instantInteractEnabled = not instantInteractEnabled
        if instantInteractEnabled then
            applyInstantInteract()
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.Y then
        local nowOn = not (smartTargetingEnabled and smartPositionEnabled and smartRecoveryEnabled and adaptivePredictionEnabled)
        smartTargetingEnabled = nowOn
        smartPositionEnabled = nowOn
        smartRecoveryEnabled = nowOn
        adaptivePredictionEnabled = nowOn
        return
    end

    if input.KeyCode == Enum.KeyCode.U then
        if positionMode == positionBelow then
            positionMode = positionBehind
        elseif positionMode == positionBehind then
            positionMode = positionAuto
        else
            positionMode = positionBelow
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.J then
        recoveryOnAttack = not recoveryOnAttack
        return
    end

    if input.KeyCode == Enum.KeyCode.H then
        hudEnabled = not hudEnabled
        if hud and hud.gui then
            hud.gui.Enabled = hudEnabled
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.F1 then
        helpEnabled = not helpEnabled
        if helpGui and helpGui.gui then
            helpGui.gui.Enabled = helpEnabled
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.E then
        goToPreviousTarget()
        return
    end

    if input.KeyCode == Enum.KeyCode.R then
        cycleTarget()
        return
    end

    if input.KeyCode == Enum.KeyCode.T then
        previousTarget = target
        target = nil
        resetParticleTracking()
        lastTargetDamageTime = 0
        wallRetreatActive = false
        m1Active = false
        ultedActive = false
        clearWallCache()
        if not victimCamEnabled then restoreCamera() end
        return
    end

    if input.KeyCode == Enum.KeyCode.One then
        simulateKey1()
        return
    end

    if input.KeyCode == Enum.KeyCode.Two
        or input.KeyCode == Enum.KeyCode.Three
    then
        simulateKey3()
        return
    end
end)

inputEndedConnection = userInputService.InputEnded:Connect(function(input)
    if stopped then return end

    if input.KeyCode == Enum.KeyCode.Four then
        keyFourHeld = false
        evaluateHoldBack()
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        lmbHeld = false
        evaluateHoldBack()
        return
    end
end)

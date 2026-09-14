local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local stats = game:GetService("Stats")
local tweenService = game:GetService("TweenService")
local virtualInputManager
pcall(function() virtualInputManager = game:GetService("VirtualInputManager") end)
local localPlayer = players.LocalPlayer

pcall(function()
    if type(getgenv) == "function" then
        getgenv().AntiVoid = true
    end
end)

local C = {
    minDistance = 5,
    defaultDistance = 5,
    lmbDistance = 5,
    keyDistance = 5,
    belowDistance = 5,
    minBelowDistance = 5,
    maxBelowDistance = 30,
    behindDistance = 5,
    behindYOffset = 0,
    groundSink = 1.5,
    characterDownTilt = math.rad(7),
    meleeStickyDuration = 0.6,
    combatStandoff = 5,
    combatYOffset = 0,
    positionSmoothness = 40,
    awayDirMemory = 1.5,
    damagePushBack = 1.5,
    damageNudge = 0.5,
    userAttackRange = 10,
    damageReactionLimit = 2,
    teamerDefenseEnabled = true,
    teamerHostileCount = 2,
    teamerHostileRadius = 22,
    teamerFacingDot = 0.35,
    teamerHostileMinSpeed = 2.5,
    teamerMovementMemory = 0.75,
    teamerParkTime = 2.5,
    damageBurstWindow = 0.8,
    damageBurstCount = 2,
    panicParkTime = 2,
    finisherHpThreshold = 15,
    particleRecoveryEnabled = true,
    particleRescanInterval = 0.15,
    particleGracePeriod = 0.35,
    particleRecoverySkipsFinisher = true,
    targetDamageMemory = 0.7,
    persistentParticleThreshold = 60,
    particleSkipAccessories = true,
    particleNameBlacklist = {
        "footstep", "dust", "ambient", "idle", "sweat", "step",
        "awaken", "wake", "aura", "buff", "glow", "shine",
        "hair", "hat", "wing", "cape", "accessory", "accessor",
        "music", "particleholder", "seizure", "flameaura",
        "footprint", "sparkle", "fart", "gas", "smoke",
    },
    holdBackAmount = 4.5,
    holdReleaseDelay = 2,
    oneBackAmount = 0.75,
    lmbCheckDelay = 0.4,
    heavyDamageThreshold = 15,
    lowHealthThreshold = 30,
    macroStepDelay = 0.15,
    macroGoVictimWait = 1,
    macroRecoveryWait = 5,
    facingDotThreshold = 0.35,
    predictionHistory = 12,
    threatRadius = 30,
    threatCountTrigger = 2,
    selfHpRecoveryPct = 0.4,
    selfDpsWindow = 1.5,
    selfDpsRecoveryThreshold = 25,
    promptInteractDistance = 16,
    parkPosition = Vector3.new(0, 2000, 0),
    manualParkPosition = Vector3.new(0, 5000, 0),
    vCycleRounds = 2,
    vCycleDelay = 0.35,
    predictionStrength = 1.0,
    predictionLookahead = 0.24,
    predictionMoveCompensation = 2.4,
    predictionMaxOffset = 55,
    predictionPingScale = 1.0,
    predictionPingCap = 0.35,
    predictionVerticalBoost = 1.4,
    wallRaycastDistance = 500,
    wallStopOffset = 3,
    wallRetreatSpeedFallback = 20,
    wallRecalcDistance = 40,
    m1TeleportDistance = 4,
    manualRecoveryCooldownTime = 4,
    autoCombatHitDelay = 0.5,
    autoCombatKeyDelay = 0.5,
    positionBelow = "below",
    positionBehind = "behind",
    positionAuto = "auto",
    loadingUrl = "https://raw.githubusercontent.com/fischisreal/LarpingHub/main/docs/Loading.lua",
    attackAnimationIds = {
        "rbxassetid://1234567890",
        "rbxassetid://1234567891",
        "rbxassetid://1234567892",
    },
    accent = Color3.fromRGB(120, 180, 255),
    accentAlt = Color3.fromRGB(200, 130, 255),
    bgDark = Color3.fromRGB(16, 16, 20),
    bgMid = Color3.fromRGB(24, 24, 30),
    bgLight = Color3.fromRGB(36, 36, 44),
    textDim = Color3.fromRGB(160, 160, 175),
    textColor = Color3.fromRGB(240, 240, 245),
    okColor = Color3.fromRGB(110, 210, 140),
    warnColor = Color3.fromRGB(240, 200, 90),
    badColor = Color3.fromRGB(240, 100, 100),
    infoColor = Color3.fromRGB(140, 180, 255),
    specialColor = Color3.fromRGB(200, 130, 255),
}

local S = {
    enabled = true,
    stopped = false,
    smartTargetingEnabled = true,
    smartPositionEnabled = true,
    smartRecoveryEnabled = true,
    adaptivePredictionEnabled = true,
    victimCamEnabled = true,
    sidebarEnabled = true,
    hudEnabled = true,
    helpEnabled = false,
    predictionEnabled = true,
    instantInteractEnabled = true,
    recoveryOnAttack = true,
    positionMode = "behind",
    currentDistance = 5,
    currentBelowDistance = 5,
    manualRecoveryCooldown = 0,
    target = nil,
    previousTarget = nil,
    candidates = {},
    mainConnection = nil,
    inputConnection = nil,
    inputEndedConnection = nil,
    characterConnection = nil,
    trackedConnections = {},
    recoveryActive = false,
    vCycleActive = false,
    vCycleVersion = 0,
    hud = nil,
    helpGui = nil,
    sidebar = nil,
    loadingScreen = nil,
    healthConnection = nil,
    watchedHumanoid = nil,
    lastHealth = 0,
    damageReactionCount = 0,
    lastTargetDamageTime = 0,
    myHealthConnection = nil,
    lastMyHealth = 0,
    selfDamageTimes = {},
    keyFourHeld = false,
    lmbHeld = false,
    holdBackActive = false,
    holdReleaseToken = 0,
    lmbMissToken = 0,
    velocityHistory = {},
    combatStickyUntil = 0,
    cachedHeadTarget = nil,
    cachedHead = nil,
    killCount = 0,
    lowHpCount = 0,
    fpsFrames = 0,
    fpsAccum = 0,
    fpsDisplay = 0,
    pingDisplay = 0,
    statsAccum = 0,
    macroActive = false,
    macroToken = 0,
    teamerParkUntil = 0,
    teamerParkToken = 0,
    cachedAwayDir = Vector3.new(0, 0, 1),
    cachedLookFlat = Vector3.new(0, 0, -1),
    cachedVictimHasParticles = false,
    lastParticleCheck = 0,
    lastParticleSeenAt = 0,
    particleRecoveryActive = false,
    particleContinuousStart = 0,
    recentMovers = {},
    wallRetreatActive = false,
    cachedWallCFrame = nil,
    cachedWallTarget = nil,
    cachedWallOrigin = nil,
    m1Active = false,
    ultedActive = false,
    manualRecoveryPark = false,
    autoCombatActive = false,
    autoCombatToken = 0,
}

local function track(connection)
    table.insert(S.trackedConnections, connection)
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
    if not S.target then return false end
    if not isValidTarget(S.target) then return false end
    local humanoid = getHumanoid(S.target)
    if not humanoid then return false end
    return humanoid.Health <= C.finisherHpThreshold
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
    for _, keyword in ipairs(C.particleNameBlacklist) do
        if string.find(lower, keyword, 1, true) then
            return true
        end
    end
    return false
end

local function isUnderAccessory(obj)
    if not C.particleSkipAccessories then return false end
    if obj:FindFirstAncestorOfClass("Accessory") then return true end
    if obj:FindFirstAncestorOfClass("Accoutrement") then return true end
    return false
end

local function victimHasParticles()
    if not S.target then return false end
    if not isValidTarget(S.target) then return false end
    for _, obj in ipairs(S.target:GetDescendants()) do
        local isEffect = obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
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
        S.candidates[model] = true
    end
end

local function removeCandidate(model)
    S.candidates[model] = nil
    if S.target == model then S.target = nil end
    if S.previousTarget == model then S.previousTarget = nil end
    S.recentMovers[model] = nil
end

local function getCandidates()
    local result = {}
    for model in pairs(S.candidates) do
        if isValidTarget(model) then
            result[#result + 1] = model
        else
            S.candidates[model] = nil
            S.recentMovers[model] = nil
        end
    end
    return result
end

local function getModelFromPart(part)
    local model = part and part:FindFirstAncestorOfClass("Model")
    while model do
        if getHumanoid(model) then return model end
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
    local hpScore = (1 - hpPct) * 45

    local toMe = myRoot.Position - root.Position
    local flat = Vector3.new(toMe.X, 0, toMe.Z)

    local facingScore = 0
    if flat.Magnitude > 0.05 then
        local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
        if look.Magnitude > 0.05 then
            local dot = look.Unit:Dot(flat.Unit)
            facingScore = math.max(0, dot) * 30
        end
    end

    return dist - hpScore - facingScore
end

local function sortSmart(list)
    if not S.smartTargetingEnabled then
        local myRoot = getMyRoot()
        if myRoot then
            table.sort(list, function(a, b)
                local ra, rb = getRoot(a), getRoot(b)
                if not ra then return false end
                if not rb then return true end
                return (ra.Position - myRoot.Position).Magnitude < (rb.Position - myRoot.Position).Magnitude
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
    if player then return player.DisplayName end
    return model.Name
end

local function resetParticleTracking()
    S.cachedVictimHasParticles = false
    S.lastParticleCheck = 0
    S.lastParticleSeenAt = 0
    S.particleRecoveryActive = false
    S.particleContinuousStart = 0
end

local function clearWallCache()
    S.cachedWallCFrame = nil
    S.cachedWallTarget = nil
    S.cachedWallOrigin = nil
end

local function setTarget(newTarget)
    if newTarget ~= S.target then
        S.previousTarget = S.target
        resetParticleTracking()
        S.lastTargetDamageTime = 0
        S.wallRetreatActive = false
        S.m1Active = false
        S.ultedActive = false
        clearWallCache()
    end
    S.target = newTarget
end

local function lockTargetUnderMouse()
    local mouse = localPlayer:GetMouse()
    if not mouse then return false end
    local model = getModelFromPart(mouse.Target)
    if model and isValidTarget(model) then
        setTarget(model)
        S.currentDistance = C.defaultDistance
        S.currentBelowDistance = C.belowDistance
        S.damageReactionCount = 0
        S.velocityHistory = {}
        return true
    end
    return false
end

local function setDistance(value)
    S.currentDistance = math.max(C.minDistance, value)
end

local function selectClosestTarget()
    local list = sortSmart(getCandidates())
    if #list == 0 then
        S.previousTarget = S.target
        S.target = nil
        return false
    end
    setTarget(list[1])
    S.currentDistance = C.defaultDistance
    S.currentBelowDistance = C.belowDistance
    S.damageReactionCount = 0
    S.velocityHistory = {}
    return true
end

local function cycleTarget()
    local list = sortSmart(getCandidates())
    if #list == 0 then return false end
    local index = 0
    for i, model in ipairs(list) do
        if model == S.target then
            index = i
            break
        end
    end
    setTarget(list[(index % #list) + 1])
    S.currentDistance = C.defaultDistance
    S.currentBelowDistance = C.belowDistance
    S.damageReactionCount = 0
    S.velocityHistory = {}
    return true
end

local function goToPreviousTarget()
    if not S.previousTarget then return false end
    if not isValidTarget(S.previousTarget) then
        S.previousTarget = nil
        return false
    end
    local temp = S.target
    setTarget(S.previousTarget)
    S.previousTarget = temp

    S.currentDistance = C.defaultDistance
    S.currentBelowDistance = C.belowDistance
    S.damageReactionCount = 0
    S.velocityHistory = {}

    if isValidTarget(S.target) then
        local tRoot = getRoot(S.target)
        if tRoot then
            S.combatStickyUntil = tick() + C.meleeStickyDuration
        end
    end
    return true
end

local function updateVelocityHistory(root)
    if not S.adaptivePredictionEnabled then return end
    S.velocityHistory[#S.velocityHistory + 1] = root.AssemblyLinearVelocity
    while #S.velocityHistory > C.predictionHistory do
        table.remove(S.velocityHistory, 1)
    end
end

local function getSmoothedVelocity()
    if not S.adaptivePredictionEnabled then return nil end
    if #S.velocityHistory == 0 then return nil end
    local sum = Vector3.new(0, 0, 0)
    local weightTotal = 0
    for i, v in ipairs(S.velocityHistory) do
        local weight = i * i
        sum += v * weight
        weightTotal += weight
    end
    if weightTotal == 0 then return nil end
    return sum / weightTotal
end

local function getPingCompensation()
    local pingSec = math.clamp(S.pingDisplay / 1000, 0, C.predictionPingCap)
    return pingSec * C.predictionPingScale
end

local function predictPosition(root, deltaTime)
    if not S.predictionEnabled then return root.Position end

    local pos = root.Position
    local vel = getSmoothedVelocity() or root.AssemblyLinearVelocity
    local humanoid = getHumanoid(root.Parent)
    local moveDir = humanoid and humanoid.MoveDirection or Vector3.new(0, 0, 0)

    local dt = deltaTime or 0
    local lookahead = C.predictionLookahead + dt + getPingCompensation()

    local velLead = vel * (lookahead * C.predictionStrength)
    velLead = Vector3.new(velLead.X, velLead.Y * C.predictionVerticalBoost, velLead.Z)
    local walkLead = moveDir * (C.predictionMoveCompensation * C.predictionStrength)

    local predicted = pos + velLead + walkLead
    local offset = predicted - pos

    if offset.Magnitude > C.predictionMaxOffset then
        predicted = pos + offset.Unit * C.predictionMaxOffset
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
    local alpha = math.clamp(1 - math.exp(-C.positionSmoothness * dt), 0, 1)
    root.CFrame = root.CFrame:Lerp(targetCF, alpha)
end

local function parkCharacter(position)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if root then
        root.CFrame = CFrame.new(position or C.parkPosition)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

local function faceTorsoFrom(pos, targetRoot, predicted)
    local torsoPos = getTorso(targetRoot.Parent, predicted + Vector3.new(0, 2, 0))
    local dir = torsoPos - pos
    if dir.Magnitude < 0.05 then dir = Vector3.new(0, 1, 0) end
    local base = CFrame.lookAt(pos, pos + dir.Unit)
    return base * CFrame.Angles(-C.characterDownTilt, 0, 0)
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
    if awayRaw.Magnitude > C.awayDirMemory then
        S.cachedAwayDir = awayRaw.Unit
    end
    local awayDir = S.cachedAwayDir
    local standoff = math.max(C.combatStandoff, C.minDistance)

    local combatPos = Vector3.new(
        predicted.X + awayDir.X * standoff,
        torsoPos.Y + C.combatYOffset,
        predicted.Z + awayDir.Z * standoff
    )
    local dir = torsoPos - combatPos
    if dir.Magnitude < 0.05 then dir = Vector3.new(0, 1, 0) end

    local base = CFrame.lookAt(combatPos, combatPos + dir.Unit)
    local newCF = base * CFrame.Angles(-C.characterDownTilt, 0, 0)
    applySmoothCFrame(root, newCF, deltaTime)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function victimIsFacingMe(targetRoot)
    if not S.smartPositionEnabled then return false end
    local myRoot = getMyRoot()
    if not myRoot or not targetRoot then return false end

    local toMe = Vector3.new(myRoot.Position.X - targetRoot.Position.X, 0, myRoot.Position.Z - targetRoot.Position.Z)
    if toMe.Magnitude < 0.05 then return true end

    local look = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
    if look.Magnitude < 0.05 then return false end

    local dot = look.Unit:Dot(toMe.Unit)
    return dot > C.facingDotThreshold
end

local function moveCharacterBelow(targetRoot, deltaTime)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end
    local humanoid = getHumanoid(character)
    local predicted = predictPosition(targetRoot, deltaTime or 0)
    local distance = math.max(S.currentBelowDistance, C.minBelowDistance)

    local belowPos = Vector3.new(predicted.X, predicted.Y - distance - C.groundSink, predicted.Z)
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

    local lookFlatRaw = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
    if lookFlatRaw.Magnitude > 0.05 then S.cachedLookFlat = lookFlatRaw.Unit end

    local lookFlat = S.cachedLookFlat
    local distance = math.max(C.behindDistance, C.minDistance)

    local behindPos = Vector3.new(
        predicted.X - lookFlat.X * distance,
        predicted.Y - C.behindYOffset - C.groundSink,
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

    local lookFlatRaw = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
    local lookFlat
    if lookFlatRaw.Magnitude > 0.05 then
        lookFlat = lookFlatRaw.Unit
        S.cachedLookFlat = lookFlat
    else
        lookFlat = S.cachedLookFlat
    end

    local behindPos = Vector3.new(
        predicted.X - lookFlat.X * C.m1TeleportDistance,
        predicted.Y - C.groundSink,
        predicted.Z - lookFlat.Z * C.m1TeleportDistance
    )
    local torsoPos = getTorso(targetRoot.Parent, predicted + Vector3.new(0, 2, 0))
    local dir = torsoPos - behindPos
    if dir.Magnitude < 0.05 then dir = Vector3.new(0, 1, 0) end

    local newCF = CFrame.lookAt(behindPos, behindPos + dir.Unit) * CFrame.Angles(-C.characterDownTilt, 0, 0)
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
        away = S.cachedAwayDir
    else
        away = away.Unit
        S.cachedAwayDir = away
    end

    local rayOrigin = myPos + Vector3.new(0, 2, 0)
    local rayDir = away * C.wallRaycastDistance

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { character, targetRoot and targetRoot.Parent or nil }
    params.IgnoreWater = true

    local result = workspace:Raycast(rayOrigin, rayDir, params)

    local destination
    if result then
        destination = result.Position - away * C.wallStopOffset
    else
        destination = myPos + away * C.wallRetreatSpeedFallback
    end
    destination = Vector3.new(destination.X, myPos.Y, destination.Z)

    local faceDir = Vector3.new(away.X, 0, away.Z)
    if faceDir.Magnitude < 0.05 then faceDir = Vector3.new(0, 0, -1) end
    return CFrame.lookAt(destination, destination + faceDir.Unit)
end

local function moveToWall(targetRoot, deltaTime)
    local character = localPlayer.Character
    local root = character and getRoot(character)
    if not root then return end
    local humanoid = getHumanoid(character)
    local myPos = root.Position

    local validCache = S.cachedWallCFrame
        and S.cachedWallTarget == S.target
        and S.cachedWallOrigin
        and (myPos - S.cachedWallOrigin).Magnitude < C.wallRecalcDistance

    if not validCache then
        S.cachedWallCFrame = computeWallCFrame(targetRoot, character)
        S.cachedWallTarget = S.target
        S.cachedWallOrigin = myPos
    end

    if not S.cachedWallCFrame then return end
    local newCF = S.cachedWallCFrame * CFrame.Angles(-C.characterDownTilt, 0, 0)
    applySmoothCFrame(root, newCF, deltaTime)

    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Running then
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end

local function resolvePositionMode(targetRoot)
    if not S.smartPositionEnabled then return S.positionMode end
    if S.positionMode ~= C.positionAuto then return S.positionMode end
    if victimIsFacingMe(targetRoot) then return C.positionBehind end
    return C.positionBelow
end

local function setCameraState(cameraType, subject)
    local camera = workspace.CurrentCamera
    if not camera then return end
    pcall(function()
        if camera.CameraType ~= cameraType then camera.CameraType = cameraType end
        if subject ~= nil and camera.CameraSubject ~= subject then camera.CameraSubject = subject end
    end)
end

local function attachCameraToVictimHead(targetRoot)
    if not targetRoot then return end
    local character = targetRoot.Parent
    if not character then return end

    local currentHead = getHead(character)
    if not currentHead then
        S.cachedHeadTarget = character
        S.cachedHead = nil
        return
    end

    if S.cachedHeadTarget ~= character or S.cachedHead ~= currentHead then
        S.cachedHeadTarget = character
        S.cachedHead = currentHead
    end
    setCameraState(Enum.CameraType.Custom, S.cachedHead)
end

local function restoreCamera()
    local character = localPlayer.Character
    local humanoid = character and getHumanoid(character)
    if humanoid then setCameraState(Enum.CameraType.Custom, humanoid) end
end

local function snapToCombat(targetRoot)
    if not targetRoot then return end
    if not isValidTarget(targetRoot.Parent) then return end
    moveCharacterCombat(targetRoot, 0)
end

local function setRecoveryMode(enabledState)
    if enabledState and tick() < S.manualRecoveryCooldown then return end
    if enabledState and S.ultedActive then return end
    S.recoveryActive = enabledState
    if enabledState then parkCharacter() end
end

local function forceRecovery(enabledState)
    S.manualRecoveryCooldown = 0
    S.recoveryActive = enabledState
    S.manualRecoveryPark = enabledState
    if enabledState then
        S.particleRecoveryActive = false
        parkCharacter(C.manualParkPosition)
    else
        S.manualRecoveryPark = false
    end
end

local function exitAllRecovery()
    S.recoveryActive = false
    S.particleRecoveryActive = false
    S.wallRetreatActive = false
    S.manualRecoveryPark = false
    S.teamerParkUntil = 0
    S.teamerParkToken += 1
    S.manualRecoveryCooldown = tick() + C.manualRecoveryCooldownTime
    clearWallCache()
    if S.macroActive then
        S.macroActive = false
        S.macroToken += 1
    end
end

local function countNearbyThreats()
    local myRoot = getMyRoot()
    if not myRoot then return 0 end
    local count = 0
    for _, model in ipairs(getCandidates()) do
        if not isProtectedFromTeamerDetection(model) then
            local root = getRoot(model)
            if root and (root.Position - myRoot.Position).Magnitude <= C.threatRadius then
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
            S.recentMovers[model] = nil
        else
            local root = getRoot(model)
            if root then
                local speed = root.AssemblyLinearVelocity.Magnitude
                local humanoid = getHumanoid(model)
                local moving = speed >= C.teamerHostileMinSpeed
                if not moving and humanoid then
                    local moveDir = humanoid.MoveDirection
                    if moveDir.Magnitude >= 0.1 then moving = true end
                end
                if moving then S.recentMovers[model] = now end
            end
        end
    end
end

local function isRecentMover(model)
    if isProtectedFromTeamerDetection(model) then
        S.recentMovers[model] = nil
        return false
    end
    local last = S.recentMovers[model]
    if not last then return false end
    if tick() - last > C.teamerMovementMemory then
        S.recentMovers[model] = nil
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
                if dist <= C.teamerHostileRadius then
                    local toMeFlat = Vector3.new(toMe.X, 0, toMe.Z)
                    local lookFlat = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
                    if toMeFlat.Magnitude > 0.05 and lookFlat.Magnitude > 0.05 then
                        local facing = lookFlat.Unit:Dot(toMeFlat.Unit)
                        if facing >= C.teamerFacingDot then
                            if isRecentMover(model) then count += 1 end
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
    for i = #S.selfDamageTimes, 1, -1 do
        local entry = S.selfDamageTimes[i]
        if entry.time >= now - C.damageBurstWindow then
            count += 1
        else
            break
        end
    end
    return count
end

local function triggerTeamerPark(duration)
    if S.vCycleActive then return end
    if isFinisherTarget() then return end
    if tick() < S.manualRecoveryCooldown then return end
    if S.ultedActive then return end
    if S.autoCombatActive then return end

    local now = tick()
    local newEnd = now + (duration or C.teamerParkTime)
    if newEnd > S.teamerParkUntil then
        S.teamerParkUntil = newEnd
        S.teamerParkToken += 1
    end
end

local function checkTeamerThreat()
    if not C.teamerDefenseEnabled then return false end
    if S.vCycleActive then return false end
    if S.macroActive then return false end
    if isFinisherTarget() then return false end
    if tick() < S.manualRecoveryCooldown then return false end
    if S.m1Active then return false end
    if S.ultedActive then return false end
    if S.autoCombatActive then return false end

    local recent = countRecentDamageEvents()
    if recent >= C.damageBurstCount then
        triggerTeamerPark(C.panicParkTime)
        return true
    end

    local hostiles = countHostilePlayers()
    if hostiles >= C.teamerHostileCount then
        triggerTeamerPark(C.teamerParkTime)
        return true
    end
    return false
end

local function countLowHpCandidates()
    local count = 0
    for _, model in ipairs(getCandidates()) do
        local humanoid = getHumanoid(model)
        if humanoid and humanoid.Health < C.lowHealthThreshold then
            count += 1
        end
    end
    return count
end

local function getRecentSelfDps()
    local now = tick()
    local cutoff = now - C.selfDpsWindow
    local total = 0
    for i = #S.selfDamageTimes, 1, -1 do
        local entry = S.selfDamageTimes[i]
        if entry.time >= cutoff then
            total += entry.damage
        else
            table.remove(S.selfDamageTimes, i)
        end
    end
    return total / C.selfDpsWindow
end

local function startHoldBack()
    if S.holdBackActive then return end
    S.holdBackActive = true
    S.holdReleaseToken += 1
    S.currentBelowDistance = math.clamp(S.currentBelowDistance + C.holdBackAmount, C.minBelowDistance, C.maxBelowDistance)
end

local function endHoldBack()
    if not S.holdBackActive then return end
    S.holdBackActive = false
    S.holdReleaseToken += 1
    local myToken = S.holdReleaseToken
    task.delay(C.holdReleaseDelay, function()
        if S.stopped then return end
        if myToken ~= S.holdReleaseToken then return end
        if S.holdBackActive then return end
        S.currentBelowDistance = math.clamp(S.currentBelowDistance - C.holdBackAmount, C.minBelowDistance, C.maxBelowDistance)
    end)
end

local function evaluateHoldBack()
    if S.keyFourHeld and S.lmbHeld then
        startHoldBack()
    else
        endHoldBack()
    end
end

local function scheduleLMBMissCheck()
    S.lmbMissToken += 1
    local myToken = S.lmbMissToken
    local watchTarget = S.target
    if not isValidTarget(watchTarget) then return end
    local humanoid = getHumanoid(watchTarget)
    if not humanoid then return end
    local hpBefore = humanoid.Health

    task.delay(C.lmbCheckDelay, function()
        if S.stopped then return end
        if myToken ~= S.lmbMissToken then return end
        if S.target ~= watchTarget then return end
        if not isValidTarget(watchTarget) then return end
        local hpAfter = humanoid.Health
        if hpAfter >= hpBefore then
            if S.positionMode ~= C.positionBelow then
                S.positionMode = C.positionBehind
            end
        end
    end)
end

local function simulateKey1()
    S.currentBelowDistance = math.clamp(S.currentBelowDistance + C.oneBackAmount, C.minBelowDistance, C.maxBelowDistance)
    S.positionMode = C.positionBehind
    if isValidTarget(S.target) then setDistance(C.keyDistance) end
end

local function simulateKey3()
    S.positionMode = C.positionBehind
    if isValidTarget(S.target) then setDistance(C.keyDistance) end
end

local function cancelMacro()
    if not S.macroActive then return end
    S.macroActive = false
    S.macroToken += 1
end

local function runMacro()
    if S.macroActive then
        cancelMacro()
        return
    end
    S.macroToken += 1
    S.macroActive = true
    local myToken = S.macroToken

    task.spawn(function()
        setRecoveryMode(true)
        task.wait(C.macroStepDelay)
        if S.stopped or myToken ~= S.macroToken then S.macroActive = false return end

        simulateKey1()
        task.wait(C.macroGoVictimWait)
        if S.stopped or myToken ~= S.macroToken then S.macroActive = false return end

        setRecoveryMode(false)
        task.wait(C.macroStepDelay)
        if S.stopped or myToken ~= S.macroToken then S.macroActive = false return end

        setRecoveryMode(true)
        task.wait(C.macroRecoveryWait)
        if S.stopped or myToken ~= S.macroToken then S.macroActive = false return end

        simulateKey3()
        S.macroActive = false
    end)
end

local function vimMouseClick()
    if not virtualInputManager then return end
    if not virtualInputManager.SendMouseButtonEvent then return end
    pcall(function() virtualInputManager:SendMouseButtonEvent(0, 0, 1, true, nil, 0) end)
    task.wait(0.03)
    pcall(function() virtualInputManager:SendMouseButtonEvent(0, 0, 1, false, nil, 0) end)
end

local function vimKeyPress(keyCode)
    if not virtualInputManager then return end
    if not virtualInputManager.SendKeyEvent then return end
    pcall(function() virtualInputManager:SendKeyEvent(keyCode, true, false, nil) end)
    task.wait(0.05)
    pcall(function() virtualInputManager:SendKeyEvent(keyCode, false, false, nil) end)
    task.wait(0.05)
end

local function autoCombatBurst(count, myToken)
    for _ = 1, count do
        if not S.autoCombatActive or S.stopped or myToken ~= S.autoCombatToken then return false end
        if not isValidTarget(S.target) then
            S.autoCombatActive = false
            return false
        end
        task.wait(C.autoCombatHitDelay)
        vimMouseClick()
    end
    return true
end

local function cancelAutoCombat()
    if not S.autoCombatActive then return end
    S.autoCombatActive = false
    S.autoCombatToken += 1
end

local function runAutoCombat()
    if S.autoCombatActive then
        cancelAutoCombat()
        return
    end
    if not isValidTarget(S.target) then return end

    S.autoCombatToken += 1
    S.autoCombatActive = true
    local myToken = S.autoCombatToken

    task.spawn(function()
        while S.autoCombatActive and not S.stopped and myToken == S.autoCombatToken do
            if not isValidTarget(S.target) then
                S.autoCombatActive = false
                return
            end
            local humanoid = getHumanoid(S.target)
            if not humanoid or humanoid.Health <= 0 then
                S.autoCombatActive = false
                return
            end

            if not autoCombatBurst(4, myToken) then return end
            if not S.autoCombatActive or myToken ~= S.autoCombatToken then return end
            vimKeyPress(Enum.KeyCode.Q)
            task.wait(C.autoCombatKeyDelay)

            if not autoCombatBurst(4, myToken) then return end
            if not S.autoCombatActive or myToken ~= S.autoCombatToken then return end
            vimKeyPress(Enum.KeyCode.Two)
            task.wait(C.autoCombatKeyDelay)

            if not autoCombatBurst(4, myToken) then return end
            if not S.autoCombatActive or myToken ~= S.autoCombatToken then return end
            vimKeyPress(Enum.KeyCode.One)
            task.wait(C.autoCombatKeyDelay)

            if not S.autoCombatActive or myToken ~= S.autoCombatToken then return end
            vimKeyPress(Enum.KeyCode.Q)
            task.wait(C.autoCombatKeyDelay)

            if not autoCombatBurst(4, myToken) then return end
            if not S.autoCombatActive or myToken ~= S.autoCombatToken then return end
            vimKeyPress(Enum.KeyCode.Three)
            task.wait(C.autoCombatKeyDelay)
        end
        S.autoCombatActive = false
    end)
end

local function onTargetHealthChanged(newHealth)
    if S.stopped then return end
    if not S.target or not isValidTarget(S.target) then return end

    local delta = newHealth - S.lastHealth
    S.lastHealth = newHealth

    if newHealth <= 0 then
        S.killCount += 1
        cancelAutoCombat()
        return
    end
    if delta >= 0 then return end

    S.lastTargetDamageTime = tick()
    if S.damageReactionCount >= C.damageReactionLimit then return end
    S.damageReactionCount += 1

    local myRoot = getMyRoot()
    local targetRoot = getRoot(S.target)
    if not myRoot or not targetRoot then return end

    local dist = (myRoot.Position - targetRoot.Position).Magnitude
    if dist <= C.userAttackRange then
        S.currentBelowDistance = math.clamp(S.currentBelowDistance + C.damagePushBack, C.minBelowDistance, C.maxBelowDistance)
    else
        local nudge = (math.random() < 0.5) and -C.damageNudge or C.damageNudge
        S.currentBelowDistance = math.clamp(S.currentBelowDistance + nudge, C.minBelowDistance, C.maxBelowDistance)
    end
end

local function attachHealthWatcher(model)
    local humanoid = model and getHumanoid(model)
    if humanoid == S.watchedHumanoid then return end

    if S.healthConnection then
        S.healthConnection:Disconnect()
        S.healthConnection = nil
    end

    S.watchedHumanoid = humanoid
    if not humanoid then return end
    S.lastHealth = humanoid.Health
    S.damageReactionCount = 0
    S.healthConnection = humanoid.HealthChanged:Connect(onTargetHealthChanged)
end

local function onMyHealthChanged(newHealth)
    if S.stopped then return end

    local delta = newHealth - S.lastMyHealth
    S.lastMyHealth = newHealth
    if delta >= 0 then return end

    local damage = -delta
    table.insert(S.selfDamageTimes, { time = tick(), damage = damage })

    if S.vCycleActive then return end
    if isFinisherTarget() then return end

    if damage > C.heavyDamageThreshold then triggerTeamerPark(C.panicParkTime) end

    local character = localPlayer.Character
    local humanoid = character and getHumanoid(character)
    if humanoid and humanoid.Health / math.max(humanoid.MaxHealth, 1) < C.selfHpRecoveryPct then
        S.positionMode = C.positionBehind
        if S.smartRecoveryEnabled and not S.recoveryActive and not S.lmbHeld and not S.macroActive and not S.ultedActive and not S.autoCombatActive then
            setRecoveryMode(true)
        end
        return
    end
    if damage > C.heavyDamageThreshold or newHealth < C.lowHealthThreshold then
        S.positionMode = C.positionBehind
    end
end

local function attachMyHealthWatcher()
    if S.myHealthConnection then
        S.myHealthConnection:Disconnect()
        S.myHealthConnection = nil
    end
    local character = localPlayer.Character
    local humanoid = character and getHumanoid(character)
    if not humanoid then return end
    S.lastMyHealth = humanoid.Health
    S.myHealthConnection = humanoid.HealthChanged:Connect(onMyHealthChanged)
end

local function configureInfinitePrompt(prompt)
    if not S.instantInteractEnabled then return end
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    pcall(function()
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = C.promptInteractDistance
    end)
end

local function applyInstantInteract()
    if not S.instantInteractEnabled then return end
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
            for _, attackId in ipairs(C.attackAnimationIds) do
                if anim.AnimationId == attackId then return true end
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
        if not arm then arm = character:WaitForChild("Right Arm", 3) end
        if not arm then arm = character:FindFirstChild("RightHand") end
        if not arm then arm = character:WaitForChild("RightHand", 3) end
        if not arm then return end
        track(arm.ChildAdded:Connect(onAntiVoidChildAdded))
    end)
end

local function bindIdle()
    track(localPlayer.Idled:Connect(function()
        if virtualInputManager and virtualInputManager.SendMouseButtonEvent then
            pcall(function() virtualInputManager:SendMouseButtonEvent(0, 0, 2, true, nil, 0) end)
            task.wait(1)
            pcall(function() virtualInputManager:SendMouseButtonEvent(0, 0, 2, false, nil, 0) end)
        end
    end))
end

local function vCycle()
    if S.vCycleActive then
        S.vCycleActive = false
        S.vCycleVersion += 1
        return
    end
    S.vCycleActive = true
    S.teamerParkUntil = 0
    S.teamerParkToken += 1
    resetParticleTracking()
    S.recentMovers = {}
    S.vCycleVersion += 1
    local myVersion = S.vCycleVersion

    task.spawn(function()
        for _ = 1, C.vCycleRounds do
            local list = sortSmart(getCandidates())
            if #list == 0 then break end
            for _, model in ipairs(list) do
                if S.stopped or not S.vCycleActive or S.vCycleVersion ~= myVersion then return end
                if isValidTarget(model) then
                    setTarget(model)
                    S.currentDistance = C.defaultDistance
                    S.currentBelowDistance = C.belowDistance
                    S.damageReactionCount = 0
                    S.velocityHistory = {}
                end
                task.wait(C.vCycleDelay)
            end
        end
        if S.vCycleVersion == myVersion then S.vCycleActive = false end
    end)
end

local function stopEverything()
    if S.stopped then return end
    S.stopped = true
    S.enabled = false
    S.recoveryActive = false
    S.vCycleActive = false
    S.vCycleVersion += 1
    S.holdBackActive = false
    S.holdReleaseToken += 1
    S.lmbMissToken += 1
    S.macroActive = false
    S.macroToken += 1
    S.teamerParkUntil = 0
    S.teamerParkToken += 1
    S.wallRetreatActive = false
    clearWallCache()
    resetParticleTracking()
    S.target = nil
    S.previousTarget = nil
    S.velocityHistory = {}
    S.combatStickyUntil = 0
    S.cachedHead = nil
    S.cachedHeadTarget = nil
    S.cachedAwayDir = Vector3.new(0, 0, 1)
    S.cachedLookFlat = Vector3.new(0, 0, -1)
    S.recentMovers = {}
    S.m1Active = false
    S.ultedActive = false
    S.manualRecoveryPark = false
    S.autoCombatActive = false
    S.autoCombatToken += 1

    pcall(function() if S.healthConnection then S.healthConnection:Disconnect() end end)
    S.healthConnection = nil
    S.watchedHumanoid = nil
    S.damageReactionCount = 0

    pcall(function() if S.myHealthConnection then S.myHealthConnection:Disconnect() end end)
    S.myHealthConnection = nil
    pcall(function() if S.mainConnection then S.mainConnection:Disconnect() end end)
    S.mainConnection = nil
    pcall(function() if S.inputConnection then S.inputConnection:Disconnect() end end)
    S.inputConnection = nil
    pcall(function() if S.inputEndedConnection then S.inputEndedConnection:Disconnect() end end)
    S.inputEndedConnection = nil
    pcall(function() if S.characterConnection then S.characterConnection:Disconnect() end end)
    S.characterConnection = nil

    for _, connection in ipairs(S.trackedConnections) do
        pcall(function() connection:Disconnect() end)
    end
    S.trackedConnections = {}

    pcall(function() if S.hud and S.hud.gui then S.hud.gui:Destroy() end end)
    S.hud = nil
    pcall(function() if S.helpGui and S.helpGui.gui then S.helpGui.gui:Destroy() end end)
    S.helpGui = nil
    pcall(function() if S.sidebar and S.sidebar.gui then S.sidebar.gui:Destroy() end end)
    S.sidebar = nil
    pcall(function() if S.loadingScreen and S.loadingScreen.gui then S.loadingScreen.gui:Destroy() end end)
    S.loadingScreen = nil

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
    frame.BackgroundColor3 = C.bgDark
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.bgLight
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -16)
    accentBar.Position = UDim2.new(0, 6, 0, 8)
    accentBar.BackgroundColor3 = C.accent
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
    nameLabel.TextColor3 = C.textColor
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = frame

    local healthTrack = Instance.new("Frame")
    healthTrack.Size = UDim2.new(0, 110, 0, 6)
    healthTrack.Position = UDim2.new(1, -200, 0.5, 0)
    healthTrack.BackgroundColor3 = C.bgLight
    healthTrack.BorderSizePixel = 0
    healthTrack.Parent = frame

    local htCorner = Instance.new("UICorner")
    htCorner.CornerRadius = UDim.new(1, 0)
    htCorner.Parent = healthTrack

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = C.okColor
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthTrack

    local hfCorner = Instance.new("UICorner")
    hfCorner.CornerRadius = UDim.new(1, 0)
    hfCorner.Parent = healthFill

    local statusPill = Instance.new("Frame")
    statusPill.Size = UDim2.new(0, 82, 0, 22)
    statusPill.Position = UDim2.new(1, -88, 0.5, -11)
    statusPill.BackgroundColor3 = C.bgLight
    statusPill.BorderSizePixel = 0
    statusPill.Parent = frame

    local spCorner = Instance.new("UICorner")
    spCorner.CornerRadius = UDim.new(1, 0)
    spCorner.Parent = statusPill

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "READY"
    statusLabel.TextColor3 = C.okColor
    statusLabel.TextSize = 11
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Parent = statusPill

    return { gui = gui, nameLabel = nameLabel, healthFill = healthFill, statusLabel = statusLabel, statusPill = statusPill }
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
    frame.BackgroundColor3 = C.bgDark
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.bgLight
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
        key.TextColor3 = C.textDim
        key.TextSize = 11
        key.Font = Enum.Font.GothamMedium
        key.TextXAlignment = Enum.TextXAlignment.Left
        key.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.45, 0, 1, 0)
        value.Position = UDim2.new(0.55, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = "--"
        value.TextColor3 = C.textColor
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

    return { gui = gui, fpsValue = fpsValue, pingValue = pingValue, killsValue = killsValue, lowHpValue = lowHpValue }
end

local function getPing()
    local ok, value = pcall(function()
        return stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok and value then return math.floor(value + 0.5) end
    return 0
end

local function updateSidebar(deltaTime)
    if not S.sidebar then return end
    S.fpsFrames += 1
    S.fpsAccum += deltaTime
    if S.fpsAccum >= 0.5 then
        S.fpsDisplay = math.floor(S.fpsFrames / S.fpsAccum + 0.5)
        S.fpsFrames = 0
        S.fpsAccum = 0
    end
    S.statsAccum += deltaTime
    if S.statsAccum >= 0.25 then
        S.statsAccum = 0
        S.pingDisplay = getPing()
        S.lowHpCount = countLowHpCandidates()
    end

    S.sidebar.fpsValue.Text = tostring(S.fpsDisplay)

    local pingColor
    if S.pingDisplay <= 60 then pingColor = C.okColor
    elseif S.pingDisplay <= 120 then pingColor = C.warnColor
    else pingColor = C.badColor end
    S.sidebar.pingValue.Text = tostring(S.pingDisplay) .. "ms"
    S.sidebar.pingValue.TextColor3 = pingColor

    S.sidebar.killsValue.Text = tostring(S.killCount)

    local hpColor
    if S.lowHpCount == 0 then hpColor = C.textColor
    elseif S.lowHpCount <= 2 then hpColor = C.warnColor
    else hpColor = C.badColor end
    S.sidebar.lowHpValue.Text = tostring(S.lowHpCount)
    S.sidebar.lowHpValue.TextColor3 = hpColor
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
    frame.BackgroundColor3 = C.bgDark
    frame.BackgroundTransparency = 0.12
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.bgLight
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.new(0, 12, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = "KEYBINDS"
    title.TextColor3 = C.textColor
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
        header.TextColor3 = C.accent
        header.TextSize = 11
        header.Font = Enum.Font.GothamBold
        header.TextXAlignment = Enum.TextXAlignment.Left
        header.Parent = frame

        local body = Instance.new("TextLabel")
        body.Size = UDim2.new(1, -20, 0, #rows * 15)
        body.Position = UDim2.new(0, 12, 0, y + 16)
        body.BackgroundTransparency = 1
        body.Text = table.concat(rows, "\n")
        body.TextColor3 = C.textColor
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
        "K                toggle victim cam",
    })
    y = section(y, "COMBAT", {
        "0                toggle auto combat",
        "Q                snap into combat range",
        "LMB (hold)  melee sticky (snap into range)",
        "1                 behind + 0.75 studs back",
        "2/3             behind position",
        "4 + LMB      push back 4.5 studs",
        "9                 macro: recovery -> attack",
    })
    y = section(y, "SYSTEM", {
        "C                cancel ALL recovery (4s cooldown)",
        "M               recovery -> 0,5000,0 (bypasses cd)",
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
    if not S.hud then return end
    if not isValidTarget(S.target) then
        S.hud.nameLabel.Text = "No Target"
        S.hud.healthFill.Size = UDim2.new(0, 0, 1, 0)
        S.hud.statusLabel.Text = S.enabled and "READY" or "PAUSED"
        S.hud.statusLabel.TextColor3 = S.enabled and C.okColor or C.warnColor
        return
    end

    local humanoid = getHumanoid(S.target)
    S.hud.nameLabel.Text = getTargetName(S.target)

    local statusText
    local statusColor

    if S.autoCombatActive then statusText = "AUTO" statusColor = C.badColor
    elseif isFinisherTarget() then statusText = "FINISH" statusColor = C.warnColor
    elseif S.wallRetreatActive then statusText = "WALL" statusColor = C.badColor
    elseif S.m1Active then statusText = "M1" statusColor = C.badColor
    elseif S.ultedActive then statusText = "ULTED" statusColor = C.specialColor
    elseif S.vCycleActive then statusText = "CYCLE" statusColor = C.infoColor
    elseif S.particleRecoveryActive then statusText = "PARTICLE" statusColor = C.specialColor
    elseif tick() < S.teamerParkUntil then statusText = "PARK" statusColor = C.badColor
    elseif S.macroActive then statusText = "MACRO" statusColor = C.specialColor
    elseif S.recoveryActive then statusText = "RECOVERY" statusColor = C.warnColor
    elseif S.lmbHeld then statusText = "COMBAT" statusColor = C.badColor
    elseif tick() < S.combatStickyUntil then statusText = "COMBAT" statusColor = C.badColor
    elseif S.holdBackActive then statusText = "HOLD" statusColor = C.warnColor
    elseif not S.enabled then statusText = "PAUSED" statusColor = C.warnColor
    else statusText = "TRACKING" statusColor = C.okColor end

    S.hud.statusLabel.Text = statusText
    S.hud.statusLabel.TextColor3 = statusColor

    if humanoid then
        local pct = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
        S.hud.healthFill.Size = UDim2.new(pct, 0, 1, 0)
        if pct > 0.5 then S.hud.healthFill.BackgroundColor3 = C.okColor
        elseif pct > 0.25 then S.hud.healthFill.BackgroundColor3 = C.warnColor
        else S.hud.healthFill.BackgroundColor3 = C.badColor end
    end
end

for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        if player.Character then addCandidate(player.Character) end
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
    if character then removeCandidate(character) end
end))

track(workspace.DescendantAdded:Connect(function(object)
    if object:IsA("Humanoid") then
        local model = object.Parent
        if model and model:IsA("Model") then task.defer(addCandidate, model) end
    end
    if object:IsA("BasePart") and object.Name == "HumanoidRootPart" then
        local model = object.Parent
        if model and model:IsA("Model") then task.defer(addCandidate, model) end
    end
end))

track(workspace.DescendantRemoving:Connect(function(object)
    if object:IsA("Model") then removeCandidate(object) end
end))

track(workspace.DescendantAdded:Connect(function(descendant)
    configureInfinitePrompt(descendant)
end))

local function getLoadingScreenBuilder()
    local ok, result = pcall(function()
        local source = game:HttpGet(C.loadingUrl)
        if not source or source == "" then error("empty response") end
        local chunk = loadstring(source)
        if not chunk then error("chunk failed") end
        return chunk()
    end)
    if not ok then return nil end
    if type(result) ~= "function" then return nil end
    return result
end

local createLoadingScreen = getLoadingScreenBuilder()

if createLoadingScreen then
    local ok, screen = pcall(createLoadingScreen)
    if ok and screen and screen.setProgress and screen.destroy then
        S.loadingScreen = screen
    end
end

if S.loadingScreen and S.loadingScreen.setProgress then
    local steps = {
        { 0.15, "starting up" },
        { 0.35, "loading modules" },
        { 0.55, "preparing ui" },
        { 0.75, "hooking controls" },
        { 0.90, "almost ready" },
        { 1.00, "ready" },
    }
    for _, step in ipairs(steps) do
        pcall(function() S.loadingScreen.setProgress(step[1], step[2]) end)
        task.wait(0.16)
    end
    task.wait(0.5)
    pcall(function() S.loadingScreen.destroy() end)
    S.loadingScreen = nil
    task.wait(0.45)
end

S.hud = createHUD()
S.sidebar = createSidebar()
S.helpGui = createHelpPanel()

applyInstantInteract()
bindIdle()
attachMyHealthWatcher()
bindAntiVoid(localPlayer.Character)

if S.helpGui and S.helpGui.gui then S.helpGui.gui.Enabled = C.helpEnabled end

S.characterConnection = localPlayer.CharacterAdded:Connect(function(newCharacter)
    S.target = nil
    S.previousTarget = nil
    S.currentDistance = C.defaultDistance
    S.currentBelowDistance = C.belowDistance
    S.vCycleActive = false
    S.vCycleVersion += 1
    S.recoveryActive = false
    S.holdBackActive = false
    S.holdReleaseToken += 1
    S.lmbMissToken += 1
    S.macroActive = false
    S.macroToken += 1
    S.teamerParkUntil = 0
    S.teamerParkToken += 1
    S.damageReactionCount = 0
    S.positionMode = C.positionBehind
    S.velocityHistory = {}
    S.combatStickyUntil = 0
    S.cachedHead = nil
    S.cachedHeadTarget = nil
    S.cachedAwayDir = Vector3.new(0, 0, 1)
    S.cachedLookFlat = Vector3.new(0, 0, -1)
    S.recentMovers = {}
    S.wallRetreatActive = false
    S.m1Active = false
    S.ultedActive = false
    S.manualRecoveryPark = false
    clearWallCache()
    resetParticleTracking()
    S.lastTargetDamageTime = 0
    cancelAutoCombat()

    if S.healthConnection then
        S.healthConnection:Disconnect()
        S.healthConnection = nil
    end
    S.watchedHumanoid = nil

    task.wait(0.2)
    if S.stopped then return end
    attachMyHealthWatcher()
    bindAntiVoid(newCharacter)
    restoreCamera()
end)

S.mainConnection = runService.RenderStepped:Connect(function(deltaTime)
    if S.stopped then return end

    updateHUD()
    updateSidebar(deltaTime)
    updateMoverStatus()

    if not S.enabled then
        attachHealthWatcher(nil)
        restoreCamera()
        return
    end

    if S.target and isTrulyDead(S.target) then
        S.target = nil
        S.wallRetreatActive = false
        S.m1Active = false
        S.ultedActive = false
        clearWallCache()
        cancelAutoCombat()
    end

    if not S.target then
        if S.vCycleActive then
            attachHealthWatcher(nil)
            if not S.victimCamEnabled then restoreCamera() end
            return
        end
        if not selectClosestTarget() then
            attachHealthWatcher(nil)
            if not S.victimCamEnabled then restoreCamera() end
            return
        end
    end

    local targetRoot = getRoot(S.target)
    if not targetRoot then return end

    attachHealthWatcher(S.target)
    updateVelocityHistory(targetRoot)
    checkTeamerThreat()

    local finisher = isFinisherTarget()
    local grabbed = hasGrabbedFolder(S.target)
    local m1On = hasM1Attribute(S.target)
    S.m1Active = m1On
    S.ultedActive = hasUltedAttribute(S.target)

    if S.ultedActive and S.recoveryActive and not S.manualRecoveryPark then
        S.recoveryActive = false
    end

    if grabbed then
        if not S.wallRetreatActive then clearWallCache() end
        S.wallRetreatActive = true
        if S.recoveryActive then S.recoveryActive = false end
        if S.particleRecoveryActive then S.particleRecoveryActive = false end
    else
        if S.wallRetreatActive then clearWallCache() end
        S.wallRetreatActive = false
    end

    local manualCooldownActive = tick() < S.manualRecoveryCooldown

    if C.particleRecoveryEnabled and not S.vCycleActive and not S.macroActive and not grabbed and not manualCooldownActive and not S.ultedActive and not S.autoCombatActive then
        if C.particleRecoverySkipsFinisher and finisher then
            if S.particleRecoveryActive then
                S.particleRecoveryActive = false
                if S.recoveryActive then setRecoveryMode(false) end
            end
            S.cachedVictimHasParticles = false
            S.particleContinuousStart = 0
        else
            local now = tick()
            if now - S.lastParticleCheck >= C.particleRescanInterval then
                S.lastParticleCheck = now
                S.cachedVictimHasParticles = victimHasParticles()
                if S.cachedVictimHasParticles then
                    S.lastParticleSeenAt = now
                    if S.particleContinuousStart == 0 then S.particleContinuousStart = now end
                else
                    S.particleContinuousStart = 0
                end
            end

            local particleWindow = (now - S.lastParticleSeenAt) < C.particleGracePeriod
            local victimRecentlyDamaged = (now - S.lastTargetDamageTime) < C.targetDamageMemory
            local persistentAura = S.particleContinuousStart > 0
                and (now - S.particleContinuousStart) >= C.persistentParticleThreshold

            if particleWindow and not victimRecentlyDamaged and not persistentAura then
                if not S.recoveryActive then setRecoveryMode(true) end
                S.particleRecoveryActive = true
            else
                if S.particleRecoveryActive then
                    S.particleRecoveryActive = false
                    if S.recoveryActive then setRecoveryMode(false) end
                end
            end
        end
    else
        if S.particleRecoveryActive then S.particleRecoveryActive = false end
    end

    if not S.vCycleActive and not finisher and not S.particleRecoveryActive and S.smartRecoveryEnabled and not S.macroActive and not S.lmbHeld and not grabbed and not manualCooldownActive and not m1On and not S.ultedActive and not S.autoCombatActive then
        local threats = countNearbyThreats()
        local dps = getRecentSelfDps()
        if threats >= C.threatCountTrigger and not S.recoveryActive then setRecoveryMode(true) end
        if dps >= C.selfDpsRecoveryThreshold and not S.recoveryActive then setRecoveryMode(true) end
    end

    if not S.vCycleActive and not finisher and not S.particleRecoveryActive and S.recoveryOnAttack and S.target and isAttacking(S.target) and not S.macroActive and not S.lmbHeld and not grabbed and not manualCooldownActive and not m1On and not S.ultedActive and not S.autoCombatActive then
        if not S.recoveryActive then setRecoveryMode(true) end
    end

    if (S.lmbHeld or S.autoCombatActive) and not S.macroActive then
        S.combatStickyUntil = tick() + C.meleeStickyDuration
    end

    local teamerParking = (not S.vCycleActive) and (not finisher) and tick() < S.teamerParkUntil
    local activeRecovery = (not S.vCycleActive) and (not finisher) and S.recoveryActive

    if S.wallRetreatActive then
        moveToWall(targetRoot, deltaTime)
    elseif m1On then
        teleportBehindM1(targetRoot)
    elseif activeRecovery then
        parkCharacter(S.manualRecoveryPark and C.manualParkPosition or C.parkPosition)
    elseif teamerParking then
        parkCharacter(C.parkPosition)
    elseif tick() < S.combatStickyUntil then
        moveCharacterCombat(targetRoot, deltaTime)
    else
        local resolvedMode = resolvePositionMode(targetRoot)
        if resolvedMode == C.positionBelow then
            moveCharacterBelow(targetRoot, deltaTime)
        else
            moveCharacterBehind(targetRoot, deltaTime)
        end
    end

    if S.victimCamEnabled then
        attachCameraToVictimHead(targetRoot)
    else
        restoreCamera()
    end
end)

S.inputConnection = userInputService.InputBegan:Connect(function(input, gameProcessed)
    if S.stopped then return end

    if input.KeyCode == Enum.KeyCode.O then
        stopEverything()
        return
    end

    if input.KeyCode == Enum.KeyCode.C then
        exitAllRecovery()
        cancelAutoCombat()
        return
    end

    if input.KeyCode == Enum.KeyCode.M then
        forceRecovery(not S.recoveryActive)
        return
    end

    if input.KeyCode == Enum.KeyCode.Zero then
        runAutoCombat()
        return
    end

    if input.KeyCode == Enum.KeyCode.Q then
        if isValidTarget(S.target) then
            local tRoot = getRoot(S.target)
            if tRoot then
                S.combatStickyUntil = tick() + C.meleeStickyDuration
                snapToCombat(tRoot)
            end
        end
        return
    end

    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.K then
        S.victimCamEnabled = not S.victimCamEnabled
        if not S.victimCamEnabled then restoreCamera() end
        return
    end

    if input.KeyCode == Enum.KeyCode.Nine then runMacro() return end

    if input.KeyCode == Enum.KeyCode.N then
        S.sidebarEnabled = not S.sidebarEnabled
        if S.sidebar and S.sidebar.gui then S.sidebar.gui.Enabled = S.sidebarEnabled end
        return
    end

    if input.KeyCode == Enum.KeyCode.Four then
        S.keyFourHeld = true
        evaluateHoldBack()
        S.positionMode = C.positionBehind
        if isValidTarget(S.target) then setDistance(C.keyDistance) end
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        S.lmbHeld = true
        local hadTarget = isValidTarget(S.target)
        if hadTarget then
            S.combatStickyUntil = tick() + C.meleeStickyDuration
            local tRoot = getRoot(S.target)
            if tRoot then snapToCombat(tRoot) end
        end
        evaluateHoldBack()
        if not (S.keyFourHeld and S.lmbHeld) then
            if hadTarget then
                setDistance(C.lmbDistance)
                scheduleLMBMissCheck()
            else
                if lockTargetUnderMouse() then
                    S.combatStickyUntil = tick() + C.meleeStickyDuration
                    local tRoot = getRoot(S.target)
                    if tRoot then snapToCombat(tRoot) end
                end
            end
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.RightShift then
        S.enabled = not S.enabled
        if not S.enabled then restoreCamera() end
        return
    end

    if input.KeyCode == Enum.KeyCode.V then vCycle() return end

    if input.KeyCode == Enum.KeyCode.P then
        S.predictionEnabled = not S.predictionEnabled
        return
    end

    if input.KeyCode == Enum.KeyCode.I then
        S.instantInteractEnabled = not S.instantInteractEnabled
        if S.instantInteractEnabled then applyInstantInteract() end
        return
    end

    if input.KeyCode == Enum.KeyCode.Y then
        local nowOn = not (S.smartTargetingEnabled and S.smartPositionEnabled and S.smartRecoveryEnabled and S.adaptivePredictionEnabled)
        S.smartTargetingEnabled = nowOn
        S.smartPositionEnabled = nowOn
        S.smartRecoveryEnabled = nowOn
        S.adaptivePredictionEnabled = nowOn
        return
    end

    if input.KeyCode == Enum.KeyCode.U then
        if S.positionMode == C.positionBelow then S.positionMode = C.positionBehind
        elseif S.positionMode == C.positionBehind then S.positionMode = C.positionAuto
        else S.positionMode = C.positionBelow end
        return
    end

    if input.KeyCode == Enum.KeyCode.J then
        S.recoveryOnAttack = not S.recoveryOnAttack
        return
    end

    if input.KeyCode == Enum.KeyCode.H then
        S.hudEnabled = not S.hudEnabled
        if S.hud and S.hud.gui then S.hud.gui.Enabled = S.hudEnabled end
        return
    end

    if input.KeyCode == Enum.KeyCode.F1 then
        S.helpEnabled = not S.helpEnabled
        if S.helpGui and S.helpGui.gui then S.helpGui.gui.Enabled = S.helpEnabled end
        return
    end

    if input.KeyCode == Enum.KeyCode.E then goToPreviousTarget() return end
    if input.KeyCode == Enum.KeyCode.R then cycleTarget() return end

    if input.KeyCode == Enum.KeyCode.T then
        S.previousTarget = S.target
        S.target = nil
        resetParticleTracking()
        S.lastTargetDamageTime = 0
        S.wallRetreatActive = false
        S.m1Active = false
        S.ultedActive = false
        S.manualRecoveryPark = false
        clearWallCache()
        cancelAutoCombat()
        if not S.victimCamEnabled then restoreCamera() end
        return
    end

    if input.KeyCode == Enum.KeyCode.One then simulateKey1() return end
    if input.KeyCode == Enum.KeyCode.Two or input.KeyCode == Enum.KeyCode.Three then simulateKey3() return end
end)

S.inputEndedConnection = userInputService.InputEnded:Connect(function(input)
    if S.stopped then return end
    if input.KeyCode == Enum.KeyCode.Four then
        S.keyFourHeld = false
        evaluateHoldBack()
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        S.lmbHeld = false
        evaluateHoldBack()
        return
    end
end)

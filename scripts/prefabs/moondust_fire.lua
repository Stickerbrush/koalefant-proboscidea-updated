local assets =
{
	Asset("ANIM", "anim/special_fire.zip"),
	Asset("SOUND", "sound/common.fsb"),
}
local heats = { 30, 70, 120, 180, 220 }

local function GetHeatFn(inst)
    return heats[inst.components.firefx.level] or 20
end

local firelevels =
{
    {anim="level1", sound="dontstarve/common/campfire", radius=2, intensity=.75, falloff=.33, colour = {197/255,197/255,170/255}, soundintensity=.1},
    {anim="level2", sound="dontstarve/common/campfire", radius=3, intensity=.8, falloff=.33, colour = {255/255,255/255,192/255}, soundintensity=.3},
    {anim="level3", sound="dontstarve/common/campfire", radius=4, intensity=.8, falloff=.33, colour = {255/255,255/255,192/255}, soundintensity=.6},
    {anim="level4", sound="dontstarve/common/campfire", radius=5, intensity=.9, falloff=.25, colour = {255/255,190/255,121/255}, soundintensity=1},
    {anim="level4", sound="dontstarve/common/forestfire", radius=6, intensity=.9, falloff=.2, colour = {255/255,190/255,121/255}, soundintensity=1},
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetBank("fire")
    inst.AnimState:SetBuild("special_fire")
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("FX")
	inst:AddTag("NOCLICK")
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("firefx")
    inst.components.firefx.levels = firelevels

    inst.components.firefx.extinguishsoundtest = function() 
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 5) 
        local fireyness = 0
        for k,v in pairs(ents) do
            if v ~= inst and v.components.firefx and v.components.firefx.level then
                fireyness = fireyness + v.components.firefx.level
            end
        end

        return fireyness < 5
    end

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn
	
	inst.AnimState:SetFinalOffset(-1)
	
    return inst
end

return Prefab("common/fx/moondust_fire", fn, assets)
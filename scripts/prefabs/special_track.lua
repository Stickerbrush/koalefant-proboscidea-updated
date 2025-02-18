local assets =
{
    Asset("ANIM", "anim/special_tracks.zip"),
}

local function OnSave(inst, data)
    data.direction = inst.Transform:GetRotation()
end
        
local function OnLoad(inst, data)
    if data and data.direction then
        inst.Transform:SetRotation(data.direction)
    end
end

local function fadeout(inst, duration, dt)
    if inst._fadetime > dt then
        inst._fadetime = inst._fadetime - dt
        local k = inst._fadetime / duration
        inst.AnimState:SetMultColour(k, k, k, k)
    else
        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("track")
    
    inst.AnimState:SetBank("track")
    inst.AnimState:SetBuild("koalefant_tracks")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder( 3 )
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:PlayAnimation("idle")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")
	
	inst:SetPrefabName("animal_track")
	
	inst._fadetime = 15
    inst:DoPeriodicTask(FRAMES, fadeout, 30, inst._fadetime, FRAMES)

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

	inst.persists = false
	
    return inst
end

return Prefab("forest/objects/special_track", fn, assets)
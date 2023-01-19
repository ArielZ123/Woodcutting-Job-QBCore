local QBCore = exports['qb-core']:GetCoreObject()

local Ispedwoodcutting = false

local Trees = { -- Wood position to harvest, you can add more locations
    {x= -583.23, y= 5490.79, z= 55.83},
}

local Process = { -- wood process location, you can add more locations.
    {x = -515.22 ,y = 5332.64 ,z = 79.26},
}

local Sell = { -- wood sell location, you can add more locations.
    {x = 2676.33 ,y = 3513.26 ,z = 51.71},
}

local Npc  = { -- npc location with the sell locations, add together.
   {x= -515.35, y= 5332.15, z= 79.26, h= 324.46},
   {x= 2677.19, y= 3512.92, z= 51.71, h= 67.93}, -- 2677.19, 3512.92, 52.71, 67.93
}

Citizen.CreateThread(function()
    while true do
	   local ped = PlayerPedId()
       local plyCoords = GetEntityCoords(ped)
       local NearMarker = false
       for k in pairs(Trees) do
           if Ispedwoodcutting == false then
              local Plycoords = vector3(plyCoords.x, plyCoords.y, plyCoords.z)
	          local Trees_coords = vector3(Trees[k].x, Trees[k].y, Trees[k].z)
              local dist = #(Plycoords - Trees_coords)
              if dist <= 1.0 and not NearMarker then
                 DrawMarker(2, Trees[k].x, Trees[k].y, Trees[k].z, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.4, 0, 155, 78, 146 ,2 ,0 ,0 ,0)
                 NearMarker = true
                 if GetSelectedPedWeapon(ped) == GetHashKey("weapon_hatchet") then
                    woodcuttext(Trees[k].x, Trees[k].y, Trees[k].z, tostring('Press ~o~[E]~w~ to cut this tree'))
                 else
                    woodcuttext(Trees[k].x, Trees[k].y, Trees[k].z, tostring('You need to hold a hatchet'))
                 end
                 if IsControlJustPressed(0,38) and dist <= 1.1 then
                    if GetSelectedPedWeapon(ped) == GetHashKey("weapon_hatchet") then
                       woodcut()
                       Ispedwoodcutting = true
                    end
                 end
              end
           end
       end

       for k in pairs(Process) do
           local Plycoords = vector3(plyCoords.x, plyCoords.y, plyCoords.z)
	       local Process_coords = vector3(Process[k].x, Process[k].y, Process[k].z)
           local dist = #(Plycoords - Process_coords)
           if dist <= 1.2 and not NearMarker then
              DrawMarker(1, Process[k].x, Process[k].y, Process[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.2001, 0, 172, 247, 242 ,0 ,0 ,0 ,0)
              woodcuttext(Process[k].x, Process[k].y, Process[k].z+1.0, tostring('Press ~o~[E]~w~ to process your wood logs'))
              NearMarker = true
              if IsControlJustPressed(0,38) then
                 TriggerServerEvent('Woodcutting:Wood:Process')
              end
           end
       end

       for k in pairs(Sell) do
           local Plycoords = vector3(plyCoords.x, plyCoords.y, plyCoords.z)
	       local Sell_coords = vector3(Sell[k].x, Sell[k].y, Sell[k].z)
           local dist = #(Plycoords - Sell_coords)
           if dist <= 1.7 and not NearMarker then
              DrawMarker(1, Sell[k].x, Sell[k].y, Sell[k].z, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.2001, 37, 129, 220, 210 ,0 ,0 ,0 ,0)
              woodcuttext(Sell[k].x, Sell[k].y, Sell[k].z+1.0, tostring('Press ~f~[E]~w~ to sell Processed wood'))
              NearMarker = true
              if IsControlJustPressed(0,38) then
                 TriggerServerEvent('Woodcutting:Wood:Sell')
              end
           end
       end

       if not NearMarker then
            Citizen.Wait(1000)
       end
       Citizen.Wait(0)
    end
end)

-- harvest location
Citizen.CreateThread(function()
	for k,v in pairs(Trees) do
		local harvest_blip = AddBlipForCoord(Trees[k].x, Trees[k].y, Trees[k].z)

		SetBlipSprite(harvest_blip, 153)
		SetBlipScale(harvest_blip, 0.80)
                SetBlipColour(harvest_blip, 56)
		SetBlipAsShortRange(harvest_blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Harvest Spot')
		EndTextCommandSetBlipName(harvest_blip)
	end

    -- Npc
    for k in pairs(Npc) do
       RequestModel(GetHashKey("s_m_m_gaffer_01"))
       while not HasModelLoaded(GetHashKey("s_m_m_gaffer_01")) do
         Citizen.Wait(0)
       end
       local npc =  CreatePed(4, GetHashKey("s_m_m_gaffer_01"), Npc[k].x, Npc[k].y, Npc[k].z, Npc[k].h, false, true)
       TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, 1)
       FreezeEntityPosition(npc, true)
       SetEntityHeading(npc, Npc [k].h, true)
       SetEntityInvincible(npc, true)
       SetBlockingOfNonTemporaryEvents(npc, true)
    end

    -- Processing location
    local Processing_blip = AddBlipForCoord(-512.67, 5332.44, 80.26)

	SetBlipSprite(Processing_blip, 568)
	SetBlipScale(Processing_blip, 0.80)
    SetBlipColour(Processing_blip, 10)
	SetBlipAsShortRange(Processing_blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Wood Processing')
	EndTextCommandSetBlipName(Processing_blip)

    -- Sell location
    local Sell_blip = AddBlipForCoord(2670.82, 3516.14, 52.71)

	SetBlipSprite(Sell_blip, 501)
	SetBlipScale(Sell_blip, 0.80)
    SetBlipColour(Sell_blip, 56)
    SetBlipAsShortRange(Sell_blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Wood Sell')
	EndTextCommandSetBlipName(Sell_blip)
end)


function woodcut()
    Citizen.CreateThread(function()
        local impacts = 0
        local ped = PlayerPedId()
        local plyCoords = GetEntityCoords(ped)
        local FrontTree   = GetEntityForwardVector(ped)
        local x, y, z   = table.unpack(plyCoords + FrontTree * 1.0)
        local EffectName = 'bul_wood_splinter'
        while impacts < 4 do
            Citizen.Wait(0)
            if not HasNamedPtfxAssetLoaded("core") then
	           RequestNamedPtfxAsset("core")
	           while not HasNamedPtfxAssetLoaded("core") do
		         Citizen.Wait(0)
	           end
            end
            LoadDict('melee@hatchet@streamed_core')
            TaskPlayAnim((ped), 'melee@hatchet@streamed_core', 'plyr_front_takedown', 4.0, -8, 0.01, 0, 0, 0, 0, 0)
            FreezeEntityPosition(ped, true)
            Citizen.Wait(100)
            UseParticleFxAssetNextCall("core")
            Citizen.Wait(400)
            effect = StartParticleFxLoopedAtCoord(EffectName, x, y, z, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
            Citizen.Wait(1000)
            StopParticleFxLooped(effect, 0)
            Citizen.Wait(1700)
            ClearPedTasks(ped)
            impacts = impacts+1
            print('woodcut', impacts)
            if impacts == 4 then
               impacts = 0
               Ispedwoodcutting = false
               TriggerServerEvent('Woodcutting:Wood:Cut')
               FreezeEntityPosition(ped, false)
               break
            end
        end
    end)
end

function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end

function woodcuttext(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.0, 0.30)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

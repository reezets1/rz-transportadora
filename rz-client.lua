local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vServer = Tunnel.getInterface("rz-transportadora")

Working = false
forklift = nil
pounder = nil
props_truck = {}
prop1 = nil
prop2 = nil
prop3 = nil
prop4 = nil
blips = nil

-------------------------------------------------------------------------------------------
-- [ FUNÇÃO DRAW MARKER] ------------------------------------------------------------------
-------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
    Citizen.Wait(60000)
    print('rz-transportadora')
    print('')
    print('Resource startado com sucesso!')
    local draw_marker = 1000
    while true do
        local ped = PlayerPedId()
        draw_marker = 1000
        if Working == false then
            local cdsPed = GetEntityCoords(ped)
            for k,v in pairs(config_drawMarkers) do
                if Vdist(cdsPed,vector3(v.x,v.y,v.z)) <= 5.0 then
                    draw_marker = 1
                    DrawText3D(v.x,v.y,v.z,v.text)
                    if Vdist(cdsPed,vector3(v.x,v.y,v.z)) <= 1.0 then
                        if IsControlJustPressed(0,38) then
                            Working = true
                            TriggerEvent('stopWorking',v.job)
                            TriggerEvent(v.job)
                            TriggerEvent('Notify','importante','Você entrou em serviço!')
                        end
                    end
                end
            end
        end
        Citizen.Wait(draw_marker)
    end
end)

-------------------------------------------------------------------------------------------
-- [ EVENTO SAIR DE SERVIÇO] --------------------------------------------------------------
-------------------------------------------------------------------------------------------

RegisterNetEvent('stopWorking')
AddEventHandler('stopWorking',function(job)
    while Working do
        drawTxt('PRESSIONE ~y~F7 ~w~PARA SAIR DE TRABALHO',2,0.23,0.93,0.40,255,255,255,180)
        if IsControlJustPressed(0,168) then
            Working = false
            RemoveBlip(blip)
            TriggerEvent('Notify','importante','Você saiu de serviço!')
            if job == 'truck-driver' then
                truck_driver = false
                abrindoPorts = false
                carregndoCaixas = false
                fecharPortas = false
                inRota = false
                Fade(1000)
                if DoesEntityExist(forklift) then
                    TriggerServerEvent("trydeleteveh",VehToNet(forklift))
                end
                if DoesEntityExist(pounder) then
                    TriggerServerEvent("trydeleteveh",VehToNet(pounder))
                end
                for k,v in pairs(props_truck) do    
                    if DoesEntityExist(v) then
                        DetachEntity(v,false,false)
                        TriggerServerEvent("trydeleteobj",ObjToNet(v))
                    end               
                end
                if DoesEntityExist(prop1) then
                    TriggerServerEvent("trydeleteobj",ObjToNet(prop1))
                end
                if DoesEntityExist(prop2) then
                    TriggerServerEvent("trydeleteobj",ObjToNet(prop2))
                end
                if DoesEntityExist(prop3) then
                    TriggerServerEvent("trydeleteobj",ObjToNet(prop3))
                end
                if DoesEntityExist(prop4) then
                    TriggerServerEvent("trydeleteobj",ObjToNet(prop4))
                end

                return
            end
        end
        Citizen.Wait(5)
    end
end)


-------------------------------------------------------------------------------------------
-- [ CAMINHONEIRO ] -----------------------------------------------------------------------
-------------------------------------------------------------------------------------------
abrindoPorts = false
carregndoCaixas = false
fecharPortas = false
descrregando = false
prop1status = false
prop2status = false
prop3status = false
prop4status = false
retornando = false

RegisterNetEvent('truck-driver')
AddEventHandler('truck-driver',function()
    local ped = PlayerPedId()
    if not Working then
        return
    end
    RequestModel(GetHashKey('prop_boxpile_06a'))
    if not Working then
        return
    end
    while not HasModelLoaded(GetHashKey('prop_boxpile_06a')) do
        Citizen.Wait(10)
    end
    if not Working then
        return
    end
    Fade(1000)
    local id = FindID()
    if not Working then
        return
    end
    if id == false then
        Working = false
        RemoveBlip(blips)
        DoScreenFadeOut(1000)
        truck_driver = false
        abrindoPorts = false
        carregndoCaixas = false
        fecharPortas = false
        inRota = false
        retornando = false
        Fade(1000)
        if DoesEntityExist(forklift) then
            TriggerServerEvent("trydeleteveh",VehToNet(forklift))
        end
        if DoesEntityExist(forklift2) then
            TriggerServerEvent("trydeleteveh",VehToNet(forklift2))
        end
        if DoesEntityExist(pounder) then
            TriggerServerEvent("trydeleteveh",VehToNet(pounder))
        end
        for k,v in pairs(props_truck) do    
            if DoesEntityExist(v) then
                DetachEntity(v,false,false)
                TriggerServerEvent("trydeleteobj",ObjToNet(v))
            end               
        end
        if DoesEntityExist(prop1) then
            TriggerServerEvent("trydeleteobj",ObjToNet(prop1))
        end
        if DoesEntityExist(prop2) then
            TriggerServerEvent("trydeleteobj",ObjToNet(prop2))
        end
        if DoesEntityExist(prop3) then
            TriggerServerEvent("trydeleteobj",ObjToNet(prop3))
        end
        if DoesEntityExist(prop4) then
            TriggerServerEvent("trydeleteobj",ObjToNet(prop4))
        end
        DoScreenFadeIn(1000)
        TriggerEvent('Notify','negado','Vagas ocupadas, tente novamente daqui a pouco!')
        return
    end
    if not Working then
        return
    end
    TriggerServerEvent('rz-transportadora:syncStatusServer',id,true)
    forklift = spawnVehicle('forklift',config_props_truck[id].cds.coords2.x,config_props_truck[id].cds.coords2.y,config_props_truck[id].cds.coords2.z,config_props_truck[id].cds.h2)
    pounder = spawnVehicle('pounder',config_props_truck[id].cds.coords.x,config_props_truck[id].cds.coords.y,config_props_truck[id].cds.coords.z,config_props_truck[id].cds.h)
    FreezeEntityPosition(forklift,true)
    for i=1,#config_props_truck[id].props do    
        table.insert(props_truck,CreateObject(GetHashKey('prop_boxpile_06a'), config_props_truck[id].props[i].x,config_props_truck[id].props[i].y,config_props_truck[id].props[i].z-0.965, true, true, true))
    end
    if not Working then
        return
    end
    local DoorsOpen = false
    abrindoPorts = true
    while abrindoPorts do
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local px,py,pz = table.unpack(GetOffsetFromEntityInWorldCoords(pounder, 0.0, -8.0, 0.0))
        if not IsPedInAnyVehicle(ped) then
            if Vdist(x,y,z,px,py,pz) > 2.5 then
                drawTxt('Abra as portas do ~g~caminhão',4,0.5,0.93,0.50,255,255,255,180)
            end
            if Vdist(x,y,z,px,py,pz) <= 2.5 then
                DrawText3D(px,py,pz+0.8,'Pressione ~y~[E] ~w~para abrir as portas do caminhão.')
                if IsControlJustPressed(0,38) then
                    DoorsOpen = true
                    SetVehicleDoorOpen(pounder, 3, false, false)
                    SetVehicleDoorOpen(pounder, 2, false, false)
                    abrindoPorts = false
                end
            end
        end
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    FreezeEntityPosition(forklift,false)
    local quantidade = 1
    carregndoCaixas = true
    if not Working then
        return
    end
    while carregndoCaixas do
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local px,py,pz = table.unpack( GetOffsetFromEntityInWorldCoords(pounder, 0.0, -8.0, 0.0))
        for k,v in pairs(props_truck) do
            local ox,oy,oz = table.unpack(GetEntityCoords(v))
            local CloseTruck = false
            if DoorsOpen then
                if GetVehiclePedIsIn(ped,false) == forklift then
                    drawTxt('Carregue as ~g~caixas ~w~até o caminhão',4,0.5,0.93,0.50,255,255,255,180)
                else
                    drawTxt('Entre na ~g~empilhadeira',4,0.5,0.93,0.50,255,255,255,180)
                end 
                if Vdist(ox,oy,oz,x,y,z) <= 25.0 and not CloseTruck then
                    DrawMarker(21,ox,oy,oz+1.5,0,0,0,0.0,0,0,1.0,1.0,0.75,255,0,0,50,1,0,0,1)
                end
                if Vdist(ox,oy,oz,px,py,pz) <= 2.5 then
                    CloseTruck = true
                    DrawText3D(ox,oy,oz+0.5,'Pressione ~y~[E] ~w~para colocar a caixa no caminhão.')
                    if IsControlJustPressed(0,38) then
                        if quantidade == 1 then
                            TriggerServerEvent("trydeleteobj",ObjToNet(v))
                            prop1 = CreateObject(GetHashKey('prop_boxpile_06a'),px,py+2.5,pz+0.3, true, true, true)
                            AttachEntityToEntity(prop1,pounder,0.0,0.0,-1.0,0.25,0.0,0.0,0.0,false,false,true,false,2,true)
                            FreezeEntityPosition(prop1,true)
                            quantidade = quantidade +1
                        elseif quantidade == 2 then
                            TriggerServerEvent("trydeleteobj",ObjToNet(v))
                            prop2 = CreateObject(GetHashKey('prop_boxpile_06a'),px,py+2.5,pz+0.3, true, true, true)
                            AttachEntityToEntity(prop2,pounder,0.0,0.0,-3.0,0.25,0.0,0.0,0.0,false,false,true,false,2,true)
                            FreezeEntityPosition(prop2,true)
                            quantidade = quantidade +1
                        elseif quantidade == 3 then
                            TriggerServerEvent("trydeleteobj",ObjToNet(v))
                            prop3 = CreateObject(GetHashKey('prop_boxpile_06a'),px,py+2.5,pz+0.3, true, true, true)
                            AttachEntityToEntity(prop3,pounder,0.0,0.0,-5.0,0.25,0.0,0.0,0.0,false,false,true,false,2,true)
                            FreezeEntityPosition(prop3,true)
                            quantidade = quantidade +1
                        elseif quantidade == 4 then
                            TriggerServerEvent("trydeleteobj",ObjToNet(v))
                            prop4 = CreateObject(GetHashKey('prop_boxpile_06a'),px,py+2.5,pz+0.3, true, true, true)
                            AttachEntityToEntity(prop4,pounder,0.0,0.0,-7.0,0.25,0.0,0.0,0.0,false,false,true,false,2,true)
                            FreezeEntityPosition(prop4,true)
                            carregndoCaixas = false
                        end
                    end
                end
            end
        end
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    fecharPortas = true
    if not Working then
        return
    end
    while fecharPortas do
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local px,py,pz = table.unpack( GetOffsetFromEntityInWorldCoords(pounder, 0.0, -8.0, 0.0))
        if Vdist(x,y,z,px,py,pz) > 2.5 then
            drawTxt('Feche as portas do ~g~caminhão',4,0.5,0.93,0.50,255,255,255,180)
        end
        if Vdist(x,y,z,px,py,pz) <= 2.5 then
            DrawText3D(px,py,pz+0.8,'Pressione ~y~[E] ~w~para fechar as portas do caminhão.')
            if IsControlJustPressed(0,38) then
                DoorsOpen = false
                SetVehicleDoorShut(pounder, 3, false)
                SetVehicleDoorShut(pounder, 2, false)
                fecharPortas = false
            end
        end
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    TriggerServerEvent('rz-transportadora:syncStatusServer',id,false)
    local mathvalue = math.random(1,#config_rotas_transportadora)
    CriandoBlip(config_rotas_transportadora[mathvalue].cds.x,config_rotas_transportadora[mathvalue].cds.y,config_rotas_transportadora[mathvalue].cds.z)
    inRota = true
    TaskLeaveVehicle(ped,forklift,0)
    Citizen.Wait(500)
    Fade(1000)
    if not Working then
        return
    end
    if DoesEntityExist(forklift) then
        TriggerServerEvent("trydeleteveh",VehToNet(forklift))
    end
    TriggerEvent('Notify','importante','Vá até <b>'..config_rotas_transportadora[mathvalue].nome,8000)
    if not Working then
        return
    end
    while inRota do
        if GetVehiclePedIsIn(ped,false) == pounder then
            drawTxt('Vá até o ~g~destino',4,0.5,0.93,0.50,255,255,255,180)
            if Vdist(GetEntityCoords(PlayerPedId()),config_rotas_transportadora[mathvalue].cds) <= 10.0 then
                DrawText3D(config_rotas_transportadora[mathvalue].cds.x,config_rotas_transportadora[mathvalue].cds.y,config_rotas_transportadora[mathvalue].cds.z+0.8,'Pressione ~y~[E] ~w~para começar a entrega.')
                if Vdist(GetEntityCoords(PlayerPedId()),config_rotas_transportadora[mathvalue].cds) <= 10.0 then
                    if IsControlJustPressed(0,38) then
                        inRota = false
                    end
                end
            end
        else
            drawTxt('Entre no caminhão',4,0.5,0.93,0.50,255,255,255,180)
        end 
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    Fade(1000)
    forklift2 = spawnVehicle('forklift',config_rotas_transportadora[mathvalue].forkLift.cds.x,config_rotas_transportadora[mathvalue].forkLift.cds.y,config_rotas_transportadora[mathvalue].forkLift.cds.z,config_rotas_transportadora[mathvalue].forkLift.h)
    abrindoPorts = true
    if not Working then
        return
    end
    while abrindoPorts do
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local px,py,pz = table.unpack(GetOffsetFromEntityInWorldCoords(pounder, 0.0, -8.0, 0.0))
        if not IsPedInAnyVehicle(ped) then
            if Vdist(x,y,z,px,py,pz) > 2.5 then
                drawTxt('Abra as portas do ~g~caminhão',4,0.5,0.93,0.50,255,255,255,180)
            end
            if Vdist(x,y,z,px,py,pz) <= 2.5 then
                DrawText3D(px,py,pz+0.8,'Pressione ~y~[E] ~w~para abrir as portas do caminhão.')
                if IsControlJustPressed(0,38) then
                    DoorsOpen = true
                    SetVehicleDoorOpen(pounder, 3, false, false)
                    SetVehicleDoorOpen(pounder, 2, false, false)
                    abrindoPorts = false
                end
            end
        end
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    descrregando = true
    while descrregando do
        if not Working then
            return
        end
        if GetVehiclePedIsIn(ped,false) == forklift2 then
            drawTxt('Entregue as caixas',4,0.5,0.93,0.50,255,255,255,180)
            local cdsP = GetOffsetFromEntityInWorldCoords(pounder,-2.65,-8.5,0.0)
            if Vdist(GetEntityCoords(PlayerPedId()),cdsP) <= 5.0 then
                DrawText3D(cdsP.x,cdsP.y,cdsP.z+0.8,'Pressione ~y~[E] ~w~para descarregar a caixa.')
                if IsControlJustPressed(0,38) then
                    if quantidade == 4 then
                        quantidade = quantidade-1
                        DetachEntity(prop4,false,false)
                        SetEntityCoords(prop4,cdsP.x,cdsP.y,cdsP.z-1.0)
                        FreezeEntityPosition(prop4,false)
                    elseif quantidade == 3 then
                        quantidade = quantidade-1
                        DetachEntity(prop3,false,false)
                        SetEntityCoords(prop3,cdsP.x,cdsP.y,cdsP.z-1.0)
                        FreezeEntityPosition(prop3,false)
                    elseif quantidade == 2 then
                        quantidade = quantidade-1
                        DetachEntity(prop2,false,false)
                        SetEntityCoords(prop2,cdsP.x,cdsP.y,cdsP.z-1.0)
                        FreezeEntityPosition(prop2,false)
                    elseif quantidade == 1 then
                        DetachEntity(prop1,false,false)
                        SetEntityCoords(prop1,cdsP.x,cdsP.y,cdsP.z-1.0)
                        FreezeEntityPosition(prop1,false)
                    end
                end
            end
            for i=1,#config_rotas_transportadora[mathvalue].props do
                if Vdist(config_rotas_transportadora[mathvalue].props[i][1],GetEntityCoords(ped)) <= 20.0 then
                    if config_rotas_transportadora[mathvalue].props[i].status == false then
                        DrawMarker(21,config_rotas_transportadora[mathvalue].props[i][1].x,config_rotas_transportadora[mathvalue].props[i][1].y,config_rotas_transportadora[mathvalue].props[i][1].z,0,0,0,0.0,0,0,1.0,1.0,0.75,255,0,0,50,1,0,0,1)
                    end
                end
                if Vdist(config_rotas_transportadora[mathvalue].props[i][1],GetEntityCoords(prop1)) <= 2.0 then
                    config_rotas_transportadora[mathvalue].props[i].status = true
                end
                if Vdist(config_rotas_transportadora[mathvalue].props[i][1],GetEntityCoords(prop2)) <= 2.0 then
                    config_rotas_transportadora[mathvalue].props[i].status = true
                end
                if Vdist(config_rotas_transportadora[mathvalue].props[i][1],GetEntityCoords(prop3)) <= 2.0 then
                    config_rotas_transportadora[mathvalue].props[i].status = true
                end
                if Vdist(config_rotas_transportadora[mathvalue].props[i][1],GetEntityCoords(prop4)) <= 2.0 then
                    config_rotas_transportadora[mathvalue].props[i].status = true
                end
            end
        else
            drawTxt('Entre na empilhadeira',4,0.5,0.93,0.50,255,255,255,180)
        end
        if config_rotas_transportadora[mathvalue].props[1].status == true and config_rotas_transportadora[mathvalue].props[2].status == true and config_rotas_transportadora[mathvalue].props[3].status == true and  config_rotas_transportadora[mathvalue].props[4].status == true then
            descrregando = false
        end
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    RemoveBlip(blips)
    fecharPortas = true
    if not Working then
        return
    end
    while fecharPortas do
        if not Working then
            return
        end
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
        local px,py,pz = table.unpack( GetOffsetFromEntityInWorldCoords(pounder, 0.0, -8.0, 0.0))
        if Vdist(x,y,z,px,py,pz) > 2.5 then
            drawTxt('Feche as portas do ~g~caminhão',4,0.5,0.93,0.50,255,255,255,180)
        end
        if Vdist(x,y,z,px,py,pz) <= 2.5 then
            DrawText3D(px,py,pz+0.8,'Pressione ~y~[E] ~w~para fechar as portas do caminhão.')
            if IsControlJustPressed(0,38) then
                DoorsOpen = false
                SetVehicleDoorShut(pounder, 3, false)
                SetVehicleDoorShut(pounder, 2, false)
                fecharPortas = false
            end
        end
        Citizen.Wait(1)
    end
    if not Working then
        return
    end
    TaskLeaveVehicle(ped,forklift2,0)
    Citizen.Wait(1000)
    Fade(1000)
    if DoesEntityExist(forklift2) then
        TriggerServerEvent("trydeleteveh",VehToNet(forklift2))
    end
    if DoesEntityExist(prop1) then
        TriggerServerEvent("trydeleteobj",ObjToNet(prop1))
    end
    if DoesEntityExist(prop2) then
        TriggerServerEvent("trydeleteobj",ObjToNet(prop2))
    end
    if DoesEntityExist(prop3) then
        TriggerServerEvent("trydeleteobj",ObjToNet(prop3))
    end
    if DoesEntityExist(prop4) then
        TriggerServerEvent("trydeleteobj",ObjToNet(prop4))
    end
    retornando = true
    CriandoBlip2(retorno_loc.x,retorno_loc.y,retorno_loc.z)
    if not Working then
        return
    end
    while retornando do
        if not Working then
            return
        end
        if GetVehiclePedIsIn(ped,false) == pounder then
            drawTxt('Retorne a central',4,0.5,0.93,0.50,255,255,255,180)
        else
            drawTxt('Entre no caminhão',4,0.5,0.93,0.50,255,255,255,180)
        end
        if Vdist(GetEntityCoords(ped),retorno_loc) <= 50.0 then

            DrawMarker(27,retorno_loc.x,retorno_loc.y,retorno_loc.z-0.9,0,0,0,0.0,0,0,10.0,10.0,0.3,255,0,0,50,0,0,0,1)
            if Vdist(GetEntityCoords(ped),retorno_loc) <= 2.5 then
                DrawText3D(retorno_loc.x,retorno_loc.y,retorno_loc.z+0.9,'Pressione ~r~[E] ~w~para finalizar o serviço.')
                if IsControlJustPressed(0,38) then
                    Working = false
                    RemoveBlip(blips)
                    DoScreenFadeOut(1000)
                    truck_driver = false
                    abrindoPorts = false
                    carregndoCaixas = false
                    fecharPortas = false
                    inRota = false
                    retornando = false
                    Fade(1000)
                    if DoesEntityExist(forklift) then
                        TriggerServerEvent("trydeleteveh",VehToNet(forklift))
                    end
                    if DoesEntityExist(forklift2) then
                        TriggerServerEvent("trydeleteveh",VehToNet(forklift2))
                    end
                    if DoesEntityExist(pounder) then
                        TriggerServerEvent("trydeleteveh",VehToNet(pounder))
                    end
                    for k,v in pairs(props_truck) do    
                        if DoesEntityExist(v) then
                            DetachEntity(v,false,false)
                            TriggerServerEvent("trydeleteobj",ObjToNet(v))
                        end               
                    end
                    if DoesEntityExist(prop1) then
                        TriggerServerEvent("trydeleteobj",ObjToNet(prop1))
                    end
                    if DoesEntityExist(prop2) then
                        TriggerServerEvent("trydeleteobj",ObjToNet(prop2))
                    end
                    if DoesEntityExist(prop3) then
                        TriggerServerEvent("trydeleteobj",ObjToNet(prop3))
                    end
                    if DoesEntityExist(prop4) then
                        TriggerServerEvent("trydeleteobj",ObjToNet(prop4))
                    end
                    DoScreenFadeIn(1000)
                    TriggerEvent('Notify','importante','Você finalizou o serviço!')
                    local pgto = math.random(config_rotas_transportadora[mathvalue].pagamento.valorMinimo,config_rotas_transportadora[mathvalue].pagamento.valorMaximo)
                    vServer.checkPayment(pgto)
                    TriggerEvent('Notify','importante','Você recebeu <b>$'..pgto)
                end
            end
        end
        Citizen.Wait(1)
    end
end)    
-------------------------------------------------------------------------------------------
-- [ FUNÇÕES GERAIS ] ---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function createBlip(x,y,z,sprite,color,scale,text)
	blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(blip,sprite)
	SetBlipColour(blip,color)
	SetBlipScale(blip,scale)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

function setBlipCoords(x,y,z)
    SetBlipCoords(blip,x,y,z)
	SetBlipRoute(blip,false)
	SetBlipRoute(blip,true)
end

function setBlipText(text)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0,100)
end


function spawnVehicle(mhash,x,y,z,h)
    RequestModel(mHash)
	while not HasModelLoaded(mHash) do
		RequestModel(mHash)
		Citizen.Wait(10)
	end
    local ped = PlayerPedId()
    local nveh = CreateVehicle(mHash,x,y,z,h,true,false)
    SetVehicleDirtLevel(nveh,0.0)
    SetVehRadioStation(nveh,"OFF")
    SetVehicleNumberPlateText(nveh,plate)
    SetEntityAsMissionEntity(nveh,true,true)
    SetModelAsNoLongerNeeded(mHash)
    vServer.createVeh(plate)
    return nveh
end

function Fade(time)
    FreezeEntityPosition(PlayerPedId(),true)
	DoScreenFadeOut(800)
	Wait(time)
	DoScreenFadeIn(800)
    FreezeEntityPosition(PlayerPedId(),false)
end

function CriandoBlip(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,10)
	SetBlipColour(blips,24)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Carga")
	EndTextCommandSetBlipName(blips)
end

function CriandoBlip2(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,10)
	SetBlipColour(blips,24)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Destino")
	EndTextCommandSetBlipName(blips)
end


RegisterNetEvent('rz-transportadora:syncStatusClient')
AddEventHandler('rz-transportadora:syncStatusClient',function(id,status)
    config_props_truck[id].status = status
end)

function FindID()
    for i=1,#config_props_truck do
        if config_props_truck[i].status == false then
            return i
        end
    end
    return false
end

RegisterNetEvent('trydeleteobj',function(obj)
    DeleteEntity(NetToObj(obj))
end)

RegisterNetEvent('trydeleteveh',function(veh)
    DeleteEntity(NetToVeh(veh))
end)


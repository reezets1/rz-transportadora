local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
local blips = {}

vServer = {}
Tunnel.bindInterface("rz-transportadora",vServer)

function vServer.checkPayment(value)
    local user_id = vRP.getUserId(source)
    if usaItemDinheiro == false then
        vRP.giveMoney(user_id,value)
    elseif usaItemDinheiro == true then
        vRP.giveInventoryItem(user_id,itemDinheiro,value)
    end
    TriggerClientEvent('Notify',source,'importante','Você recebeu <b>R$'..value..'</b> pelo seu serviço!')
end

function vServer.createVeh(plate)
    local source = source
	local user_id = vRP.getUserId(source)
	TriggerEvent("setPlateEveryone",plate)
	TriggerEvent("setPlatePlayers",plate,user_id)	
end

RegisterServerEvent('rz-transportadora:syncStatusServer')
AddEventHandler('rz-transportadora:syncStatusServer',function(id,status)
    TriggerClientEvent('rz-transportadora:syncStatusClient',-1,id,status)
end)

RegisterServerEvent('trydeleteobj',function(obj)
    TriggerClientEvent('trydeleteobj',-1,obj)
end)

RegisterServerEvent('trydeleteveh',function(veh)
    TriggerClientEvent('trydeleteveh',-1,veh)
end)
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(Config.Trigger, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    print("-------------------------------------")
    print("^5[Started] ^7- MenuAdmin - ^1Lawk#0008")
    print("^5Discord : ^7discord.gg^1/lpdev")
    print("-------------------------------------")
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    blockinput = true
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(10)
    end 
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        blockinput = false
        return result
    else
        Wait(500)
        blockinput = false
        return nil
    end
end

local open = false

local mainmenu = RageUI.CreateMenu("Bienvenue", "Bienvenue à vous !")

mainmenu.Closed = function()
    open = false
end

mainmenu:SetRectangleBanner(0, 0, 255, 70)

local acquis = false

CreateThread(function()
    while true do
        ESX.TriggerServerCallback('lawk:checkkit', function(cb)
            acquis = cb
        end)
        Wait(500)
    end
end)

function OpenKitBienvenue()
    if open then
        open = false
        RageUI.Visible(mainmenu, false)
        return
    else
        open = true
        RageUI.Visible(mainmenu, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainmenu, function()
                    RageUI.Separator("Votre ID : ~r~" .. GetPlayerServerId(PlayerId()).. "~s~")
                    RageUI.Line()
                    if acquis == true then
                        RageUI.Separator("Vous avez déjà pris votre kit de bienvenue !")
                    else
                        RageUI.Button("Kit de Bienvenue", "Prenez votre kit de bienvenue !", {LeftBadge = RageUI.BadgeStyle.Star, RightLabel = "→→→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("lawk:kitbienvenue")
                            end
                        })
                    end
                end)
                Wait(0)
            end
        end)
    end
end

if Config.MenuPed == true then      
    Citizen.CreateThread(function()
        local hash = GetHashKey(Config.Ped.Model)
        while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
        end
        ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Ped.Model, Config.Ped.Position, Config.Ped.Heading, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
    end)
end

if Config.MenuPed == true then    
    Citizen.CreateThread(function()
        while true do
            local coords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(coords, Config.Ped.Position.x, Config.Ped.Position.y, Config.Ped.Position.z, true)
            if distance < 2 and open == false then
                ESX.ShowHelpNotification('Appuyez sur ~INPUT_CONTEXT~ pour parler à ~b~Dale~s~')
                if IsControlJustPressed(0, 38) then
                    OpenKitBienvenue()
                end
            end
            Wait(0)
        end
    end)
else
    RegisterCommand("kitbienvenue", function()
        OpenKitBienvenue()
    end)
end
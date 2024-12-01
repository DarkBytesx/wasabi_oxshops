CAT = {}

CAT.DrawText3D = function(x, y, z, text)
	local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

CAT.DrawMarker = function(pos, r, g, b, opacity)
	DrawMarker(2, pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, r, g, b, opacity, false, false, false, true, false, false, false)
end

RegisterNetEvent('wasabi_oxshops:setProductPrice', function(shop, slot)
    local input = lib.inputDialog(Strings.sell_price, {Strings.amount_input})
    local price = not input and 0 or tonumber(input[1]) --[[@as number]]
    price = price < 0 and 0 or price

    TriggerEvent('ox_inventory:closeInventory')
    TriggerServerEvent('wasabi_oxshops:setData', shop, slot, math.floor(price))
    lib.notify({
        title = Strings.success,
        description = (Strings.item_stocked_desc):format(price),
        type = 'success'
    })
end)

local function createBlip(coords, sprite, color, text, scale)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

CreateThread(function()
    for _, v in pairs(Config.Shops) do
        if v.blip.enabled then
            createBlip(v.blip.coords, v.blip.sprite, v.blip.color, v.blip.string, v.blip.scale)
        end
    end
end)

CreateThread(function()
    local points = {}
    while not PlayerLoaded do Wait(500) end
    
    for k, v in pairs(Config.Shops) do
        if not points[k] then points[k] = {} end
        points[k].stash = lib.points.new({
            coords = v.locations.stash.coords,
            distance = v.locations.stash.range,
            shop = k
        })
        points[k].shop = lib.points.new({
            coords = v.locations.shop.coords,
            distance = v.locations.shop.range,
            shop = k
        })
        if v.bossMenu.enabled then
            points[k].bossMenu = lib.points.new({
                coords = v.bossMenu.coords,
                distance = v.bossMenu.range,
                shop = k
            })
        end
    end

    for _, v in pairs(points) do
        function v.stash:nearby()
            if not self.isClosest or PlayerData.job.name ~= self.shop then return end
            if Config.DrawMarkers then
                CAT.DrawMarker(self.coords, 255, 0, 0, 255)
                CAT.DrawText3D(self.coords.x, self.coords.y, self.coords.z, Config.Shops[self.shop].locations.stash.string)  -- Adjust Z position
            end
            if self.currentDistance < self.distance then
                if IsControlJustReleased(0, 38) then
                    exports.ox_inventory:openInventory('stash', self.shop)
                end
            end
        end

        function v.shop:nearby()
            if not self.isClosest then return end
        
            local shopConfig = Config.Shops[self.shop]
            local shopLocation = shopConfig.locations.shop
            if Config.DrawMarkers then
                CAT.DrawMarker(shopLocation.coords, 255, 0, 0, 255)
                CAT.DrawText3D(shopLocation.coords.x, shopLocation.coords.y, shopLocation.coords.z, shopLocation.string)
            end
            if self.currentDistance < shopLocation.range then
                if IsControlJustReleased(0, 38) then
                    if shopLocation.license then
                        ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
                            if hasWeaponLicense then
                                exports.ox_inventory:openInventory('shop', { type = self.shop, id = 1 })
                            else
                                lib.notify({
                                    title = 'License Required',
                                    description = 'You need a ' ..shopLocation.licensetype.. ' license to access this shop.',
                                    type = 'error',
                                    position = 'top',
                                })
                            end
                        end, GetPlayerServerId(PlayerId()), shopLocation.licensetype)
                    else
                        exports.ox_inventory:openInventory('shop', { type = self.shop, id = 1 })
                    end
                end
            end
        end

        if v.bossMenu then
            function v.bossMenu:nearby()
                if not self.isClosest then return end
                if IsBoss() then
                    if self.currentDistance < self.distance then
                        if Config.DrawMarkers then
                            CAT.DrawMarker(self.coords, 255, 0, 0, 255)
                            CAT.DrawText3D(self.coords.x, self.coords.y, self.coords.z, Config.Shops[self.shop].bossMenu.string)  -- Adjust Z position
                        end
                        if IsControlJustReleased(0, 38) then
                            OpenBossMenu(PlayerData.job.name)
                        end
                    end
                end
            end
        end
    end
end)
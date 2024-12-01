Config = {}

Config.discordWebhookURL = ''-- Purchase Logs
Config.discordWebhookURL1 = '' -- Add to Shops Logs
Config.discordWebhookURL2 = '' -- Refresh Shops
Config.checkForUpdates = true -- Check for updates?
Config.DrawMarkers = true -- draw markers when nearby?

Config.Shops = {
    ['uwu'] = { -- Job name
        label = 'UwU Cafe Offline Store',
        blip = {
            enabled = false,
            coords = vec3(-583.37, -1060.80, 22.34),
            sprite = 279,
            color = 8,
            scale = 0.7,
            string = 'UwU Cafe'
        },
        bossMenu = {
            enabled = false, -- Enable boss menu?
            coords = vec3(-597.07, -1053.40, 22.34), -- Location of boss menu
            string = '[E] - Access Boss Menu', -- Text UI label string
            range = 3.0, -- Distance to allow access/prompt with text UI
        },
        locations = {
            stash = {
                string = '~y~[E] ~w~- Access Offline Inventory',
                coords = vec3(-593.8631, -1068.1515, 22.3442),
                range = 3.0
            },
            shop = {
                string = '~y~[E] ~w~- UwU Cafe Offline Shop',
                coords = vec3(-578.7049, -1070.6077, 22.3296),
                range = 2.0
                license = true, -- If The Shop Needed A License Set to False if Not
                licensetype = 'weapon' -- Type of License * Weapon for Weapon License * Drive for Drivers License
            }
        }
    },
}
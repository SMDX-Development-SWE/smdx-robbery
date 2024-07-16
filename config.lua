Config = {}

Config.StartCommand = "startrobbery" -- Command used to open the robbery menu if ped is disabled

Config.UsePolice = true -- true = police will get alerted, false = no alerts to cops. (You need ps-dispatch for this to work)
Config.PoliceChance = 50 -- The chance that the police get's alarmed (You need ps-dispatch for this to work) | for example, 30 is 30% chance of police getting alerted, 50 is 50% chance and so on. Max is 100 which is 100% chance.

-------------------
-- REWARD AMOUNT --
-------------------
Config.RewardAmount = 1000 -- The reward amount
Config.RewardType = "cash" -- Choose between cash/bank

Config.UseItemRewards = true -- Set this to true if you want to receive items as reward aswell
Config.RewardItems = {
    "meth",
    "weapon_crowbar"
    -- Add more items if you want :)
}

------------------
-- PED SETTINGS --
------------------
Config.PedSettings = {
    enabled = true, -- If false, a command will be used to start the robbery mission
    model = 'a_m_m_eastsa_01',
    coords = vector3(1774.51, -1617.64, 111.59),
    heading = 289.01,
}

-------------------
-- BLIP SETTINGS --
-------------------
Config.BlipSettings = {
    enabled = true,
    coords = vector3(1776.19, -1617.19, 112.37),
    label = "Robbery Mission",
    sprite = 84,
    color = 1,
    display = 4,
    scale = 0.8,
    shortRange = true,
}

Config.ProgTime = { -- The time in miliseconds every progress takes
    trevor_breakin = 10000,
    michael_breakin = 10000,
    steal_time = 10000,
}

-----------------
-- TRANSLATION --
-----------------
Config.Translate = {
    target = {
        talk_to_ped = "Talk to Robbery NPC",
        break_open_door = "Break open the door",
        steal_item = "Steal Item"
    },
    start_menu = {
        title = "ROBBERY",
        btn_title = "START ROBBERY",
        btn_desc = "Start a robbery mission",
        exit_btn = "EXIT",
        exit_desc = "Exit the menu",
    },
    trevor_breakin = {
        title = "ROBBERY",
        desc = "You broke the door open, now go inside and look for items to steal",
    },
    michael_breakin = {
        title = "ROBBERY",
        desc = "You broke the door open, now go inside and look for items to steal",
    },
    missionstarted = {
        title = "STEP 1",
        desc = "Go to the marked location on your map.",
        title2 = "STEP 2",
        desc2 = "Break open the door!",
    },
    itemsteal = {
        title = "ITEM STOLEN",
        desc = "You stole one item!",
    },
    nextstep = {
        title = "GREAT",
        desc = "You have stolen all the items, now move to the next place located on your GPS!",
        title2 = "BREAK IN",
        desc2 = "Break open the door and keep stealing stuff!",
    },
    finish = {
        title = "RETURN",
        desc = "You got everything, now return to the robbery guy to get paid!",
    },
    reward = {
        title = "REWARD",
        desc = "Good job, come back to me whenever you want more work!",
    },
    progress = {
        breaking_trevor = "Breaking up the door...",
        breaking_michael = "Breaking up the door...",
        stealing_items = "Stealing Items...",
    },
}
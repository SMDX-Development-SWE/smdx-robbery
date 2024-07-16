Config = {}

----------------------------------
-- ITEM USED TO BREAK OPEN DOORS--
----------------------------------
Config.LockPickItem = "lockpick"

-------------------
-- REWARD AMOUNT --
-------------------
Config.RewardAmount = 1000
Config.RewardType = "cash" -- Choose between cash/bank

Config.UseItemRewards = true -- Set this to true if you want to receive items as reward aswell
Config.RewardItems = {
    "meth",
    "weapon_crowbar"
}

------------------
-- PED SETTINGS --
------------------
Config.PedSettings = {
    enabled = true,
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

-----------------
-- TRANSLATION --
-----------------
Config.Translate = {
    target = {
        talk_to_ped = "Talk to Robbery NPC",
        break_open_door = "Break open the door",
    },
    start_menu = {
        title = "ROBBERY",
        btn_title = "START ROBBERY",
        btn_desc = "Start a robbery mission",
        exit_btn = "EXIT",
        exit_desc = "Exit the menu",
    },
}
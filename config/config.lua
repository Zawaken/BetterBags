local addonName = ... ---@type string

---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon(addonName)

---@class Localization: AceModule
local L = addon:GetModule('Localization')

---@class Database: AceModule
local DB = addon:GetModule('Database')

---@class Constants: AceModule
local const = addon:GetModule('Constants')

---@class HelpText
---@field title string
---@field text string
---@field group string

---@class Config: AceModule
---@field helpText HelpText[]
local config = addon:NewModule('Config')

---@class Events: AceModule
local events = addon:GetModule('Events')


local GUI = LibStub('AceGUI-3.0')

---@param info table
---@return any, string, string
function config:ResolvePath(info)
  ---@type string|tablelib
  local path = info[#info]

  local db = DB:GetData().profile
  if type(path) == "string" then
		return db, path, path
	elseif type(path) == "table" then
		local n = #path
		for i = 1, n-1 do
      ---@type table
			db = db[path[i]]
		end
		return db, path[n], strjoin('.', unpack(path))
	else
    error("Invalid config option table -- this is a bug, please report it to github.com/Cidan/BetterBags", 2)
  end
end

---@param kind BagKind
---@return Bag
function config:GetBag(kind)
  return kind == const.BAG_KIND.BACKPACK and addon.Bags.Backpack or addon.Bags.Bank
end

---@return AceConfig.OptionsTable
function config:GetGeneralOptions()
  ---@type AceConfig.OptionsTable
  local options = {
    type = "group",
    name = L:G("General"),
    order = 0,
    args = {
      showBagButton = {
        type = "toggle",
        name = L:G("Show Blizzard Bag Button"),
        desc = L:G("Show or hide the default Blizzard bag button."),
        get = DB.GetShowBagButton,
        set = function(_, value)
          local sneakyFrame = _G["BetterBagsSneakyFrame"] ---@type Frame	
          if value then
            BagsBar:SetParent(UIParent)
          else
            BagsBar:SetParent(sneakyFrame)
          end
          DB:SetShowBagButton(value)
        end,
      },
    }
  }
  return options
end

function config:GetOptions()
  ---@type AceConfig.OptionsTable
  local options = {
    type = "group",
    name = L:G("BetterBags"),
    args = {
      general = self:GetGeneralOptions(),
      customCategories = self:GetCustomCategoryConfig(),
      backpack = self:GetBagOptions(const.BAG_KIND.BACKPACK),
      bank = self:GetBagOptions(const.BAG_KIND.BANK),
      help = self:GenerateHelp(),
    }
  }
  return options
end

function config:OnEnable()
  self.helpText = {}
  self:CreateAllHelp()
  GUI:RegisterWidgetType("ItemList", config.CreateItemListWidget, 1)
  LibStub('AceConfig-3.0'):RegisterOptionsTable(addonName, function() return self:GetOptions() end)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(addonName, "BetterBags")
  LibStub("AceConfigDialog-3.0"):SetDefaultSize(addonName, 700, 800)
  LibStub('AceConsole-3.0'):RegisterChatCommand("bb", function()
    LibStub("AceConfigDialog-3.0"):Open(addonName)
  end)

  events:RegisterMessage('categories/Changed', function()
    LibStub('AceConfigRegistry-3.0'):NotifyChange(addonName)
  end)
end

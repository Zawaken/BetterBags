local addonName = ... ---@type string

---@class BetterBags: AceAddon
local addon = LibStub('AceAddon-3.0'):GetAddon(addonName)

---@class Config: AceModule
local config = addon:GetModule('Config')

---@class Localization: AceModule
local L = addon:GetModule('Localization')

---@return AceConfig.OptionsTable
function config:GenerateHelp()
  ---@type AceConfig.OptionsTable
  local options = {
    type = "group",
    name = L:G("Help"),
    args = {
      mainHelp = {
        type = "group",
        name = L:G("Help"),
        inline = true,
        order = 1,
        args = {
          text = {
            type = "description",
            name = L:G("Welcome to Better Bags! Please select a help item from the left menu for FAQ's and other information."),
            order = 1,
          }
        }
      }
    }
  }
  for _, helpItem in pairs(self.helpText) do
    if not options.args[helpItem.group] then
      options.args[helpItem.group] = {
        type = "group",
        name = helpItem.group,
        order = 1,
        args = {}
      }
    end
    options.args[helpItem.group].args[helpItem.title] = {
      type = "group",
      name = helpItem.title,
      order = 1,
      inline = true,
      args = {
        text = {
          type = "description",
          name = helpItem.text,
          order = 1,
        }
      }
    }
  end
  return options
end

---@param helpItem HelpText
function config:AddHelp(helpItem)
  table.insert(self.helpText, helpItem)
end

function config:CreateAllHelp()
  self:AddHelp({
    group = L:G("Custom Categories"),
    title = L:G("Why are some of my items not showing up in my custom categories?"),
    text = L:G("Items can only be in one category at a time. If you have a category that is missing items, it is likely that the items in that category are already in another category.")
  })
  self:AddHelp({
    group = L:G("Custom Categories"),
    title = L:G("Why does a custom category reappear after I delete it?"),
    text = L:G("If you delete a custom category that was created by another addon/plugin, it will reappear the next time you log in/reload. To permanently delete a custom category created by a plugin/another addon, you must disable the addon creating the category and then delete the category in the UI.")
  })
  self:AddHelp({
    group = L:G("Custom Categories"),
    title = L:G("How do I delete an item from a custom category?"),
    text = L:G("When viewing a custom category configuration, you can right click on an item to open it's menu and select 'delete' to delete it from the category.")
  })
end

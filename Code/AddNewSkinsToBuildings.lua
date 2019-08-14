local orig_print = print
if Mods.mrudat_TestingMods then
  print = orig_print
else
  print = empty_func
end

local CurrentModId = rawget(_G, 'CurrentModId') or rawget(_G, 'CurrentModId_X')
local CurrentModDef = rawget(_G, 'CurrentModDef') or rawget(_G, 'CurrentModDef_X')
if not CurrentModId then

  -- copied shamelessly from Expanded Cheat Menu
  local Mods, rawset = Mods, rawset
  for id, mod in pairs(Mods) do
    rawset(mod.env, "CurrentModId_X", id)
    rawset(mod.env, "CurrentModDef_X", mod)
  end

  CurrentModId = CurrentModId_X
  CurrentModDef = CurrentModDef_X
end

orig_print("loading", CurrentModId, "-", CurrentModDef.title)

--[[
Foreach descendent of SkinChangeable, allow a function to register a new Entity, palette combination.

GetSkins returns a parallel list of {entity1, e2, e3, ...}, {palette1, p2, p3, ...}

Only override GetSkins()

Maybe also override ChangeSkin(), but only when the vanilla one doesn't work.
]]

--local orig_SkinChangeable_GetSkins = SkinChangeable.GetSkins

--function SkinChangeable:RegisterNewSkin(entity, pallette)end

-- GetBuildingSkins ?

function OnMsg.ClassesPreprocess()
  ForEachDescendantClass("SkinChangeable", function(classname, class)
    -- if we patch Building.GetSkins, OpenAirBuilding should work as expected
    if classname == "OpenAirBuilding" then return end

    local orig_GetSkins = class.GetSkins
    -- this class doesn't override GetSkins, so provided we override the base class, everything should be fine.
    if orig_GetSkins == nil then return end
    -- class.GetSkins =
    local GetSkins = function(self, ignore_destroyed_state)
      local entities, pallets = orig_GetSkins(self, ignore_destroyed_state)
      return entities, pallets
    end
  end)
end

orig_print("loaded", CurrentModId, "-", CurrentModDef.title)

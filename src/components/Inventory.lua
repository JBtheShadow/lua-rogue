require "utils.optionUtils"
local Message = require "messages.Message"

local Inventory = { capacity, items, owner }

function Inventory:new(capacity)
    local obj = setmetatable({}, {__index = self})
    obj.capacity = capacity
    obj.items = {}
    obj.owner = nil
    return obj
end

function Inventory:addItem(item)
    local results = {}

    if item.item.canStack then
        local candidate = nil
        for _, x in ipairs(self.items) do
            if x.name == item.name and x.item.canStack then
                candidate = x
                break
            end
        end
        if not candidate and #self.items >= self.capacity then
            table.insert(results, { itemAdded, message = Message:new("You cannot carry any more, your inventory is full", "yellow") })
        else
            table.insert(results, { itemAdded = item, message = Message:new(string.format("You pick up %d %s(s)!", item.item.amount, item.name), "blue") })

            if not candidate then
                table.insert(self.items, item)
            else
                candidate.item.amount = candidate.item.amount + item.item.amount
            end
        end
    else
        if #self.items >= self.capacity then
            table.insert(results, { itemAdded, message = Message:new("You cannot carry any more, your inventory is full", "yellow") })
        else
            table.insert(results, { itemAdded = item, message = Message:new(string.format("You pick up the %s!", item.name), "blue") })

            table.insert(self.items, item)
        end
    end

    return results
end

function Inventory:use(itemEntity, args)
    local results = {}

    local itemComponent = itemEntity.item

    if not itemComponent.onUse then
        local equippableComponent = itemEntity.equippable

        if equippableComponent then
            table.insert(results, { equip = itemEntity })
        else
            table.insert(results, { message = Message:new(string.format("The %s cannot be used", itemEntity.name), "yellow") })
        end
    elseif itemComponent.targeting and not (args or args.target or args.target.x or args.target.y) then
        table.insert(results, { targeting = itemEntity })
    else
        local onUseArgs = {}
        for k, v in pairs(itemComponent.args) do onUseArgs[k] = v end
        for k, v in pairs(args) do onUseArgs[k] = v end
        local itemResults = itemComponent.onUse(self.owner, onUseArgs)

        for _, itemResult in ipairs(itemResults) do
            if itemResult.consumed then
                self:removeItem(itemEntity)
            end
            table.insert(results, itemResult)
        end
    end

    return results
end

function Inventory:removeItem(item)
    local index
    for i, v in ipairs(self.items) do
        if v.name == item.name then
            index = i
            break
        end
    end
    table.remove(self.items, index)
end

function Inventory:dropItem(item)
    local results = {}

    if self.owner.equipment.mainHand == item or self.owner.equipment.offHand == item then
        self.owner.equipment:toggle_equip(item)
    end

    item.x = self.owner.x
    item.y = self.owner.y

    self:removeItem(item)
    table.insert(results, { itemDropped = item, message = Message:new(string.format("You dropped the %s", item.name), "yellow") })
    
    return results
end

function Inventory:getOptions()
    if not #self.items then
        return { "Inventory is empty. "}
    end

    local options = {}
    local equipOptions = {}
    local resultOptions = {}

    for _, item in ipairs(self.items) do
        if self.owner and self.owner.equipment then
            if self.owner.equipment.mainHand == item then
                table.insert(equipOptions, string.format("%s (on main hand)", item.name))
            elseif self.owner.equipment.offHand == item then
                table.insert(equipOptions, string.format("%s (on off hand)", item.name))
            else
                table.insert(equipOptions, string.format("%s (equipped elsewhere?)", item.name))
            end
        elseif item.item.canStack then
            table.insert(options, string.format("%d %s(s)", item.item.amount, item.name))
        else
            table.insert(options, item.name)
        end
    end

    for _, option in ipairs(equipOptions) do table.insert(resultOptions, option) end
    for _, option in ipairs(groupOptions(options)) do table.insert(resultOptions, option) end
    
    return resultOptions
end

function Inventory:getIndexFromOptions(index)
    return groupIndexes(self:getOptions())[index]
end

return Inventory
function Player.onEquipItem(self, item, slot)
	-- Default event for equipping any item
	return false
end

function Player.onDeEquipItem(self, item, slot)
	-- Default event for de-equipping any item
	return false
end

Enchantments = {}

function Enchantments.runEquipHandler(player, item, src, dest)
	-- Source is from inventory, destination is elsewhere (moving anywhere is de-equip)
	if src.x == CONTAINER_POSITION and src.y < 10 then
		if not player:onDeEquipItem(item, src.y) then
			return false
		end
	end

	-- Destination is in inventory
	if dest.x == CONTAINER_POSITION and dest.y < 10 then
		if not player:onEquipItem(item, dest.y) then
			return false
		end
	end

	return true
end
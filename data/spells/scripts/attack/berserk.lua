local function searchCornerItems(center, id)
	for k, offset in pairs(Position.directionOffset) do
		if Tile(center + offset):getItemById(id) then
			return true
		end
	end
	return false
end

function onCastSpell(creature, variant)
	if searchCornerItems(creature:getPosition(), 2725) then
		creature:say('ok', TALKTYPE_MONSTER_SAY)
	else
		creature:say('no ok', TALKTYPE_MONSTER_SAY)
	end
end

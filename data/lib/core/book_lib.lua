tpBook = {
	config = dofile('config/tp-book.lua'),
	exhausts = {}
}

OFFSETS = {
	{x = 0, y = -1},
	{x = 1, y = 0},
	{x = 0, y = 1},
	{x = -1, y = 0}
}

function Player.sendMagicEffects(self, distanceEffect, offsetTable)
	local cid = self:getId()
	local function effect(i, j)
		local player = Player(cid)
		if not player then
			return
		end
		local pos = player:getPosition()
		pos.x = pos.x + offsetTable[i].x
		pos.y = pos.y + offsetTable[i].y
		local nextPos = player:getPosition()
		nextPos.x = nextPos.x + (offsetTable[i+1] or offsetTable[1]).x
		nextPos.y = nextPos.y + (offsetTable[i+1] or offsetTable[1]).y
		pos:sendDistanceEffect(nextPos, distanceEffect)
		if i < j then
			effect(i+1, j)
		end
	end
	effect(1, #offsetTable)
end

function Position.serialize(self)
	return ('(X: %d, Y: %d, Z: %d)'):format(self.x, self.y, self.z)
end

function unserializePos(pos)
	local x, y, z = pos:match('X: (%d+), Y: (%d+), Z: (%d+)')
	return Position(x, y, z)
end

function Position.sendAnimatedText(self, text)
	for _, player in pairs(Game.getSpectators(self, false, true, 7, 7, 5, 5)) do
		player:say(text, TALKTYPE_MONSTER_SAY, false, player, self)
	end
end


countdownEvents = {}

function tpBook.countdown(cid, i)
	local player = Player(cid)
	if i == 0 or not player then
		return
	end
	player:getPosition():sendAnimatedText(i)
	countdownEvents[cid] = addEvent(tpBook.countdown, 1000, cid, i - 1)
end

function tpBook.tryTeleport(cid, checkpoint, i, j)
	i = i or 0
	j = j or tpBook.config.teleportTime / tpBook.config.effectInterval

	local player = Player(cid)
	if not player then
		return
	end

	if player:getCondition(CONDITION_INFIGHT) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your teleport has been canceled because you are in a fight.')
		stopEvent(countdownEvents[cid])
		countdownEvents[cid] = nil
		return
	end

	-- time is up, teleport player now
	if i >= j then
		player:teleportTo(checkpoint.position)
		checkpoint.position:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have been teleported to '.. checkpoint.checkpointName)
		stopEvent(countdownEvents[cid])
		countdownEvents[cid] = nil
		local exhaust = (player:getPremiumDays() > 0) and tpBook.config.premiumExhaust or tpBook.config.exhaust
		tpBook.exhausts[cid] = os.mtime() + exhaust
		return
	end

	-- start the countdown
	if not countdownEvents[cid] then
		tpBook.countdown(cid, tpBook.config.teleportTime / 1000)
	end

	player:sendMagicEffects(CONST_ANI_HOLY, OFFSETS)
	addEvent(tpBook.tryTeleport, tpBook.config.effectInterval, cid, checkpoint, i + 1, j)
end

function tpBook.addCheckpoint(player, aid)
	local checkpoint = tpBook.config.checkpoints[aid]
	local book = player:getItemById(1955, true)

	if not book or not checkpoint then
		return false
	end

	local text = book:getAttribute(ITEM_ATTRIBUTE_TEXT)
	for savedCheckpoint in text:gmatch('%[([^%]]*)%]') do
		if savedCheckpoint == checkpoint.name then
			return false
		end
	end

	if text ~= '' then
		book:setAttribute(ITEM_ATTRIBUTE_TEXT, string.format('%s\n{%s} [%s]: %s', text, checkpoint.requirePremium and 'Yes' or 'No', checkpoint.name, checkpoint.destination:serialize()))
	else
		book:setAttribute(ITEM_ATTRIBUTE_TEXT, string.format('{%s} [%s]: %s', checkpoint.requirePremium and 'Yes' or 'No', checkpoint.name, checkpoint.destination:serialize()))
	end

	return checkpoint
end
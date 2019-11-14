function onStepIn(creature, item, position, fromPosition)
	local player = Player(creature)
	if not player then
		return true
	end
	local checkpoint = tpBook.addCheckpoint(player, item:getActionId())
	if checkpoint then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format(tpBook.config.message, checkpoint.name))
		position:sendMagicEffect(tpBook.config.messageMagicEffect)
	end
	return true
end
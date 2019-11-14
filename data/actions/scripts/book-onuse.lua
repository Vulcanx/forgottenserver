function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local modalWindow = ModalWindow {title = "Teleport Book", message = "Select your destination to teleport to."}
	local checkpoints = {}
	for premium, checkpointName, position in item:getAttribute(ITEM_ATTRIBUTE_TEXT):gmatch('{(%a+)} %[([^]]+)%]: ([^\n]+)') do
		modalWindow:addChoice(string.format('[Premium: %s] %s', premium, checkpointName))
		checkpoints[#checkpoints+1] = {premium = premium, checkpointName = checkpointName, position = unserializePos(position)}
	end

	if not next(checkpoints) then
		player:sendCancelMessage('You do not have any locations saved in your book.')
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
	end

	modalWindow:addButton('Select', function(button, choice)
		local cid = player:getId()
		if countdownEvents[cid] then
			player:sendCancelMessage('You are already teleporting.')
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return
		end

		local exh = tpBook.exhausts[cid]
		local exhausted = exh and (os.mtime() - exh) < 0 or false
		if exhausted then
			player:sendCancelMessage(string.format('You are exhausted for %.2f seconds', (exh - os.mtime()) / 1000))
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return
		end 

		if player:getCondition(CONDITION_INFIGHT) then
			player:sendCancelMessage('You may not teleport while in combat.')
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return
		end
		local checkpoint = checkpoints[choice.id]
		if checkpoint then
			tpBook.tryTeleport(player:getId(), checkpoint)
		end
	end)
	modalWindow:setDefaultEnterButton('Select')

	modalWindow:addButton('Quit', function(button, choice) end)
	modalWindow:setDefaultEscapeButton('Quit')

	modalWindow:sendToPlayer(player)
	return true
end
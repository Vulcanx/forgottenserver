function onSay(player, words, param)
	local playerInfo = {
		player:getName(),
		player:getLevel(),
    	player:getMaxHealth(),
    	player:getMaxMana(),
    	player:getMagicLevel()
	}
	for skill = SKILL_FIST, SKILL_FISHING do
		playerInfo[#playerInfo+1] = player:getSkillLevel(skill)
	end
    local info = string.format("%s's Information:\n\nLevel: %d\n\nHealth: %d\n\nMana: %d\n\nMagic Level: %d\n\nSkills:\nFist: %d\n\nClub: %d\n\nSword: %d\n\nAxe: %d\n\nDistance: %d\n\nShielding: %d\n\nFishing: %d\n\n", unpack(playerInfo))
    player:popupFYI(info)
    return true
end
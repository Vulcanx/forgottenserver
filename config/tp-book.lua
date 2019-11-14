return {
	checkpoints = {
		[4001] = { -- new checkpoint on action id 4001
			name = 'Something Spawn', -- name of the checkpoint
			destination = Position(101, 116, 7), -- position to teleport to
			requirePremium = false,
		},
		[4002] = { -- new checkpoint on action id 4001
			name = 'Something Spawn 2', -- name of the checkpoint
			destination = Position(101, 115, 7), -- position to teleport to
			requirePremium = false,
		}
	},

	message = 'You have achieved the %s checkpoint, use the book again at any time to teleport to here.', -- must be pre formatted for string.format
	messageMagicEffect = CONST_ME_MAGIC_GREEN,

	effectInterval = 200, -- teleport effect interval (milliseconds)
	teleportTime = 5000, -- time it takes to teleport (milliseconds)
	exhaust = 60000, -- exhaust time (milliseconds)
	premiumExhaust = 30000, -- exhaust time for premium accounts
}
/datum/crafting_recipe/pipebomb
	name = "Pipe Bomb"
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 50
	reqs = list(/obj/item/stack/sheet/iron = 10,
	/obj/item/stack/sheet/cloth = 1,
	/obj/item/gas_can = 1,
	/obj/item/soil_sack/rich = 2,
	/obj/item/stack/cable_coil = 15,
	/obj/item/shard = 2)
	result = /obj/item/grenade/pipebomb
	category = CAT_WEAPON_RANGED
	skill_dots_minimum = 3

/obj/item/grenade/pipebomb
	name = "Pipe Bomb"
	desc = "The great equalizer between us and them"
	w_class = WEIGHT_CLASS_NORMAL
	icon = 'modular_vcg/modules/weapons/icons/bombs.dmi'
	icon_state = "pipebomb_fuse"
	lefthand_file = 'modular_vcg/modules/weapons/icons/bombs_lefthand.dmi'
	righthand_file = 'modular_vcg/modules/weapons/icons/bombs_righthand.dmi'
	worn_icon = 'modular_vcg/modules/weapons/icons/worn_bomb.dmi'
	ONFLOOR_ICON_HELPER('modular_vcg/modules/weapons/icons/bomb_onfloor.dmi')
	shrapnel_type = /obj/projectile/bullet/shrapnel
	shrapnel_radius = 1
	throw_speed = 3
	throw_range = 6
	det_time = 30
	//ex_heavy = 0
	//ex_light = 3
	//ex_flame = 6

/obj/item/grenade/pipebomb/attack_self(mob/user) // you need to light it
	return

/obj/item/grenade/pipebomb/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(active)
		return NONE
	var/ignition_msg = tool.ignition_effect(src, user)
	if(!ignition_msg)
		return NONE
	visible_message(ignition_msg)
	arm_grenade(user)
	return ITEM_INTERACT_SUCCESS

/obj/item/grenade/firecracker/fire_act(exposed_temperature, exposed_volume)
	detonate()//combo bomb shenangins and accidental detonations

/obj/item/grenade/pipebomb/arm_grenade(mob/user, delayoverride, msg = TRUE, volume = 80)
	log_grenade(user)
	if(user)
		add_fingerprint(user)
		if(msg)
			to_chat(user, span_warning("You prime [src]! [capitalize(DisplayTimeText(det_time))]!"))
	playsound(src, 'sound/effects/fuse.ogg', volume, TRUE)
	active = TRUE
	icon_state = initial(icon_state) + "_live"
	addtimer(CALLBACK(src, PROC_REF(detonate)), isnull(delayoverride)? det_time : delayoverride)

/obj/item/grenade/pipebomb/detonate(mob/living/lanced_by)
	. = ..()
	if(!.)
		return

	update_mob()
	explosion(src, devastation_range = 0, heavy_impact_range = -1, light_impact_range = 4)
	qdel(src)

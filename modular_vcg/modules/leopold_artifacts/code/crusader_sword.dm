/obj/item/occult_artifact/holy/crusader_sword
	name = "Old Sword"
	desc = "An old rusty sword it seems to gleem in the light"
	true_name = "Crusader Sword"
	true_desc = "A Mastercrafted Sword emblazed with a cross holy energy seems to radiate off it use in hand to use the light of god gives the strength and willpower to fell your enemies"

	icon = 'modular_vcg/modules/leopold_artifacts/icons/relics.dmi'
	icon_state = "crusader_sword"
	inhand_icon_state = "crusader_sword"
	lefthand_file = 'modular_vcg/modules/leopold_artifacts/icons/relic_inhand_left.dmi'
	righthand_file = 'modular_vcg/modules/leopold_artifacts/icons/relic_inhand_right.dmi'
	worn_icon = 'modular_vcg/modules/leopold_artifacts/icons/relics_worn.dmi'
	worn_icon_state = "crusader_sword"
	ONFLOOR_ICON_HELPER('modular_vcg/modules/leopold_artifacts/icons/relic_floor.dmi')
	var/mob/living/empowered_wielder
	var/holy_abilities_active = FALSE
	var/mob/living/empowered_wielder = null
	COOLDOWN_DECLARE(holy_flash_timer)
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BELT
	sharpness = SHARP_EDGED
	hitsound = 'sound/items/weapons/slash.ogg'
	attack_verb_continuous = list("slashes", "cuts")
	attack_verb_simple = list("slash", "cut")
	research_value = 0

	// Inactive defaults, including before identification.
	force = 1 LETHAL_TTRPG_DAMAGE
	damtype = BRUTE

	// Separate from identification: disabling powers never unidentifies it.
	var/holy_abilities_active = FALSE

/obj/item/occult_artifact/holy/crusader_sword/proc/remove_wielder_bonuses()
	if(!QDELETED(empowered_wielder))
		empowered_wielder.st_remove_stat_mod(STAT_STRENGTH, src)
		empowered_wielder.st_remove_stat_mod(STAT_PERMANENT_WILLPOWER, src)

	empowered_wielder = null

/obj/item/occult_artifact/holy/crusader_sword/proc/set_holy_abilities(active)
	holy_abilities_active = active

	if(holy_abilities_active)
		force = 2.5 LETHAL_TTRPG_DAMAGE
		damtype = AGGRAVATED
	else
		force = initial(force)
		damtype = initial(damtype)

/obj/item/occult_artifact/holy/crusader_sword/equipped(mob/user, slot, initial = FALSE)
	. = ..()

	// Check if the wielder is holy
	set_holy_abilities(
		(slot & ITEM_SLOT_HANDS) && identified && user?.mind?.holy_role
	)

/obj/item/occult_artifact/holy/crusader_sword/dropped(mob/user, silent = FALSE)
	set_holy_abilities(FALSE)
	. = ..()

/obj/item/occult_artifact/holy/crusader_sword/identify(mob/living/artifact_identifier)
	. = ..()

	//makes sure abilties activate when identified so you dont have to drop the sword to get the benifits
	if(!identified || !ismob(loc))
		return

	var/mob/holder = loc
	if(holder.get_held_index_of_item(src))
		set_holy_abilities(holder.mind?.holy_role)


/obj/item/occult_artifact/holy/crusaders_sword/proc/remove_wielder_bonuses()
	if(!QDELETED(empowered_wielder))
		empowered_wielder.st_remove_stat_mod(STAT_STRENGTH, src)
		empowered_wielder.st_remove_stat_mod(STAT_PERMANENT_WILLPOWER, src)

	empowered_wielder = null



/obj/item/occult_artifact/holy/crusader_sword/proc/update_wielder_bonuses(mob/user)
	remove_wielder_bonuses()

	if(!identified || !isliving(user) || !user?.mind?.holy_role)
		return

	if(!user.get_held_index_of_item(src))
		return

	empowered_wielder = user
	empowered_wielder.st_add_stat_mod(STAT_STRENGTH, 1, src)// Reduced from tabletop being +5 Potence 5 is not free im not that crazy
	empowered_wielder.st_add_stat_mod(STAT_PERMANENT_WILLPOWER, 3, src)//Replicate Iron will/True Faith 3 Turns out using dominate on the crusader is a bad idea 

/obj/item/occult_artifact/holy/crusader_sword/equipped(mob/user, slot, initial = FALSE)
	. = ..()

	if(slot & ITEM_SLOT_HANDS)
		update_wielder_bonuses(user)
	else
		remove_wielder_bonuses()

/obj/item/occult_artifact/holy/crusader_sword/dropped(mob/user, silent = FALSE)
	remove_wielder_bonuses()
	. = ..()

/obj/item/occult_artifact/holy/crusader_sword/Destroy()
	remove_wielder_bonuses()
	return ..()

/obj/item/occult_artifact/holy/crusader_sword/identify(mob/living/artifact_identifier)
	. = ..()

	//Allows you to identify even when holding sword
	if(identified && ismob(loc))
		update_wielder_bonuses(loc)

/obj/item/occult_artifact/holy/crusader_sword/attack_self(mob/user, modifiers)
	//if not identified dont flashbang
	if(!identified)
		return ..()

	if(!isliving(user) || !user?.mind?.holy_role)
		return

	if(empowered_wielder != user || !user.get_held_index_of_item(src))
		return

	if(!COOLDOWN_FINISHED(src, holy_flash_timer))
		return

	COOLDOWN_START(src, holy_flash_timer, 60 SECONDS)//doubled timer as sword is STRONG already

	do_sparks(rand(5, 9), FALSE, user)
	playsound(
		user.loc,
		'modular_darkpack/modules/jobs/sounds/cross.ogg',
		100, FALSE, 8, 0.9
	)

	for(var/mob/living/victim in get_hearers_in_view(4, src))
		holy_bang(victim, empowered_wielder)

/obj/item/occult_artifact/holy/crusader_sword/proc/holy_bang(mob/living/victim, mob/living/user)
	if(victim.stat == DEAD || victim == user || victim.mind?.holy_role)
		return

	victim.show_message(
		span_warning(span_bold("GODS WRATH IS COMING!")),
		MSG_AUDIBLE
	)//God sees you didnt seem threatening enough

	if(HAS_TRAIT(victim, TRAIT_REPELLED_BY_HOLINESS))
		victim.emote("scream")
		victim.pointed(user)

	var/distance = max(1, get_dist(src, victim))
	victim.flash_act(affect_silicon = TRUE)
	victim.Paralyze(max(10 / distance, 5))
	victim.Knockdown(max(100 / distance, 40))

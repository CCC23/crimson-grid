/datum/discipline/path_of_earth
	name = "Path of Earth"
	desc = {"Gives Power over the earth allowing one to use it to immobilize their enemies
	● Grasp of Earth: Charisma + Empathy
	●● The Haunting: Manipulation + Subterfuge
	●●● Eyes of Chaos: Perception + Occult
	●●●● Voice of Madness: Manipulation + Empathy
	●●●●● Total Insanity: Manipulation + Intimidation"}
	icon_state = "path_of_earth"
	clan_restricted = TRUE
	power_type = /datum/discipline_power/path_of_earth
	signature_clan = VAMPIRE_CLAN_OLD_CLAN_TZIMISCE

/datum/discipline_power/path_of_earth
	name = "path of earth power name"
	desc = "path of earth power description"

	activate_sound = 'modular_darkpack/modules/powers/sounds/serpentis.ogg'//placeholder sound ignore


/datum/discipline_power/path_of_earth/grasp_of_earth
	name = "Grasp Of Earth"
	desc = "Utilize the earth to grasp at a foe immobilizing them for a short period of time"

	level = 1
	check_flags = DISC_CHECK_CAPABLE | DISC_CHECK_SEE
	target_type = TARGET_LIVING
	range = 7
	vitae_cost = 1

	aggravating = FALSE
	hostile = TRUE
	violates_masquerade = TRUE

	multi_activate = TRUE
	duration_length = 1.5 SECONDS
	cooldown_length = 40 SECONDS

/datum/discipline_power/path_of_earth/grasp_of_earth/proc/immobilize_target(mob/living/target, duration = 1.5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

/datum/discipline_power/path_of_earth/grasp_of_earth/proc/release_target(mob/living/target)
	to_chat(target, span_danger("You feel the earth fall away you are able to move again"))
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

/datum/discipline_power/path_of_earth/grasp_of_earth/activate(mob/living/target)
	. = ..()
	target.visible_message(span_hypnophrase("<b>The earth grasps [target] immobilizing them</b>"), span_warning("<b>The earth grasps you immobilzing you</b>"))
	immobilize_target(target)
//		var/mob/living/carbon/human/H = target
//		H.remove_overlay(POWERS_LAYER)
//		var/mutable_appearance/serpentis_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/serpentis.dmi', "serpentis", -POWERS_LAYER)
//		H.overlays_standing[POWERS_LAYER] = serpentis_overlay           //overlay stuff please ignore remove once finished
//		H.apply_overlay(POWERS_LAYER)
	immobilize_target(target)

/datum/discipline_power/path_of_earth/grasp_of_earth/deactivate(mob/living/target)
	. = ..()
	release_target(target)


/datum/discipline_power/path_of_earth/endurance_of_stone
	name = "Endurance of Stone"
	desc = "Become as hard as stone. Let nothing bring you down"

	level = 2
	var/activating = FALSE
	var/active_armor = FALSE
	check_flags = DISC_CHECK_CONSCIOUS
	vitae_cost = 2
	toggled = TRUE
	duration_length = 20 TURNS

/datum/discipline_power/path_of_earth/endurance_of_stone/pre_activation_checks()
	. = ..()
	if(activating) // Prevent multi-activation while the do_after is ongoing
		to_chat(owner, span_warning("You are already hardening your skin"))
		return FALSE

	activating = TRUE
	to_chat(owner, span_warning("Your body starts to harden"))
	if(do_after(owner, 1 TURNS, timed_action_flags = (IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM)))
		return TRUE

/datum/discipline_power/path_of_earth/endurance_of_stone/activate()
	. = ..()
	activating = FALSE
	var/roll = SSroll.storyteller_roll_datum(owner, difficulty = 7, applic_stats = list(STAT_PERMANENT_WILLPOWER))
	switch(roll)
		if(ROLL_SUCCESS)
			active_armor = TRUE
			owner.damage_resistance += 20
			to_chat(owner, span_green("You successfuly harness the earth armoring yourself"))
		if(ROLL_FAILURE)
			to_chat(owner, span_warning("You fail to harness the earth"))
			deactivate()
		if(ROLL_BOTCH)
			owner.apply_damage(20, BRUTE)
			to_chat(owner, span_danger("The earth refuses your will injuring you"))
			deactivate()

/datum/discipline_power/path_of_earth/endurance_of_stone/deactivate()
	. = ..()
	if(!active_armor)
		return
	to_chat(owner, span_notice("The earth falls away from your body"))
	owner.damage_resistance -= 20 // CRIMSON EDIT - Reduces Strength of Obetenebration 4

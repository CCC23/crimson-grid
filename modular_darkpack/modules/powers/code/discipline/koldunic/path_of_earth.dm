/datum/discipline/path_of_earth
	name = "Path of Earth"
	desc = {"Makes all humans in radius mentally ill for a moment, supressing their defending ability.
	● Passion: Charisma + Empathy
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
	vitae_cost = 0

	aggravating = TRUE
	hostile = TRUE
	violates_masquerade = TRUE
	frenzy_usable = FALSE

	multi_activate = TRUE
	duration_length = 5 SECONDS
	cooldown_length = 5 SECONDS

/datum/discipline_power/path_of_earth/grasp_of_earth/proc/immobilize_target(mob/living/target, duration = 5 SECONDS)
	ADD_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))
	RegisterSignals(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT), PROC_REF(on_target_attacked))
	if(do_after(owner, duration, target))
		release_target(target)
		return TRUE
	else
		release_target(target)
		return FALSE

///datum/discipline_power/serpentis/the_eyes_of_the_serpent/proc/on_target_attacked(datum/source)
//	SIGNAL_HANDLER
//	var/mob/living/target = source
//	release_target(target)
//	to_chat(owner, span_warning("Your concentration is broken as [target] is attacked!"))
//	to_chat(target, span_warning("The mental hold on you breaks as you're attacked!"))

//datum/discipline_power/serpentis/the_eyes_of_the_serpent/proc/release_target(mob/living/target)
//	UnregisterSignal(target, list(COMSIG_ATOM_ATTACKBY, COMSIG_MOB_ITEM_ATTACK, COMSIG_PROJECTILE_PREHIT))
//	to_chat(target, span_danger("You feel your concentration become your own once more, able to look away from the commanding gaze."))
	REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, DISCIPLINE_TRAIT(type))

/datum/discipline_power/path_of_earth/grasp_of_earth/can_activate_untargeted(alert)
	. = ..()
	if (owner?.is_eyes_covered())
		if (alert)
			to_chat(owner, span_warning("You cannot use [name] with your eyes covered!"))
		. = FALSE
	return .

/datum/discipline_power/path_of_earth/grasp_of_earth/activate(mob/living/target)
	. = ..()
	target.face_atom(owner)
	target.visible_message(span_hypnophrase("<b>The earth grasps [target] immobilizing them</b>"), span_warning("<b>The earth grasps you immobilzing you</b>"))
	if(ishuman(target))
//		var/mob/living/carbon/human/H = target
//		H.remove_overlay(POWERS_LAYER)
//		var/mutable_appearance/serpentis_overlay = mutable_appearance('modular_darkpack/modules/powers/icons/serpentis.dmi', "serpentis", -POWERS_LAYER)
//		H.overlays_standing[POWERS_LAYER] = serpentis_overlay           //overlay stuff please ignore remove once finished
//		H.apply_overlay(POWERS_LAYER)
	immobilize_target(target)

/datum/discipline_power/path_of_earth/grasp_of_earth/deactivate(mob/living/target)
	. = ..()
	release_target(target)
	if (ishuman(target))
		var/mob/living/carbon/human/human_target = target
	//	human_target.remove_overlay(POWERS_LAYER)

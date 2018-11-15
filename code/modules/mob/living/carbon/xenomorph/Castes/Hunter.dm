//Hunter Code - Colonial Marines - Last Edit: Apophis775 - 11JUN16

/mob/living/carbon/Xenomorph/Hunter
	caste = "Hunter"
	name = "Hunter"
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/Xeno/1x1_Xenos.dmi'
	icon_state = "Hunter Running"
	melee_damage_lower = 20
	melee_damage_upper = 30
	tackle_damage = 35
	health = 150
	maxHealth = 150
	plasma_stored = 50
	plasma_gain = 10
	plasma_max = 100
	evolution_threshold = 200
	upgrade_threshold = 200
	caste_desc = "A fast, powerful front line combatant."
	speed = -1.5 //Not as fast as runners, but faster than other xenos
	pixel_x = 0
	old_x = 0
	evolves_to = list("Ravager")
	charge_type = 2 //Pounce - Hunter
	armor_deflection = 10
	attack_delay = -1
	pounce_delay = 150
	tier = 2
	upgrade = 0
	var/stealth_delay = null
	var/last_stealth = null
	var/used_stealth = FALSE
	var/stealth = FALSE
	var/can_sneak_attack = FALSE
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/pounce,
		/datum/action/xeno_action/activable/stealth,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)

/mob/living/carbon/Xenomorph/Hunter/proc/handle_stealth()
	if(!stealth_router(HANDLE_STEALTH_CHECK))
		return
	if(stat != CONSCIOUS || stealth == FALSE || lying || resting) //Can't stealth while unconscious/resting
		cancel_stealth()
		return
	//Initial stealth
	if(last_stealth > world.time - HUNTER_STEALTH_INITIAL_DELAY) //We don't start out at max invisibility
		alpha = HUNTER_STEALTH_RUN_ALPHA //50% invisible
		return
	//Stationary stealth
	else if(last_move_intent < world.time - HUNTER_STEALTH_STEALTH_DELAY) //If we're standing still for 4 seconds we become almost completely invisible
		alpha = HUNTER_STEALTH_STILL_ALPHA //95% invisible
	//Walking stealth
	else if(m_intent == MOVE_INTENT_WALK)
		alpha = HUNTER_STEALTH_WALK_ALPHA //80% invisible
	//Running stealth
	else
		alpha = HUNTER_STEALTH_RUN_ALPHA //50% invisible
	//If we have 0 plasma after expending stealth's upkeep plasma, end stealth.
	if(!plasma_stored)
		to_chat(src, "<span class='xenodanger'>You lack sufficient plasma to remain camouflaged.</span>")
		cancel_stealth()

/mob/living/carbon/Xenomorph/Hunter/handle_status_effects()
	. = ..()
	handle_stealth()

/mob/living/carbon/Xenomorph/Hunter/handle_living_plasma_updates()
	var/turf/T = loc
	if(!T || !istype(T))
		return
	if(current_aura)
		plasma_stored -= 5
	if(plasma_stored == plasma_max)
		return
	var/modifier = 1
	if(stealth && last_move_intent > world.time - 20) //Stealth halves the rate of plasma recovery on weeds, and eliminates it entirely while moving
		modifier = 0.0
	else
		modifier = 0.5
	if(locate(/obj/effect/alien/weeds) in T)
		plasma_stored += plasma_gain * modifier
		if(recovery_aura)
			plasma_stored += round(plasma_gain * recovery_aura * 0.25 * modifier) //Divided by four because it gets massive fast. 1 is equivalent to weed regen! Only the strongest pheromones should bypass weeds
	else
		plasma_stored++
	if(plasma_stored > plasma_max)
		plasma_stored = plasma_max
	else if(plasma_stored < 0)
		plasma_stored = 0
		if(current_aura)
			current_aura = null
			to_chat(src, "<span class='warning'>You have ran out of plasma and stopped emitting pheromones.</span>")

	hud_set_plasma() //update plasma amount on the plasma mob_hud
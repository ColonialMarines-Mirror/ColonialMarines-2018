//Xenomorph - Drone - Colonial Marines - Apophis775 - Last Edit: 11JUN16

/mob/living/carbon/Xenomorph/Drone
	caste = "Drone"
	name = "Drone"
	desc = "An Alien Drone"
	icon = 'icons/Xeno/1x1_Xenos.dmi'
	icon_state = "Drone Walking"
	melee_damage_lower = 12
	melee_damage_upper = 16
	tackle_damage = 25
	health = 120
	maxHealth = 120
	plasma_stored = 350
	plasma_max = 750
	evolution_threshold = 100
	upgrade_threshold = 100
	plasma_gain = 25
	tier = 1
	upgrade = 0
	speed = -0.8
	pixel_x = 0
	old_x = 0
	aura_strength = 0.5 //Drone's aura is the weakest. At the top of their evolution, it's equivalent to a Young Queen Climbs by 0.5 to 2
	evolves_to = list("Queen", "Carrier", "Hivelord") //Add more here seperated by commas
	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	pull_speed = -2
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/activable/corrosive_acid/drone,
		/datum/action/xeno_action/emit_pheromones,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)

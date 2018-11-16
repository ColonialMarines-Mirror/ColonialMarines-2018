
/mob/living/carbon/Xenomorph/proc/upgrade_xeno(newlevel)
	upgrade = newlevel
	upgrade_stored = 0
	visible_message("<span class='xenonotice'>\The [src] begins to twist and contort.</span>", \
	"<span class='xenonotice'>You begin to twist and contort.</span>")
	do_jitter_animation(1000)

/*
*1 is indicative of the base speed/armor
ARMOR
UPGRADE		*1	2	3	4
--------------------------
Runner		0	5	10	10
Hunter		15	20	25	25
Ravager		40	45	50	50
Defender	50	55	60	70
Warrior		30	35	40	45
Crusher		60	65	70	75
Sentinel	15	15	20	20
Spitter		15	20	25	30
Boiler		20	30	35	35
Praetorian	35	40	45	50
Drone		0	5	10	15
Hivelord	0	10	15	20
Carrier		0	10	10	15
Queen		45	50	55	55

SPEED
UPGRADE		 4		 3		 2		 *1
----------------------------------------
Runner		-2.1	-2.0	-1.9	-1.8
Hunter		-1.8	-1.7	-1.6	-1.5
Ravager		-1.0	-0.9	-0.8	-0.7
Defender	-0.5	-0.4	-0.3	-0.2
Warrior		-0.5	-0.6	-0.7	-0.8
Crusher		 0.1	 0.1	 0.1	 0.1	*-2.0 when charging
Sentinel	-1.1	-1.0	-0.9	-0.8
Spitter		-0.8	-0.7	-0.6	-0.5
Boiler		 0.4	 0.5	 0.6	 0.7
Praetorian	-0.8	-0.7	-0.6	-0.5
Drone		-1.1	-1.0	-0.9	-0.8
Hivelord	 0.1	 0.2	 0.3	 0.4
Carrier		-0.3	-0.2	-0.1	 0.0
Queen		 0.0	 0.1	 0.2	 0.3
*/

	switch(upgrade)
		//FIRST UPGRADE
		if(1)
			upgrade_name = "Mature"
			to_chat(src, "<span class='xenodanger'>You feel a bit stronger.</span>")
			switch(caste)
				if("Runner")
					melee_damage_lower = 20
					melee_damage_upper = 30
					health = 120
					maxHealth = 120
					plasma_gain = 2
					plasma_max = 150
					upgrade_threshold = 200
					caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks a little more dangerous."
					speed = -1.9
					armor_deflection = 10
					attack_delay = -4
					tackle_damage = 30 // Prior was 25
					pounce_delay = 35
				if("Ravager")
					melee_damage_lower = 50
					melee_damage_upper = 70
					health = 250
					maxHealth = 250
					plasma_gain = 13
					plasma_max = 175
					upgrade_threshold = 800
					caste_desc = "A brutal, devastating front-line attacker. It looks a little more dangerous."
					speed = -0.55
					armor_deflection = 25
					tackle_damage = 60 // Prior was 55
				if ("Warrior")
					melee_damage_lower = 35
					melee_damage_upper = 45
					health = 250
					maxHealth = 250
					plasma_gain = 8
					plasma_max = 100
					upgrade_threshold = 400
					caste_desc = "An alien with an armored carapace. It looks a little more dangerous."
					speed = -0.4
					armor_deflection = 50
					tackle_damage = 45 // Prior was 40
				if("Sentinel")
					melee_damage_lower = 20
					melee_damage_upper = 30
					health = 180
					maxHealth = 180
					plasma_gain = 12
					plasma_max = 400
					upgrade_threshold = 200
					spit_delay = 20
					caste_desc = "A ranged combat alien. It looks a little more dangerous."
					armor_deflection = 15
					tackle_damage = 30 // Prior was 25
					speed = -0.9
				if("Spitter")
					melee_damage_lower = 25
					melee_damage_upper = 35
					health = 220
					maxHealth = 220
					plasma_gain = 25
					plasma_max = 700
					upgrade_threshold = 400
					spit_delay = 20
					caste_desc = "A ranged damage dealer. It looks a little more dangerous."
					tackle_damage = 35 // Prior was 30
					armor_deflection = 25
					speed = -0.6
				if("Queen")
					melee_damage_lower = 50
					melee_damage_upper = 60
					health = 325
					maxHealth = 325
					plasma_max = 800
					plasma_gain = 40
					upgrade_threshold = 1600
					spit_delay = 20
					caste_desc = "The biggest and baddest xeno. The Queen controls the hive and plants eggs."
					armor_deflection = 50
					tackle_damage = 60 // Prior was 55
					speed = 0.5
					aura_strength = 3
					queen_leader_limit = 2

		//SECOND UPGRADE
		if(2)
			upgrade_name = "Elder"
			to_chat(src, "<span class='xenodanger'>You feel a whole lot stronger.</span>")
			switch(caste)
				if("Runner")
					melee_damage_lower = 20
					melee_damage_upper = 35
					health = 130
					maxHealth = 150
					plasma_gain = 2
					plasma_max = 200
					upgrade_threshold = 400
					caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks pretty strong."
					speed = -2.0
					armor_deflection = 10
					attack_delay = -4
					tackle_damage = 35 // Prior was 30
					pounce_delay = 30
				if("Ravager")
					melee_damage_lower = 55
					melee_damage_upper = 75
					health = 260
					maxHealth = 260
					plasma_gain = 14
					plasma_max = 190
					upgrade_threshold = 1600
					caste_desc = "A brutal, devastating front-line attacker. It looks pretty strong."
					speed = -0.58
					armor_deflection = 28
					tackle_damage = 65 // Prior was 60
				if ("Warrior")
					melee_damage_lower = 40
					melee_damage_upper = 45
					tackle_damage = 50 // Prior was 45
					health = 260
					maxHealth = 260
					plasma_gain = 8
					plasma_max = 100
					upgrade_threshold = 800
					caste_desc = "An alien with an armored carapace. It looks pretty strong."
					speed = -0.4
					armor_deflection = 50
				if("Sentinel")
					melee_damage_lower = 25
					melee_damage_upper = 30
					health = 190
					maxHealth = 190
					plasma_gain = 15
					plasma_max = 500
					upgrade_threshold = 400
					spit_delay = 15
					caste_desc = "A ranged combat alien. It looks pretty strong."
					armor_deflection = 20
					tackle_damage = 35 // Prior was 30
					speed = -1.0
				if("Spitter")
					melee_damage_lower = 30
					melee_damage_upper = 35
					health = 240
					maxHealth = 240
					plasma_gain = 30
					plasma_max = 800
					upgrade_threshold = 800
					spit_delay = 15
					caste_desc = "A ranged damage dealer. It looks pretty strong."
					armor_deflection = 30
					tackle_damage = 40 // Prior was 35
					speed = -0.7
				if("Queen")
					melee_damage_lower = 55
					melee_damage_upper = 65
					health = 350
					maxHealth = 350
					plasma_max = 900
					plasma_gain = 50
					upgrade_threshold = 3200
					spit_delay = 20
					caste_desc = "The biggest and baddest xeno. The Empress controls multiple hives and planets."
					armor_deflection = 55
					tackle_damage = 65 // Prior was 60
					speed = 0.4
					aura_strength = 4
					queen_leader_limit = 3

		//Final UPGRADE
		if(3)
			upgrade_name = "Ancient"
			switch(caste)
				if("Runner")
					to_chat(src, "<span class='xenoannounce'>You are the fastest assassin of all time. Your speed is unmatched.</span>")
					melee_damage_lower = 25
					melee_damage_upper = 35
					health = 160
					maxHealth = 160
					plasma_gain = 2
					plasma_max = 200
					caste_desc = "Not what you want to run into in a dark alley. It looks fucking deadly."
					speed = -2.1
					armor_deflection = 10
					attack_delay = -4
					tacklemin = 3
					tacklemax = 5
					tackle_damage = 40 // Prior was 30
					pounce_delay = 30
				if("Ravager")
					to_chat(src, "<span class='xenoannounce'>You are death incarnate. All will tremble before you.</span>")
					melee_damage_lower = 60
					melee_damage_upper = 80
					adjustBruteLoss(255)
					health = 265
					maxHealth = 265
					plasma_gain = 15
					plasma_max = 200
					caste_desc = "As I walk through the valley of the shadow of death."
					speed = -0.6
					armor_deflection = 30
					tackle_damage = 70 // Prior was 65
				if ("Warrior")
					to_chat(src, "<span class='xenoannounce'>None can stand before you. You will annihilate all weaklings who try.</span>")
					melee_damage_lower = 45
					melee_damage_upper = 50
					tackle_damage = 55 // Prior was 50
					health = 265
					maxHealth = 265
					plasma_gain = 8
					plasma_max = 100
					caste_desc = "An hulking beast capable of effortlessly breaking and tearing through its enemies."
					speed = -0.5
					armor_deflection = 55
				if("Sentinel")
					to_chat(src, "<span class='xenoannounce'>You are the stun master. Your stunning is legendary and causes massive quantities of salt.</span>")
					melee_damage_lower = 25
					melee_damage_upper = 35
					health = 195
					maxHealth = 195
					plasma_gain = 20
					plasma_max = 600
					spit_delay = 15
					caste_desc = "Neurotoxin Factory, don't let it get you."
					armor_deflection = 20
					tackle_damage = 40	 // Prior was 35
					speed = -1.1
				if("Spitter")
					to_chat(src, "<span class='xenoannounce'>You are a master of ranged stuns and damage. Go fourth and generate salt.</span>")
					melee_damage_lower = 30
					melee_damage_upper = 40
					health = 250
					maxHealth = 250
					plasma_gain = 50
					plasma_max = 900
					spit_delay = 15
					caste_desc = "A ranged destruction machine."
					armor_deflection = 30
					tackle_damage = 45	 // Prior was 35
					speed = -0.8
				if("Queen")
					to_chat(src, "<span class='xenoannounce'>You are the Alpha and the Omega. The beginning and the end.</span>")
					melee_damage_lower = 60
					melee_damage_upper = 70
					health = 375
					maxHealth = 375
					plasma_max = 1000
					plasma_gain = 50
					spit_delay = 15
					caste_desc = "The most perfect Xeno form imaginable."
					armor_deflection = 60
					tackle_damage = 70 // Prior was 65
					speed = 0.3
					aura_strength = 5
					queen_leader_limit = 4

	generate_name() //Give them a new name now

	hud_set_queen_overwatch() //update the upgrade level insignia on our xeno hud.


//Tiered spawns.
/mob/living/carbon/Xenomorph/Runner/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Runner/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Runner/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Drone/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Drone/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Drone/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Carrier/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Carrier/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Carrier/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Hivelord/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Hivelord/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Hivelord/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Praetorian/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Praetorian/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Praetorian/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Ravager/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Ravager/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Ravager/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Sentinel/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Sentinel/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Sentinel/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Spitter/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Spitter/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Spitter/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Hunter/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Hunter/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Hunter/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Queen/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Queen/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Queen/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Crusher/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Crusher/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Crusher/ancient/New()
	..()
	upgrade_xeno(3)

/mob/living/carbon/Xenomorph/Boiler/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Boiler/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Boiler/ancient/New()
	..()
	upgrade_xeno(3)



/mob/living/carbon/Xenomorph/Defender/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Defender/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Defender/ancient/New()
	..()
	upgrade_xeno(3)


/mob/living/carbon/Xenomorph/Warrior/mature/New()
	..()
	upgrade_xeno(1)

/mob/living/carbon/Xenomorph/Warrior/elder/New()
	..()
	upgrade_xeno(2)

/mob/living/carbon/Xenomorph/Warrior/ancient/New()
	..()
	upgrade_xeno(3)

//Pistol ammo
//There's only two sections because revolvers exist

/datum/ammo/bullet/pistol
	name = "pistol bullet"
	damage = 20
	accuracy = -10

/datum/ammo/bullet/pistol/tranq
	name = "tranq bullet"
	debilitate = list(0,2,0,0,5,3,20,0)

/datum/ammo/bullet/pistol/hollow
	name = "hollowpoint pistol bullet"
	accuracy = -15
	shrapnel_chance = 45

/datum/ammo/bullet/pistol/hollow/on_hit_mob(mob/M,obj/item/projectile/P)
	staggerstun(M, P, 5, 0, 0, 1, 0.5, 0)

/datum/ammo/bullet/pistol/ap
	name = "armor-piercing pistol bullet"
	damage = 25
	accuracy = 10
	penetration = 30
	shrapnel_chance = 25

/datum/ammo/bullet/pistol/heavy
	name = "heavy pistol bullet"
	damage = 40
	accuracy = -15
	shrapnel_chance = 25
	accuracy_var_low = 7
	penetration = 5

/datum/ammo/bullet/pistol/incendiary
	name = "incendiary pistol bullet"
	damage = 20
	damage_type = BURN
	accuracy = 15
	shrapnel_chance = 0
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY

/datum/ammo/bullet/pistol/squash
	name = "squash-head pistol bullet"
	damage = 50
	penetration= 20
	accuracy = 15
	shrapnel_chance = 25
	debilitate = list(0,0,0,0,0,0,0,2)

/datum/ammo/bullet/pistol/mankey
	name = "live monkey"
	icon_state = "monkey1"
	damage = 15
	damage_var_high = 9
	shell_speed = 2
	ping = null //no bounce off.
	damage_type = BURN
	debilitate = list(4,4,0,0,0,0,0,0)
	flags_ammo_behavior = AMMO_INCENDIARY|AMMO_IGNORE_ARMOR

/datum/ammo/bullet/pistol/mankey/on_hit_mob(mob/M,obj/item/projectile/P)
	if(P && P.loc && !M.stat && !istype(M,/mob/living/carbon/monkey))
		P.visible_message("<span class='danger'>The [src] chimpers furiously!</span>")
		new /mob/living/carbon/monkey(P.loc)

//REVOLVER AMMO
//revolvers are just cowboy pistols anyways i'm not putting them in their own file

/datum/ammo/bullet/revolver
	name = "revolver bullet"
	damage = 40
	accuracy = -15
	penetration = 5

/datum/ammo/bullet/revolver/on_hit_mob(mob/M,obj/item/projectile/P)
	staggerstun(M, P, 5, 0, 0, 1, 0.5, 0)

/datum/ammo/bullet/revolver/small
	name = "small revolver bullet"
	damage = 30

/datum/ammo/bullet/revolver/marksman
	name = "slimline revolver bullet"
	shrapnel_chance = 0
	accuracy = 15
	accurate_range = 10
	scatter = -15
	damage = 30
	penetration = 10
	damage_falloff = 0

/datum/ammo/bullet/revolver/heavy
	name = "heavy revolver bullet"
	damage = 50
	penetration= 5
	accuracy = -15

/datum/ammo/bullet/revolver/heavy/on_hit_mob(mob/M,obj/item/projectile/P)
	staggerstun(M, P, 5, 0, 0, 1, 0.5, 0)

/datum/ammo/bullet/revolver/highimpact
	name = "high-impact revolver bullet"
	accuracy_var_high = 10
	damage = 55
	damage_var_low = 5
	damage_var_high = 7
	penetration= 10

/datum/ammo/bullet/revolver/highimpact/on_hit_mob(mob/M,obj/item/projectile/P)
	staggerstun(M, P, 5, 0, 1, 2, 2)

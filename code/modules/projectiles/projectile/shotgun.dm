/datum/ammo/bullet/shotgun

/datum/ammo/bullet/shotgun/slug
	name = "shotgun slug"
	max_range = 10
	damage = 70
	penetration= 20

/datum/ammo/bullet/shotgun/slug/on_hit_mob(mob/M,obj/item/projectile/P)
	staggerstun(M, P, 5, 0, 1, 2, 2)

/datum/ammo/bullet/shotgun/beanbag
	name = "beanbag slug"
	icon_state = "beanbag"
	max_range = 10
	shrapnel_chance = 0
	accuracy = 15
	shell_speed = 3
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_IGNORE_RESIST

/datum/ammo/bullet/shotgun/beanbag/on_hit_mob(mob/M, obj/item/projectile/P)
	if(!M || M == P.firer)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name == "Human") //no effect on synths or preds.
			if(H.mind && H.mind.special_role)
				H.apply_effects(0,1) //ineffective against antags.
			else
				H.apply_effects(6,8)
		shake_camera(H, 2, 1)

/datum/ammo/bullet/shotgun/incendiary
	name = "incendiary slug"
	accuracy = -10
	max_range = 10
	damage = 50
	penetration= 5
	damage_type = BURN
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_INCENDIARY

datum/ammo/bullet/shotgun/incendiary/on_hit_mob(mob/M,obj/item/projectile/P)
	burst(get_turf(M),P,damage_type)
	knockback(M,P)

/datum/ammo/bullet/shotgun/incendiary/on_hit_obj(obj/O,obj/item/projectile/P)
	burst(get_turf(P),P,damage_type)

/datum/ammo/bullet/shotgun/incendiary/on_hit_turf(turf/T,obj/item/projectile/P)
	burst(get_turf(T),P,damage_type)

/datum/ammo/bullet/shotgun/flechette
	name = "shotgun flechette shell"
	accuracy_var_low = 7
	accuracy_var_high = 7
	max_range = 10
	damage = 35
	damage_var_low = -5
	damage_var_high = 5
	penetration	= 50
	bonus_projectiles_amount = 2
	icon_state = "flechette"
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/flechette_spread

/datum/ammo/bullet/shotgun/flechette_spread
	name = "additional flechette"
	icon_state = "flechette"
	accuracy_var_low = 7
	accuracy_var_high = 7
	max_range = 10
	damage = 35
	damage_var_low = -5
	damage_var_high = 5
	penetration	= 50
	scatter = 40*2 //bonus projectiles run their own scatter chance

/datum/ammo/bullet/shotgun/buckshot
	name = "shotgun buckshot shell"
	icon_state = "buckshot"
	accuracy_var_low = 9
	accuracy_var_high = 9
	accurate_range = 5
	max_range = 5
	damage = 90
	damage_var_low = -7
	damage_var_high = 7
	damage_falloff = 5
	penetration	= -10
	bonus_projectiles_amount = 2
	shell_speed = 2
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread

/datum/ammo/bullet/shotgun/buckshot/on_hit_mob(mob/M,obj/item/projectile/P)
	knockback(M,P)

//buckshot variant only used by the masterkey shotgun attachment.
/datum/ammo/bullet/shotgun/buckshot/masterkey
	damage = 70
	bonus_projectiles_type = /datum/ammo/bullet/shotgun/spread/masterkey

/datum/ammo/bullet/shotgun/spread
	name = "additional buckshot"
	icon_state = "buckshot"
	accuracy_var_low = 9
	accuracy_var_high = 9
	accurate_range = 5
	max_range = 5
	damage = 50
	damage_var_low = -7
	damage_var_high = 7
	damage_falloff = 5
	penetration	= -10
	shell_speed = 2
	scatter = 40*4 //bonus projectiles run their own scatter chance

/datum/ammo/bullet/shotgun/spread/masterkey/
	damage = 30

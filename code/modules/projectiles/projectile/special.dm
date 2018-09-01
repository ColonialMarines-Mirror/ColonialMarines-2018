/datum/ammo/bullet/smartgun
	name = "smartgun bullet"
	accurate_range = 10
	damage = 30
	penetration= 10
	icon_state = "redbullet" //Red bullets to indicate friendly fire restriction
	iff_signal = ACCESS_IFF_MARINE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SKIPS_HUMANS

/datum/ammo/bullet/smartgun/lethal
	damage = 40
	penetration= 20
	flags_ammo_behavior = AMMO_BALLISTIC
	icon_state 	= "bullet"

/datum/ammo/bullet/smartgun/dirty
	name = "irradiated smartgun bullet"
	shrapnel_chance = 75
	iff_signal = ACCESS_IFF_PMC
	debilitate = list(0,0,0,3,0,0,0,1)

/datum/ammo/bullet/smartgun/dirty/lethal
	flags_ammo_behavior = AMMO_BALLISTIC
	icon_state 	= "bullet"
	damage = 40
	penetration= 30

/datum/ammo/bullet/turret
	name = "autocannon bullet"
	accurate_range = 10
	accuracy_var_low = 5
	accuracy_var_high = 5
	max_range = 10
	damage = 30
	penetration= 10
	accuracy = -10
	icon_state 	= "redbullet" //Red bullets to indicate friendly fire restriction
	iff_signal = ACCESS_IFF_MARINE
	flags_ammo_behavior = AMMO_BALLISTIC|AMMO_SKIPS_HUMANS

/datum/ammo/bullet/turret/dumb
	icon_state 	= "bullet"
	iff_signal = 0

/datum/ammo/bullet/machinegun //Adding this for the MG Nests (~Art)
	name = "machinegun bullet"
	icon_state 	= "bullet" // Keeping it bog standard with the turret but allows it to be changed. Had to remove IFF so you have to watch out.
	accurate_range = 10
	damage = 50
	penetration= 60 //Bumped the penetration to serve a different role from sentries, MGs are a bit more offensive
	accuracy = 15

/datum/ammo/bullet/minigun
	name = "minigun bullet"
	accuracy = -10
	accuracy_var_low = 5
	accuracy_var_high = 5
	accurate_range = 10
	damage = 50
	penetration= 20
	shrapnel_chance = 25
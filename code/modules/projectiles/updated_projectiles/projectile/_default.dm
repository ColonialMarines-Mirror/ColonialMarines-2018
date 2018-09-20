#define DEBUG_STAGGER_SLOWDOWN 0

/datum/ammo
	var/name 		= "generic bullet"
	var/icon 		= 'icons/obj/items/projectiles.dmi'
	var/icon_state 	= "bullet"
	var/ping 		= "ping_b" //The icon that is displayed when the bullet bounces off something.
	var/sound_hit //When it deals damage.
	var/sound_armor //When it's blocked by human armor.
	var/sound_miss //When it misses someone.
	var/sound_bounce //When it bounces off something.

	var/iff_signal					= 0 		// PLACEHOLDER. Bullets that can skip friendlies will call for this
	var/accuracy 					= 0 		// This is added to the bullet's base accuracy
	var/accuracy_var_low			= 0 		// How much the accuracy varies when fired
	var/accuracy_var_high			= 0
	var/accurate_range 				= 0 		// For most guns, this is where the bullet dramatically looses accuracy. Not for snipers though
	var/accurate_range_min 			= 0			// Snipers use this to simulate poor accuracy at close ranges
	var/point_blank_range			= 0			// Weapons will get a large accuracy buff at this short range
	var/max_range 					= 0 		// This will de-increment a counter on the bullet
	var/scatter  					= 0 		// How much the ammo scatters when burst fired, added to gun scatter, along with other mods
	var/damage 						= 0 		// This is the base damage of the bullet as it is fired
	var/damage_var_low				= 0 		// Same as with accuracy variance
	var/damage_var_high				= 0
	var/damage_falloff 				= 0 		// How much damage the bullet loses per turf traveled
	var/damage_type 				= BRUTE 	// BRUTE, BURN, TOX, OXY, CLONE are the only things that should be in here
	var/penetration					= 0 		// How much armor it ignores before calculations take place
	var/shrapnel_chance 			= 0 		// The % chance it will imbed in a human
	var/shell_speed 				= 0 		// How fast the projectile moves
	var/bonus_projectiles_type 					// Type path of the extra projectiles
	var/bonus_projectiles_amount 	= 0 		// How many extra projectiles it shoots out. Works kind of like firing on burst, but all of the projectiles travel together
	var/debilitate[]				= null 		// Stun,knockdown,knockout,irradiate,stutter,eyeblur,drowsy,agony

	New()
		accuracy 			= 5 	// This is added to the bullet's base accuracy.
		accuracy_var_low	= 1 	// How much the accuracy varies when fired.
		accuracy_var_high	= 1
		accurate_range 		= 5 	// For most guns, this is where the bullet dramatically looses accuracy. Not for snipers though.
		max_range 			= 20 	// This will de-increment a counter on the bullet.
		damage_var_low		= 1 	// Same as with accuracy variance.
		damage_var_high		= 1
		damage_falloff 		= 1 	// How much damage the bullet loses per turf traveled.
		shell_speed 		= 1 	// How fast the projectile moves.

	var/flags_ammo_behavior = NOFLAGS

	proc/do_at_half_range(obj/item/projectile/P)
		return

	proc/do_at_max_range(obj/item/projectile/P)
		return

	proc/on_shield_block(mob/M, obj/item/projectile/P) //Does it do something special when shield blocked? Ie. a flare or grenade that still blows up.
		return

	proc/on_hit_turf(turf/T, obj/item/projectile/P) //Special effects when hitting dense turfs.
		return

	proc/on_hit_mob(mob/M, obj/item/projectile/P) //Special effects when hitting mobs.
		return

	proc/on_hit_obj(obj/O, obj/item/projectile/P) //Special effects when hitting objects.
		return

	proc/knockback(mob/M, obj/item/projectile/P, var/max_range = 2)
		if(!M || M == P.firer)
			return
		if(P.distance_travelled > max_range || M.lying) shake_camera(M, 2, 1) //Three tiles away or more, basically.

		else //Two tiles away or less.
			shake_camera(M, 3, 4)
			if(isliving(M)) //This is pretty ugly, but what can you do.
				if(isXeno(M))
					var/mob/living/carbon/Xenomorph/target = M
					if(target.mob_size == MOB_SIZE_BIG)
						return //Big xenos are not affected.
					target.apply_effects(0,1) //Smaller ones just get shaken.
					to_chat(target, "<span class='xenodanger'>You are shaken by the sudden impact!</span>")
				else
					if(!isYautja(M)) //Not predators.
						var/mob/living/target = M
						target.apply_effects(1,2) //Humans get stunned a bit.
						to_chat(target, "<span class='highdanger'>The blast knocks you off your feet!</span>")
			step_away(M,P)

	proc/staggerstun(mob/M, obj/item/projectile/P, var/max_range = 2, var/stun = 0, var/weaken = 1, var/stagger = 2, var/slowdown = 1, var/knockback = 1, var/size_threshold = 2, var/shake = 1)
		if(!M || M == P.firer)
			return
		if(shake && (P.distance_travelled > max_range || M.lying))
			shake_camera(M, shake+1, shake)
			return
		if(!isliving(M) || (isYautja(M) && size_threshold < 4) || (M.mob_size == MOB_SIZE_BIG && size_threshold < 3) || (isXeno(M) && size_threshold < 2) || ( ishuman(M) && size_threshold < 1))
			return
		if(shake)
			shake_camera(M, shake+2, shake+3)
		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/target = M
			target.apply_effects(stun,weaken)
			#if DEBUG_STAGGER_SLOWDOWN
			to_chat(world, "<span class='debuginfo'>Damage: Initial stagger is: <b>[target.stagger]</b></span>")
			#endif
			target.adjust_stagger(stagger)
			#if DEBUG_STAGGER_SLOWDOWN
			to_chat(world, "<span class='debuginfo'>Damage: Final stagger is: <b>[target.stagger]</b></span>")
			#endif
			#if DEBUG_STAGGER_SLOWDOWN
			to_chat(world, "<span class='debuginfo'>Damage: Initial slowdown is: <b>[target.slowdown]</b></span>")
			#endif
			target.add_slowdown(slowdown)
			#if DEBUG_STAGGER_SLOWDOWN
			to_chat(world, "<span class='debuginfo'>Damage: Final slowdown is: <b>[target.slowdown]</b></span>")
			#endif
			to_chat(target, "<span class='xenodanger'>You are shaken by the sudden impact!</span>")
		else
			var/mob/living/target = M
			target.apply_effects(stun,weaken)
			to_chat(target, "<span class='highdanger'>The blast knocks you off your feet!</span>")
		for(var/i=0, i<knockback, i++)
			step_away(M,P)

	proc/burst(atom/target, obj/item/projectile/P, damage_type = BRUTE)
		if(!target || !P)
			return
		for(var/mob/living/carbon/M in orange(1,target))
			if(P.firer == M)
				continue
			M.visible_message("<span class='danger'>[M] is hit by backlash from \a [P.name]!</span>","[isXeno(M)?"<span class='xenodanger'>":"<span class='highdanger'>"]You are hit by backlash from \a </b>[P.name]</b>!</span>")
			M.apply_damage(rand(5,P.damage/2),damage_type)

	proc/fire_bonus_projectiles(obj/item/projectile/original_P)
		set waitfor = 0
		var/i
		for(i = 1 to bonus_projectiles_amount) //Want to run this for the number of bonus projectiles.
			var/obj/item/projectile/P = rnew(/obj/item/projectile, original_P.shot_from)
			P.generate_bullet(ammo_list[bonus_projectiles_type]) //No bonus damage or anything.
			var/turf/new_target = null
			if(prob(P.scatter))
				var/scatter_x = rand(-1,1)
				var/scatter_y = rand(-1,1)
				new_target = locate(original_P.target_turf.x + round(scatter_x),original_P.target_turf.y + round(scatter_y),original_P.target_turf.z)
				if(!istype(new_target) || isnull(new_target))
					continue	//If we didn't find anything, make another pass.
				P.original = new_target
			P.accuracy = round(P.accuracy * original_P.accuracy/initial(original_P.accuracy)) //if the gun changes the accuracy of the main projectile, it also affects the bonus ones.
			if(!new_target)
				new_target = original_P.target_turf
			P.fire_at(new_target,original_P.firer,original_P.shot_from,P.ammo.max_range,P.ammo.shell_speed) //Fire!

	//This is sort of a workaround for now. There are better ways of doing this ~N.
	proc/stun_living(mob/living/target, obj/item/projectile/P) //Taser proc to stun folks.
		if(istype(target))
			if( isYautja(target) || isXeno(target) )
				return //Not on aliens.
			if(target.mind && target.mind.special_role)
				switch(target.mind.special_role) //Switches are still better than evaluating this twice.
					if("IRON BEARS") //These antags can shrug off tasers so they are not shut down.
						target.apply_effects(1,1) //Barely affected.
						return
					if("UPP") //These antags can shrug off tasers so they are not shut down.
						target.apply_effects(1,1) //Barely affected.
						return
					if("DEATH SQUAD")
						target.apply_effects(0,1) //Almost unaffacted.
						return
			target.apply_effects(12,20)

	proc/drop_flame(turf/T) // ~Art updated fire 20JAN17
		if(!istype(T))
			return
		if(locate(/obj/flamer_fire) in T)
			return
		new /obj/flamer_fire(T, 20, 20)

//default ammo
//placeholder ammo when something screws up
/datum/ammo/bullet
	name = "default bullet"
	damage = 10
	shrapnel_chance = 10
	shell_speed = 4
	icon_state = "bullet"
	flags_ammo_behavior = AMMO_BALLISTIC
	sound_hit 	 = "ballistic_hit"
	sound_armor  = "ballistic_armor"
	sound_miss	 = "ballistic_miss"
	sound_bounce = "ballistic_bounce"
	point_blank_range = 2
	accurate_range_min = 0
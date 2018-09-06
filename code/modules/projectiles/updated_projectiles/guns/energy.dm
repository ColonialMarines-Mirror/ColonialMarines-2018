
//-------------------------------------------------------
//ENERGY GUNS/ETC

/obj/item/weapon/gun/energy
	attachable_allowed = list()



/obj/item/weapon/gun/energy/taser
	name = "taser gun"
	desc = "An advanced stun device capable of firing balls of ionized electricity. Used for nonlethal takedowns."
	icon_state = "taser"
	item_state = "taser"
	muzzle_flash = null //TO DO.
	fire_sound = 'sound/weapons/Taser.ogg'
	origin_tech = "combat=1;materials=1"
	matter = list("metal" = 2000)
	ammo = /datum/ammo/energy/taser
	movement_acc_penalty_mult = 1
	var/obj/item/cell/high/cell //10000 power.
	var/charge_cost = 100 //100 shots.
	flags_gun_features = GUN_UNUSUAL_DESIGN
	gun_skill_category = GUN_SKILL_PISTOLS
	movement_acc_penalty_mult = 0

/obj/item/weapon/gun/energy/taser/New()
	..()
	cell = new /obj/item/cell/high(src)

/obj/item/weapon/gun/energy/taser/set_gun_config_values()
	fire_delay = config.high_fire_delay * 2
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult


/obj/item/weapon/gun/energy/taser/update_icon()
	if(!cell || cell.charge - charge_cost < 0)
		icon_state = base_gun_icon + "_e"
	else
		icon_state = base_gun_icon

/obj/item/weapon/gun/energy/taser/emp_act(severity)
	cell.use(round(cell.maxcharge / severity))
	update_icon()
	..()

/obj/item/weapon/gun/energy/taser/able_to_fire(mob/living/user)
	. = ..()
	if (. && istype(user)) //Let's check all that other stuff first.
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.police < SKILL_POLICE_MP)
			to_chat(user, "<span class='warning'>You don't seem to know how to use [src]...</span>")
			return 0

/obj/item/weapon/gun/energy/taser/load_into_chamber()
	if(!cell || cell.charge - charge_cost < 0) return

	cell.charge -= charge_cost
	in_chamber = create_bullet(ammo)
	return in_chamber

/obj/item/weapon/gun/energy/taser/reload_into_chamber()
	update_icon()
	return 1

/obj/item/weapon/gun/energy/taser/delete_bullet(var/obj/item/projectile/projectile_to_fire, refund = 0)
	cdel(projectile_to_fire)
	if(refund) cell.charge += charge_cost
	return 1



/obj/item/weapon/gun/energy/plasmarifle
	name = "plasma rifle"
	desc = "A long-barreled heavy plasma weapon capable of taking down large game. It has a mounted scope for distant shots and an integrated battery."
	icon = 'icons/obj/items/predator.dmi'
	icon_state = "plasmarifle"
	item_state = "plasmarifle"
	origin_tech = "combat=8;materials=7;bluespace=6"
	unacidable = 1
	fire_sound = 'sound/weapons/pred_plasma_shot.ogg'
	ammo = /datum/ammo/energy/yautja/rifle/bolt
	muzzle_flash = null // TO DO, add a decent one.
	zoomdevicename = "scope"
	flags_equip_slot = SLOT_BACK
	w_class = 5
	var/charge_time = 0
	var/last_regen = 0
	flags_gun_features = GUN_UNUSUAL_DESIGN


/obj/item/weapon/gun/energy/plasmarifle/New()
	..()
	processing_objects.Add(src)
	last_regen = world.time
	update_icon()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag



/obj/item/weapon/gun/energy/plasmarifle/Dispose()
	. = ..()
	processing_objects.Remove(src)


/obj/item/weapon/gun/energy/plasmarifle/process()
	if(charge_time < 100)
		charge_time++
		if(charge_time == 99)
			if(ismob(loc)) to_chat(loc, "<span class='notice'>[src] hums as it achieves maximum charge.</span>")
		update_icon()


/obj/item/weapon/gun/energy/plasmarifle/set_gun_config_values()
	fire_delay = config.high_fire_delay*2
	accuracy_mult = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
	scatter = config.med_scatter_value
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult


/obj/item/weapon/gun/energy/plasmarifle/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [charge_time] / 100 charge.")
	else
		to_chat(user, "This thing looks like an alien rifle of some kind. Strange.")

/obj/item/weapon/gun/energy/plasmarifle/update_icon()
	if(last_regen < charge_time + 20 || last_regen > charge_time || charge_time > 95)
		var/new_icon_state = charge_time <=15 ? null : icon_state + "[round(charge_time/33, 1)]"
		update_special_overlay(new_icon_state)
		last_regen = charge_time

/obj/item/weapon/gun/energy/plasmarifle/unique_action(mob/user)
	if(!isYautja(user))
		to_chat(user, "<span class='warning'>You have no idea how this thing works!</span>")
		return
	..()
	zoom(user)

/obj/item/weapon/gun/energy/plasmarifle/able_to_fire(mob/user)
	if(!isYautja(user))
		to_chat(user, "<span class='warning'>You have no idea how this thing works!</span>")
		return

	return ..()

/obj/item/weapon/gun/energy/plasmarifle/load_into_chamber()
	ammo = ammo_list[charge_time < 15? /datum/ammo/energy/yautja/rifle/bolt : /datum/ammo/energy/yautja/rifle/blast]
	var/obj/item/projectile/P = create_bullet(ammo)
	P.SetLuminosity(1)
	in_chamber = P
	charge_time = round(charge_time / 2)
	return in_chamber

/obj/item/weapon/gun/energy/plasmarifle/reload_into_chamber()
	update_icon()
	return 1

/obj/item/weapon/gun/energy/plasmarifle/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	cdel(projectile_to_fire)
	if(refund) charge_time *= 2
	return 1

/obj/item/weapon/gun/energy/plasmarifle/attack_self(mob/living/user)
	if(!isYautja(user))
		return ..()

	if(charge_time > 10)
		user.visible_message("<span class='notice'>You feel a strange surge of energy in the area.</span>","<span class='notice'>You release the rifle battery's energy.</span>")
		var/obj/item/clothing/gloves/yautja/Y = user:gloves
		if(Y && Y.charge < Y.charge_max)
			Y.charge += charge_time * 2
			if(Y.charge > Y.charge_max) Y.charge = Y.charge_max
			charge_time = 0
			to_chat(user, "<span class='notice'>Your bracers absorb some of the released energy.</span>")
			update_icon()
	else
		to_chat(user, "<span class='warning'>The weapon's not charged enough with ambient energy!</span>")





/obj/item/weapon/gun/energy/plasmapistol
	name = "plasma pistol"
	desc = "A plasma pistol capable of rapid fire. It has an integrated battery."
	icon = 'icons/obj/items/predator.dmi'
	icon_state = "plasmapistol"
	item_state = "plasmapistol"
	origin_tech = "combat=8;materials=7;bluespace=6"
	unacidable = 1
	fire_sound = 'sound/weapons/pulse3.ogg'
	flags_equip_slot = SLOT_WAIST
	ammo = /datum/ammo/energy/yautja/pistol
	muzzle_flash = null // TO DO, add a decent one.
	w_class = 3
	var/charge_time = 40
	flags_gun_features = GUN_UNUSUAL_DESIGN


/obj/item/weapon/gun/energy/plasmapistol/New()
	..()
	processing_objects.Add(src)
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag



/obj/item/weapon/gun/energy/plasmapistol/Dispose()
	. = ..()
	processing_objects.Remove(src)


/obj/item/weapon/gun/energy/plasmapistol/process()
	if(charge_time < 40)
		charge_time++
		if(charge_time == 39)
			if(ismob(loc)) to_chat(loc, "<span class='notice'>[src] hums as it achieves maximum charge.</span>")



/obj/item/weapon/gun/energy/plasmapistol/set_gun_config_values()
	fire_delay = config.med_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.med_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult + config.high_hit_accuracy_mult
	scatter = config.low_scatter_value
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult



/obj/item/weapon/gun/energy/plasmapistol/examine(mob/user)
	if(isYautja(user))
		..()
		to_chat(user, "It currently has [charge_time] / 40 charge.")
	else
		to_chat(user, "This thing looks like an alien rifle of some kind. Strange.")


/obj/item/weapon/gun/energy/plasmapistol/able_to_fire(mob/user)
	if(!isYautja(user))
		to_chat(user, "<span class='warning'>You have no idea how this thing works!</span>")
		return
	else
		return ..()

/obj/item/weapon/gun/energy/plasmapistol/load_into_chamber()
	if(charge_time < 1) return
	var/obj/item/projectile/P = create_bullet(ammo)
	P.SetLuminosity(1)
	in_chamber = P
	charge_time -= 1
	return in_chamber

/obj/item/weapon/gun/energy/plasmapistol/reload_into_chamber()
	return 1

/obj/item/weapon/gun/energy/plasmapistol/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	cdel(projectile_to_fire)
	if(refund) charge_time *= 2
	return 1











/obj/item/weapon/gun/energy/plasma_caster
	icon = 'icons/obj/items/predator.dmi'
	icon_state = "plasma"
	item_state = "plasma_wear"
	name = "plasma caster"
	desc = "A powerful, shoulder-mounted energy weapon."
	fire_sound = 'sound/weapons/pred_plasmacaster_fire.ogg'
	ammo = /datum/ammo/energy/yautja/caster/bolt
	muzzle_flash = null // TO DO, add a decent one.
	w_class = 5
	force = 0
	fire_delay = 3
	var/obj/item/clothing/gloves/yautja/source = null
	var/charge_cost = 100 //How much energy is needed to fire.
	var/mode = 0
	actions_types = list(/datum/action/item_action/toggle)
	flags_atom = FPRINT|CONDUCT
	flags_item = NOBLUDGEON|DELONDROP //Can't bludgeon with this.
	flags_gun_features = GUN_UNUSUAL_DESIGN

/obj/item/weapon/gun/energy/plasma_caster/New()
	..()
	verbs -= /obj/item/weapon/gun/verb/field_strip
	verbs -= /obj/item/weapon/gun/verb/toggle_burst
	verbs -= /obj/item/weapon/gun/verb/empty_mag
	verbs -= /obj/item/weapon/gun/verb/use_unique_action

/obj/item/weapon/gun/energy/plasma_caster/Dispose()
	. = ..()
	source = null


/obj/item/weapon/gun/energy/plasma_caster/set_gun_config_values()
	fire_delay = config.high_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult + config.high_fire_delay
	scatter = config.med_scatter_value
	scatter_unwielded = config.med_scatter_value
	damage_mult = config.base_hit_damage_mult

/obj/item/weapon/gun/energy/plasma_caster/attack_self(mob/living/user)
	switch(mode)
		if(0)
			mode = 1
			charge_cost = 100
			fire_delay = config.med_fire_delay * 4
			fire_sound = 'sound/weapons/emitter2.ogg'
			to_chat(user, "<span class='notice'>[src] is now set to fire medium plasma blasts.</span>")
			ammo = ammo_list[/datum/ammo/energy/yautja/caster/blast]
		if(1)
			mode = 2
			charge_cost = 300
			fire_delay = config.high_fire_delay * 20
			fire_sound = 'sound/weapons/pulse.ogg'
			to_chat(user, "<span class='notice'>[src] is now set to fire heavy plasma spheres.</span>")
			ammo = ammo_list[/datum/ammo/energy/yautja/caster/sphere]
		if(2)
			mode = 0
			charge_cost = 30
			fire_delay = config.high_fire_delay
			fire_sound = 'sound/weapons/pred_lasercannon.ogg'
			to_chat(user, "<span class='notice'>[src] is now set to fire light plasma bolts.</span>")
			ammo = ammo_list[/datum/ammo/energy/yautja/caster/bolt]

/obj/item/weapon/gun/energy/plasma_caster/dropped(mob/living/carbon/human/M)
	playsound(M,'sound/weapons/pred_plasmacaster_off.ogg', 15, 1)
	..()

/obj/item/weapon/gun/energy/plasma_caster/able_to_fire(mob/user)
	if(!source)	return
	if(!isYautja(user))
		to_chat(user, "<span class='warning'>You have no idea how this thing works!</span>")
		return

	return ..()

/obj/item/weapon/gun/energy/plasma_caster/load_into_chamber()
	if(source.drain_power(usr,charge_cost))
		in_chamber = create_bullet(ammo)
		return in_chamber

/obj/item/weapon/gun/energy/plasma_caster/reload_into_chamber()
	return 1

/obj/item/weapon/gun/energy/plasma_caster/delete_bullet(obj/item/projectile/projectile_to_fire, refund = 0)
	cdel(projectile_to_fire)
	if(refund)
		source.charge += charge_cost
		var/perc = source.charge / source.charge_max * 100
		var/mob/living/carbon/human/user = usr //Hacky...
		user.update_power_display(perc)
	return 1


//-------------------------------------------------------
//Lasguns

/obj/item/weapon/gun/energy/lasgun
	name = "\improper Lasgun"
	desc = "A laser based firearm. Uses power cells."
	origin_tech = "combat=5;materials=4"
	reload_sound = 'sound/weapons/gun_rifle_reload.ogg'
	fire_sound = 'sound/weapons/Laser.ogg'
	matter = list("metal" = 2000)
	flags_equip_slot = SLOT_BACK
	w_class = 4
	force = 15
	overcharge = 0
	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_ENERGY
	aim_slowdown = SLOWDOWN_ADS_RIFLE
	wield_delay = WIELD_DELAY_SLOW
	gun_skill_category = GUN_SKILL_RIFLES


/obj/item/weapon/gun/rifle/set_gun_config_values()
	fire_delay = config.mhigh_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult
	accuracy_mult_unwielded = config.base_hit_accuracy_mult - config.high_hit_accuracy_mult
	damage_mult = config.base_hit_damage_mult
	scatter_unwielded = config.high_scatter_value //Heavy and unwieldy
	recoil_unwielded = config.high_recoil_value
	damage_falloff_mult = config.med_damage_falloff_mult


//-------------------------------------------------------
//M43 Sunfury Lasgun MK1

/obj/item/weapon/gun/energy/lasgun/M43
	name = "\improper M43 Sunfury Lasgun MK1"
	desc = "An accurate, recoilless laser based battle rifle with an integrated charge selector. Ideal for longer range engagements. Uses power cells."
	icon = 'icons/obj/old_guns/old_guns.dmi'
	icon_state = "laser"
	item_state = "laser0"
	fire_sound = 'sound/weapons/Laser.ogg'
	attachable_allowed = list(
						/obj/item/attachable/bayonet,
						/obj/item/attachable/reddot,
						/obj/item/attachable/verticalgrip,
						/obj/item/attachable/angledgrip,
						/obj/item/attachable/lasersight,
						/obj/item/attachable/gyro,
						/obj/item/attachable/flashlight,
						/obj/item/attachable/bipod,
						/obj/item/attachable/magnetic_harness,
						/obj/item/attachable/stock/rifle,
						/obj/item/attachable/attached_gun/grenade,
						/obj/item/attachable/attached_gun/flamer,
						/obj/item/attachable/attached_gun/shotgun,
						/obj/item/attachable/scope,
						/obj/item/attachable/scope/mini)

	flags_gun_features = GUN_AUTO_EJECTOR|GUN_CAN_POINTBLANK|GUN_AMMO_COUNTER|GUN_ENERGY
	starting_attachment_types = list(/obj/item/attachable/attached_gun/grenade)

/obj/item/weapon/gun/energy/lasgun/M43/New()
	..()
	update_icon()
	attachable_offset = list("muzzle_x" = 32, "muzzle_y" = 18,"rail_x" = 12, "rail_y" = 23, "under_x" = 24, "under_y" = 13, "stock_x" = 24, "stock_y" = 13)

/obj/item/weapon/gun/energy/lasgun/M43/set_gun_config_values()
	fire_delay = config.low_fire_delay
	accuracy_mult = config.base_hit_accuracy_mult + config.max_hit_accuracy_mult
	scatter_unwielded = config.high_scatter_value //Heavy and unwieldy
	damage_mult = config.base_hit_damage_mult

//variant without ugl attachment
/obj/item/weapon/gun/energy/lasgun/M43/stripped
	starting_attachment_types = list()

/obj/item/weapon/gun/energy/lasgun/M43/unique_action(mob/user)
	toggle_chargemode(user)


//Toggles Overcharge mode. Overcharge mode significantly increases damage and AP in exchange for doubled ammo usage and increased fire delay.
/obj/item/weapon/gun/energy/lasgun/M43/proc/toggle_chargemode(mob/user)
	to_chat(user, "\icon[src] You [overcharge? "<B>disable</b>" : "<B>enable</b>" ] [src]'s overcharge mode.")
	if(overcharge == 0)
		//While overcharge is active, double ammo consumption, and
		playsound(user, 'sound/weapons/emitter.ogg', 15, 1)
		ammo_per_shot = 2
		fire_delay = config.med_fire_delay
		fire_sound = 'sound/weapons/Laser3.ogg'
		overcharge = 1
	else
		playsound(user, 'sound/weapons/emitter2.ogg', 15, 1)
		ammo_per_shot = 1
		fire_delay = config.low_fire_delay
		fire_sound = 'sound/weapons/Laser.ogg'
		overcharge = 0
	replace_ammo(user,current_mag)
	load_into_chamber(user, TRUE)
	to_chat(user, "DEBUG: Toggle End: Magazine: [current_mag] Regular: [current_mag.default_ammo] Overcharge: [current_mag.overcharge_ammo] Ammo per Shot: [ammo_per_shot] Ammo: [ammo] Chamber: [in_chamber] Rounds Left: [current_mag.current_rounds]")
	/*	if(in_chamber) //Update chamber if we have something loaded.
			update_chamber(user,refund)*/

//Ammo/Charge functions
/obj/item/weapon/gun/energy/lasgun/update_icon()
	if(!current_mag || current_mag.current_rounds <= 0)
		icon_state = base_gun_icon + "0"
	else if(current_mag.current_rounds > round(current_mag.max_rounds*0.75))
		icon_state = base_gun_icon + "100"
	else if(current_mag.current_rounds > round(current_mag.max_rounds*0.5))
		icon_state = base_gun_icon + "75"
	else if(current_mag.current_rounds > round(current_mag.max_rounds*0.25))
		icon_state = base_gun_icon + "50"
	else
		icon_state = base_gun_icon + "25"

//EMPs will fuck with remaining charge
/obj/item/weapon/gun/energy/lasgun/emp_act(severity)
	var/amount = round(current_mag.max_rounds / severity)
	if(current_mag.current_rounds < amount)	return 0
	current_mag.current_rounds = max(0,current_mag.current_rounds - amount)
	update_icon()
	..()

// use power from a cell
/obj/item/ammo_magazine/lasgun/proc/use(var/amount)

	return 1

/*
/obj/item/weapon/gun/energy/lasgun/M43/proc/update_chamber(mob/user = null, refund = 0)
	cdel(in_chamber)
	active_attachable.current_rounds += refund
	ammo = ammo_list[overcharge? current_mag.overcharge_ammo : current_mag.default_ammo]
	to_chat(user, "DEBUG: Toggle: Update Chamber. Magazine: [current_mag] Regular: [current_mag.default_ammo] Overcharge: [current_mag.overcharge_ammo] Ammo per Shot: [ammo_per_shot] Ammo: [ammo] Chamber: [in_chamber] Refund: [refund]")
	ready_in_chamber(user)


/obj/item/weapon/gun/energy/lasgun/proc/clear_chamber(mob/user = null, refund = 0)
	if(in_chamber)
		cdel(in_chamber)
		if(refund)
			current_mag.current_rounds += ammo_per_shot
	to_chat(user, "DEBUG: Clear Chamber. Magazine: [current_mag] Regular: [current_mag.default_ammo] Overcharge: [current_mag.overcharge_ammo] Ammo per Shot: [ammo_per_shot] Ammo: [ammo] Chamber: [in_chamber] Refund: [refund]")
	return TRUE


/obj/item/weapon/gun/lasgun/load_into_chamber(mob/user)
	//The workhorse of the bullet procs.
 	//If we have a round chambered and no active attachable, we're good to go.
	if(in_chamber && !active_attachable)
		return in_chamber //Already set!

	//Let's check on the active attachable. It loads ammo on the go, so it never chambers anything
	if(active_attachable)
		if(active_attachable.current_rounds > 0) //If it's still got ammo and stuff.
			active_attachable.current_rounds--
			return create_bullet(active_attachable.ammo)
		else
			to_chat(user, "<span class='warning'>[active_attachable] is empty!</span>")
			to_chat(user, "<span class='notice'>You disable [active_attachable].</span>")
			playsound(user, active_attachable.activation_sound, 15, 1)
			active_attachable.activate_attachment(src, null, TRUE)
	else
		return ready_in_chamber(user)//We're not using the active attachable, we must use the active mag if there is one.


/obj/item/weapon/gun/energy/lasgun/ready_in_chamber(mob/user)
	if(current_mag && current_mag.current_rounds > 0)
		if(current_mag.current_rounds - ammo_per_shot < 0) //Check if we have adequate power for overcharge
			in_chamber = create_bullet(ammo[current_mag.default_ammo])//Not enough power for overcharge, so fire regular ammo.
			to_chat(user, "DEBUG: Inadequate power. In_Chamber: [in_chamber]")
		else
			in_chamber = create_bullet(ammo)
		to_chat(user, "DEBUG: Regular shot: Magazine: [current_mag] Regular: [current_mag.default_ammo] Overcharge: [current_mag.overcharge_ammo] Ammo per Shot: [ammo_per_shot] Ammo: [ammo] Chamber: [in_chamber]")
		current_mag.current_rounds -= min(current_mag.current_rounds, ammo_per_shot) //Subtract the round from the mag.
		to_chat(user, "DEBUG: Rounds spent to chamber: [min(current_mag.current_rounds, ammo_per_shot)] Remaining Rounds [current_mag.current_rounds]")
		update_icon()
		return in_chamber


/obj/item/weapon/gun/energy/lasgun/reload_into_chamber(mob/user)
	/*
	ATTACHMENT POST PROCESSING
	This should only apply to the masterkey, since it's the only attachment that shoots through Fire()
	instead of its own thing through fire_attachment(). If any other bullet attachments are added, they would fire here.
	*/

	if(active_attachable)
		make_casing(active_attachable.type_of_casings) // Attachables can drop their own casings.
	else
		in_chamber = null //If we didn't fire from attachable, let's set this so the next pass doesn't think it still exists.

	if(!active_attachable) //We don't need to check for the mag if an attachment was used to shoot.
		if(current_mag.current_rounds <= 0 && flags_gun_features & GUN_AUTO_EJECTOR) // This is where the magazine is auto-ejected.
			unload(user,1,1) // We want to quickly autoeject the magazine. This proc does the rest based on magazine type. User can be passed as null.
			playsound(src, empty_sound, 25, 1)
	return 1

//Drop out the magazine. Keep the ammo type for next time so we don't need to replace it every time.
//This can be passed with a null user, so we need to check for that as well.
/obj/item/weapon/gun/energy/lasgun/unload(mob/user, reload_override = 0, drop_override = 0) //Override for reloading mags after shooting, so it doesn't interrupt burst. Drop is for dropping the magazine on the ground.
	if(!reload_override && (flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG)))
		return

	if(!current_mag || isnull(current_mag) || current_mag.loc != src) //you can't cock a lasgun
		return
	if(in_chamber)
		clear_chamber(user,in_chamber,ammo_per_shot) //Capacitors discharge back into the battery.
	if(drop_override || !user) //If we want to drop it on the ground or there's no user.
		current_mag.loc = get_turf(src) //Drop it on the ground.
	else
		user.put_in_hands(current_mag)

	playsound(user, unload_sound, 25, 1, 5)
	user.visible_message("<span class='notice'>[user] unloads [current_mag] from [src].</span>",
	"<span class='notice'>You unload [current_mag] from [src].</span>", null, 4)
	current_mag.update_icon()
	current_mag = null

	update_icon()


/obj/item/weapon/gun/energy/lasgun/reload(mob/user, obj/item/ammo_magazine/magazine)
	if(flags_gun_features & (GUN_BURST_FIRING|GUN_UNUSUAL_DESIGN|GUN_INTERNAL_MAG))
		return

	if(!magazine || !istype(magazine))
		to_chat(user, "<span class='warning'>That's not an appropriate power cell!</span>")
		return

	if(magazine.flags_magazine & AMMUNITION_HANDFUL)
		to_chat(user, "<span class='warning'>[src] needs a power cell; bullets won't work.</span>")
		return

	if(magazine.current_rounds <= 0)
		to_chat(user, "<span class='warning'>[magazine] is empty!</span>")
		return

	if(!istype(src, magazine.gun_type))
		to_chat(user, "<span class='warning'>That magazine doesn't fit in there!</span>")
		return

	if(current_mag)
		to_chat(user, "<span class='warning'>It's still got something loaded.</span>")
		return



	if(user)
		if(magazine.reload_delay > 1)
			to_chat(user, "<span class='notice'>You begin reloading [src]. Hold still...</span>")
			if(do_after(user,magazine.reload_delay, TRUE, 5, BUSY_ICON_FRIENDLY))
				replace_magazine(user, magazine)
			else
				to_chat(user, "<span class='warning'>Your reload was interrupted!</span>")
				return
		else
			replace_magazine(user, magazine)
	else
		current_mag = magazine
		magazine.loc = src
		replace_ammo(user,magazine)
		if(!in_chamber)
			load_into_chamber(user)

	update_icon()
	return TRUE

/obj/item/weapon/gun/energy/lasgun/replace_magazine(mob/user, obj/item/ammo_magazine/magazine)
	user.drop_inv_item_to_loc(magazine, src) //Click!
	current_mag = magazine
	replace_ammo(user,magazine)
	if(!in_chamber) //We don't cock
		ready_in_chamber()
	user.visible_message("<span class='notice'>[user] loads [magazine] into [src]!</span>",
	"<span class='notice'>You load [magazine] into [src]!</span>", null, 3)
	if(reload_sound)
		playsound(user, reload_sound, 25, 1, 5)


/obj/item/weapon/gun/energy/lasgun/M43/replace_ammo(mob/user = null, var/obj/item/ammo_magazine/magazine)
	if(!magazine.default_ammo)
		to_chat(user, "Something went horribly wrong. Ahelp the following: ERROR CODE A1: null ammo while reloading.")
		log_debug("ERROR CODE A1: null ammo while reloading. User: <b>[user]</b>")
		ammo = ammo_list[/datum/ammo/bullet] //Looks like we're defaulting it.
	else
		ammo = ammo_list[overcharge? magazine.overcharge_ammo : magazine.default_ammo]
	to_chat(user, "DEBUG: Replace Ammo. Magazine: [magazine] Regular: [magazine.default_ammo] Overcharge: [magazine.overcharge_ammo]  Ammo per Shot: [ammo_per_shot]  Ammo: [ammo] Chamber: [in_chamber] Rounds Left:[magazine.current_rounds]")
		/*else
			ammo = ammo_list[magazine.overcharge_ammo]
		*/*/
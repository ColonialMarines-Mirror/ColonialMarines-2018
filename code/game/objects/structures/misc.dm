/obj/structure/showcase
	name = "Showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	var/damage = 0
	var/health_max = 200
	var/soak = 5 //how much damage is reduced before affecting health
	var/max_temperature = 1000
	var/d_state
	
//create_debris creates debris like shards and rods. This also includes the window frame for explosions
//If an user is passed, it will create a "user smashes through the window" message. AM is the item that hits
//Please only fire this after a hit
/obj/structure/showcase/proc/healthcheck(make_hit_sound = 1, create_debris = 1, mob/user, atom/movable/AM)

	if(damage >= health_max)
		if(user)
			user.visible_message("<span class='danger'>[user] smashes through [src][AM ? " with [AM]":""]!</span>")
		playsound(loc, 'sound/effects/metal_crash.ogg', 35)
		create_debris()
	if(make_hit_sound)
		playsound(loc, 'sound/effects/grillehit.ogg', 25, 1)

/obj/structure/showcase/proc/create_debris(var/create_debris = 1)
	new /obj/item/stack/sheet/metal(loc)
	if(create_debris > 1) //If it was properly dismantled, generate another stack o metal.
		new /obj/item/stack/sheet/metal(loc)
	cdel(src)

/obj/structure/showcase/bullet_act(var/obj/item/projectile/Proj)
	var/impact = max(0,Proj.damage - soak)
	if(Proj.ammo.damage_type == HALLOSS || impact <= 0)
		return 0

	damage += impact
	..()
	healthcheck()
	return 1
	
/obj/structure/showcase/ex_act(severity)
	var/impact 
	switch(severity)
		if(1)
			cdel(src) //Nope
		if(2)
			impact = max(0,rand(100, 300) - soak)
			if(impact)
				damage += impact 
				healthcheck(0, 1)
		if(3)
			impact = max(0,rand(25, 100) - soak)
			if(impact)
				damage += impact 
				healthcheck(0, 1)

/obj/structure/showcase/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>The [src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	tforce -= soak
	if(tforce)
		damage += tforce
		healthcheck()

/obj/structure/showcase/attack_hand(mob/user as mob)
	if(HULK in user.mutations)
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] smashes through the [src]!</span>")
		damage += max(0,100 - soak)
		healthcheck(1, 1, user)

	else if(ishuman(user) && user.a_intent == "hurt")
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			attack_generic(H, 25)

/obj/structure/showcase/attack_paw(mob/user as mob)
	return attack_hand(user)

//Used by attack_animal
/obj/structure/showcase/proc/attack_generic(mob/living/user, impact = 0)
	user.animation_attack_on(src)
	user.visible_message("<span class='danger'>[user] smashes into the [src]!</span>")
	impact -= soak
	if(impact)
		damage += max(impact - soak,0)
		healthcheck(1, 1, user)

/obj/structure/fence/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	attack_generic(M, M.melee_damage_upper)

/obj/structure/showcase/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/stack/sheet/metal) && damage)
		if(user.mind && user.mind.cm_skills && user.mind.cm_skills.construction < SKILL_CONSTRUCTION_PLASTEEL)
			user << "<span class='warning'>You don't have the skill needed to fix the [src]'s structure."
			return
		var/obj/item/stack/sheet/R = W
		var/amount_needed = 1
		if(R.amount >= amount_needed)
			user.visible_message("<span class='notice'>[user] starts repairing the [src] with [R].</span>",
			"<span class='notice'>You start repairing the [src] with [R]")
			playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
			if(do_after(user, 30, TRUE, 5, BUSY_ICON_FRIENDLY))
				if(R.amount < amount_needed)
					user << "<span class='warning'>You need more metal sheets to repair [src]."
					return
				R.use(amount_needed)
				damage = 0
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message("<span class='notice'>[user] repairs [src] with [R].</span>",
				"<span class='notice'>You repair [src] with [R]")
				return
		else
			user << "<span class='warning'>You need more metal sheets to repair [src]."
			return

	if(istype(W, /obj/item/grab) && get_dist(src, user) < 2)
		var/obj/item/grab/G = W
		if(istype(G.grabbed_thing, /mob/living))
			var/mob/living/M = G.grabbed_thing
			var/state = user.grab_level
			var/impact
			user.drop_held_item()
			switch(state)
				if(GRAB_PASSIVE)
					M.visible_message("<span class='warning'>[user] slams [M] against \the [src]!</span>")
					M.apply_damage(7)
				if(GRAB_AGGRESSIVE)
					M.visible_message("<span class='danger'>[user] bashes [M] against \the [src]!</span>")
					if(prob(50))
						M.KnockDown(1)
					M.apply_damage(10)
					impact += (10 - soak)
				if(GRAB_NECK)
					M.visible_message("<span class='danger'><big>[user] crushes [M] against \the [src]!</big></span>")
					M.KnockDown(5)
					M.apply_damage(20)
					impact += (15 - soak)
			if(impact)
				damage += impact
				healthcheck(1, 1, M) //The person thrown into the showcase literally shattered it
		return

	if(W.flags_item & NOBLUDGEON) return

	if(istype(W, /obj/item/tool/weldingtool))
		user.visible_message("<span class='notice'>[user] starts cutting through [src] with [W].</span>",
		"<span class='notice'>You start cutting through [src] with [W]")
		playsound(src, 'sound/items/Welder.ogg', 25, 1)
		if(do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
			playsound(src, 'sound/items/Welder.ogg', 25, 1)
			user.visible_message("<span class='notice'>[user] cuts through [src] with [W].</span>",
			"<span class='notice'>You cut apart the [src] with [W]")
			create_debris(2)
		return
	if(istype(W, /obj/item/tool/wrench))
		if(anchored)
			user.visible_message("<span class='notice'>[user] starts loosening the [src]'s bolts with [W].</span>",
			"<span class='notice'>You start loosening the [src]'s bolts with [W]")
			playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
			if(do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message("<span class='notice'>[user] loosened the [src]'s bolts with [W].</span>",
				"<span class='notice'>You loosened the [src]'s bolts with [W]")
				anchored = 0
		else
			user.visible_message("<span class='notice'>[user] starts tightening the [src]'s bolts with [W].</span>",
			"<span class='notice'>You start tightening the [src]'s bolts with [W]")
			playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
			if(do_after(user, 20, TRUE, 5, BUSY_ICON_BUILD))
				playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
				user.visible_message("<span class='notice'>[user] tightened the [src]'s bolts with [W].</span>",
				"<span class='notice'>You tightened the [src]'s bolts with [W]")
				anchored = 1
		return	
	else
		var/strike = max(0,(W.force - soak))
		if(strike)
			damage += strike
			healthcheck(1, 1, user, W)
		..()

/obj/structure/showcase/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > T0C + 800)
		damage += round(exposed_volume / 100)
		healthcheck(0) //Don't make hit sounds, it's dumb with fire/heat
	..()


/obj/structure/monorail
	name = "monorail track"
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "monorail"
	density = 0
	anchored = 1
	layer = ATMOS_PIPE_LAYER + 0.01

/obj/structure/mopbucket
	name = "mop bucket"
	desc = "Fill it with water, but don't forget a mop!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "mopbucket"
	density = 1
	anchored = 0
	flags_atom = FPRINT|OPENCONTAINER
	var/amount_per_transfer_from_this = 5 //Shit I dunno, adding this so syringes stop runtime erroring. --NeoFite

/obj/structure/mopbucket/New()
	..()
	create_reagents(100)

/obj/structure/mopbucket/examine(mob/user)
	..()
	user << "It contains [reagents.total_volume] unit\s of water!"

/obj/structure/mopbucket/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/tool/mop))
		if(reagents.total_volume < 1)
			user << "<span class='warning'>[src] is out of water!</span>"
		else
			reagents.trans_to(I, 5)
			user << "<span class='notice'>You wet [I] in [src].</span>"
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)












//ICE COLONY RESEARCH DECORATION-----------------------//
//Most of icons made by ~Morrinn
obj/structure/xenoautopsy
	name = "Research thingies"
	icon = 'icons/obj/alien_autopsy.dmi'
	icon_state = "jarshelf_9"

obj/structure/xenoautopsy/jar_shelf
	name = "jar shelf"
	icon_state = "jarshelf_0"
	var/randomise = 1 //Random icon

	New()
		if(randomise)
			icon_state = "jarshelf_[rand(0,9)]"

obj/structure/xenoautopsy/tank
	name = "cryo tank"
	icon_state = "tank_empty"
	desc = "It is empty."

obj/structure/xenoautopsy/tank/broken
	name = "cryo tank"
	icon_state = "tank_broken"
	desc = "Something broke it..."

obj/structure/xenoautopsy/tank/alien
	name = "cryo tank"
	icon_state = "tank_alien"
	desc = "There is something big inside..."

obj/structure/xenoautopsy/tank/hugger
	name = "cryo tank"
	icon_state = "tank_hugger"
	desc = "There is something spider-like inside..."

obj/structure/xenoautopsy/tank/larva
	name = "cryo tank"
	icon_state = "tank_larva"
	desc = "There is something worm-like inside..."

obj/item/alienjar
	name = "sample jar"
	icon = 'icons/obj/alien_autopsy.dmi'
	icon_state = "jar_sample"
	desc = "Used to store organic samples inside for preservation."

	New()
		var/image/I
		I = image('icons/obj/alien_autopsy.dmi', "sample_[rand(0,11)]")
		I.layer = src.layer - 0.1
		overlays += I
		pixel_x += rand(-3,3)
		pixel_y += rand(-3,3)




//stairs

/obj/structure/stairs
	name = "Stairs"
	icon = 'icons/obj/structures/structures.dmi'
	desc = "Stairs.  You walk up and down them."
	icon_state = "rampbottom"
	density = 0
	opacity = 0

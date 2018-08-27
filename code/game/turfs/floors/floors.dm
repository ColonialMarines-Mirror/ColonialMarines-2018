//////////////////////////////////////////////////////////////////////
/turf/open/floor/plating
	name = "plating"
	icon_state = "plating"
	floor_tile = null
	intact_tile = 0

/turf/open/floor/airless
	icon_state = "floor"
	name = "airless floor"

/turf/open/floor/airless/New()
	..()
	name = "floor"

/turf/open/floor/icefloor
	icon_state = "floor"
	name = "ice colony floor"

/turf/open/floor/icefloor/New()
	..()
	name = "floor"

/turf/open/floor/light
	name = "Light floor"
	luminosity = 5
	icon_state = "light_on"
	floor_tile = new/obj/item/stack/tile/light

/turf/open/floor/light/New()
	floor_tile.New() //I guess New() isn't run on objects spawned without the definition of a turf to house them, ah well.
	var/n = name //just in case commands rename it in the ..() call
	..()
	spawn(4)
		if(src)
			update_icon()
			name = n

/turf/open/floor/wood
	name = "floor"
	icon_state = "wood"
	floor_tile = new/obj/item/stack/tile/wood

/turf/open/floor/vault
	icon_state = "rockvault"

/turf/open/floor/vault/New(location,type)
	..()
	icon_state = "[type]vault"

/turf/open/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	intact_tile = 0
	breakable_tile = FALSE
	burnable_tile = FALSE

/turf/open/floor/engine/make_plating()
	return

/turf/open/floor/engine/attackby(obj/item/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/tool/wrench))
		user.visible_message("<span class='notice'>[user] starts removing [src]'s protective cover.</span>",
		"<span class='notice'>You start removing [src]'s protective cover.</span>")
		playsound(src, 'sound/items/Ratchet.ogg', 25, 1)
		if(do_after(user, 30, TRUE, 5, BUSY_ICON_BUILD))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/open/floor)
			var/turf/open/floor/F = src
			F.make_plating()

/turf/open/floor/engine/ex_act(severity)
	switch(severity)
		if(1)
			break_tile_to_plating()
		if(2)
			if(prob(25))
				break_tile_to_plating()

/turf/open/floor/engine/nitrogen

/turf/open/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"

/turf/open/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"

/turf/open/floor/engine/mars/exterior
	name = "floor"
	icon_state = "ironsand1"

/turf/open/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/open/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"

/turf/open/floor/grass
	name = "Grass patch"
	icon_state = "grass1"
	floor_tile = new/obj/item/stack/tile/grass

/turf/open/floor/grass/New()
	floor_tile.New() //I guess New() isn't ran on objects spawned without the definition of a turf to house them, ah well.
	icon_state = "grass[pick("1","2","3","4")]"
	..()
	spawn(4)
		if(src)
			update_icon()
			for(var/direction in cardinal)
				if(istype(get_step(src,direction),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

/turf/open/floor/carpet
	name = "Carpet"
	icon_state = "carpet"
	floor_tile = new/obj/item/stack/tile/carpet

/turf/open/floor/carpet/New()
	floor_tile.New() //I guess New() isn't ran on objects spawned without the definition of a turf to house them, ah well.
	if(!icon_state)
		icon_state = "carpet"
	..()
	spawn(4)
		if(src)
			update_icon()
			for(var/direction in list(1,2,4,8,5,6,9,10))
				if(istype(get_step(src,direction),/turf/open/floor))
					var/turf/open/floor/FF = get_step(src,direction)
					FF.update_icon() //so siding get updated properly

// Start Prison tiles
/turf/open/floor/prison
	icon = 'icons/turf/prison.dmi'
	icon_state = "floor"

/turf/open/floor/prison/trim/red
	icon_state = "darkred2"

////// Mechbay //////////
/turf/open/floor/mech_bay_recharge_floor
	name = "Mech Bay Recharge Station"
	icon = 'icons/mecha/mech_bay.dmi'
	icon_state = "recharge_floor"
	var/obj/machinery/mech_bay_recharge_port/recharge_port
	var/obj/machinery/computer/mech_bay_power_console/recharge_console
	var/obj/mecha/recharging_mecha = null

/turf/open/floor/mech_bay_recharge_floor/Entered(var/obj/mecha/mecha)
	. = ..()
	if(istype(mecha))
		mecha.occupant_message("<b>Initializing power control devices.</b>")
		init_devices()
		if(recharge_console && recharge_port)
			recharging_mecha = mecha
			recharge_console.mecha_in(mecha)
			return
		else if(!recharge_console)
			mecha.occupant_message("<font color='red'>Control console not found. Terminating.</font>")
		else if(!recharge_port)
			mecha.occupant_message("<font color='red'>Power port not found. Terminating.</font>")
	return

/turf/open/floor/mech_bay_recharge_floor/Exited(atom)
	. = ..()
	if(atom == recharging_mecha)
		recharging_mecha = null
		if(recharge_console)
			recharge_console.mecha_out()
	return

/turf/open/floor/mech_bay_recharge_floor/proc/init_devices()
	if(!recharge_console)
		recharge_console = locate() in range(1,src)
	if(!recharge_port)
		recharge_port = locate() in get_step(src, WEST)

	if(recharge_console)
		recharge_console.recharge_floor = src
		if(recharge_port)
			recharge_console.recharge_port = recharge_port
	if(recharge_port)
		recharge_port.recharge_floor = src
		if(recharge_console)
			recharge_port.recharge_console = recharge_console
	return

// temporary fix for broken icon until somebody gets around to make these player-buildable
/turf/open/floor/mech_bay_recharge_floor/attackby(obj/item/C as obj, mob/user as mob)
	..()
	if(floor_tile)
		icon_state = "recharge_floor"
	else
		icon_state = "support_lattice"

/turf/open/floor/mech_bay_recharge_floor/break_tile()
	if(broken)
		return
	ChangeTurf(/turf/open/floor/plating)
	broken = TRUE
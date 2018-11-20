
obj/machinery/atmospherics/pipe/simple/heat_exchanging
	icon = 'icons/atmos/heat.dmi'
	icon_state = "intact"
	pipe_icon = "hepipe"
	level = 2
	var/initialize_directions_he
	var/surface = 2	//surface area in m^2

	minimum_temperature_difference = 20

	// BubbleWrap
	New()
		..()
		initialize_directions_he = initialize_directions	// The auto-detection from /pipe is good enough for a simple HE pipe
	// BubbleWrap END

	initialize()
		normalize_dir()
		var/node1_dir
		var/node2_dir

		for(var/direction in cardinal)
			if(direction&initialize_directions_he)
				if (!node1_dir)
					node1_dir = direction
				else if (!node2_dir)
					node2_dir = direction

		for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node1_dir))
			if(target.initialize_directions_he & get_dir(target,src))
				node1 = target
				break
		for(var/obj/machinery/atmospherics/pipe/simple/heat_exchanging/target in get_step(src,node2_dir))
			if(target.initialize_directions_he & get_dir(target,src))
				node2 = target
				break
		if(!node1 && !node2)
			cdel(src)
			return

		update_icon()
		return


	process()
		if(!parent)
			..()

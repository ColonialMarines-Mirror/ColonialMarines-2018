/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	var/obj/machinery/atmospherics/node1
	var/obj/machinery/atmospherics/node2
	var/obj/machinery/atmospherics/node3

	level = 1

/obj/machinery/atmospherics/pipe/manifold/New()
	..()
	alpha = 255
	icon = null

	switch(dir)
		if(NORTH)
			initialize_directions = EAST|SOUTH|WEST
		if(SOUTH)
			initialize_directions = WEST|NORTH|EAST
		if(EAST)
			initialize_directions = SOUTH|WEST|NORTH
		if(WEST)
			initialize_directions = NORTH|EAST|SOUTH

/obj/machinery/atmospherics/pipe/manifold/hide(var/i)
	if(level == 1 && istype(loc, /turf))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/pipeline_expansion()
	return list(node1, node2, node3)

/obj/machinery/atmospherics/pipe/manifold/process()
	if(!parent)
		..()
	else
		//. = PROCESS_KILL
		stop_processing()

/obj/machinery/atmospherics/pipe/manifold/Dispose()
	var/obj/machinery/atmospherics/n1 = node1
	var/obj/machinery/atmospherics/n2 = node2
	var/obj/machinery/atmospherics/n3 = node3
	n1?.disconnect(src)
	n2?.disconnect(src)
	n3?.disconnect(src)
	. = ..()
	n1?.build_network()
	n2?.build_network()
	n3?.build_network()

/obj/machinery/atmospherics/pipe/manifold/disconnect(obj/machinery/atmospherics/reference)
	if(reference == node1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			del(parent)
		node1 = null

	if(reference == node2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			del(parent)
		node2 = null

	if(reference == node3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			del(parent)
		node3 = null

	update_icon()

	..()

/obj/machinery/atmospherics/pipe/manifold/change_color(var/new_color)
	..()
	//for updating connected atmos device pipes (i.e. vents, manifolds, etc)
	if(node1)
		node1.update_underlays()
	if(node2)
		node2.update_underlays()
	if(node3)
		node3.update_underlays()

/obj/machinery/atmospherics/pipe/manifold/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	if(!node1 && !node2 && !node3)
		var/turf/T = get_turf(src)
		new /obj/item/pipe(loc, make_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.target == src)
				new /obj/item/pipe_meter(T)
				cdel(meter)
		cdel(src)
	else
		overlays.Cut()
		overlays += icon_manager.get_atmos_icon("manifold", , pipe_color, "core" + icon_connect_type)
		overlays += icon_manager.get_atmos_icon("manifold", , , "clamps" + icon_connect_type)
		underlays.Cut()

		var/turf/T = get_turf(src)
		var/list/directions = list(NORTH, SOUTH, EAST, WEST)
		var/node1_direction = get_dir(src, node1)
		var/node2_direction = get_dir(src, node2)
		var/node3_direction = get_dir(src, node3)

		directions -= dir

		directions -= add_underlay(T,node1,node1_direction,icon_connect_type)
		directions -= add_underlay(T,node2,node2_direction,icon_connect_type)
		directions -= add_underlay(T,node3,node3_direction,icon_connect_type)

		for(var/D in directions)
			add_underlay(T,,D,icon_connect_type)


/obj/machinery/atmospherics/pipe/manifold/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/initialize()
	var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					var/c = check_connect_types(target,src)
					if (c)
						target.connected_to = c
						src.connected_to = c
						node1 = target
						connect_directions &= ~direction
						break
			if (node1)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					var/c = check_connect_types(target,src)
					if (c)
						target.connected_to = c
						src.connected_to = c
						node2 = target
						connect_directions &= ~direction
						break
			if (node2)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/target in get_step(src,direction))
				if(target.initialize_directions & get_dir(target,src))
					var/c = check_connect_types(target,src)
					if (c)
						target.connected_to = c
						src.connected_to = c
						node3 = target
						connect_directions &= ~direction
						break
			if (node3)
				break

	if(!node1 && !node2 && !node3)
		cdel(src)
		return

	var/turf/T = get_turf(src)
	if(istype(T))
		hide(T.intact_tile)
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = 2

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = list(3)
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = list(2)
	layer = ATMOS_PIPE_SUPPLY_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = list(3)
	layer = ATMOS_PIPE_SCRUBBER_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = list(2)
	layer = ATMOS_PIPE_SUPPLY_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/machinery/atmospherics/pipe/manifold/hidden/purple
	color = PIPE_COLOR_PURPLE

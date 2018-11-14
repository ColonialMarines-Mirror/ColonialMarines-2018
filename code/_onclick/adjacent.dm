/*
	Adjacency proc for determining touch range

	This is mostly to determine if a user can enter a square for the purposes of touching something.
	Examples include reaching a square diagonally or reaching something on the other side of a glass window.

	This is calculated by looking for border items, or in the case of clicking diagonally from yourself, dense items.
	This proc will NOT notice if you are trying to attack a window on the other side of a dense object in its turf.  There is a window helper for that.

	Note that in all cases the neighbor is handled simply; this is usually the user's mob, in which case it is up to you
	to check that the mob is not inside of something
*/
/atom/proc/Adjacent(var/atom/neighbor) // basic inheritance, unused
	return 0

// Not a sane use of the function and (for now) indicative of an error elsewhere
/area/Adjacent(var/atom/neighbor)
	CRASH("Call to /area/Adjacent(), unimplemented proc")


/*
	Adjacency (to turf):
	* If you are in the same turf, always true
	* If you are vertically/horizontally adjacent, ensure there are no border objects
	* If you are diagonally adjacent, ensure you can pass through at least one of the mutually adjacent square.
		* Passing through in this case ignores anything with the throwpass flag, such as tables, racks, and morgue trays.
*/
/turf/Adjacent(atom/neighbor, atom/target = null, atom/movable/mover = null)
	var/turf/T0 = get_turf(neighbor)
	if(T0 == src)
		return TRUE
	if(!T0 || get_dist(src,T0) > 1 || z != T0.z) //too far
		return FALSE
	// Non diagonal case
	if(T0.x == x || T0.y == y)
		// Check for border blockages
		return T0.ClickCross(get_dir(T0,src), TRUE, target, mover) && ClickCross(get_dir(src,T0), TRUE, target, mover)
	// Diagonal case
	var/in_dir = get_dir(T0,src)	// eg. northwest	(1+8) = 9 (00001001)
	var/d1 = in_dir & 3				// eg. north		(1+8) & 3 (0000 0011) = 1 (0000 0001)
	var/d2 = in_dir & 12			// eg. west			(1+8) & 12 (0000 1100) = 8 (0000 1000)
	for(var/d in list(d1,d2))
		if(!T0.ClickCross(d, TRUE, target, mover))
			continue // could not leave T0 in that direction
		var/turf/T1 = get_step(T0,d)
		if(!T1 || T1.density)
			continue
		if(!T1.ClickCross(get_dir(T1,src), FALSE, target, mover) || !T1.ClickCross(get_dir(T1,T0), FALSE, target, mover))
			continue // couldn't enter or couldn't leave T1
		if(!ClickCross(get_dir(src,T1), TRUE, target, mover))
			continue // could not enter src
		return TRUE // we don't care about our own density
	return FALSE

/*
Quick adjacency (to turf):
* If you are in the same turf, always true
* If you are not adjacent, then false
*/
/turf/proc/AdjacentQuick(atom/neighbor, atom/target = null)
	var/turf/T0 = get_turf(neighbor)
	if(T0 == src)
		return TRUE
	if(get_dist(src,T0) > 1)
		return FALSE
	return TRUE

/*
	Adjacency (to anything else):
	* Must be on a turf (can be inside a container, just not in nullspace)
	* In the case of a multiple-tile object, all valid locations are checked for adjacency.

	Note: Multiple-tile objects are created when the bound_width and bound_height are creater than the tile size.
	This is not used in stock /tg/station currently.
*/
/atom/movable/Adjacent(atom/neighbor)
	if(!neighbor)
		return FALSE
	var/turf/source_loc
	for(var/S in locs) // To account for multi-tiles
		if(!(source_loc = get_turf(S))) // Check if not in nullspace
			continue
		if(source_loc.Adjacent(neighbor)) // Turf redefinition of the proc, not recursive
			return TRUE
	return FALSE
/*
	Special case: This allows you to reach a door when it is visally on top of,
	but technically behind, a fire door

	You could try to rewrite this to be faster, but I'm not sure anything would be.
	This can be safely removed if border firedoors are ever moved to be on top of doors
	so they can be interacted with without opening the door.
*/
/obj/machinery/door/Adjacent(atom/neighbor)
	var/obj/machinery/door/firedoor/border_only/BOD = locate() in loc
	if(BOD)
		BOD.throwpass = TRUE // allow click to pass
		. = ..()
		BOD.throwpass = FALSE
		return .
	else
		return ..()
/*
	This checks if you there is uninterrupted airspace between that turf and this one.
	This is defined as any dense ON_BORDER object, or any dense object without throwpass.
	The border_only flag allows you to not objects (for source and destination squares)
*/
/turf/proc/ClickCross(target_dir, border_only, target_atom = null, atom/movable/mover = null)
	for(var/obj/O in src)
		if(mover && O.CanPass(mover,get_step(src,target_dir)) || !mover && !O.density)
			continue // throwpass is used for anything you can click through
		if(O == target_atom || O == mover || O.throwpass) //check if there's a dense object present on the turf
			continue // LETPASSTHROW is used for anything you can click through (or the firedoor special case, see above)
		if(O.flags_atom & ON_BORDER) // windows have throwpass but are on border, check them first
			if(O.dir & target_dir || O.dir & (O.dir-1)) // full tile windows are just diagonals mechanically
				return target_atom?.ClickCross_not_full_window()
		else if(!border_only) // dense, not on border, cannot pass over
			return FALSE
	return TRUE

/atom/proc/ClickCross_not_full_window()
	return FALSE

/obj/structure/window/ClickCross_not_full_window()
	if(is_full_window())
		return FALSE
	else
		return TRUE

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
	return FALSE

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
/turf/Adjacent(atom/neighbor, target_atom = null)
	var/turf/T0 = get_turf(neighbor)
	if(!T0 || !loc) //Unlikely, but one of us is in nullspace or a null input was passed. Abort.
		return
	if(T0 == src)
		return TRUE
	if(get_dist(src,T0) > 1 || z != T0.z) //too far
		return FALSE
	// Non diagonal case
	if(T0.x == x || T0.y == y)
		// Check for border blockages
		return T0.ClickCross(get_dir(T0,src), TRUE, target_atom) && ClickCross(get_dir(src,T0), TRUE, target_atom)
	// Diagonal case
	var/in_dir = get_dir(T0,src)	// eg. northwest	(1+8) = 9 (00001001)
	var/d1 = in_dir & 3				// eg. north		(1+8) & 3 (0000 0011) = 1 (0000 0001)
	var/d2 = in_dir & 12			// eg. west			(1+8) & 12 (0000 1100) = 8 (0000 1000)
	for(var/d in list(d1,d2))
		if(!T0.ClickCross(d, TRUE, target_atom))
			continue // could not leave T0 in that direction
		var/turf/T1 = get_step(T0,d)
		if(!T1 || T1.density)
			continue
		if(!T1.ClickCross(get_dir(T1,src), FALSE, target_atom) || !T1.ClickCross(get_dir(T1,T0), FALSE, target_atom))
			continue // couldn't enter or couldn't leave T1
		if(!ClickCross(get_dir(src,T1), TRUE, target_atom))
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
	var/turf/source_loc = get_turf(loc) // They could be inside containers
	if(source_loc?.Adjacent(neighbor)) // Turf redefinition of the proc, not recursive
		return TRUE
	return FALSE

/obj/item/Adjacent(atom/neighbor)
	var/turf/source_loc = get_turf(loc) // They could be inside containers
	if(source_loc == get_turf(neighbor)) // Items have a high chance of being in someone's contents
		return TRUE
	if(source_loc?.Adjacent(neighbor)) // Turf redefinition of the proc, not recursive
		return TRUE
	return FALSE
/*
	Multi-tile adjacency:
*/
/obj/structure/Adjacent(atom/neighbor) // Several structures are multi-tiles
	for(var/S in locs) // To account for multi-tiles
		var/turf/source_loc = get_turf(S)
		if(source_loc?.Adjacent(neighbor, src))
			return TRUE

/obj/machinery/door/Adjacent(atom/neighbor) // Some doors are multi-tiles
	for(var/S in locs) // To account for multi-tiles
		var/turf/source_loc = get_turf(S)
		if(source_loc?.Adjacent(neighbor, src)) // Pass the source in case of windoors
			return TRUE

/mob/living/silicon/decoy/Adjacent(atom/neighbor) // The one multi-tile mob exception, an odd one
	for(var/S in locs) // To account for multi-tiles
		var/turf/source_loc = get_turf(S)
		if(source_loc?.Adjacent(neighbor)) // Turf redefinition of the proc, not recursive
			return TRUE
/*
	This checks if you there is uninterrupted airspace between that turf and this one.
	This is defined as any dense ON_BORDER object, or any dense object without throwpass.
	The border_only flag allows you to not objects (for source and destination squares)
*/
/turf/proc/ClickCross(target_dir, border_only, target_atom = null)
	for(var/obj/O in src)
		if(!O.density || O.throwpass || O == target_atom) //check if there's a dense object present on the turf
			continue // throwpass is used for anything you can click through
		if(O.flags_atom & ON_BORDER) // windows are on border, check them first
			if(O.dir & target_dir || O.dir & (O.dir-1)) // full tile windows are just diagonals mechanically
				return FALSE
		else if(!border_only) // dense, not on border, cannot pass over
			return FALSE
	return TRUE

/atom/proc/handle_barriers(mob/living/M)
	for(var/obj/structure/S in M.loc)
		if(S.flags_atom & ON_BORDER && S.dir & get_dir(M,src) || S.dir&(S.dir-1))
			if(S.flags_barrier & HANDLE_BARRIER_CHANCE)
				if(S.handle_barrier_chance(M))
					return S // blocked
	for(var/obj/structure/S in loc)
		if(S.flags_atom & ON_BORDER && S.dir & get_dir(src,M) || S.dir&(S.dir-1))
			if(S.flags_barrier & HANDLE_BARRIER_CHANCE)
				if(S.handle_barrier_chance(M))
					return S // blocked
	return src // not blocked

/turf/handle_barriers(mob/living/M)
	return src
	
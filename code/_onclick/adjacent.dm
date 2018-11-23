/*
	Adjacency proc for determining touch range

	This is mostly to determine if a user can enter a square for the purposes of touching something.
	Examples include reaching a square diagonally or reaching something on the other side of a glass window.

	This is calculated by looking for border items, or in the case of clicking diagonally from yourself, dense items.
	This proc will NOT notice if you are trying to attack a window on the other side of a dense object in its turf.  There is a window helper for that.

	Note that in all cases the neighbor is handled simply; this is usually the user's mob, in which case it is up to you
	to check that the mob is not inside of something
*/
var/static/Adjacent_swap = FALSE

/atom/proc/Adjacent(atom/neighbor, target_atom = null) // basic inheritance, unused
	Adjacent_swap = !Adjacent_swap
	if(Adjacent_swap)
		return Adjacent_Holder_New(neighbor, target_atom)
	else
		return Adjacent_Holder_Old(neighbor, target_atom)

/atom/proc/Adjacent_Holder_New(atom/neighbor, target_atom = null)
	return Adjacent_New(neighbor, target_atom)

/atom/proc/Adjacent_Holder_Old(atom/neighbor, target_atom = null)
	return Adjacent_Old(neighbor, target_atom)

/atom/proc/Adjacent_New()
	return FALSE

/atom/proc/Adjacent_Old()
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
/turf/Adjacent_New(atom/neighbor, target_atom = null)
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
		return T0.ClickCross_New(get_dir(T0,src), TRUE, target_atom) && ClickCross_New(get_dir(src,T0), TRUE, target_atom)
	// Diagonal case
	var/in_dir = get_dir(T0,src)	// eg. northwest	(1+8) = 9 (00001001)
	var/d1 = in_dir & 3				// eg. north		(1+8) & 3 (0000 0011) = 1 (0000 0001)
	var/d2 = in_dir & 12			// eg. west			(1+8) & 12 (0000 1100) = 8 (0000 1000)
	for(var/d in list(d1,d2))
		if(!T0.ClickCross_New(d, TRUE, target_atom))
			continue // could not leave T0 in that direction
		var/turf/T1 = get_step(T0,d)
		if(!T1 || T1.density)
			continue
		if(!T1.ClickCross_New(get_dir(T1,src), FALSE, target_atom) || !T1.ClickCross_New(get_dir(T1,T0), FALSE, target_atom))
			continue // couldn't enter or couldn't leave T1
		if(!ClickCross_New(get_dir(src,T1), TRUE, target_atom))
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
/atom/movable/Adjacent_New(atom/neighbor)
	var/turf/source_loc = get_turf(loc) // They could be inside containers
	if(source_loc?.Adjacent_New(neighbor)) // Turf redefinition of the proc, not recursive
		return TRUE
	return FALSE

/obj/item/Adjacent_New(atom/neighbor)
	var/turf/source_loc = get_turf(loc) // They could be inside containers
	if(source_loc == get_turf(neighbor)) // Items have a high chance of being in someone's contents
		return TRUE
	if(source_loc?.Adjacent_New(neighbor)) // Turf redefinition of the proc, not recursive
		return TRUE
	return FALSE
/*
	Multi-tile adjacency:
*/
/obj/structure/Adjacent_New(atom/neighbor) // Several structures are multi-tiles
	for(var/S in locs) // To account for multi-tiles
		var/turf/source_loc = get_turf(S)
		if(source_loc?.Adjacent_New(neighbor, src))
			return TRUE

/obj/machinery/door/Adjacent_New(atom/neighbor) // Some doors are multi-tiles
	for(var/S in locs) // To account for multi-tiles
		var/turf/source_loc = get_turf(S)
		if(source_loc?.Adjacent_New(neighbor, src)) // Pass the source in case of windoors
			return TRUE

/mob/living/silicon/decoy/Adjacent_New(atom/neighbor) // The one multi-tile mob exception, an odd one
	for(var/S in locs) // To account for multi-tiles
		var/turf/source_loc = get_turf(S)
		if(source_loc?.Adjacent_New(neighbor)) // Turf redefinition of the proc, not recursive
			return TRUE
/*
	This checks if you there is uninterrupted airspace between that turf and this one.
	This is defined as any dense ON_BORDER object, or any dense object without throwpass.
	The border_only flag allows you to not objects (for source and destination squares)
*/
/turf/proc/ClickCross_New(target_dir, border_only, target_atom = null)
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

/turf/Adjacent_Old(var/atom/neighbor, var/atom/target = null)
	var/turf/T0 = get_turf(neighbor)
	if(T0 == src)
		return 1
	if(get_dist(src,T0) > 1)
		return 0

	if(T0.x == x || T0.y == y)
		// Check for border blockages
		return T0.ClickCross_Old(get_dir(T0,src), border_only = 1) && src.ClickCross_Old(get_dir(src,T0), border_only = 1, target_atom = target)

	// Not orthagonal
	var/in_dir = get_dir(neighbor,src) // eg. northwest (1+8)
	var/d1 = in_dir&(in_dir-1)		// eg west		(1+8)&(8) = 8
	var/d2 = in_dir - d1			// eg north		(1+8) - 8 = 1

	for(var/d in list(d1,d2))
		if(!T0.ClickCross_Old(d, border_only = 1))
			continue // could not leave T0 in that direction

		var/turf/T1 = get_step(T0,d)
		if(!T1 || T1.density || !T1.ClickCross_Old(get_dir(T1,T0)|get_dir(T1,src), border_only = 0))
			continue // couldn't enter or couldn't leave T1

		if(!src.ClickCross_Old(get_dir(src,T1), border_only = 1, target_atom = target))
			continue // could not enter src

		return 1 // we don't care about our own density
	return 0

/atom/movable/Adjacent_Old(var/atom/neighbor)
	if(neighbor == loc) return 1
	if(!isturf(loc)) return 0
	for(var/turf/T in locs)
		if(isnull(T)) continue
		if(T.Adjacent_Old(neighbor,src)) return 1
	return 0

/obj/Adjacent_Old(var/atom/neighbor)
	if(neighbor == loc)
		return 1
	var/turf/T = get_turf(loc)
	if(!T)
		return 0
	return (T.Adjacent_Old(neighbor,src))

// This is necessary for storage items not on your person.
/obj/item/Adjacent_Old(var/atom/neighbor, var/recurse = 1)
	if(neighbor == loc)
		return 1
	if(istype(loc,/obj/item))
		if(recurse > 0)
			return loc.Adjacent_Old(neighbor,recurse - 1)
		return 0
	return ..()

/obj/machinery/door/Adjacent_Old(var/atom/neighbor)
	var/obj/machinery/door/firedoor/border_only/BOD = locate() in loc
	if(BOD)
		BOD.throwpass = 1 // allow click to pass
		. = ..()
		BOD.throwpass = 0
		return .
	return ..()

/turf/proc/ClickCross_Old(var/target_dir, var/border_only, var/target_atom = null)
	for(var/obj/O in src)
		if( !O.density || O == target_atom || O.throwpass) continue // throwpass is used for anything you can click through

		if( O.flags_atom & ON_BORDER) // windows have throwpass but are on border, check them first
			if( O.dir & target_dir || O.dir&(O.dir-1) ) // full tile windows are just diagonals mechanically
				var/obj/structure/window/W = target_atom
				if(istype(W))
					if(!W.is_full_window())	//exception for breaking full tile windows on top of single pane windows
						return 0
				else
					return 0

		else if( !border_only ) // dense, not on border, cannot pass over
			return 0
	return 1
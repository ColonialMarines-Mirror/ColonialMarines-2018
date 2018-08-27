/turf/open
	var/is_groundmap_turf = FALSE //whether this a turf used as main turf type for the 'outside' of a map.
	var/allow_construction = TRUE //whether you can build things like barricades on this turf.
	var/slayer = 0 //snow layer
	var/wet	 //whether the turf is wet (only used by floors).
	var/weedable //>using procs, REE!

/turf/open/Entered(atom/A, atom/OL)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(!C.lying && !(C.buckled && istype(C.buckled,/obj/structure/bed/chair)))
			if(ishuman(C))
				var/mob/living/carbon/human/H = C

				// Tracking blood
				var/list/bloodDNA = null
				var/bloodcolor=""
				if(H.shoes)
					var/obj/item/clothing/shoes/S = H.shoes
					if(S.track_blood && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
				else
					if(H.track_blood && H.feet_blood_DNA)
						bloodDNA = H.feet_blood_DNA
						bloodcolor=H.feet_blood_color
						H.track_blood--

				if (bloodDNA && !locate(/obj/structure) in contents)
					src.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,H.dir,0,bloodcolor) // Coming
					var/turf/from = get_step(H,reverse_direction(H.dir))
					if(istype(from) && from)
						from.AddTracks(/obj/effect/decal/cleanable/blood/tracks/footprints,bloodDNA,0,H.dir,bloodcolor) // Going

					bloodDNA = null

			switch (wet)
				if(FLOOR_WET_WATER)
					if(!C.slip(null, 5, 3, TRUE))
						C.inertia_dir = 0

				if(FLOOR_WET_LUBE) //lube
					if(C.slip(null, 10, 10, FALSE, TRUE, 4))
						C.take_limb_damage(2)

				if(FLOOR_WET_ICE) // Ice
					if(!C.slip("icy floor", 4, 3, FALSE, TRUE, 1))
						C.inertia_dir = 0
	..()

/turf/open/examine(mob/user)
	..()
	ceiling_desc(user)
#define LINKIFY_READY(string, value) "<a href='byond://?src=\ref[src];ready=[value]'>[string]</a>"
/mob/new_player
	var/ready = PLAYER_NOT_READY //default
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/totalPlayers = 0		 //Player counts for the Lobby tab
	var/totalPlayersReady = 0
	universal_speak = 1

	invisibility = 101
	density = FALSE
	stat = DEAD
	canmove = FALSE
	anchored = TRUE	//  don't get pushed around

/mob/new_player/New()
	mob_list += src

/mob/new_player/proc/version_check()
	if((client.byond_version < world.byond_version) || ((client.byond_version == world.byond_version) && (client.byond_build < world.byond_build)))
		client << "<span class='warning'>Your version of Byond differs from the server (v[world.byond_version].[world.byond_build]). You may experience graphical glitches, crashes, or other errors. You will be disconnected until your version matches or exceeds the server version.<br> \
		Direct Download (Windows Installer): http://www.byond.com/download/build/[world.byond_version]/[world.byond_version].[world.byond_build]_byond.exe <br> \
		Other versions (search for [world.byond_build] or higher): http://www.byond.com/download/build/[world.byond_version]</span>"
		cdel(client)

/mob/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()

/mob/new_player/proc/new_player_panel_proc()
	var/output = "<center><p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!ticker || !ticker.mode || ticker.current_state <= GAME_STATE_PREGAME)
		switch(ready)
			if(PLAYER_NOT_READY)
				output += "<p>\[ [LINKIFY_READY("Ready", PLAYER_READY_TO_PLAY)] | <b>Not Ready</b> | [LINKIFY_READY("Observe", PLAYER_READY_TO_OBSERVE)] \]</p>"
			if(PLAYER_READY_TO_PLAY)
				output += "<p>\[ <b>Ready</b> | [LINKIFY_READY("Not Ready", PLAYER_NOT_READY)] | [LINKIFY_READY("Observe", PLAYER_READY_TO_OBSERVE)] \]</p>"
			if(PLAYER_READY_TO_OBSERVE)
				output += "<p>\[ [LINKIFY_READY("Ready", PLAYER_READY_TO_PLAY)] | [LINKIFY_READY("Not Ready", PLAYER_NOT_READY)] | <b> Observe </b> \]</p>"
	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join the USCM!</A></p>"
		output += "<p><a href='byond://?src=\ref[src];late_join_xeno=1'>Join the Hive!</A></p>"
		if(ticker.mode.flags_round_type & MODE_PREDATOR)
			if(ticker.mode.check_predator_late_join(src,0)) output += "<p><a href='byond://?src=\ref[src];late_join_pred=1'>Join the Hunt!</A></p>"
		output += "<p>[LINKIFY_READY("Observe", PLAYER_READY_TO_OBSERVE)]</p>"

	if(!IsGuestKey(src.key))
		establish_db_connection()
		if(dbcon.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/DBQuery/query = dbcon.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break
			output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A>[newpoll?" (NEW!)":""]</b></p>"

	output += "</div>"

	var/datum/browser/popup = new(src, "playersetup", "<div align='center'>New Player Options</div>", 250, 265)
	popup.set_window_options("can_close=0")
	popup.set_content(output)
	popup.open(0)

/mob/new_player/Stat()
	if (!..())
		return FALSE

	stat("Map:", "[map_tag]")
	if(ticker.hide_mode)
		stat("Game Mode:", "Colonial Marines")
	else
		if(ticker.hide_mode == 0)
			stat("Game Mode:", "[master_mode]") // Old setting for showing the game mode

	if(ticker.current_state == GAME_STATE_PREGAME)
		stat("Time To Start:", "[ticker.pregame_timeleft][going ? "" : " (DELAYED)"]")
		stat("Players: [totalPlayers]", "Players Ready: [totalPlayersReady]")
		totalPlayers = 0
		totalPlayersReady = 0
		for(var/mob/new_player/player in player_list)
			stat("[player.key]", (player.ready == PLAYER_READY_TO_PLAY)?("(Playing)"):(null))
			totalPlayers++
			if(player.ready == PLAYER_READY_TO_PLAY)
				totalPlayersReady++
	return TRUE

/mob/new_player/Topic(href, href_list[])
	if(src != usr)
		return 0
	if(!client)
		return

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return 1

	if(href_list["ready"])
		var/tready = text2num(href_list["ready"])
		//Avoid updating ready if we're after PREGAME (they should use latejoin instead)
		//This is likely not an actual issue but I don't have time to prove that this
		//no longer is required
		if(ticker.current_state <= GAME_STATE_PREGAME)
			ready = tready
		//if it's post initialisation and they're trying to observe we do the needful
		if(!ticker.current_state < GAME_STATE_PREGAME && tready == PLAYER_READY_TO_OBSERVE)
			ready = tready
			make_me_an_observer()
			return

	if(href_list["refresh"])
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel_proc()

	if(href_list["late_join"])
		if(!ticker || ticker.current_state != GAME_STATE_PLAYING || !ticker.mode)
			src << "<span class='warning'>The round is either not ready, or has already finished...</span>"
			return
		if(ticker.mode.flags_round_type	& MODE_NO_LATEJOIN)
			src << "<span class='warning'>Sorry, you cannot late join during [ticker.mode.name]. You have to start at the beginning of the round. You may observe or try to join as an alien, if possible.</span>"
			return

		if(client.prefs.species != "Human")
			if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return

			var/datum/species/S = all_species[client.prefs.species]
			if(!(S.flags & IS_WHITELISTED))
				src << alert("Your current species,[client.prefs.species], is not available for play on the station.")
				return
		LateChoices()

	if(href_list["late_join_xeno"])
		if(!ticker || ticker.current_state != GAME_STATE_PLAYING || !ticker.mode)
			src << "<span class='warning'>The round is either not ready, or has already finished...</span>"
			return

		if(alert(src,"Are you sure you want to attempt joining as a xenomorph?","Confirmation","Yes","No") == "Yes" )
			if(ticker.mode.check_xeno_late_join(src))
				var/mob/new_xeno = ticker.mode.attempt_to_join_as_xeno(src, 0)
				if(new_xeno)
					close_spawn_windows(new_xeno)
					ticker.mode.transfer_xeno(src, new_xeno)

	if(href_list["late_join_pred"])
		if(!ticker || ticker.current_state != GAME_STATE_PLAYING || !ticker.mode)
			src << "<span class='warning'>The round is either not ready, or has already finished...</span>"
			return

		if(alert(src,"Are you sure you want to attempt joining as a predator?","Confirmation","Yes","No") == "Yes" )
			if(ticker.mode.check_predator_late_join(src,0))
				close_spawn_windows()
				ticker.mode.attempt_to_join_as_predator(src)
			else
				src << "<span class='warning'>You are no longer able to join as predator.</span>"
				new_player_panel()

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])
		if(!enter_allowed)
			usr << "<span class='warning'>There is an administrative lock on entering the game!</span>"
			return

		if(client.prefs.species != "Human")
			if(!is_alien_whitelisted(src, client.prefs.species) && config.usealienwhitelist)
				src << alert("You are currently not whitelisted to play [client.prefs.species].")
				return 0

			var/datum/species/S = all_species[client.prefs.species]
			if(!(S.flags & IS_WHITELISTED))
				src << alert("Your current species,[client.prefs.species], is not available for play on the station.")
				return 0

		AttemptLateSpawn(href_list["job_selected"],client.prefs.spawnpoint)
		return

	if(href_list["showpoll"])
		handle_player_polling()
		return

	else
		if(!ready && href_list["preference"])
			if(client) client.prefs.process_link(src, href_list)
		else new_player_panel()

/mob/new_player/proc/make_me_an_observer()
	if(!src.client) //we dont have QDELETED
		ready = PLAYER_NOT_READY
		return FALSE

	var/this_is_like_playing_right = alert(src,"Are you sure you wish to observe? You will not be able to play this round!","Player Setup","Yes","No")

	if(!src.client || this_is_like_playing_right != "Yes")
		ready = PLAYER_NOT_READY
		src << browse(null, "window=playersetup") //closes the player setup window
		new_player_panel()
		return FALSE

	var/mob/dead/observer/observer = new()
	spawning = TRUE

	observer.started_as_observer = TRUE
	close_spawn_windows()
	var/obj/O = locate("landmark*Observer-Start")
	src << "<span class='notice'>Now teleporting.</span>"
	if(O)
		observer.forceMove(O.loc)
	else
		src << "<span class='notice'>Teleporting failed. Ahelp an admin please</span>"
		error("There's no freaking observer landmark available on this map or you're making observers before the map is initialised")
	observer.key = key
	observer.client = client
	//observer.set_ghost_appearance()
	if(observer.client && observer.client.prefs)
		observer.real_name = observer.client.prefs.real_name
		observer.name = observer.real_name
	//observer.update_icon()
	observer << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1)
	//observer.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	//QDEL_NULL(mind)
	cdel(src)
	return TRUE

/mob/new_player/proc/AttemptLateSpawn(rank, spawning_at)
	if (src != usr)
		return
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		usr << "<span class='warning'>The round is either not ready, or has already finished!<spawn>"
		return
	if(!enter_allowed)
		usr << "<span class='warning'>There is an administrative lock on entering the game!<spawn>"
		return
	if(!RoleAuthority.assign_role(src, RoleAuthority.roles_for_mode[rank], 1))
		src << alert("[rank] is not available. Please try another.")
		return

	spawning = 1
	close_spawn_windows()

	var/datum/spawnpoint/S //We need to find a spawn location for them.
	var/turf/T
	if(spawning_at)
		S = spawntypes[spawning_at]
	if(istype(S))
		T = pick(S.turfs)
	else
		T = pick(latejoin)

	var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
	RoleAuthority.equip_role(character, RoleAuthority.roles_for_mode[rank], T)
	UpdateFactionList(character)
	EquipCustomItems(character)

	ticker.mode.latespawn(character)
	data_core.manifest_inject(character)
	ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
	ticker.mode.latejoin_tally++

	for(var/datum/squad/sq in RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(clients.len)
			sq.max_medics = medic_slot_formula(clients.len)

	if(ticker.mode.latejoin_larva_drop && ticker.mode.latejoin_tally >= ticker.mode.latejoin_larva_drop)
		ticker.mode.latejoin_tally -= ticker.mode.latejoin_larva_drop
		ticker.mode.stored_larva++
	cdel(src)

/mob/new_player/proc/AnnounceArrival(var/mob/living/carbon/human/character, var/rank, var/join_message)
	if(ticker.current_state == GAME_STATE_PLAYING)
		var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)// BS12 EDIT Arrivals Announcement Computer, rather than the AI.
		if(character.mind.role_alt_title) rank = character.mind.role_alt_title
		a.autosay("[character.real_name],[rank ? " [rank]," : " visitor," ] [join_message ? join_message : "has arrived on the station"].", "Arrivals Announcement Computer")
		cdel(a)

/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000
	var/dat = "<center>Round Duration: [round(hours)]h [round(mins)]m<br>"

	if(EvacuationAuthority)
		switch(EvacuationAuthority.evac_status)
			if(EVACUATION_STATUS_INITIATING)
				dat += "<font color='red'><b>The [MAIN_SHIP_NAME] is being evacuated.</b></font><br>"
			if(EVACUATION_STATUS_COMPLETE)
				dat += "<font color='red'>The [MAIN_SHIP_NAME] has undergone evacuation.</font><br>"

	dat += "Choose from the following open positions:<br>"
	for(var/i in RoleAuthority.roles_for_mode)
		var/datum/job/J = RoleAuthority.roles_for_mode[i]
		if(!RoleAuthority.check_role_entry(src, J, 1))
			continue
		var/active = 0 // Only players with the job assigned and AFK for less than 10 minutes count as active
		for(var/mob/M in player_list)
			if(M.mind && M.client && M.mind.assigned_role == J.title && M.client.inactivity <= 10 * 60 * 10)
				active++
		dat += "<a href='byond://?src=\ref[src];SelectedJob=1;job_selected=[J.title]'>[J.disp_title] ([J.current_positions]) (Active: [active])</a><br>"
	dat += "</center>"

	var/datum/browser/popup = new(src, "latechoices", "<center>Choose Profession</center>", 440, 500)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(dat)
	popup.open(0) // 0 is passed to open so that it doesn't use the onclose() proc

/mob/new_player/proc/create_character()
	spawning = 1
	close_spawn_windows()
	var/mob/living/carbon/human/new_character
	var/datum/species/chosen_species

	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
	if(chosen_species) // Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new(loc, client.prefs.species)
	if(!new_character)
		new_character = new(loc)
	new_character.lastarea = get_area(loc)
	var/datum/language/chosen_language
	if(client.prefs.language)
		chosen_language = all_languages["[client.prefs.language]"]
	if(chosen_language)
		if(is_alien_whitelisted(src, client.prefs.language) || !config.usealienwhitelist || !(chosen_language.flags & WHITELISTED) || (new_character.species && (chosen_language.name in new_character.species.secondary_langs)))
			new_character.add_language("[client.prefs.language]")
	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_for(new_character)
	else
		client.prefs.copy_to(new_character)
	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)		//won't transfer key since the mind is not active
	new_character.name = real_name
	new_character.dna.ready_dna(new_character)

	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED
	// And uncomment this, too.
	//new_character.dna.UpdateSE()
	new_character.regenerate_icons() // Do the initial caching of the player's body icons.
	new_character.key = key		//Manually transfer the key to log them in

	if(new_character.client)
		new_character.client.change_view(world.view)
	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4>Crew Manifest:</h4>"
	dat += data_core.get_manifest(OOC = 1)

	src << browse(dat, "window=manifest;size=400x420;can_close=1")

/mob/new_player/Move()
	return 0

/mob/new_player/proc/close_spawn_windows()
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // Stops lobby music.
	src << browse(null, "window=latechoices") //closes late choices window
	src << browse(null, "window=playersetup") //closes the player setup window
	src << browse(null, "window=preferences") //closes job selection
	src << browse(null, "window=mob_occupation")
	src << browse(null, "window=latechoices") //closes late job selection

/mob/new_player/proc/has_admin_rights()
	return client.holder.rights & R_ADMIN

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S)
		return 1
	return is_alien_whitelisted(src, S.name) || !config.usealienwhitelist || !(S.flags & IS_WHITELISTED)

/mob/new_player/get_species()
	var/datum/species/chosen_species

	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]
	if(!chosen_species)
		return "Human"
	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"

/mob/new_player/get_gender()
	if(!client || !client.prefs)
		..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/client/proc/play_imported_sound(S as sound)
	set category = "Fun"
	set name = "Play Imported Sound"
	set desc = "Play a sound imported from anywhere on your computer."

	if(!check_rights(R_SOUNDS))
		return
	var/vol = input(usr, "What volume would you like the sound to play at?",, 100) as null|num
	if(!vol)
		return
	var/sound/admin_sound = new()
	admin_sound.priority = 250
	admin_sound.file = S
	admin_sound.volume = vol
	admin_sound.channel = 777

	var/res = alert(usr, "Show the title of this song to the players?",, "Yes","No", "Cancel")
	switch(res)
		if("Yes")
			world << "<b><font color='#002eb9' size='2'>An admin played: [S]</b></font>"
		if("Cancel")
			return

	for(var/mob/M in player_list)
		if(M.client.prefs.toggles_sound && SOUND_MIDI)
			playsound(M, S, vol)

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)
	feedback_add_details("admin_verb","PCS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))
		return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)
	playsound(get_turf(src.mob),S, 50, 0, 0)
	feedback_add_details("admin_verb","Play Local Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_sound_from_list()
	set category = "Fun"
	set name = "Play Sound From List"
	set desc = "Play a sound already in the project from a pre-made list."
	if(!check_rights(R_SOUNDS))	return

	var/list/sounds = file2list("sound/soundlist.txt");
	sounds += "--CANCEL--"

	var/melody = input("Select a sound to play", "Sound list", "--CANCEL--") in sounds

	if(melody == "--CANCEL--")	return

	play_imported_sound(melody)
	feedback_add_details("admin_verb","PDS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/stop_sounds()
	set category = "Debug"
	set name = "Stop All Playing Sounds"
	if(!src.holder)
		return

	log_admin("[key_name(src)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(src)] stopped all currently playing sounds.")
	for(var/mob/M in player_list)
		if(M.client)
			M << sound(null)
	feedback_add_details("admin_verb","Stop All Playing Sounds") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
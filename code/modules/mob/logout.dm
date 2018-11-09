/mob/Logout()
	nanomanager.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	if(interactee) unset_interaction()
	player_list -= src
	log_access("Logout: [key_name(src)]")
	unansweredMhelps.Remove(src.computer_id)
	unansweredAhelps.Remove(src.computer_id)
	if(admin_datums[src.ckey])
		if (ticker && ticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
//			var/admins_number = admins.len

			message_admins("Admin logout: [key_name(src)]")

			var/admin_number_afk = 0
			var/mentor_number_afk = 0

			var/list/mentorholders = list()
			var/list/adminholders = list()
			for(var/client/X in admins)
				if((R_ADMIN & X.holder.rights) || (R_MOD & X.holder.rights)) // just admins here please
					adminholders += X
					if(X.is_afk())
						admin_number_afk++
				if((R_MENTOR & X.holder.rights) && !((R_ADMIN & X.holder.rights) || (R_MOD & X.holder.rights))) // we don't want to count admins twice. This list should be JUST mentors
					mentorholders += X
					if(X.is_afk())
						mentor_number_afk++

			if(!adminholders.len || admin_number_afk == adminholders.len)
				if(length(mentorholders) && mentor_number_afk != length(mentorholders))
					for(var/client/X in mentorholders) // Mentors get a reduced message
						if(X.prefs.toggles_sound & SOUND_ADMINHELP)
							X << 'sound/effects/adminhelp_new.ogg'
						to_chat(X, "<br><font color='#009900'><b>There is a new adminhelp! <font color='#DA6200'>Please notify an Administrator on Discord!</b></font><br>")



//			if(admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
//				send2adminirc("[key_name(src)] logged out - no more admins online.")
	if(s_active)
		s_active.hide_from(src)
	..()
	return 1

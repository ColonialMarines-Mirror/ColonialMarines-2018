//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	to_chat(world.log, "## ERROR: [msg][log_end]")

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	to_chat(world.log, "## WARNING: [msg][log_end]")

//print a testing-mode debug message to world.log
/proc/testing(msg)
	to_chat(world.log, "## TESTING: [msg][log_end]")

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"


/proc/log_debug(text)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	for(var/client/C in admins)
		if(C.prefs.toggles_chat & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]")


/proc/log_game(text)
	if (config.log_game)
		diary << html_decode("\[[time_stamp()]]GAME: [text][log_end]")

/proc/log_vote(text)
	if (config.log_vote)
		diary << html_decode("\[[time_stamp()]]VOTE: [text][log_end]")

/proc/log_access(text)
	if (config.log_access)
		diary << html_decode("\[[time_stamp()]]ACCESS: [text][log_end]")

/proc/log_say(text)
	if (config.log_say)
		diary << html_decode("\[[time_stamp()]]SAY: [text][log_end]")

/proc/log_hivemind(text)
	if (config.log_hivemind)
		diary << html_decode("\[[time_stamp()]]HIVEMIND: [text][log_end]")

/proc/log_ooc(text)
	if (config.log_ooc)
		diary << html_decode("\[[time_stamp()]]OOC: [text][log_end]")

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << html_decode("\[[time_stamp()]]WHISPER: [text][log_end]")

/proc/log_emote(text)
	if (config.log_emote)
		diary << html_decode("\[[time_stamp()]]EMOTE: [text][log_end]")

/proc/log_attack(text)
	if (config.log_attack)
		diary << html_decode("\[[time_stamp()]]ATTACK: [text][log_end]")

/proc/log_adminsay(text)
	if (config.log_adminchat)
		diary << html_decode("\[[time_stamp()]]ADMINSAY: [text][log_end]")

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << html_decode("\[[time_stamp()]]ADMINWARN: [text][log_end]")

/proc/log_pda(text)
	if (config.log_pda)
		diary << html_decode("\[[time_stamp()]]PDA: [text][log_end]")

/proc/log_misc(text)
	diary << html_decode("\[[time_stamp()]]MISC: [text][log_end]")

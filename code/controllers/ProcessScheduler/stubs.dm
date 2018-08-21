/**
 * _stubs.dm
 *
 * This file contains constructs that the process scheduler expects to exist
 * in a standard ss13 fork.
 */

/**
 * message_admins
 *
 * sends a message to admins
 */
///proc/message_admins(msg)
//	to_chat(world, msg)

/**
 * logTheThing
 *
 * In goonstation, this proc writes a message to either the world log or diary.
 *
 * Blame Keelin.
 */
/proc/logTheThing(type, source, target, text, diaryType)
	if(diaryType)
		to_chat(world, "Diary: \[[diaryType]:[type]] [text]")
	else
		to_chat(world, "Log: \[[type]] [text]")

/**
 * var/disposed
 *
 * In goonstation, disposed is set to 1 after an object enters the delete queue
 * or the object is placed in an object pool (effectively out-of-play so to speak)
 */
/datum/var/disposed
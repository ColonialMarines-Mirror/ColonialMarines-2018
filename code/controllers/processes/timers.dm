/datum/controller/process/timers

/datum/controller/process/timers/setup()
	name = "Timers"
	schedule_interval = 10 //1 second

/datum/controller/process/timers/doWork()

	var/i = 1
	while(i<=processing_timers.len)
		var/obj/Object = processing_timers[i]
		if(Object)
			Object.process()
			i++
			continue
		processing_objects.Cut(i,i+1)
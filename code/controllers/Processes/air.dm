/datum/controller/process/air
	schedule_interval = 31 // every 2 seconds

/datum/controller/process/air/setup()
	name = "air"

	if(!air_master)
		air_master = new
		air_master.Setup()

/datum/controller/process/air/doWork()
	try
		if(!air_processing_killed)
			if(!air_master.Tick()) //Runtimed.
				air_master.failed_ticks++

				if(air_master.failed_ticks > 5)
					world << "<SPAN CLASS='danger'>RUNTIMES IN ATMOS TICKER.  Killing air simulation!</SPAN>"
					world.log << "### ZAS SHUTDOWN"

					message_admins("ZASALERT: Shutting down! status: [air_master.tick_progress]")
					log_admin("ZASALERT: Shutting down! status: [air_master.tick_progress]")

					air_processing_killed = TRUE
					air_master.failed_ticks = 0
			scheck()
	catch(var/exception/e)
		world.Error(e)
		return
/proc/RemoveAllFactionIcons(var/datum/mind/M)
	ticker.mode.update_cult_icons_removed(M)
	ticker.mode.update_rev_icons_removed(M)
	ticker.mode.update_wizard_icons_removed(M)

/proc/ClearRoles(var/datum/mind/M)
	ticker.mode.remove_revolutionary(M)

/proc/isAdminGhost(A)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/isAdminGhost() called tick#: [world.time]")
	if(isobserver(A))
		var/mob/dead/observer/O = A
		if(O.check_rights(R_ADMIN|R_FUN))
			return 1
	return 0


/proc/canGhostRead(var/mob/A, var/obj/target, var/flags=PERMIT_ALL)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/canGhostRead() called tick#: [world.time]")
	if(isAdminGhost(A))
		return 1
	if(flags & PERMIT_ALL)
		return 1
	return 0

/proc/canGhostWrite(var/mob/A, var/obj/target, var/desc="fucked with", var/flags=0)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/canGhostWrite() called tick#: [world.time]")
	if(flags & PERMIT_ALL)
		if(!target.blessed)
			return 1
	if(isAdminGhost(A))
		if(desc!="")
			add_ghostlogs(A, target, desc, 1)
		return 1
	return 0

/proc/isloyal(A) //Checks to see if the person contains a loyalty implant, then checks that the implant is actually inside of them
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/isloyal() called tick#: [world.time]")
	for(var/obj/item/weapon/implant/loyalty/L in A)
		if(L && L.implanted)
			return 1
	return 0

/proc/check_holy(var/mob/A) //checks to see if the tile the mob stands on is holy
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/check_holy() called tick#: [world.time]")
	var/turf/T = get_turf(A)
	if(!T) return 0
	if(!T.holy) return 0
	return 1  //The tile is holy. Beware!

proc/hasorgans(A)
	//writepanic("[__FILE__].[__LINE__] \\/proc/hasorgans() called tick#: [world.time]")
	return ishuman(A)

/proc/hsl2rgb(h, s, l)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/hsl2rgb() called tick#: [world.time]")
	return


/proc/check_zone(zone)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/check_zone() called tick#: [world.time]")
	if(!zone)	return "chest"
	switch(zone)
		if("eyes")
			zone = "head"
		if("mouth")
			zone = "head"
/*		if("l_hand")
			zone = "l_arm"
		if("r_hand")
			zone = "r_arm"
		if("l_foot")
			zone = "l_leg"
		if("r_foot")
			zone = "r_leg"
		if("groin")
			zone = "chest"
*/
	return zone


/proc/ran_zone(zone, probability)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/ran_zone() called tick#: [world.time]")
	zone = check_zone(zone)
	if(!probability)	probability = 90
	if(probability == 100)	return zone

	if(zone == "chest")
		if(prob(probability))	return "chest"
		var/t = rand(1, 9)
		switch(t)
			if(1 to 3)	return "head"
			if(4 to 6)	return "l_arm"
			if(7 to 9)	return "r_arm"

	if(prob(probability * 0.75))	return zone
	return "chest"

// Emulates targetting a specific body part, and miss chances
// May return null if missed
// miss_chance_mod may be negative.
/proc/get_zone_with_miss_chance(zone, var/mob/target, var/miss_chance_mod = 0)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/get_zone_with_miss_chance() called tick#: [world.time]")
	zone = check_zone(zone)

	// you can only miss if your target is standing and not restrained
	if(!target.locked_to && !target.lying)
		var/miss_chance = 10
		switch(zone)
			if("head")
				miss_chance = 40
			if("l_leg")
				miss_chance = 20
			if("r_leg")
				miss_chance = 20
			if("l_arm")
				miss_chance = 20
			if("r_arm")
				miss_chance = 20
			if("l_hand")
				miss_chance = 50
			if("r_hand")
				miss_chance = 50
			if("l_foot")
				miss_chance = 50
			if("r_foot")
				miss_chance = 50
		miss_chance = max(miss_chance + miss_chance_mod, 0)
		if(prob(miss_chance))
			if(prob(70))
				return null
			else
				var/t = rand(1, 10)
				switch(t)
					if(1)	return "head"
					if(2)	return "l_arm"
					if(3)	return "r_arm"
					if(4) 	return "chest"
					if(5) 	return "l_foot"
					if(6)	return "r_foot"
					if(7)	return "l_hand"
					if(8)	return "r_hand"
					if(9)	return "l_leg"
					if(10)	return "r_leg"

	return zone

// adds stars to a text to obfuscate it
// var/n -> text to obfuscate
// var/pr -> percent of the text to obfuscate
// return -> obfuscated text
/proc/stars(n, pr)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/stars() called tick#: [world.time]")
	if (pr == null)
		pr = 25
	if (pr <= 0)
		return null
	else
		if (pr >= 100)
			return n
	var/te = n
	var/t = ""
	n = length(n)
	var/p = null
	p = 1
	while(p <= n)
		if ((copytext(te, p, p + 1) == " " || prob(pr)))
			t = text("[][]", t, copytext(te, p, p + 1))
		else
			t = text("[]*", t)
		p++
	return t

proc/slur(phrase)
	//writepanic("[__FILE__].[__LINE__] \\/proc/slur() called tick#: [world.time]")
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,15))
			if(1,3,5,8)	newletter="[lowertext(newletter)]"
			if(2,4,6,15)	newletter="[uppertext(newletter)]"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>[newletter]</b>"
			//if(11,12)	newletter="<big>[newletter]</big>"
			//if(13)	newletter="<small>[newletter]</small>"
		newphrase+="[newletter]";counter-=1
	return newphrase

/proc/stutter(n)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/stutter() called tick#: [world.time]")
	var/te = html_decode(n)
	var/t = ""//placed before the message. Not really sure what it's for.
	n = length(n)//length of the entire word
	var/p = null
	p = 1//1 is the start of any word
	while(p <= n)//while P, which starts at 1 is less or equal to N which is the length.
		var/n_letter = copytext(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
		if (prob(80) && (ckey(n_letter) in list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")))
			if (prob(10))
				n_letter = text("[n_letter]-[n_letter]-[n_letter]-[n_letter]")//replaces the current letter with this instead.
			else
				if (prob(20))
					n_letter = text("[n_letter]-[n_letter]-[n_letter]")
				else
					if (prob(5))
						n_letter = null
					else
						n_letter = text("[n_letter]-[n_letter]")
		t = text("[t][n_letter]")//since the above is ran through for each letter, the text just adds up back to the original word.
		p++//for each letter p is increased to find where the next letter will be.
	return copytext(sanitize(t),1,MAX_MESSAGE_LEN)


proc/Gibberish(t, p)//t is the inputted message, and any value higher than 70 for p will cause letters to be replaced instead of added
	//writepanic("[__FILE__].[__LINE__] \\/proc/Gibberish() called tick#: [world.time]")
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext

/proc/derpspeech(message, stuttering)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/derpspeech() called tick#: [world.time]")
	message = replacetext(message, " am ", " ")
	message = replacetext(message, " is ", " ")
	message = replacetext(message, " are ", " ")
	message = replacetext(message, "you", "u")
	message = replacetext(message, "help", "halp")
	message = replacetext(message, "grief", "griff")
	message = replacetext(message, "space", "spess")
	message = replacetext(message, "carp", "crap")
	message = replacetext(message, "reason", "raisin")
	if(prob(50))
		message = uppertext(message)
		message += "[stutter(pick("!", "!!", "!!!"))]"
	if(!stuttering && prob(15))
		message = stutter(message)
	return message

/proc/shake_camera(mob/M, duration=0, strength=1)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/shake_camera() called tick#: [world.time]")
	spawn(1)
		if(!M || !M.client || M.shakecamera)
			return

		var/oldeye=M.client.eye

		M.shakecamera = 1

		for (var/x = 1 to duration)
			if(!M || !M.client)
				M.shakecamera = 0
				return //somebody disconnected while being shaken
			M.client.eye = locate(Clamp(M.loc.x + rand(-strength, strength), 1, world.maxx), Clamp(M.loc.y + rand(-strength, strength), 1, world.maxy), M.loc.z)
			sleep(1)

		M.shakecamera = 0
		M.client.eye=oldeye


/proc/findname(msg)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/findname() called tick#: [world.time]")
	if(!istext(msg))
		msg = "[msg]"
	for(var/mob/M in mob_list)
		if(M.real_name == msg)
			return M
	return 0


/mob/proc/abiotic(var/full_body = 0)
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""])  \\/mob/proc/abiotic() called tick#: [world.time]")
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1

	return 0

//converts intent-strings into numbers and back
var/list/intents = list(I_HELP,I_DISARM,I_GRAB,I_HURT)
/proc/intent_numeric(argument)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/intent_numeric() called tick#: [world.time]")
	if(istext(argument))
		switch(argument)
			if(I_HELP)		return 0
			if(I_DISARM)	return 1
			if(I_GRAB)		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return I_HELP
			if(1)			return I_DISARM
			if(2)			return I_GRAB
			else			return I_HURT

//change a mob's act-intent. Input the intent as a string such as I_HELP or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set name = "a-intent"
	set hidden = 1
	//writepanic("[__FILE__].[__LINE__] ([src.type])([usr ? usr.ckey : ""]) \\/mob/verb/a_intent_change()  called tick#: [world.time]")

	if(ishuman(src) || isalienadult(src) || isbrain(src))
		switch(input)
			if(I_HELP,I_DISARM,I_GRAB,I_HURT)
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
		if(hud_used && hud_used.action_intent)
			hud_used.action_intent.icon_state = "intent_[a_intent]"

	else if(isrobot(src) || ismonkey(src) || islarva(src))
		switch(input)
			if(I_HELP)
				a_intent = I_HELP
			if(I_HURT)
				a_intent = I_HURT
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
		if(hud_used && hud_used.action_intent)
			if(a_intent == I_HURT)
				hud_used.action_intent.icon_state = "harm"
			else
				hud_used.action_intent.icon_state = "help"
proc/is_blind(A)
	//writepanic("[__FILE__].[__LINE__] \\/proc/is_blind() called tick#: [world.time]")
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/C = A
		if(C.blinded != null)
			return 1
	return 0

/proc/get_multitool(mob/user as mob)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/get_multitool() called tick#: [world.time]")
	// Get tool
	var/obj/item/device/multitool/P
	if(isrobot(user) || ishuman(user))
		P = user.get_active_hand()
	else if(isAI(user))
		var/mob/living/silicon/ai/AI=user
		P = AI.aiMulti
	else if(isAdminGhost(user))
		var/mob/dead/observer/G=user
		P = G.ghostMulti

	if(!istype(P))
		return null
	return P

/proc/broadcast_security_hud_message(var/message, var/broadcast_source)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/broadcast_security_hud_message() called tick#: [world.time]")
	broadcast_hud_message(message, broadcast_source, sec_hud_users, /obj/item/clothing/glasses/hud/security)

/proc/broadcast_medical_hud_message(var/message, var/broadcast_source)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/broadcast_medical_hud_message() called tick#: [world.time]")
	broadcast_hud_message(message, broadcast_source, med_hud_users, /obj/item/clothing/glasses/hud/health)

/proc/broadcast_hud_message(var/message, var/broadcast_source, var/list/targets, var/icon)
	//writepanic("[__FILE__].[__LINE__] (no type)([usr ? usr.ckey : ""])  \\/proc/broadcast_hud_message() called tick#: [world.time]")
	var/turf/sourceturf = get_turf(broadcast_source)
	for(var/mob/M in targets)
		var/turf/targetturf = get_turf(M)
		if((targetturf.z == sourceturf.z))
			M.show_message("<span class='info'>\icon[icon] [message]</span>", 1)

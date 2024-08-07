/*
The contents of this file were originally licensed under CC-BY-NC-SA 3.0 as part of Goonstation(https://ss13.co).
However, /tg/station and derivative codebases have been granted the right to use this code under the terms of the AGPL.
The original authors are: cogwerks, pistoleer, spyguy, angriestibm, marquesas, and stuntwaffle.
If you make a derivative work from this code, you must include this notification header alongside it.
*/

/mob/living/proc/wrestling_help()
	set name = "Recall Teachings"
	set desc = "Remember how to wrestle."
	set category = "Wrestling"

	to_chat(usr, "<b><i>You flex your muscles and have a revelation...</i></b>")
	to_chat(usr, "[span_notice("Clinch")]: Grab. Passively gives you a chance to immediately aggressively grab someone. Not always successful.")
	to_chat(usr, "[span_notice("Suplex")]: Shove someone you are grabbing. Suplexes your target to the floor. Greatly injures them and leaves both you and your target on the floor.")
	to_chat(usr, "[span_notice("Advanced grab")]: Grab. Passively causes stamina damage when grabbing someone.")

/datum/martial_art/wrestling
	name = "Wrestling"
	id = MARTIALART_WRESTLING
	// Monkestation Edit: Changes datum names to be less confusing
	var/datum/action/wrestle_slam/wrestle_slam = new/datum/action/wrestle_slam()
	var/datum/action/wrestle_throw/wrestle_throw = new/datum/action/wrestle_throw()
	var/datum/action/wrestle_kick/wrestle_kick = new/datum/action/wrestle_kick()
	var/datum/action/wrestle_strike/wrestle_strike = new/datum/action/wrestle_strike()
	var/datum/action/wrestle_drop/wrestle_drop = new/datum/action/wrestle_drop()
	// Monkestation Edit end

/datum/martial_art/wrestling/proc/check_streak(mob/living/attacker, mob/living/defender)
	switch(streak)
		if("drop")
			streak = ""
			wrestle_drop(attacker, defender)
			return TRUE
		if("strike")
			streak = ""
			wrestle_strike(attacker, defender)
			return TRUE
		if("kick")
			streak = ""
			wrestle_kick(attacker, defender)
			return TRUE
		if("throw")
			streak = ""
			wrestle_throw(attacker, defender)
			return TRUE
		if("slam")
			streak = ""
			wrestle_slam(attacker, defender)
			return TRUE
	return FALSE

/datum/action/wrestle_slam
	name = "Slam (Cinch)"
	desc = "Slam a grappled opponent into the floor." //Monkestation Edit: Moves description from name to desc
	button_icon = 'monkestation/icons/hud/martial_arts_actions.dmi'
	button_icon_state = "wrassle_slam"

/datum/action/wrestle_slam/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("You can't WRESTLE while you're OUT FOR THE COUNT."))
		return
	owner.visible_message(span_danger("[owner] prepares to BODY SLAM!"), "<b><i>Your next attack will be a BODY SLAM.</i></b>")
	owner.mind.martial_art.streak = "slam"

/datum/action/wrestle_throw
	name = "Throw (Cinch)"
	desc = "Spin a cinched opponent around and throw them." //Monkestation Edit: adds desc
	button_icon = 'monkestation/icons/hud/martial_arts_actions.dmi'
	button_icon_state = "wrassle_throw"

/datum/action/wrestle_throw/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("You can't WRESTLE while you're OUT FOR THE COUNT."))
		return
	owner.visible_message(span_danger("[owner] prepares to THROW!"), "<b><i>Your next attack will be a THROW.</i></b>")
	owner.mind.martial_art.streak = "throw"

/datum/action/wrestle_kick
	name = "Kick"
	desc = "A powerful kick, sends people flying away from you. Also useful for escaping from bad situations." //Monkestation Edit: adds desc
	button_icon = 'monkestation/icons/hud/martial_arts_actions.dmi'
	button_icon_state = "wrassle_kick"

/datum/action/wrestle_kick/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("You can't WRESTLE while you're OUT FOR THE COUNT."))
		return
	owner.visible_message(span_danger("[owner] prepares to KICK!"), "<b><i>Your next attack will be a KICK.</i></b>")
	owner.mind.martial_art.streak = "kick"

/datum/action/wrestle_strike
	name = "Strike"
	desc = "Hit a neaby opponent with a quick attack." //Monkestation Edit: adds desc
	button_icon = 'monkestation/icons/hud/martial_arts_actions.dmi'
	button_icon_state = "wrassle_strike"

/datum/action/wrestle_strike/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("You can't WRESTLE while you're OUT FOR THE COUNT."))
		return
	owner.visible_message(span_danger("[owner] prepares to STRIKE!"), "<b><i>Your next attack will be a STRIKE.</i></b>")
	owner.mind.martial_art.streak = "strike"

/datum/action/wrestle_drop
	name = "Drop"
	desc = "Smash down onto an opponent." //Monkestation Edit: adds desc
	button_icon = 'monkestation/icons/hud/martial_arts_actions.dmi'
	button_icon_state = "wrassle_drop"

/datum/action/wrestle_drop/Trigger(trigger_flags)
	if(owner.incapacitated())
		to_chat(owner, span_warning("You can't WRESTLE while you're OUT FOR THE COUNT."))
		return
	owner.visible_message(span_danger("[owner] prepares to LEG DROP!"), "<b><i>Your next attack will be a LEG DROP.</i></b>")
	owner.mind.martial_art.streak = "drop"

/datum/martial_art/wrestling/teach(mob/living/owner, make_temporary=FALSE)
	if(..())
		to_chat(owner, span_userdanger("SNAP INTO A THIN TIM!"))
		to_chat(owner, span_danger("Place your cursor over a move at the top of the screen to see what it does."))
		wrestle_drop.Grant(owner)
		wrestle_kick.Grant(owner)
		wrestle_slam.Grant(owner)
		wrestle_throw.Grant(owner)
		wrestle_strike.Grant(owner)

/datum/martial_art/wrestling/on_remove(mob/living/owner)
	to_chat(owner, span_userdanger("You no longer feel that the tower of power is too sweet to be sour..."))
	wrestle_drop.Remove(owner)
	wrestle_kick.Remove(owner)
	wrestle_slam.Remove(owner)
	wrestle_throw.Remove(owner)
	wrestle_strike.Remove(owner)

/datum/martial_art/wrestling/harm_act(mob/living/attacker, mob/living/defender)
	if(check_streak(attacker, defender))
		return 1
	log_combat(attacker, defender, "punched with wrestling")
	..()

/datum/martial_art/wrestling/proc/wrestle_throw(mob/living/attacker, mob/living/defender)
	if(!defender)
		return
	if(!attacker.pulling || attacker.pulling != defender)
		to_chat(attacker, span_warning("You need to have [defender] in a cinch!"))
		return
	defender.forceMove(attacker.loc)
	defender.setDir(get_dir(defender, attacker))

	defender.Stun(8 SECONDS)
	defender.visible_message(span_danger("[attacker] starts spinning around with [defender]!"), \
					span_userdanger("You're spun around by [attacker]!"), span_hear("You hear aggressive shuffling!"), null, attacker)
	to_chat(attacker, span_danger("You start spinning around with [defender]!"))
	attacker.emote("scream")

	for (var/i in 1 to 20)
		var/delay = 5
		switch (i)
			if (18 to INFINITY)
				delay = 0.25
			if (15 to 17)
				delay = 0.5
			if (10 to 14)
				delay = 1
			if (6 to 9)
				delay = 2
			if (1 to 5)
				delay = 3

		if (attacker && defender)

			if (get_dist(attacker, defender) > 1)
				to_chat(attacker, span_warning("[defender] is too far away!"))
				return

			if (!isturf(attacker.loc) || !isturf(defender.loc))
				to_chat(attacker, span_warning("You can't throw [defender] from here!"))
				return

			attacker.setDir(turn(attacker.dir, 90))
			var/turf/T = get_step(attacker, attacker.dir)
			var/turf/S = defender.loc
			var/direction = get_dir(defender, attacker)
			if ((S && isturf(S) && S.Exit(defender, direction)) && (T && isturf(T) && T.Enter(attacker)))
				defender.forceMove(T)
				defender.setDir(direction)
		else
			return

		sleep(delay)

	if (attacker && defender)
		// These are necessary because of the sleep call.

		if (get_dist(attacker, defender) > 1)
			to_chat(attacker, span_warning("[defender] is too far away!"))
			return

		if (!isturf(attacker.loc) || !isturf(defender.loc))
			to_chat(attacker, span_warning("You can't throw [defender] from here!"))
			return

		defender.forceMove(attacker.loc) // Maybe this will help with the wallthrowing bug.

		defender.visible_message(span_danger("[attacker] throws [defender]!"), \
						span_userdanger("You're thrown by [attacker]!"), span_hear("You hear aggressive shuffling and a loud thud!"), null, attacker)
		to_chat(attacker, span_danger("You throw [defender]!"))
		playsound(attacker.loc, SFX_SWING_HIT, 50, TRUE)
		var/turf/T = get_edge_target_turf(attacker, attacker.dir)
		if (T && isturf(T))
			if (!defender.stat)
				defender.emote("scream")
			defender.throw_at(T, 10, 4, attacker, TRUE, TRUE, callback = CALLBACK(defender, TYPE_PROC_REF(/mob/living, Paralyze), 20))
	log_combat(attacker, defender, "has thrown with wrestling")
	return

/datum/martial_art/wrestling/proc/FlipAnimation(mob/living/defender)
	set waitfor = FALSE
	if (defender)
		animate(defender, transform = matrix(180, MATRIX_ROTATE), time = 1, loop = 0)
	sleep(1.5 SECONDS)
	if (defender)
		animate(defender, transform = null, time = 1, loop = 0)

/datum/martial_art/wrestling/proc/wrestle_slam(mob/living/attacker, mob/living/defender)
	if(!defender)
		return
	if(!attacker.pulling || attacker.pulling != defender)
		to_chat(attacker, span_warning("You need to have [defender] in a cinch!"))
		return
	defender.forceMove(attacker.loc)
	attacker.setDir(get_dir(attacker, defender))
	defender.setDir(get_dir(defender, attacker))

	defender.visible_message(span_danger("[attacker] lifts [defender] up!"), \
					span_userdanger("You're lifted up by [attacker]!"), span_hear("You hear aggressive shuffling!"), null, attacker)
	to_chat(attacker, span_danger("You lift [defender] up!"))

	FlipAnimation()

	for (var/i in 1 to 3)
		if (attacker && defender)
			attacker.pixel_y += 3
			defender.pixel_y += 3
			attacker.setDir(turn(attacker.dir, 90))
			defender.setDir(turn(defender.dir, 90))

			switch (attacker.dir)
				if (NORTH)
					defender.pixel_x = attacker.pixel_x
				if (SOUTH)
					defender.pixel_x = attacker.pixel_x
				if (EAST)
					defender.pixel_x = attacker.pixel_x - 8
				if (WEST)
					defender.pixel_x = attacker.pixel_x + 8

			if (get_dist(attacker, defender) > 1)
				to_chat(attacker, span_warning("[defender] is too far away!"))
				attacker.pixel_x = attacker.base_pixel_x
				attacker.pixel_y = attacker.base_pixel_y
				defender.pixel_x = defender.base_pixel_x
				defender.pixel_y = defender.base_pixel_y
				return

			if (!isturf(attacker.loc) || !isturf(defender.loc))
				to_chat(attacker, span_warning("You can't slam [defender] here!"))
				attacker.pixel_x = attacker.base_pixel_x
				attacker.pixel_y = attacker.base_pixel_y
				defender.pixel_x = defender.base_pixel_x
				defender.pixel_y = defender.base_pixel_y
				return
		else
			if (attacker)
				attacker.pixel_x = attacker.base_pixel_x
				attacker.pixel_y = attacker.base_pixel_y
			if (defender)
				defender.pixel_x = defender.base_pixel_x
				defender.pixel_y = defender.base_pixel_y
			return

		sleep(0.1 SECONDS)

	if (attacker && defender)
		attacker.pixel_x = attacker.base_pixel_x
		attacker.pixel_y = attacker.base_pixel_y
		defender.pixel_x = defender.base_pixel_x
		defender.pixel_y = defender.base_pixel_y

		if (get_dist(attacker, defender) > 1)
			to_chat(attacker, span_warning("[defender] is too far away!"))
			return

		if (!isturf(attacker.loc) || !isturf(defender.loc))
			to_chat(attacker, span_warning("You can't slam [defender] here!"))
			return

		defender.forceMove(attacker.loc)

		var/fluff = "body-slam"
		switch(pick(2,3))
			if (2)
				fluff = "turbo [fluff]"
			if (3)
				fluff = "atomic [fluff]"

		defender.visible_message(span_danger("[attacker] [fluff] [defender]!"), \
						span_userdanger("You're [fluff]ed by [attacker]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, attacker)
		to_chat(attacker, span_danger("You [fluff] [defender]!"))
		playsound(attacker.loc, SFX_SWING_HIT, 50, TRUE)
		if (!defender.stat)
			defender.emote("scream")
			defender.Paralyze(4 SECONDS)

			switch(rand(1,3))
				if (2)
					defender.adjustBruteLoss(rand(20,30))
				if (3)
					EX_ACT(defender, EXPLODE_LIGHT)
				else
					defender.adjustBruteLoss(rand(10,20))
		else
			EX_ACT(defender, EXPLODE_LIGHT)

	else
		if (attacker)
			attacker.pixel_x = attacker.base_pixel_x
			attacker.pixel_y = attacker.base_pixel_y
		if (defender)
			defender.pixel_x = defender.base_pixel_x
			defender.pixel_y = defender.base_pixel_y


	log_combat(attacker, defender, "body-slammed")
	return

/datum/martial_art/wrestling/proc/CheckStrikeTurf(mob/living/attacker, turf/T)
	if (attacker && (T && isturf(T) && get_dist(attacker, T) <= 1))
		attacker.forceMove(T)

/datum/martial_art/wrestling/proc/wrestle_strike(mob/living/attacker, mob/living/defender)
	if(!defender)
		return
	var/turf/T = get_turf(attacker)
	if (T && isturf(T) && defender && isturf(defender.loc))
		for (var/i in 1 to 4)
			attacker.setDir(turn(attacker.dir, 90))

		attacker.forceMove(defender.loc)
		addtimer(CALLBACK(src, PROC_REF(CheckStrikeTurf), attacker, T), 4)

		defender.visible_message(span_danger("[attacker] headbutts [defender]!"), \
						span_userdanger("You're headbutted by [attacker]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, attacker)
		to_chat(attacker, span_danger("You headbutt [defender]!"))
		defender.adjustBruteLoss(rand(10,20))
		playsound(attacker.loc, SFX_SWING_HIT, 50, TRUE)
		defender.Unconscious(2 SECONDS)
	log_combat(attacker, defender, "headbutted")

/datum/martial_art/wrestling/proc/wrestle_kick(mob/living/attacker, mob/living/defender)
	if(!defender)
		return
	attacker.emote("scream")
	attacker.emote("flip")
	attacker.setDir(turn(attacker.dir, 90))

	defender.visible_message(span_danger("[attacker] roundhouse-kicks [defender]!"), \
					span_userdanger("You're roundhouse-kicked by [attacker]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), COMBAT_MESSAGE_RANGE, attacker)
	to_chat(attacker, span_danger("You roundhouse-kick [defender]!"))
	playsound(attacker.loc, SFX_SWING_HIT, 50, TRUE)
	defender.adjustBruteLoss(rand(10,20))

	var/turf/T = get_edge_target_turf(attacker, get_dir(attacker, get_step_away(defender, attacker)))
	if (T && isturf(T))
		defender.Paralyze(2 SECONDS)
		defender.throw_at(T, 3, 2)
	log_combat(attacker, defender, "roundhouse-kicked")

/datum/martial_art/wrestling/proc/wrestle_drop(mob/living/attacker, mob/living/defender)
	if(!defender)
		return
	var/obj/surface = null
	var/turf/ST = null
	var/falling = 0

	for (var/obj/O in oview(1, attacker))
		if (O.density == 1)
			if (O == attacker)
				continue
			if (O == defender)
				continue
			if (O.opacity)
				continue
			else
				surface = O
				ST = get_turf(O)
				break

	if (surface && (ST && isturf(ST)))
		attacker.forceMove(ST)
		attacker.visible_message(span_danger("[attacker] climbs onto [surface]!"), \
						span_danger("You climb onto [surface]!"))
		attacker.pixel_y = attacker.base_pixel_y + 10
		falling = 1
		sleep(1 SECONDS)

	if (attacker && defender)
		// These are necessary because of the sleep call.

		if ((falling == 0 && get_dist(attacker, defender) > 1) || (falling == 1 && get_dist(attacker, defender) > 2)) // We climbed onto stuff.
			attacker.pixel_y = attacker.base_pixel_y
			if (falling == 1)
				attacker.visible_message(span_danger("...and dives head-first into the ground, ouch!"), \
								span_userdanger("...and dive head-first into the ground, ouch!"))
				attacker.adjustBruteLoss(rand(10,20))
				attacker.Paralyze(60)
			to_chat(attacker, span_warning("[defender] is too far away!"))
			return

		if (!isturf(attacker.loc) || !isturf(defender.loc))
			attacker.pixel_y = attacker.base_pixel_y
			to_chat(attacker, span_warning("You can't drop onto [defender] from here!"))
			return

		if(attacker)
			animate(attacker, transform = matrix(90, MATRIX_ROTATE), time = 1, loop = 0)
		sleep(1 SECONDS)
		if(attacker)
			animate(attacker, transform = null, time = 1, loop = 0)

		attacker.forceMove(defender.loc)

		defender.visible_message(span_danger("[attacker] leg-drops [defender]!"), \
						span_userdanger("You're leg-dropped by [attacker]!"), span_hear("You hear a sickening sound of flesh hitting flesh!"), null, attacker)
		to_chat(attacker, span_danger("You leg-drop [defender]!"))
		playsound(attacker.loc, SFX_SWING_HIT, 50, TRUE)
		attacker.emote("scream")

		if (falling == 1)
			if (prob(33) || defender.stat)
				EX_ACT(defender, EXPLODE_LIGHT)
			else
				defender.adjustBruteLoss(rand(20,30))
		else
			defender.adjustBruteLoss(rand(20,30))

		defender.Paralyze(4 SECONDS)

		attacker.pixel_y = attacker.base_pixel_y

	else
		if (attacker)
			attacker.pixel_y = attacker.base_pixel_y
	log_combat(attacker, defender, "leg-dropped")
	return

/datum/martial_art/wrestling/disarm_act(mob/living/attacker, mob/living/defender)
	if(check_streak(attacker, defender))
		return 1
	log_combat(attacker, defender, "wrestling-disarmed")
	..()

/datum/martial_art/wrestling/grab_act(mob/living/attacker, mob/living/defender)
	if(check_streak(attacker, defender))
		return 1
	if(attacker.pulling == defender)
		return 1
	attacker.start_pulling(defender)
	defender.visible_message(span_danger("[attacker] gets [defender] in a cinch!"), \
					span_userdanger("You're put into a cinch by [attacker]!"), span_hear("You hear aggressive shuffling!"), COMBAT_MESSAGE_RANGE, attacker)
	to_chat(attacker, span_danger("You get [defender] in a cinch!"))
	defender.Stun(rand(6 SECONDS, 10 SECONDS))
	log_combat(attacker, defender, "cinched")
	return 1

/obj/item/storage/belt/champion/wrestling
	name = "Wrestling Belt"
	var/datum/martial_art/wrestling/style = new

/obj/item/storage/belt/champion/wrestling/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_BELT)
		style.teach(user, TRUE)
	return

/obj/item/storage/belt/champion/wrestling/dropped(mob/user)
	. = ..()
	if(user.get_item_by_slot(ITEM_SLOT_BELT) == src)
		style.remove(user)
	return

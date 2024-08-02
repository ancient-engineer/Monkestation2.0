/obj/item/organ/internal/tongue/robot/clockwork
	name = "dynamic micro-phonograph"
	desc = "An old-timey looking device connected to an odd, shifting cylinder."
	icon = 'monkestation/icons/obj/medical/organs/organs.dmi'
	icon_state = "tongueclock"

/obj/item/organ/internal/tongue/robot/clockwork/better
	name = "amplified dynamic micro-phonograph"

/obj/item/organ/internal/tongue/robot/clockwork/better/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT
	//speech_args[SPEECH_SPANS] |= SPAN_REALLYBIG  //i disabled this, its abnoxious and makes their chat take 3 times as much space in chat

/obj/item/organ/internal/tongue/arachnid
	name = "arachnid tongue"
	desc = "The tongue of an Arachnid. Mostly used for lying."
	say_mod = "chitters"
	modifies_speech = TRUE

/obj/item/organ/internal/tongue/arachnid/modify_speech(datum/source, list/speech_args) //This is flypeople speech
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
		message = replacetext(message, "s", "z")
		message = replacetext(message, "S", "Z")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/internal/tongue/arachnid/get_possible_languages()
	return ..() + /datum/language/buzzwords

/obj/item/organ/internal/tongue/oozeling
	name = "oozeling tongue"
	desc = "A goopy organ that mimics the tongues of other carbon beings."
	icon = 'monkestation/icons/obj/medical/organs/organs.dmi'
	icon_state = "tongue_oozeling"
	say_mod = "blurbles"
	alpha = 200

// Oozeling tongues can speak all default + slime
/obj/item/organ/internal/tongue/oozeling/get_possible_languages()
	return ..() + /datum/language/slime

/obj/item/organ/internal/tongue/robot/polyglot_voicebox
	name = "polyglot voicebox"
	desc = "A voice synthesizer that allows you to emulate the tongues of other species."
	say_mod = "beeps"
	//The current tongue being emulated.
	var/current_tongue = "synth"
	var/datum/action/innate/select_tongue/select_tongue
	var/draw_length = 3

/obj/item/organ/internal/tongue/robot/polyglot_voicebox/Initialize(mapload)
	. = ..()
	draw_length = rand(2, 6)
	if(prob(10))
		draw_length += 2

/obj/item/organ/internal/tongue/robot/polyglot_voicebox/can_speak_language(language)
	return ..()

/obj/item/organ/internal/tongue/robot/polyglot_voicebox/modify_speech(datum/source, list/speech_args)
	switch(current_tongue)
		if("synth")
			speech_args[SPEECH_SPANS] |= SPAN_ROBOT
		if("arachnid")
			var/static/regex/fly_buzz = new("z+", "g")
			var/static/regex/fly_buZZ = new("Z+", "g")
			var/message = speech_args[SPEECH_MESSAGE]
			if(message[1] != "*")
				message = fly_buzz.Replace(message, "zzz")
				message = fly_buZZ.Replace(message, "ZZZ")
				message = replacetext(message, "s", "z")
				message = replacetext(message, "S", "Z")
			speech_args[SPEECH_MESSAGE] = message
		if("lizard")
			var/static/regex/lizard_hiss = new("s+", "g")
			var/static/regex/lizard_hiSS = new("S+", "g")
			var/static/regex/lizard_kss = new(@"(\w)x", "g")
			var/static/regex/lizard_kSS = new(@"(\w)X", "g")
			var/static/regex/lizard_ecks = new(@"\bx([\-|r|R]|\b)", "g")
			var/static/regex/lizard_eckS = new(@"\bX([\-|r|R]|\b)", "g")
			var/message = speech_args[SPEECH_MESSAGE]
			if(message[1] != "*")
				message = lizard_hiss.Replace(message, repeat_string(draw_length, "s"))
				message = lizard_hiSS.Replace(message, repeat_string(draw_length, "S"))
				message = lizard_kss.Replace(message, "$1k[repeat_string(max(draw_length - 1, 1), "s")]")
				message = lizard_kSS.Replace(message, "$1K[repeat_string(max(draw_length - 1, 1), "S")]")
				message = lizard_ecks.Replace(message, "eck[repeat_string(max(draw_length - 2, 1), "s")]$1")
				message = lizard_eckS.Replace(message, "ECK[repeat_string(max(draw_length - 2, 1), "S")]$1")
			speech_args[SPEECH_MESSAGE] = message
		if("snail")
			var/new_message
			var/message = speech_args[SPEECH_MESSAGE]
			for(var/i in 1 to length(message))
				if(findtext("ABCDEFGHIJKLMNOPWRSTUVWXYZabcdefghijklmnopqrstuvwxyz", message[i]))
					new_message += message[i] + message[i] + message[i]
				else
					new_message += message[i]
			speech_args[SPEECH_MESSAGE] = new_message
		else
			return ..()

/obj/item/organ/internal/tongue/robot/polyglot_voicebox/on_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	select_tongue = new
	select_tongue.Grant(organ_owner)

/obj/item/organ/internal/tongue/robot/polyglot_voicebox/on_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	select_tongue.Remove(organ_owner)

/datum/action/innate/select_tongue
	name = "Select tongue"
	desc = "Select a tongue to emulate with your polyglot voicebox"
	button_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	background_icon_state = "bg_revenant"
	overlay_icon_state = "bg_revenant_border"
	button_icon_state = "join"

/datum/action/innate/select_tongue/Activate()
	//All possible tongues that can be emulated.
	var/list/possible_tongues = list(
		"synth"  = image(icon = 'monkestation/code/modules/smithing/icons/ipc_organ.dmi', icon_state = "cybertongue"),
		"arachnid" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tongue"),
		"oozeling" = image(icon = 'monkestation/icons/obj/medical/organs/organs.dmi', icon_state = "tongue_oozeling"),
		"ethereal" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "electrotongue"),
		"monkey" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tongue"),
		"moth" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tongue"),
		"human" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tongue"),
		"lizard" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tonguelizard"),
		"snail" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tongue"),
		"cat" = image(icon = 'icons/obj/medical/organs/organs.dmi', icon_state = "tongue")
	)
	var/obj/item/organ/internal/tongue/robot/polyglot_voicebox/polyglot_voicebox = owner.get_organ_slot(ORGAN_SLOT_TONGUE)
	var/picked_tongue = show_radial_menu(owner, owner, possible_tongues, radius = 50, require_near = TRUE, tooltips = TRUE)
	if(!picked_tongue)
		return
	polyglot_voicebox.current_tongue = picked_tongue
	switch(picked_tongue)
		if("synth")
			polyglot_voicebox.say_mod = "beeps"
		if("arachnid")
			polyglot_voicebox.say_mod = "chitters"
		if("oozeling")
			polyglot_voicebox.say_mod = "blurbles"
		if("ethereal")
			polyglot_voicebox.say_mod = "crackles"
		if("monkey")
			polyglot_voicebox.say_mod = "chimpers"
		if("moth")
			polyglot_voicebox.say_mod = "flutters"
		if("human")
			polyglot_voicebox.say_mod = "says"
		if("lizard")
			polyglot_voicebox.say_mod = "hisses"
		if("snail")
			polyglot_voicebox.say_mod = "says"
		if("cat")
			polyglot_voicebox.say_mod = "meows"

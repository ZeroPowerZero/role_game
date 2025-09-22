extends Control

func set_role(role:String):
	$TextureRect.texture= load(Global.cards[role])
	$Label.text=Global.ROLE_MESSAGES[role]

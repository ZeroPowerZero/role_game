extends Control
func set_info(id:int ,p_name:String):
	$VBoxContainer/HBoxContainer/Name.text = p_name
	var image = Image.load_from_file(Global.lobby_image_list[id])
	var texture = ImageTexture.create_from_image(image)
	$VBoxContainer/TextureRect.texture = texture
	$ColorRect.color=Global.lobby_color_list[id]

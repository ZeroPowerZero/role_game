extends Control

@onready var name_input = $VBoxContainer/NameInput
@onready var ip_input = $VBoxContainer/IPInput
@onready var rounds_input =$VBoxContainer/RoundsInput
@onready var info_label = $VBoxContainer/InfoLabel 

var PORT = 9520 ## The port number

const MAX_CONNECTIONS = 4
func _ready():
	$VBoxContainer/YourIp.text ="Your IP : " + get_ip_string()
	info_label.text = ""

func _on_host_button_pressed() -> void:
	
	Global.player_name = name_input.text.strip_edges().to_upper()
	if(Global.player_name.length()==0):
		info_label.text="Please Enter a name !"
		return
	
	Global.is_host = true
	Global.round_count = int(rounds_input.value)
	
	var peer = ENetMultiplayerPeer.new()
	if peer.create_server(PORT,MAX_CONNECTIONS) != OK:
		info_label.text = "Failed to start server!"
		return
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")

func _on_join_button_pressed() -> void:

	Global.player_name = name_input.text.strip_edges().to_upper() 

	if(Global.player_name.length()==0):
		info_label.text="Please Enter a name !"
		return
	Global.is_host = false
	
	var ip = ip_input.text.strip_edges()
	if ip == "":
		ip = "127.0.0.1";

	var peer = ENetMultiplayerPeer.new()
	if peer.create_client(ip, PORT) != OK:
		info_label.text = "Failed to connect to host!"
		return

	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()

func  get_ip_string()->String:
	var ip ="Network Error"
	if OS.get_name() == "Android":
		for device in IP.get_local_interfaces():
			if device["name"] == "ap0":
				ip=device["addresses"][0]
	else:
		for device in IP.get_local_interfaces():
			if device["friendly"] == "Wi-Fi":
				ip=device["addresses"][0]
	return ip

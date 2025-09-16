# Global.gd
extends Node

signal player_names_updated  

var player_name: String = ""

var actual_roles: Array[String] = ["king","queen","bishop","thief"]
var duplicate_roles: Array[String]
var player_names: Array[String] = []
var is_host: bool = false
var player_role : String

@rpc("any_peer","reliable")
func name_adding(players_names):
	Global.player_names.append(players_names)
	rpc("updating_name",Global.player_names)

@rpc("any_peer", "reliable")
func updating_name(players_ka_nam :Array[String]):
	Global.player_names = players_ka_nam
	emit_signal("player_names_updated")
	

#role thing going on here
@rpc("any_peer")
func duplication_function(name_coming :Array[String]):
	Global.duplicate_roles = name_coming

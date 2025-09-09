# Global.gd
extends Node

var player_name: String = ""
var actual_roles: Array[String] = ["king","queen","bishop","thief"]

var player_names: Array[String] = []
var is_host: bool = false



var player_role : String

#random krna ka tarika ramiser() ka bad fun ka nam .shuffle() ho gaya 

extends Node

var touch = false

var try = 1
var floor = 1
var mistakes = 0
var story_checkpoints = true

var fix_wrong_attempts = 0
var fix_selected_node
var fix_menu_shown = 0
var anomalies_data = []

var fix_game

func show_fix_menu():
	fix_game.get_node("CanvasLayer/fix").visible = 1

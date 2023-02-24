extends Node

## This class contains controls that should always be accessible, like pausing
## the game or toggling the window full-screen.


# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
@onready var _pause_menu = $InterfaceLayer/PauseMenu


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# We need to clean up a little bit first to avoid SubViewport errors.
		if name == "Splitscreen":
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()


func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (not ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
		get_viewport().set_input_as_handled()
	# The GlobalControls node, in the Stage scene, is set to process even
	# when the game is paused, so this code keeps running.
	# To see that, select GlobalControls, and scroll down to the Pause category
	# in the inspector.
	elif event.is_action_pressed("toggle_pause"):
		var tree = get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			_pause_menu.open()
		else:
			_pause_menu.close()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("splitscreen"):
		if name == "Splitscreen":
			# We need to clean up a little bit first to avoid SubViewport errors.
			$Black/SplitContainer/ViewportContainer1.free()
			$Black.queue_free()
			get_tree().change_scene_to_file("res://src/Main/Game.tscn")
		else:
			get_tree().change_scene_to_file("res://src/Main/Splitscreen.tscn")

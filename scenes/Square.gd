extends Control

signal solve(c, r, t, n)

# Declare member variables here. Examples:
var notes = [1, 2, 3, 4, 5, 6, 7, 8, 9]
var solution = 0
var col = -1
var row = -1
var tile = -1	#3x3 tile of squares. left->right then top->bottom


# Called when the node enters the scene tree for the first time.
func _ready():
	#tbd: apply solution number?
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_coords():
	col = get_index() % 9 # + 1
	row = floor(get_index() / 9) # + 1
	
	var tc = int(col/3)
	var tr = int(row/3)
	tile = tc + (3 * tr)


func _input(event):
	if has_focus() and event is InputEventKey and event.is_pressed():
		var input_string = OS.get_scancode_string(event.scancode)
		
		if int(input_string) in range(1, 10):
			try_solution(input_string)
			release_focus()


func add_note(n):
	n = int(n)
	if $Notes.visible and not n in notes:
		notes.append(n)
		$Notes.get_child(n-1).self_modulate = Color.white


func remove_note(n):
	n = int(n)
	if $Notes.visible and n in notes:
		notes.erase(n)
		$Notes.get_child(n-1).self_modulate = Color.transparent


func try_solution(n):
	# if solution is good:
	$Solution.text = str(n)
	$Notes.visible = false
	emit_signal("solve", col, row, tile, n)
	# remove sibling tile/row/column notes


func _on_Square_focus_entered():
	$Select_Highlight.show()


func _on_Square_focus_exited():
	$Select_Highlight.hide()
	
	# if mouse is not over square: ?
	$Hover_Highlight.hide()


func _on_Square_mouse_entered():
	$Hover_Highlight.show()


func _on_Square_mouse_exited():
	$Hover_Highlight.hide()

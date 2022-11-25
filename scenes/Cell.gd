extends Control

signal solve(col, row, box, n)

var markup = [1, 2, 3, 4, 5, 6, 7, 8, 9] # possible answers, culled after solution generated
var notes = [] # user notes
var note_mode = false	# distinguish when entering solution (false) vs entering note (true)

var solution = 0
var solved = false
var col = -1
var row = -1
var box = -1	#3x3 set of cells. indexed left->right then top->bottom

#var GRID_PURPLE = Color("7b5974")
var CELL_AQUA = Color("75d1be")
var CELL_YELLOW = Color("ede989")


# Called when the node enters the scene tree for the first time.
func _ready():
	#tbd: apply solution number?
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_coords():
	col = get_index() % 9
	row = floor(get_index() / 9)
	
	var bc = int(col/3)
	var br = int(row/3)
	box = bc + (3 * br)
	
	col += 1	#1-indexing
	row += 1
	box += 1


func add_note(n):
	if solved: return
		
	n = int(n)
	if n in notes:
		remove_note(n)
	else:
		notes.append(n)
		if n in markup:
			$Notes.get_child(n-1).self_modulate = Color.white
		else:
			$Notes.get_child(n-1).self_modulate = Color.crimson


func remove_note(n):
	if solved: return
	
	n = int(n)
	if n in notes:
		notes.erase(n)
		$Notes.get_child(n-1).self_modulate = Color.transparent


func show_notes():
	$Notes.modulate = Color.white


func hide_notes():
	$Notes.modulate = Color.transparent


func remove_markup(n):
	n = int(n)
	markup.erase(n)


func input_solution(n):
	n = int(n)
	if n == solution:
		$Solution.self_modulate = Color.white
	else:
		$Solution.self_modulate = Color.crimson
	
	$Solution.text = str(n)
	$Notes.visible = false
	solved = true
	emit_signal("solve", col, row, box, n)


func input_is_num(event):
	return event is InputEventKey and event.is_pressed()

func interpret_num(event):
	var input_string = OS.get_scancode_string(event.scancode)
	if int(input_string) in range(1, 10):
		return input_string


func _on_Cell_focus_entered():
	#print('(r', row, ' c', col, ': b', box, ')')
	$Select_Highlight.show()


func _on_Cell_focus_exited():
	$Select_Highlight.self_modulate = CELL_AQUA
	$Select_Highlight.hide()
	
	# if mouse is not over cell: ?
	$Hover_Highlight.hide()
	
	note_mode = false


func _on_Cell_mouse_entered():
	$Hover_Highlight.show()


func _on_Cell_mouse_exited():
	$Hover_Highlight.hide()


func _on_Cell_gui_input(event):
	if has_focus() and Input.is_action_just_pressed("ui_cancel"):
		release_focus()
	
	elif has_focus() and input_is_num(event):
		var num = interpret_num(event)
		if num != null:
			if note_mode:
				add_note(num)
			else:
				input_solution(num)
				release_focus()
	
	elif Input.is_action_just_pressed("note"):
		grab_focus()
		$Select_Highlight.self_modulate = CELL_YELLOW
		note_mode = true
	
	elif Input.is_action_just_pressed("select"):
		$Select_Highlight.self_modulate = CELL_AQUA
		note_mode = false

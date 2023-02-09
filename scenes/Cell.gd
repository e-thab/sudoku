extends Control

signal solve(col, row, box, n)

var markup = [1, 2, 3, 4, 5, 6, 7, 8, 9] # actual possible answers, culled after solution generated
var notes = [] # user notes
var note_mode = false	# distinguish when entering solution (false) vs entering note (true)

#var solutions = []
var solution = 0
var lonely = 0
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
	#set_bg()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reset():
	solution = 0
	lonely = 0
	solved = false
	markup = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	notes = []
	$Solution.text = ''
	$Notes.visible = true
	set_bg()


func prep():
#	lonely = 0
	solved = false
	markup = [1, 2, 3, 4, 5, 6, 7, 8, 9] #?
	notes = []
	show_markup()
	set_bg()


func set_coords():
	col = get_index() % 9
	row = floor(get_index() / 9)
	
	var bc = int(col/3)
	var br = int(row/3)
	box = bc + (3 * br)
	
#	col += 1	#1-indexing
#	row += 1
#	box += 1

func random_choice(arr):
	# Return random element from array
	if arr:
		return arr[randi() % len(arr)]


func input_note(n):
	if solved: return
		
	n = int(n)
	if n in notes:
		remove_note(n)
	else:
		add_note(n)
#		notes.append(n)


func add_note(n):
	if solved: return
	
	n = int(n)
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


func show_markup():
	for n in range(1, 10):
		if n in markup:
			add_note(n)
		elif n in notes:
			remove_note(n)


func highlight_markup(n):
	$Notes.get_child(n-1).self_modulate = $Background.self_modulate.inverted()


func remove_markup(n):
	n = int(n)
	markup.erase(n)


func input_solution(n):
	n = int(n)
	if n == solution:
		$Solution.self_modulate = Color.white
		solved = true
	else:
		$Solution.self_modulate = Color.crimson
	
	$Solution.text = str(n)
	$Notes.visible = false
	#$Background.self_modulate = Color.black
#	solved = true
	#solution = n
#	solutions.append(n)
	emit_signal("solve", col, row, box, n)


func input_random_solution():
	if solved: return
	var rand = random_choice(markup)
	input_solution(rand)


func set_solution(n):
	solution = n
	solved = true
	emit_signal("solve", col, row, box, n)


func set_random_solution():
#	if solved: return
	var rand = random_choice(markup)
	set_solution(rand)


func show_solution():
	$Solution.text = str(solution)
	$Solution.self_modulate = Color.black


func solve():
	input_solution(solution)


#func show_average():
#	var avg = avg(solutions)
#	$Solution.text = str(avg)
#	#$Solution.self_modulate = Color.black


func avg(arr):
	if arr:
		var t = 0
		for x in arr:
			t += x
		return t / len(arr)


func set_bg():
	if solved: return
	
	var color = Color.black
	match len(markup):
		1:
			color = Color(1, 0, 0)
		2:
			color = Color(1, 0.33, 0)
		3:
			color = Color(1, 0.67, 0)
		4:
			color = Color(1, 1, 0)
		5:
			color = Color(0.67, 1, 0)
		6:
			color = Color(0.33, 1, 0)
		7:
			color = Color(0, 1, 0)
		8:
			color = Color(0, 1, 0.33)
		9:
			color = Color(0, 1, 0.67)
	$Background.self_modulate = color


#func remove_solution():
#	$Solution.text = ''
#	$Notes.visible = true
#	solved = false


func input_is_num(event):
	if event is InputEventKey and event.is_pressed():
		return interpret_num(event) != null
	return false

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
	if has_focus():
		if Input.is_action_just_pressed("ui_cancel"):
			release_focus()
		
#		elif Input.is_action_just_pressed("delete"):
#			remove_solution()
		
		elif Input.is_action_just_pressed("random_val"):
			input_random_solution()
		
		elif input_is_num(event):
			var num = interpret_num(event)
			if num != null:
				if note_mode:
					input_note(num)
				else:
					input_solution(num)
					release_focus()
			print("(", col, ", ", row, ", ", box, ")")
	
	elif Input.is_action_just_pressed("note"):
		grab_focus()
		$Select_Highlight.self_modulate = CELL_YELLOW
		note_mode = true
	
	elif Input.is_action_just_pressed("select"):
		$Select_Highlight.self_modulate = CELL_AQUA
		note_mode = false

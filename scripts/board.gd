extends Node

# Declare member variables here. Examples:
var rows = [null, [], [], [], [], [], [], [], [], []]	#2D array [row][row index]
var cols = [null, [], [], [], [], [], [], [], [], []]	#2D array [col][col index]
var boxes = [null, [], [], [], [], [], [], [], [], []]	#2D array [box][col index]
var solutions = [null]	# Array of solutions, 1-indexed
							# Above arrays are 1-indexed for sudoku standards
							# Boxes indexed left to right, top to bottom
var cells = []	# Holds references to each cell, top left to bottom right


#func _init():
#	print("init")


func _ready():
	for cell in get_children():
		cell.set_coords()
		cells.append(cell)
		rows[cell.row].append(cell)
		cols[cell.col].append(cell)
		boxes[cell.box].append(cell)
		cell.connect("solve", self, "_on_solve")
		cell.show_markup()
	#generate()
	
#	for cell in cells:
#		# delete this
#		cell.show_solution()


func generate():
	print("generating")
	solutions = [null]
	randomize_board()
	
	#for x in rows:			#load into solutions
	#	x.insert(0, null)	#1-indexing
	#	solutions.append(x)
	
	#cols = _rows_to_cols(rows)
	# populate boxes?
	
	for x in solutions:
		print(x)


func randomize_board():
	# 1: find next empty cell, prioritizing fewest remaining possibilities
	# 2: generate a random number from those possibilities
	# 3: fill cell
	# 4: remove that random from markups of associated cells
	# 5: repeat.
	
	#var rnd = randi() % 9 + 1
	#cells[0].set_solution(rnd)	# Set first rand solution in top left cell
	
	for cell in cells:
		var min_cell = min_possible_cell()			# Get minimum possible solution cell
		
		var only = false
		# if there is a number in that row/col/box that can only go in that cell,
		# even if the cell has other possibilities that number should be entered
		
		var rnd = random_choice(min_cell.markup)	# Generate random int from its solutions
		min_cell.set_solution(rnd)					# Set cell solution to the random int
		#_on_solve(cell.col, cell.row, cell.box, rnd)	#"Solve" cell to remove markups
		print('Setting cell (', min_cell.col, ', ', min_cell.row, ') to ', rnd)
	
	for cell in cells:
		solutions.append(cell.solution)
	


func min_possible_cell():
	# Return the cell object with the fewest remaining solution possibilities
	# In a tie, return first from top left to bottom right
	var min_amt = 10
	var min_cell
	
	for cell in cells:
		if (cell.solution == 0) and (len(cell.markup) < min_amt):
			min_cell = cell
			min_amt = len(cell.markup)
	
	return min_cell


func random_choice(arr):
	# Return random element from array
	if arr:
		return arr[randi() % len(arr)]

#func remove_box(arr, item):
#	# removes numbers in array associated with same box
#	# e.g. if index is 4, remove (3, 4, 5)
#	# if index is 0, remove (0, 1, 2)
#	if item in [0, 1, 2]:
#		arr.remove(0)
#		arr.remove(1)
#		arr.remove(2)
#
#	elif item in [3, 4, 5]:
#		arr.remove(3)
#		arr.remove(4)
#		arr.remove(5)
#
#	elif item in [6, 7, 8]:
#		arr.remove(6)
#		arr.remove(7)
#		arr.remove(8)


#func value_swap(val1, val2):
#	if val1 == val2:
#		return
#
#	#print('swapping ', val1, ' with ', val2)
#	for row in rows:
#		for i in range(9):
#			if row[i] == val1:
#				row[i] = val2
#
#			elif row[i] == val2:
#				row[i] = val1


func find_lonely():
	for cell in cells:
		for n in cell.markup:
			if is_lonely(cell.col, cell.row, cell.box, n):
				cell.highlight_markup(n)


func is_lonely(col, row, box, n):
	var found = 0
	for cell in cols[col]:
		if !cell.solved and n in cell.markup:
			found += 1
		if found > 1:
			break
	if found == 1:
		return true
	
	found = 0
	for cell in rows[row]:
		if !cell.solved and n in cell.markup:
			found += 1
		if found > 1:
			break
	if found == 1:
		return true
	
	found = 0
	for cell in boxes[box]:
		if !cell.solved and n in cell.markup:
			found += 1
		if found > 1:
			break
	if found == 1:
		return true
	
	return false


func _rows_to_cols(old):
	var new = []
	for i in range(9):
		new.append([])
		for j in range(9):
			new[i].append(old[j][i])
	return new


func _on_solve(col, row, box, n):
	for cell in rows[row]:
		cell.remove_markup(n)
		cell.remove_note(n)
		cell.set_bg()
		
	for cell in cols[col]:
		cell.remove_markup(n)
		cell.remove_note(n)
		cell.set_bg()
		
	for cell in boxes[box]:
		cell.remove_markup(n)
		cell.remove_note(n)
		cell.set_bg()
	
	find_lonely()

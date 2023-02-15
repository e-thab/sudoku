extends Node

# Declare member variables here. Examples:
var rows = [[], [], [], [], [], [], [], [], []]		#2D array [row][row index]
var cols = [[], [], [], [], [], [], [], [], []]		#2D array [col][col index]
var boxes = [[], [], [], [], [], [], [], [], []]	#2D array [box][col index]
var solutions = [[], [], [], [], [], [], [], [], []]	#Array of solutions, indexed left to right, top to bottom

var cells = []	# Holds references to each cell object, top left to bottom right
var generated = 0	# Number of cells filled during generation
var solved = 0	# For keeping track of number solved, win when = 81
var errors = 0	# For testing error rate of generation algorithm


#func _init():
#	print("init")


func _ready():
	randomize()
	debug_reset()
	
	for cell in get_children():
		cell.set_coords()
		cells.append(cell)
		rows[cell.row].append(cell)
		cols[cell.col].append(cell)
		boxes[cell.box].append(cell)
		cell.connect("solve", self, "_on_solve")
		cell.connect("assign", self, "update_markup")
		cell.show_markup()
	
	generate()
	for cell in cells:
		cell.prep()
#		cell.show_solution()
	randomize_clues()
	
	#avg_test()


func avg_test():
	var iterations = 1_000
	
	for _i in range(iterations):
		generate()
		
	#for cell in cells:
		#cell.set_bg()
		#cell.show_average()
	print('Errors: ', errors)
	print('Error rate: ', float(errors) / float(iterations))


func generate():
	#print("generating")
	solutions = [[], [], [], [], [], [], [], [], []]
	reset_cells()
	randomize_solutions()
	
#	for cell in cells:
#		cell.set_bg()
	
#	for i in range(1, len(rows)):			#load into solutions
#		solutions.append([])
#		for cell in rows[i]:
		#.insert(0, null)	#1-indexing
#			solutions[i-1].append(cell.solution)
	
#	for i in range(1, len(rows)):
#		for cell in rows[i]:
#			solutions[i].append(cell.solution)
	
#	cols = _rows_to_cols(rows)
	 #populate boxes?
	
	#for x in solutions:
		#print(x)

# Generate solutions for each cell
func randomize_solutions():
	# 1: find any cells with lonely digits, if one exists: fill it and go to step 1
	# 2: find any cells with naked singles, if one exists: fill it and go to step 1
	# 3: find the next unsolved cell with the fewest possibilities
	# 4: fill cell with a random number generated from those possibilities
	# 5: repeat
	#
	# Testing shows this algorithm has around a 1.8% chance to generate a
	# dead end, so it just resets and tries again if it fails

	generated = 0
	while generated < 81:
		var next_cell = next_cell()
		
		if len(next_cell.markup) == 0:
			print("ERROR: Regenerating...")
			generate()
			break
		
		elif next_cell.lonely != 0:
			next_cell.set_solution(next_cell.lonely)
			generated += 1
			
		elif len(next_cell.markup) == 1:
			var n = next_cell.markup[0]
			next_cell.set_solution(n)
			generated += 1
			
		else:
			next_cell.set_random_solution()
			generated += 1
			
#		mark_lonely()

# Generate clues
func randomize_clues():
	# Should eventually be a function of some difficulty modifier
	var cells_copy = cells.duplicate()
	cells_copy.shuffle()
	
	for i in range(35):
		cells_copy[i].solve()


# Return the next cell to be filled for generation
func next_cell():
	var min_amt = 10
	var next_cell
	
	for cell in cells:
		if !cell.solved:
			if cell.lonely != 0:
				return cell
			if len(cell.markup) == 1:
				return cell
			elif len(cell.markup) < min_amt:
				next_cell = cell
				min_amt = len(cell.markup)
	
	return next_cell


func reset_cells():
	for cell in cells:
		cell.reset()

# Return a random element from an array
func random_choice(arr):
	if arr:
		return arr[randi() % len(arr)]


func mark_lonely():
	for cell in cells:
		if !cell.solved:
			for n in cell.markup:
				if is_lonely(cell.col, cell.row, cell.box, n):
					cell.lonely = n
					cell.highlight_markup(n)
					return


func is_lonely(col, row, box, n):
	var found = 0
	for cell in cols[col]:
		if (!cell.solved) and (n in cell.markup):
			found += 1
		if found > 1:
			break
	if found == 1:
		return true
	
	found = 0
	for cell in rows[row]:
		if (!cell.solved) and (n in cell.markup):
			found += 1
		if found > 1:
			break
	if found == 1:
		return true
	
	found = 0
	for cell in boxes[box]:
		if (!cell.solved) and (n in cell.markup):
			found += 1
		if found > 1:
			break
	if found == 1:
		return true
	
	return false

# Clear debug file
func debug_reset():
	var file = File.new()
	file.open("C:/Users/ls/Desktop/out.txt", File.WRITE)
	file.store_string('')
	file.close()

# Add line to debug file (append)
func debug_txt(s):
	var file = File.new()
	file.open("C:/Users/ls/Desktop/out.txt", File.READ_WRITE)
	file.seek_end()
	file.store_line(s)
	file.close()

# Add debug line showing cell solution set
func debug_set(cell, n):
	debug_txt("(" + str(cell.col) + ", " + str(cell.row) + ", " + str(cell.box) + ") set to " + str(n))


func reset_markup():
	for cell in cells:
		cell.markup = []
	
	for col in range(9):
		for row in range(9):
			for box in range(9):
				for n in range(1, 10):
					if valid_markup(col, row, box, n):
						cells[row][col].markup.append(n)


func get_neighbors(col, row, box):
	# return an array of all the cells that can see indicated cell
	var neighbors = []
	return neighbors


func valid_markup(col, row, box, n):
	for cell in rows[row]:
		if cell.visible_solution == n:
			return false
	
	for cell in cols[col]:
		if cell.solution == n:
			return false
	
	for cell in boxes[box]:
		if cell.solution == n:
			return false


func update_markup(col, row, box, n):
	for cell in rows[row]:
		cell.remove_markup(n)
		cell.show_markup()
		#cell.set_bg()
		
	for cell in cols[col]:
		cell.remove_markup(n)
		cell.show_markup()
		#cell.set_bg()
		
	for cell in boxes[box]:
		cell.remove_markup(n)
		cell.show_markup()
		#cell.set_bg()
	
	mark_lonely()


func _on_solve(col, row, box, n):
	if solved == 80:
		print('you are win')
	else:
		solved += 1
	
	update_markup(col, row, box, n)

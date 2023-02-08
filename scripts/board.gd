extends Node

# Declare member variables here. Examples:
var rows = [[], [], [], [], [], [], [], [], []]	#2D array [row][row index]
var cols = [[], [], [], [], [], [], [], [], []]	#2D array [col][col index]
var boxes = [[], [], [], [], [], [], [], [], []]	#2D array [box][col index]
var solutions = []	# Array of solutions, indexed left to right, top to bottom
var cells = []	# Holds references to each cell, top left to bottom right
var solved = 0
var errors = 0


#func _init():
#	print("init")


func _ready():
	randomize()
	
	for cell in get_children():
		cell.set_coords()
		cells.append(cell)
		rows[cell.row].append(cell)
		cols[cell.col].append(cell)
		boxes[cell.box].append(cell)
		cell.connect("solve", self, "_on_solve")
		cell.connect("set", self, "_on_set")
		cell.show_markup()
	generate()
	
#	for cell in cells:
#		# delete this
#		cell.show_solution()
	#avg_test()


func avg_test():
	var iterations = 1_000
	
	for _i in range(iterations):
		generate()
		
	#for cell in cells:
		#cell.set_bg()
		#cell.show_average()
	print('Errors: ', errors)
	print('Avg error rate: ', float(errors) / float(iterations))


func generate():
	#print("generating")
	solutions = [[], [], [], [], [], [], [], [], []]
	reset_cells()
	randomize_board()
	
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


func randomize_board():
	# 1: find any cells with lonely digits, fill them if they exist
	# 2: find any cells with naked singles, fill them if they exist
	# 3: find the next unsolved cell with the fewest possibilities
	# 4: fill cell with a random number generated from those possibilities
	# 5: repeat
	
	#var rnd = randi() % 9 + 1
	#cells[0].set_solution(rnd)	# Set first rand solution in top left cell
	#reset_debug()
	while solved < 81:
		#var min_cell = min_possible_cell()			# Get minimum possible solution cell
		var next_cell = next_cell()
		
		if len(next_cell.markup) == 0:
			print("ERROR: Regenerating...")
			generate()
			break
		
		elif next_cell.lonely != 0:
			#next_cell.input_solution(next_cell.lonely)
			next_cell.set_solution(next_cell.lonely)
			solved += 1
			
		elif len(next_cell.markup) == 1:
			var n = next_cell.markup[0]
			next_cell.set_solution(n)
			solved += 1
			#next_cell.input_solution(n)
			
		else:
			next_cell.set_random_solution()
			solved += 1
			#next_cell.input_random_solution()
		
		mark_lonely()
	solved = 0
	
#	for cell in cells:
#		solutions.append(cell.solution)


func next_cell():
	var min_amt = 10
	var next_cell
	
	for cell in cells:
		if !cell.solved:
			if cell.lonely != 0:
				return cell
				#cell.input_solution(cell.lonely)
			elif len(cell.markup) == 1:
				return cell
				#cell.input_solution(cell.markup[0])
			elif len(cell.markup) < min_amt:
				next_cell = cell
				min_amt = len(cell.markup)
		
	return next_cell
	

func min_possible_cell():
	# Return the cell object with the fewest remaining solution possibilities
	# In a tie, return first from top left to bottom right
	var min_amt = 10
	var min_cell
	
	for cell in cells:
		if (!cell.solved) and (len(cell.markup) < min_amt):
			min_cell = cell
			min_amt = len(cell.markup)
	
	return min_cell


func reset_cells():
	for cell in cells:
		cell.reset()


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


func mark_lonely():
	for cell in cells:
		if !cell.solved:
			for n in cell.markup:
				if is_lonely(cell.col, cell.row, cell.box, n):
					cell.lonely = n
					cell.highlight_markup(n)
					#cell.input_solution(n)
					return


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


func reset_debug():
	var file = File.new()
	file.open("C:/Users/ls/Desktop/out.txt", File.WRITE)
	file.store_string('')
	file.close()

func debug_txt(s):
	var file = File.new()
	file.open("C:/Users/ls/Desktop/out.txt", File.READ_WRITE)
	file.seek_end()
	file.store_line(s)
	file.close()


func _rows_to_cols(old):
	var new = []
	for i in range(9):
		new.append([])
		for j in range(9):
			new[i].append(old[j][i])
	return new


func _on_set(col, row, box, n):
#	for cell in rows[row]:
#		cell.remove_markup(n)
#
#	for cell in cols[col]:
#		cell.remove_markup(n)
#
#	for cell in boxes[box]:
#		cell.remove_markup(n)
	solved += 1


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
	
	#print('(', col, ', ', row, ') set to ', n)
	mark_lonely()
	#debug_txt('(' + str(col) + ', ' + str(row) + ') set to ' + str(n))

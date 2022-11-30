extends Node

class_name Board

# Declare member variables here. Examples:
var rows = [null, [], [], [], [], [], [], [], [], []]
var cols = [null, [], [], [], [], [], [], [], [], []]
var boxes = [null, [], [], [], [], [], [], [], [], []]
var solutions = [null]


func _init():
	generate()


func generate():
#	rows = [
#		[1, 2, 3,	4, 5, 6,	7, 8, 9],	# begin with trivial board
#		[4, 5, 6,	7, 8, 9,	1, 2, 3],
#		[7, 8, 9,	1, 2, 3,	4, 5, 6],
#
#		[2, 3, 1,	5, 6, 4,	8, 9, 7],
#		[5, 6, 4,	8, 9, 7,	2, 3, 1],
#		[8, 9, 7,	2, 3, 1,	5, 6, 4],
#
#		[3, 1, 2,	6, 4, 5,	9, 7, 8],
#		[6, 4, 5,	9, 7, 8,	3, 1, 2],
#		[9, 7, 8,	3, 1, 2,	6, 4, 5],
#	]
#
#	shuffle()
	rows = random_rows()
	
	solutions = [null]
	for x in rows:			#load into solutions
		x.insert(0, null)	#1-indexing
		solutions.append(x)
	
	cols = _rows_to_cols(rows)
	# populate boxes
	
	for x in solutions:
		print(x)


func random_rows():
	var rands = []
	for i in range(9):
		rands.append(range(9))
	
	for num in range(1, 10):
		var available_rows = range(9)
		var available_cols = range(9)
		
		for i in range(9):
			if i < 8:
				available_rows.shuffle()
				available_cols.shuffle()
				#var rnd = randi() % len(available_rows)
			
			var row_pos = available_rows.pop_back()
			var col_pos = available_cols.pop_back()
			remove_box(available_rows, row_pos)
			remove_box(available_cols, col_pos)
			
			rands[row_pos][col_pos] = num
	
	for r in rands:
		print(r)
	
	return rands


func remove_box(arr, item):
	# removes numbers in array associated with same box
	# e.g. if index is 4, remove (3, 4, 5)
	# if index is 0, remove (0, 1, 2)
	if item in [0, 1, 2]:
		arr.remove(0)
		arr.remove(1)
		arr.remove(2)
	
	elif item in [3, 4, 5]:
		arr.remove(3)
		arr.remove(4)
		arr.remove(5)
	
	elif item in [6, 7, 8]:
		arr.remove(6)
		arr.remove(7)
		arr.remove(8)


func shuffle():
	shuffle_box_cols()	# randomly order 9x3 cols
	shuffle_box_rows()	# randomly order 9x3 rows
	shuffle_cols()		# randomly order each set of 3 cols
	shuffle_rows()		# randomly order each set of 3 rows
	shuffle_values()	# randomly swap pairs of cell values
	# ^ bad solution


func shuffle_values():
	var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	nums.shuffle()
	
	for n in nums:
		if n-1 != nums[n-1]:
			value_swap(n, nums[n-1])


func value_swap(val1, val2):
	if val1 == val2:
		return
	
	#print('swapping ', val1, ' with ', val2)
	for row in rows:
		for i in range(9):
			if row[i] == val1:
				row[i] = val2
				
			elif row[i] == val2:
				row[i] = val1


func shuffle_box_rows():
	var rnd = [0, 1, 2]
	rnd.shuffle()
	print(rnd)
	
	var rows_copy = rows.duplicate()
	
	for i in range(3):
		for j in range(3):
			rows[i*3 + j] = rows_copy[rnd[i]*3 + j]


func shuffle_box_cols():
	var rnd = [0, 1, 2]
	rnd.shuffle()
	print(rnd)
	
	cols = _rows_to_cols(rows)
	var cols_copy = cols.duplicate()
	
	for i in range(3):
		for j in range(3):
			cols[i*3 + j] = cols_copy[rnd[i]*3 + j]
	
	rows = _rows_to_cols(cols)


func shuffle_rows():
	for i in [0, 3, 6]:
		var rnd = [0, 1, 2]
		rnd.shuffle()
		print(rnd)
		
		var original = []
		for j in range(3):
			original.append(rows[i + j])
		
		for j in range(3):
			rows[i + j] = original[rnd[j]]


func shuffle_cols():
	for i in [0, 3, 6]:
		var rnd = [0, 1, 2]
		rnd.shuffle()
		print(rnd)
		cols = _rows_to_cols(rows)
		
		var original = []
		for j in range(3):
			original.append(cols[i + j])
		
		for j in range(3):
			cols[i + j] = original[rnd[j]]
		
		rows = _rows_to_cols(cols)


func _rows_to_cols(old):
	var new = []
	for i in range(9):
		new.append([])
		for j in range(9):
			new[i].append(old[j][i])
	return new

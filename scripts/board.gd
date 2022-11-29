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
	rows = [
		[1, 2, 3,	4, 5, 6,	7, 8, 9],	# begin with trivial board
		[4, 5, 6,	7, 8, 9,	1, 2, 3],
		[7, 8, 9,	1, 2, 3,	4, 5, 6],
		
		[2, 3, 1,	5, 6, 4,	8, 9, 7],
		[5, 6, 4,	8, 9, 7,	2, 3, 1],
		[8, 9, 7,	2, 3, 1,	5, 6, 4],
		
		[3, 1, 2,	6, 4, 5,	9, 7, 8],
		[6, 4, 5,	9, 7, 8,	3, 1, 2],
		[9, 7, 8,	3, 1, 2,	6, 4, 5],
	]
	
	shuffle()
	
	for x in rows:			#load into solutions
		x.insert(0, null)	#1-indexing
		solutions.append(x)
	
	for x in solutions:
		print(x)


func shuffle():
	var nums = [0, 1, 2]
	nums.shuffle()

	#row_box_swap(board, nums)
	#col_box_swap(board, nums)
	shuffle_rows()
	swap_values()
	
	#nums.shuffle()
	#for i in range(3):
	#	col_box_swap(board, i, nums[i])


func swap_values():
	var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	nums.shuffle()
	for n in nums:
		if n-1 != nums[n-1]:
			value_swap(n, nums[n-1])


func value_swap(val1, val2):
	if val1 == val2:
		return
	
	print('swapping ', val1, ' with ', val2)
	for row in rows:
		for i in range(9):
			if row[i] == val1:
				row[i] = val2
				
			elif row[i] == val2:
				row[i] = val1


func row_swap(r1, r2):
	print('swapping ', r1, ' with ', r2)
	var temp = rows[r1]
	rows[r1] = rows[r2]
	rows[r2] = temp


func row_box_swap(rnd):
	var rows_copy = rows.duplicate()
	for i in range(3):
		for j in range(3):
			rows[i*3 + j] = rows_copy[rnd[i]*3 + j]
			#print('row ', i*3 + j, ' = row ', rnd[i]*3 + j)


func col_box_swap(rnd):
	var columns = []
	for i in range(9):
		columns.append([])
		for j in range(9):
			columns[i].append(rows[j][i])
	
	var columns_copy = columns.duplicate()
	for i in range(3):
		for j in range(3):
			columns[i*3 + j] = columns_copy[rnd[i]*3 + j]
			print('column ', i*3 + j, ' = column ', rnd[i]*3 + j)
	
	for i in range(9):
		for j in range(9):
			rows[j][i] = columns[i][j]


func shuffle_rows():
	for i in [0, 3, 6]:
		shuffle_row(i)


func shuffle_row(box_ind):
	var rnd = [0, 1, 2]
	rnd.shuffle()
	print(rnd)
	
	var original = []
	for i in range(3):
		original.append(rows[box_ind + i])
	
	for i in range(3):
		rows[box_ind + i] = original[rnd[i]]


func shuffle_cols():
	var columns = get_columns(rows)
	for i in range(3):
		pass


func get_columns(board):
	pass

extends Control


# Declare member variables here. Examples:
var rows = [null, [], [], [], [], [], [], [], [], []]		#2D array [row][row index]
var cols = [null, [], [], [], [], [], [], [], [], []]		#2D array [col][col index]
var boxes = [null, [], [], [], [], [], [], [], [], []]		#2D array [box][box index]
var solutions = [null]
							# Above arrays are 1-indexed for sudoku standards
							# Boxes indexed left to right, top to bottom


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var board = Board.new()
	#generate_board()
	
	for cell in $Cells.get_children():
		cell.set_coords()
		cell.connect("solve", self, "_on_solve")
		cell.solution = board.solutions[cell.row][cell.col]
		
		rows[cell.row].append(cell)
		cols[cell.col].append(cell)
		boxes[cell.box].append(cell)
		
		#delete
		cell.show_solution()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func generate_board():
#	var board = [
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
#	shuffle_board(board)
#
#	for x in board:			#load into solutions
#		x.insert(0, null)	#1-indexing
#		solutions.append(x)
#
#	for x in solutions:
#		print(x)
#
#
#func shuffle_board(board):
#	var nums = [0, 1, 2]
#	nums.shuffle()
#
#	#row_box_swap(board, nums)
#	#col_box_swap(board, nums)
#	shuffle_rows(board)
#	swap_values(board)
#
#	#nums.shuffle()
#	#for i in range(3):
#	#	col_box_swap(board, i, nums[i])
#
#
#func swap_values(board):
#	var nums = [1, 2, 3, 4, 5, 6, 7, 8, 9]
#	nums.shuffle()
#	for n in nums:
#		if n-1 != nums[n-1]:
#			value_swap(board, n, nums[n-1])
#
#
#func value_swap(board, val1, val2):
#	if val1 == val2:
#		return
#
#	print('swapping ', val1, ' with ', val2)
#	for row in board:
#		for i in range(9):
#			if row[i] == val1:
#				row[i] = val2
#
#			elif row[i] == val2:
#				row[i] = val1
#
#
#func row_swap(board, r1, r2):
#	print('swapping ', r1, ' with ', r2)
#	var temp = board[r1]
#	board[r1] = board[r2]
#	board[r2] = temp
#
#
#func row_box_swap(board, rnd):
#	var board_copy = board.duplicate()
#	for i in range(3):
#		for j in range(3):
#			board[i*3 + j] = board_copy[rnd[i]*3 + j]
#			#print('row ', i*3 + j, ' = row ', rnd[i]*3 + j)
#
#
#func col_box_swap(board, rnd):
#	var columns = []
#	for i in range(9):
#		columns.append([])
#		for j in range(9):
#			columns[i].append(board[j][i])
#
#	var columns_copy = columns.duplicate()
#	for i in range(3):
#		for j in range(3):
#			columns[i*3 + j] = columns_copy[rnd[i]*3 + j]
#			print('column ', i*3 + j, ' = column ', rnd[i]*3 + j)
#
#	for i in range(9):
#		for j in range(9):
#			board[j][i] = columns[i][j]
#
#
#func shuffle_rows(board):
#	for i in [0, 3, 6]:
#		shuffle_row(board, i)
#
#
#func shuffle_row(board, box_ind):
#	var rnd = [0, 1, 2]
#	rnd.shuffle()
#	print(rnd)
#
#	var rows = []
#	for i in range(3):
#		rows.append(board[box_ind + i])
#
#	for i in range(3):
#		board[box_ind + i] = rows[rnd[i]]
#
#
#func shuffle_cols(board):
#	var columns = get_columns(board)
#	for i in range(3):
#		pass
#
#
#func get_columns(board):
#	pass


func _on_solve(col, row, box, n):
	for cell in rows[row]:
		cell.remove_markup(n)
		cell.remove_note(n)
		
	for cell in cols[col]:
		cell.remove_markup(n)
		cell.remove_note(n)
		
	for cell in boxes[box]:
		cell.remove_markup(n)
		cell.remove_note(n)

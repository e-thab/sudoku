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
	generate_board()
	
	for cell in $Cells.get_children():
		cell.set_coords()
		cell.connect("solve", self, "_on_solve")
		cell.solution = solutions[cell.row][cell.col]
		
		rows[cell.row].append(cell)
		cols[cell.col].append(cell)
		boxes[cell.box].append(cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func generate_board():
	var trivial_board = [
		[1, 2, 3,	4, 5, 6,	7, 8, 9],
		[4, 5, 6,	7, 8, 9,	1, 2, 3],
		[7, 8, 9,	1, 2, 3,	4, 5, 6],
		
		[2, 3, 1,	5, 6, 4,	8, 9, 7],
		[5, 6, 4,	8, 9, 7,	2, 3, 1],
		[8, 9, 7,	2, 3, 1,	5, 6, 4],
		
		[3, 1, 2,	6, 4, 5,	9, 7, 8],
		[6, 4, 5,	9, 7, 8,	3, 1, 2],
		[9, 7, 8,	3, 1, 2,	6, 4, 5],
	]
	
	for x in trivial_board:
		x.insert(0, null)	#1-indexing
		solutions.append(x)
	
	for x in solutions:
		print(x)


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

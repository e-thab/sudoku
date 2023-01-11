extends Control


# Declare member variables here. Examples:
#var rows = [null, [], [], [], [], [], [], [], [], []]		#2D array [row][row index]
#var cols = [null, [], [], [], [], [], [], [], [], []]		#2D array [col][col index]
#var boxes = [null, [], [], [], [], [], [], [], [], []]		#2D array [box][box index]
#var solutions = [null]
							# Above arrays are 1-indexed for sudoku standards
							# Boxes indexed left to right, top to bottom


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#var board = Board.new()
	#generate_board()
	
#	for cell in $Cells.get_children():
#		cell.set_coords()
#		cell.connect("solve", self, "_on_solve")
#		cell.solution = board.solutions[cell.row][cell.col]
#
#		rows[cell.row].append(cell)
#		cols[cell.col].append(cell)
#		boxes[cell.box].append(cell)
#
#		#delete
#		cell.show_solution()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_solve(col, row, box, n):
#	for cell in rows[row]:
#		cell.remove_markup(n)
#		cell.remove_note(n)
#
#	for cell in cols[col]:
#		cell.remove_markup(n)
#		cell.remove_note(n)
#
#	for cell in boxes[box]:
#		cell.remove_markup(n)
#		cell.remove_note(n)

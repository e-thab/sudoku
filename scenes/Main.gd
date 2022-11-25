extends Control


# Declare member variables here. Examples:
var rows = [[], [], [], [], [], [], [], [], []]		#2D array [row][row index]
var cols = [[], [], [], [], [], [], [], [], []]		#2D array [col][col index]
var tiles = [[], [], [], [], [], [], [], [], []]	#2D array [tile][tile index]
							#tile index is from left to right, top to bottom


# Called when the node enters the scene tree for the first time.
func _ready():
	for square in $Board.get_children():
		square.set_coords()
		square.connect("solve", self, "_on_solve")
		
		rows[square.row].append(square)
		cols[square.col].append(square)
		tiles[square.tile].append(square)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_solve(col, row, tile, n):
	for sq in rows[row]:
		sq.remove_note(n)
	for sq in cols[col]:
		sq.remove_note(n)
	for sq in tiles[tile]:
		sq.remove_note(n)

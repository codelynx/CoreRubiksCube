//: Playground - noun: a place where people can play

import Cocoa


let cube = Cube()

print(cube)

assert(cube.makeFront(.counterclockwise).makeFront(.clockwise) == cube)
assert(cube.makeBack(.counterclockwise).makeBack(.clockwise) == cube)
assert(cube.makeUp(.counterclockwise).makeUp(.clockwise) == cube)
assert(cube.makeDown(.counterclockwise).makeDown(.clockwise) == cube)
assert(cube.makeLeft(.counterclockwise).makeLeft(.clockwise) == cube)
assert(cube.makeRight(.counterclockwise).makeRight(.clockwise) == cube)

assert(cube.makeFront(.double).makeFront(.double) == cube)
assert(cube.makeBack(.double).makeBack(.double) == cube)
assert(cube.makeUp(.double).makeUp(.double) == cube)
assert(cube.makeDown(.double).makeDown(.double) == cube)
assert(cube.makeLeft(.double).makeLeft(.double) == cube)
assert(cube.makeRight(.double).makeRight(.double) == cube)

assert(cube.makeMove(Movement.front(turn: .clockwise)).makeMove(Movement.front(turn: .counterclockwise)) == cube)
assert(cube.makeMove(Movement.back(turn: .clockwise)).makeMove(Movement.back(turn: .counterclockwise)) == cube)
assert(cube.makeMove(Movement.up(turn: .clockwise)).makeMove(Movement.up(turn: .counterclockwise)) == cube)
assert(cube.makeMove(Movement.down(turn: .clockwise)).makeMove(Movement.down(turn: .counterclockwise)) == cube)
assert(cube.makeMove(Movement.left(turn: .clockwise)).makeMove(Movement.left(turn: .counterclockwise)) == cube)
assert(cube.makeMove(Movement.right(turn: .clockwise)).makeMove(Movement.right(turn: .counterclockwise)) == cube)

assert(cube.makeMove(Movement.front(turn: .double)).makeMove(Movement.front(turn: .double)) == cube)
assert(cube.makeMove(Movement.back(turn: .double)).makeMove(Movement.back(turn: .double)) == cube)
assert(cube.makeMove(Movement.up(turn: .double)).makeMove(Movement.up(turn: .double)) == cube)
assert(cube.makeMove(Movement.down(turn: .double)).makeMove(Movement.down(turn: .double)) == cube)
assert(cube.makeMove(Movement.left(turn: .double)).makeMove(Movement.left(turn: .double)) == cube)
assert(cube.makeMove(Movement.right(turn: .double)).makeMove(Movement.right(turn: .double)) == cube)


let moves: [Movement] = [
	.front(turn: .clockwise), .back(turn: .clockwise),
	.up(turn: .clockwise), .down(turn: .clockwise),
	.left(turn: .clockwise), .right(turn: .clockwise),
	.front(turn: .counterclockwise), .back(turn: .counterclockwise),
	.up(turn: .counterclockwise), .down(turn: .counterclockwise),
	.left(turn: .counterclockwise), .right(turn: .counterclockwise),
	.front(turn: .double), .back(turn: .double),
	.up(turn: .double), .down(turn: .double),
	.left(turn: .double), .right(turn: .double)
]

assert(cube.makeMoves(moves).reverseMoves(moves) == cube)


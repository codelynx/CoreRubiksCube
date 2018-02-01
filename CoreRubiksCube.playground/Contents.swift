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

assert(cube.makeMove(Movement.front(.clockwise)).makeMove(Movement.front(.counterclockwise)) == cube)
assert(cube.makeMove(Movement.back(.clockwise)).makeMove(Movement.back(.counterclockwise)) == cube)
assert(cube.makeMove(Movement.up(.clockwise)).makeMove(Movement.up(.counterclockwise)) == cube)
assert(cube.makeMove(Movement.down(.clockwise)).makeMove(Movement.down(.counterclockwise)) == cube)
assert(cube.makeMove(Movement.left(.clockwise)).makeMove(Movement.left(.counterclockwise)) == cube)
assert(cube.makeMove(Movement.right(.clockwise)).makeMove(Movement.right(.counterclockwise)) == cube)

assert(cube.makeMove(Movement.front(.double)).makeMove(Movement.front(.double)) == cube)
assert(cube.makeMove(Movement.back(.double)).makeMove(Movement.back(.double)) == cube)
assert(cube.makeMove(Movement.up(.double)).makeMove(Movement.up(.double)) == cube)
assert(cube.makeMove(Movement.down(.double)).makeMove(Movement.down(.double)) == cube)
assert(cube.makeMove(Movement.left(.double)).makeMove(Movement.left(.double)) == cube)
assert(cube.makeMove(Movement.right(.double)).makeMove(Movement.right(.double)) == cube)


let moves: [Movement] = [
	.front(.clockwise), .back(.clockwise),
	.up(.clockwise), .down(.clockwise),
	.left(.clockwise), .right(.clockwise),
	.front(.counterclockwise), .back(.counterclockwise),
	.up(.counterclockwise), .down(.counterclockwise),
	.left(.counterclockwise), .right(.counterclockwise),
	.front(.double), .back(.double),
	.up(.double), .down(.double),
	.left(.double), .right(.double)
]

assert(cube.makeMoves(moves).reverseMoves(moves) == cube)


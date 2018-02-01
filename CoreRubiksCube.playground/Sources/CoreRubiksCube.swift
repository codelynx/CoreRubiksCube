//
//  CoreRubiksCube.swift
//  CoreRubiksCube
//
//	The MIT License (MIT)
//
//	Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

import Foundation


//	Overview
//	--------
//	This code is for implementing Rubik's Cube's model and it's behavior.  It is
//	not intended for providing any graphical interface or solver related code.
//	It is however, provides basic functionality to turn faces, to reverse
//	turns, and to examine the state of the cube.
//
//	Xcode 9.2, Swift 4

//	Face:
//	A Rubik's Cube has six faces.  In order to identify specific face, each face has
//	its own unique name.  We assume, face will not move around, instead any faces
//	can be turned or spined, and each surfaces stay the same place.
//

public enum Face {
	case front
	case back
	case up
	case down
	case left
	case right
}


//	Tile:
//	Tile represent a single piece of tile of a surface.  Each surface has
//	3x3 (9) tiles.  In order to identify each tiles of the cube, each tile
//	has own unique identifier as follows.  The naming idea id taking from
//	this site http://iamthecu.be.
//
//
//				|U18|U19|U20|							:
//				|U10|U11|U12|							:         +-----+
//	            |U01|U02|U03|							:         |  U  |
//	|L18|L10|L01|F01|F02|F03|R03|R12|R20|B20|B19|B18|	:	+-----+-----+-----+-----+
//	|L21|L13|L04|F04|F05|F06|R06|R14|R23|B23|B22|B21|	:	|  L  |  F  |  R  |  B  |
//	|L24|L15|L07|F07|F08|F09|R09|R17|R16|B26|B25|B24|	:	+-----+-----+-----+-----+
//				|D07|D08|D09|							:         |  D  |
//				|D15|D16|D17|							:         +-----+
//				|D24|D25|D26|							:
//	** Figure 1 **

public enum Tile {
	case F01, F02, F03, F06, F09, F08, F07, F04, F05	// front
	case U18, U19, U20, U12, U03, U02, U01, U10, U11	// up
	case R03, R12, R20, R23, R26, R17, R09, R06, R14	// right
	case B24, B25, B26, B23, B20, B19, B18, B21, B22	// back
	case D07, D08, D09, D17, D26, D25, D24, D15, D16	// down
	case L18, L10, L01, L04, L07, L15, L24, L21, L13	// left
}

//	Turn:
//	Each surface can be turned in either `clockwise`, `counterclockwise` or `double` spins.

public enum Turn {
	case clockwise
	case counterclockwise
	case `double`

	public func reversed() -> Turn {
		switch self {
		case .clockwise: return .counterclockwise
		case .counterclockwise: return .clockwise
		case .double: return .double
		}
	}
}

//	Movement:
//	A cube can be turn any faces, `Movement` specifies which face to make turn.
//	It has an associated value with it.

public enum Movement {
	case front(Turn)
	case back(Turn)
	case up(Turn)
	case down(Turn)
	case left(Turn)
	case right(Turn)
}

//	Surface:
//	A `Surface` specifies all tiles on a face.  In order to specify a tile on a face,
//	we assign `a` to `i` for each positions of tiles.  All positions apply to all faces
//	in figure 1 including `back` face which can be controversial.
//
//		+---+---+---+
//		| a | b | c |
//		+---+---+---+
//		| d | e | f |
//		+---+---+---+
//		| g | h | i |
//		+---+---+---+
//		** Figure 2 **

public struct Surface: CustomStringConvertible, Equatable {
	public let (a, b, c): (Tile, Tile, Tile)
	public let (d, e, f): (Tile, Tile, Tile)
	public let (g, h, i): (Tile, Tile, Tile)

	init(_ a: Tile, _ b: Tile, _ c: Tile, _ d: Tile, _ e: Tile, _ f: Tile, _ g: Tile, _ h: Tile, _ i: Tile) {
		(self.a, self.b, self.c) = (a, b, c)
		(self.d, self.e, self.f) = (d, e, f)
		(self.g, self.h, self.i) = (g, h, i)
	}
	
	init(face: Face) {
		switch (face) {
		case .front: (a, b, c,  d, e, f,  g, h, i) = 	(.F01, .F02, .F03,	.F04, .F05, .F06,	.F07, .F08, .F09)
		case .back: (a, b, c,  d, e, f,  g, h, i) = 	(.B20, .B19, .B18,	.B23, .B22, .B21,	.B26, .B25, .B24)
		case .up: (a, b, c,  d, e, f,  g, h, i) = 		(.U18, .U19, .U20,	.U10, .U11, .U12,	.U01, .U02, .U03)
		case .down: (a, b, c,  d, e, f,  g, h, i) = 	(.D07, .D08, .D09,	.D15, .D16, .D17,	.D24, .D25, .D26)
		case .left: (a, b, c,  d, e, f,  g, h, i) = 	(.L18, .L10, .L01,	.L21, .L13, .L04,	.L24, .L15, .L07)
		case .right: (a, b, c,  d, e, f,  g, h, i) = 	(.R03, .R12, .R20,	.R06, .R14, .R23,	.R09, .R17, .R26)
		}
	}

	public var description: String {
		return [[a, b, c], [d, e, f], [g, h, i]].map { $0.map { String(describing: $0) }.joined(separator: "|") }.joined(separator: "\n")
	}

	func turn(_ turn: Turn) -> Surface {
		switch turn {
		case .clockwise: return Surface(g, d, a, h, e, b, i, f, c)
		case .counterclockwise: return Surface(c, f, i, b, e, h, a, d, g)
		case .double: return Surface(i, h, g, f, e, d, c, b, a)
		}
	}
	
	// accessors to pick three tiles in a row
	var abc: (Tile, Tile, Tile) { return (a, b, c) }
	var cba: (Tile, Tile, Tile) { return (c, b, a) }
	var ghi: (Tile, Tile, Tile) { return (g, h, i) }
	var ihg: (Tile, Tile, Tile) { return (i, h, g) }
	var adg: (Tile, Tile, Tile) { return (a, d, g) }
	var gda: (Tile, Tile, Tile) { return (g, d, a) }
	var cfi: (Tile, Tile, Tile) { return (c, f, i) }
	var ifc: (Tile, Tile, Tile) { return (i, f, c) }

	// returns a surface replaced by a row with other row
	func replaced(abc: (a: Tile, b: Tile, c: Tile)) -> Surface {
		return Surface(abc.a, abc.b, abc.c, d, e, f, g, h, i)
	}
	func replaced(ghi: (g: Tile, h: Tile, i: Tile)) -> Surface {
		return Surface(a, b, c, d, e, f, ghi.g, ghi.h, ghi.i)
	}
	func replaced(adg: (a: Tile, d: Tile, g: Tile)) -> Surface {
		return Surface(adg.a, b, c, adg.d, e, f, adg.g, h, i)
	}
	func replaced(cfi: (c: Tile, f: Tile, i: Tile)) -> Surface {
		return Surface(a, b, cfi.c, d, e, cfi.f, g, h, cfi.i)
	}
	
	// to conform Equatable
	public static func == (lhs: Surface, rhs: Surface) -> Bool {
		return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c &&
			   lhs.d == rhs.d && lhs.e == rhs.e && lhs.f == rhs.f &&
			   lhs.g == rhs.g && lhs.h == rhs.h && lhs.i == rhs.i
	}
 }

//	Cube:
//	`Cube` represnet a complete tiles of all faces
//

public struct Cube: CustomStringConvertible, Equatable {
	public let front: Surface
	public let back: Surface
	public let up: Surface
	public let down: Surface
	public let left: Surface
	public let right: Surface


	public init(front: Surface, back: Surface, up: Surface, down: Surface, left: Surface, right: Surface) {
		self.front = front
		self.back = back
		self.up = up
		self.down = down
		self.left = left
		self.right = right
	}

	public init() {
		front = Surface(face: .front)
		back = Surface(face: .back)
		up = Surface(face: .up)
		down = Surface(face: .down)
		left = Surface(face: .left)
		right = Surface(face: .right)
	}

	// accessor to retrieve a specific surface for the face
	public func surface(face: Face) -> Surface {
		switch (face) {
		case .front: return front
		case .back: return back
		case .up: return up
		case .down: return down
		case .left: return left
		case .right: return right
		}
	}

	// mostly debuging purpose
	public var description: String {
		let (f, b, u, d, l, r) = (front, back, up, down, left, right)
		return ([
			[	nil, nil, nil,	u.a, u.b, u.c,	nil, nil, nil,	nil, nil, nil	],
			[	nil, nil, nil,	u.d, u.e, u.f,	nil, nil, nil,	nil, nil, nil	],
			[	nil, nil, nil,	u.g, u.h, u.i,	nil, nil, nil,	nil, nil, nil	],
			[	l.a, l.b, l.c,	f.a, f.b, f.c,	r.a, r.b, r.c,	b.a, b.b, b.c	],
			[	l.d, l.e, l.f,	f.d, f.e, f.f,	r.d, r.e, r.f,	b.d, b.e, b.f	],
			[	l.g, l.h, l.i,	f.g, f.h, f.i,	r.g, r.h, r.i,	b.g, b.h, b.i	],
			[	nil, nil, nil,	d.a, d.b, d.c,	nil, nil, nil,	nil, nil, nil	],
			[	nil, nil, nil,	d.d, d.e, d.f,	nil, nil, nil,	nil, nil, nil	],
			[	nil, nil, nil,	d.g, d.h, d.i,	nil, nil, nil,	nil, nil, nil	]
		] as [[Tile?]])
		.map { "|" + $0.map { $0 != nil ? String(describing: $0!) + "|" : "   |" }.joined() }.joined(separator: "\n")
	}

	// make a turn on fornt face
	public func makeFront(_ turn: Turn) -> Cube {
		let f = front.turn(turn)
		switch turn {
		case .clockwise:
			let u = up.replaced(ghi: left.ifc)
			let r = right.replaced(adg: up.ghi)
			let d = down.replaced(abc: right.gda)
			let l = left.replaced(cfi: down.abc)
			return Cube(front: f, back: back, up: u, down: d, left: l, right: r)
		case .counterclockwise:
			let u = up.replaced(ghi: right.adg)
			let r = right.replaced(adg: down.cba)
			let d = down.replaced(abc: left.cfi)
			let l = left.replaced(cfi: up.ihg)
			return Cube(front: f, back: back, up: u, down: d, left: l, right: r)
		case .double:
			let u = up.replaced(ghi: down.cba)
			let r = right.replaced(adg: left.ifc)
			let d = down.replaced(abc: up.ihg)
			let l = left.replaced(cfi: right.gda)
			return Cube(front: f, back: back, up: u, down: d, left: l, right: r)
		}
	}

	// make a turn on back face
	public func makeBack(_ turn: Turn) -> Cube {
		let b = back.turn(turn)
		switch turn {
		case .clockwise:
			let u = up.replaced(abc: right.cfi)
			let r = right.replaced(cfi: down.ihg)
			let d = down.replaced(ghi: left.adg)
			let l = left.replaced(adg: up.cba)
			return Cube(front: front, back: b, up: u, down: d, left: l, right: r)
		case .counterclockwise:
			let u = up.replaced(abc: left.gda)
			let r = right.replaced(cfi: up.abc)
			let d = down.replaced(ghi: right.ifc)
			let l = left.replaced(adg: down.ghi)
			return Cube(front: front, back: b, up: u, down: d, left: l, right: r)
		case .double:
			let u = up.replaced(abc: down.ihg)
			let r = right.replaced(cfi: left.gda)
			let d = down.replaced(ghi: up.cba)
			let l = left.replaced(adg: right.ifc)
			return Cube(front: front, back: b, up: u, down: d, left: l, right: r)
		}
	}

	// make a turn on up face
	public func makeUp(_ turn: Turn) -> Cube {
		let u = up.turn(turn)
		switch turn {
		case .clockwise:
			let f = front.replaced(abc: right.abc)
			let l = left.replaced(abc: front.abc)
			let b = back.replaced(abc: left.abc)
			let r = right.replaced(abc: back.abc)
			return Cube(front: f, back: b, up: u, down: down, left: l, right: r)
		case .counterclockwise:
			let f = front.replaced(abc: left.abc)
			let l = left.replaced(abc: back.abc)
			let b = back.replaced(abc: right.abc)
			let r = right.replaced(abc: front.abc)
			return Cube(front: f, back: b, up: u, down: down, left: l, right: r)
		case .double:
			let f = front.replaced(abc: back.abc)
			let l = left.replaced(abc: right.abc)
			let b = back.replaced(abc: front.abc)
			let r = right.replaced(abc: left.abc)
			return Cube(front: f, back: b, up: u, down: down, left: l, right: r)
		}
	}

	// make a turn on down face
	public func makeDown(_ turn: Turn) -> Cube {
		let d = down.turn(turn)
		switch turn {
		case .clockwise:
			let f = front.replaced(ghi: left.ghi)
			let l = left.replaced(ghi: back.ghi)
			let b = back.replaced(ghi: right.ghi)
			let r = right.replaced(ghi: front.ghi)
			return Cube(front: f, back: b, up: up, down: d, left: l, right: r)
		case .counterclockwise:
			let f = front.replaced(ghi: right.ghi)
			let l = left.replaced(ghi: front.ghi)
			let b = back.replaced(ghi: left.ghi)
			let r = right.replaced(ghi: back.ghi)
			return Cube(front: f, back: b, up: up, down: d, left: l, right: r)
		case .double:
			let f = front.replaced(ghi: back.ghi)
			let l = left.replaced(ghi: right.ghi)
			let b = back.replaced(ghi: front.ghi)
			let r = right.replaced(ghi: left.ghi)
			return Cube(front: f, back: b, up: up, down: d, left: l, right: r)
		}
	}
	
	// make a turn on right face
	public func makeRight(_ turn: Turn) -> Cube {
		let r = right.turn(turn)
		switch turn {
		case .clockwise:
			let f = front.replaced(cfi: down.cfi)
			let u = up.replaced(cfi: front.cfi)
			let b = back.replaced(adg: up.ifc)
			let d = down.replaced(cfi: back.gda)
			return Cube(front: f, back: b, up: u, down: d, left: left, right: r)
		case .counterclockwise:
			let f = front.replaced(cfi: up.cfi)
			let u = up.replaced(cfi: back.gda)
			let b = back.replaced(adg: down.ifc)
			let d = down.replaced(cfi: front.cfi)
			return Cube(front: f, back: b, up: u, down: d, left: left, right: r)
		case .double:
			let f = front.replaced(cfi: back.gda)
			let u = up.replaced(cfi: down.cfi)
			let b = back.replaced(adg: front.ifc)
			let d = down.replaced(cfi: up.cfi)
			return Cube(front: f, back: b, up: u, down: d, left: left, right: r)
		}
	}

	// make a turn on left face
	public func makeLeft(_ turn: Turn) -> Cube {
		let l = left.turn(turn)
		switch turn {
		case .clockwise:
			let f = front.replaced(adg: up.adg)
			let u = up.replaced(adg: back.ifc)
			let b = back.replaced(cfi: down.gda)
			let d = down.replaced(adg: front.adg)
			return Cube(front: f, back: b, up: u, down: d, left: l, right: right)
		case .counterclockwise:
			let f = front.replaced(adg: down.adg)
			let u = up.replaced(adg: front.adg)
			let b = back.replaced(cfi: up.gda)
			let d = down.replaced(adg: back.ifc)
			return Cube(front: f, back: b, up: u, down: d, left: l, right: right)
		case .double:
			let f = front.replaced(adg: back.ifc)
			let u = up.replaced(adg: down.adg)
			let b = back.replaced(cfi: front.gda)
			let d = down.replaced(adg: up.adg)
			return Cube(front: f, back: b, up: u, down: d, left: l, right: right)
		}
	}

	// make a single turn
	public func makeMove(_ movement: Movement) -> Cube {
		switch movement {
		case .front(let turn): return makeFront(turn)
		case .back(let turn): return makeBack(turn)
		case .up(let turn): return makeUp(turn)
		case .down(let turn): return makeDown(turn)
		case .left(let turn): return makeLeft(turn)
		case .right(let turn): return makeRight(turn)
		}
	}

	// reverse a single turn
	public func reverseMove(_ movement: Movement) -> Cube {
		switch movement {
		case .front(let turn): return makeFront(turn.reversed())
		case .back(let turn): return makeBack(turn.reversed())
		case .up(let turn): return makeUp(turn.reversed())
		case .down(let turn): return makeDown(turn.reversed())
		case .left(let turn): return makeLeft(turn.reversed())
		case .right(let turn): return makeRight(turn.reversed())
		}
	}

	// make a sequence of turns
	public func makeMoves(_ movements: [Movement]) -> Cube {
		var cube = self
		for movement in movements {
			cube = cube.makeMove(movement)
		}
		return cube
	}

	// reverse a sequence of turns
	public func reverseMoves(_ movements: [Movement]) -> Cube {
		var cube = self
		for movement in movements.reversed() {
			cube = cube.reverseMove(movement)
		}
		return cube
	}

	// to conform Equatable
	public static func == (lhs: Cube, rhs: Cube) -> Bool {
		return lhs.front == rhs.front && lhs.back == rhs.back &&
			   lhs.up == rhs.up && lhs.down == rhs.down &&
			   lhs.left == rhs.left && lhs.right == rhs.right
	}
}


















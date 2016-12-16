# import os
# import help, deploy, init, dump, tail

import sequtils,typetraits

type Point = tuple[x, y: float]

proc `+`(p, q: Point): Point = (p.x + q.x, p.y + q.y)

proc `/`(p: Point, k: float): Point = (p.x / k, p.y / k)

proc average(points: seq[Point]): Point =
  points.foldl(a + b) / float(points.len)


proc main() =
  echo average(@[
    (x: 1.0, y: 1.0),
    (x: 2.0, y: 2.0),
    (x: 3.0, y: 3.0)
  ])


echo((4.0).type.name)
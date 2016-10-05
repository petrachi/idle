require 'quaternion'
TAU = Math::PI * 2.0

module ComplexEngine

  # Demos
  def ruby_2d
    Polyhedron.new(points: [
      Point.new(0, 0, 0),
      Point.new(0, 4, 0),
      Point.new(-2, 4, 0),
      Point.new(-1, 3, 0),
      Point.new(-3, 3, 0),
      Point.new(-3, 1, 0),
      Point.new(-4, 2, 0),
      Point.new(-4, 0, 0),
    ], faces: [
      [0, 1, 3],
      [1, 2, 3],
      [2, 3, 4],
      [3, 4, 5],
      [4, 5, 6],
      [5, 6, 7],
      [7, 5, 0],
      [0, 3, 5],
    ])
  end

  def square
    Polyhedron.new(points: [
      Point.new(0, 3, 0),
      Point.new(3, 3, 0),
      Point.new(3, 0, 0),
      Point.new(0, 0, 0),
    ], faces: [
      [0, 1, 2, 3]
    ])
  end

  def octahedron origin: Quaternion(0,0,0,0), r: 1
    Polyhedron.new points: [
      Point.new(*(origin + Quaternion(0,0,r,0)).imag),
      Point.new(*(origin + Quaternion(0,0,0,-r)).imag),
      Point.new(*(origin + Quaternion(0,r,0,0)).imag),
      Point.new(*(origin + Quaternion(0,0,0,r)).imag),
      Point.new(*(origin + Quaternion(0,-r,0,0)).imag),
      Point.new(*(origin + Quaternion(0,0,-r,0)).imag),
    ],
    faces: [
      [0, 1, 2],
      [0, 2, 3],
      [0, 3, 4],
      [0, 4, 1],
      [5, 1, 2],
      [5, 2, 3],
      [5, 3, 4],
      [5, 4, 1],
    ]
  end

  extend self
end

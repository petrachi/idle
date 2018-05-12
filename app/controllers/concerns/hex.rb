module Hex
  DIVIDE = 5


  def vector r: 1
    ComplexEngine::Polyhedron.new(points: [
        ComplexEngine::Point.new(0, r, 0),
      ],
      faces: []
    )
  end

  def unify polyhedron
    ComplexEngine::Polyhedron.new points: polyhedron.points.map{ |point|
      ComplexEngine::Point.new(point.q.unify.imag)
    },
    faces: polyhedron.faces
  end

  def isocahedron r: 1
    points = []
    dist = Math::sin(Math::PI/3)*r/2.0
    v = ->{ComplexEngine::Polyhedron.new(points: [ComplexEngine::Point.new(r, dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 3*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 4*TAU/5).points[0]
    v = ->{ComplexEngine::Polyhedron.new(points: [ComplexEngine::Point.new(-r, -dist, 0)], faces: [])}
    points << v.call.points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 2*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 3*TAU/5).points[0]
    points << v.call.rotate!(Quaternion(0,0,1,0), 4*TAU/5).points[0]

    points << ComplexEngine::Point.new(0, r, 0)
    points << ComplexEngine::Point.new(0, -r, 0)

    ComplexEngine::Polyhedron.new(
      points: points,
      faces: [
        [0, 8, 1],
        [8, 1, 9],
        [1, 9, 2],
        [9, 2, 5],
        [2, 5, 3],
        [5, 3, 6],
        [3, 6, 4],
        [6, 4, 7],
        [4, 7, 0],
        [7, 0, 8],
        [0, 1, 10],
        [1, 2, 10],
        [2, 3, 10],
        [3, 4, 10],
        [4, 0, 10],
        [8, 9, 11],
        [9, 5, 11],
        [5, 6, 11],
        [6, 7, 11],
        [7, 8, 11],
      ]
    )
  end

  def divide_isocahedron isocahedron
    points = isocahedron.points
    faces = []
    isocahedron.faces.each do |face|
      point_index = points.size
      points << midpoint(isocahedron.points[face[0]], isocahedron.points[face[1]])
      points << midpoint(isocahedron.points[face[1]], isocahedron.points[face[2]])
      points << midpoint(isocahedron.points[face[2]], isocahedron.points[face[0]])

      faces << [face[0], point_index, point_index + 2]
      faces << [point_index, face[1], point_index + 1]
      faces << [point_index + 1, face[2], point_index + 2]
      faces << [point_index, point_index + 1, point_index + 2]
    end

    ComplexEngine::Polyhedron.new points: points, faces: faces
  end

  def isocahedron_divide_x_time_then_unify r: 1
    polyhedron = isocahedron r: r
    DIVIDE.times{ polyhedron = divide_isocahedron(polyhedron) }
    unify(polyhedron).scale!(r)
  end

  def isocahedron_divide_and_unify_x_time r: 1
    polyhedron = unify(isocahedron r: r)
    DIVIDE.times{ polyhedron = unify(divide_isocahedron(polyhedron)) }
    p 'iso'
    p polyhedron.faces.size
    p polyhedron.points.size
    polyhedron.scale!(r)
  end

  def cube origin: Quaternion(0,0,0,0), r: 1
    ComplexEngine::Polyhedron.new points: [
      ComplexEngine::Point.new(*(origin + Quaternion(0,r,r,r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,-r,r,r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,r,-r,r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,-r,-r,r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,r,r,-r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,-r,r,-r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,r,-r,-r)).imag),
      ComplexEngine::Point.new(*(origin + Quaternion(0,-r,-r,-r)).imag),
    ],
    faces: [
      [0, 1, 3, 2],
      [4, 5, 7, 6],
      [0, 1, 5, 4],
      [1, 3, 7, 5],
      [3, 2, 6, 7],
      [2, 0, 4, 6],
    ]
  end

  def unified_cube r: 1
    unify(cube).scale!(r)
  end

  def midpoint p1, p2
    ComplexEngine::Point.new(
      (p1.x + p2.x) / 2.0,
      (p1.y + p2.y) / 2.0,
      (p1.z + p2.z) / 2.0,
    )
  end

  def divide_cube cube
    points = cube.points
    faces = []
    cube.faces.each do |face|
      point_index = points.size
      points << midpoint(cube.points[face[0]], cube.points[face[1]])
      points << midpoint(cube.points[face[1]], cube.points[face[2]])
      points << midpoint(cube.points[face[2]], cube.points[face[3]])
      points << midpoint(cube.points[face[3]], cube.points[face[0]])
      points << midpoint(points[point_index], points[point_index + 2])

      faces << [face[0], point_index, point_index + 4, point_index + 3]
      faces << [point_index, face[1], point_index + 1, point_index + 4]
      faces << [point_index + 4, point_index + 1, face[2], point_index + 2]
      faces << [point_index + 4, point_index + 2, face[3], point_index + 3]
    end

    ComplexEngine::Polyhedron.new points: points, faces: faces
  end

  def cube_divide_x_time_then_unify r: 1
    polyhedron = cube r: r
    (DIVIDE+1).times{ polyhedron = divide_cube(polyhedron) }
    unify(polyhedron).scale!(r)
  end

  def cube_divide_and_unify_x_time r: 1
    polyhedron = unify(cube r: r)
    (DIVIDE+1).times{ polyhedron = unify(divide_cube(polyhedron)) }
    p 'cube'
    p polyhedron.faces.size
    p polyhedron.points.size
    polyhedron.scale!(r)
  end

  extend self
end

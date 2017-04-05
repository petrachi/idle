class Sandpile
  def self.[] *values
    new values
  end

  def self.flat width, &block
    Sandpile[*width.times.map{|_| Array.new(width, &block)}]
  end

  def self.identity width
    (flat(width){6} - flat(width){6}.topple).topple
  end

  def self.drop n
    width = Math.sqrt(n/1.5).to_i
    sandpile = flat(width){0}
    sandpile[width/2, width/2] = n
    sandpile.topple
  end



  attr_accessor :adjency_list, :list, :to_check, :to_topple, :width

  def initialize values
    self.width = values.first.size
    self.list = values.flatten
    self.to_check = (0...list.size).to_set
    self.adjency_list = (0...list.size).inject({}) do |adjency_list, index|
      adjency_list[index] = case index % width
      when 0
        [index + 1, index - width, index + width]
      when width - 1
        [index - width, index - 1, index + width]
      else
        [index + 1, index - width, index - 1, index + width]
      end.select{ |i| i >= 0 && i < list.size }
      adjency_list
    end
  end

  def values
    list.in_groups_of(width)
  end



  def topple
    wobble while needs_toppling?
    self.to_check = (0...list.size).to_set
    self
  end

  def wobble
    to_topple.each do |index|
      toppling_factor = list[index] / 4

      adjency_list[index].each do |neighbour_index|
        list[neighbour_index] += toppling_factor
        to_check << neighbour_index
      end
      list[index] -= toppling_factor * 4
    end
  end

  def needs_toppling?
    self.to_topple = self.to_check.map{ |i| i if list[i] > 3 }.compact
    self.to_check.clear

    to_topple.any?
  end



  def [] i, j
    list[i * width + j]
  end

  def []= i, j, value
    list[i * width + j] = value
  end

  def + other
    Sandpile[*[list, other.list].transpose.map{|x| x.reduce(:+)}.in_groups_of(width)]
  end

  def - other
    Sandpile[*[list, other.list].transpose.map{|x| x.reduce(:-)}.in_groups_of(width)]
  end

  def * n
    self.list = list.map{|x| x * n }
    self
  end

  def dup
    self + Sandpile[*width.times.map{|_| Array.new(width){0}}]
  end



  def pack
    txt = "#{width}w#{list.map(&:to_s).join.to_i(4).to_s(16)}"
  end

  def self.unpack txt
    width, list = txt.split "w"
    Sandpile[("%0#{width.to_i**2}i" % list.to_i(16).to_s(4).to_i).split(//).map(&:to_i).in_groups_of(width.to_i)]
  end

  def self.unpack_from_file filename
    file = File.open filename
    sandpile = Sandpile.unpack file.read
    file.close

    sandpile
  end



  def to_png filename, colors: Array.new(4){ |i| [251]*3<<i*85 }
    png = ChunkyPNG::Image.new(width, width, ChunkyPNG::Color.rgba(*colors[0]))
    list.each_with_index do |value, i|
      png[i/width, i%width] = ChunkyPNG::Color.rgba(*colors[value]) if value > 0
    end
    png.save(filename, :interlace => true)
  end

  def to_complex viewbox: 100
    spacing = viewbox.to_f / width
    quater = spacing / 4.0
    half = spacing / 2.0

    points = (width + 1).times.inject([]) do |points, y|
      (width + 1).times do |x|
        points << ComplexEngine::Point.new(x * spacing, -y * spacing, 0)
      end
      points
    end

    faces = width.times.inject([]) do |faces, row|
      width.times do |col|
        faces << [row * width, row * width + 1, (row + 1) * width + 2, (row + 1) * width + 1].map{ |e| e + row + col }
      end
      faces
    end

    sand = list.each_with_index.inject({}) do |sand, (value, i)|
      if value > 0
        sand_points = []
        sand_faces = []

        faces[i].map{ |j| points[j] }.each{ |point| sand_points << ComplexEngine::Point.new(point.x, point.y, 0) }
        sand_points << ComplexEngine::Point.new(sand_points.last.x + half, sand_points.last.y + half, -Math::sqrt(3)*spacing/2)

        sand_faces = [[0,1,4], [1,2,4], [2,3,4], [3,0,4]]

        sand[i] = ComplexEngine::Polyhedron
          .new(points: sand_points, faces: sand_faces)
          .scale!(Math::sqrt(2)**value / 2**2.5, origin: Quaternion(0, sand_points.last.x, sand_points.last.y, 0))
      end

      sand
    end

    {
      real: ComplexEngine::Polyhedron.new(points: points, faces: faces).translate!(Quaternion(0, -viewbox/2.0, viewbox/2.0, 0)).scale!(0.8),
      imag: sand.each{ |_, pile| pile.translate!(Quaternion(0, -viewbox/2.0, viewbox/2.0, 0)).scale!(0.8) }
    }
  end
end

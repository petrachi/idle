class RATP::GraphLink
  attr_accessor :attributes, :dist, :node_a, :node_b

  def initialize node_a, node_b, dist:, attrs: {}
    @attributes = attrs
    @dist = dist
    @node_a = node_a
    @node_b = node_b

    node_a.links += [self]
  end

  def hash
    [node_a.name, node_b.name, line].sort.join.hash
  end

  def eql? other
    hash == other.hash
  end

  def x1() node_a.x end
  def x2() node_b.x end
  def y1() node_a.y end
  def y2() node_b.y end
  def style() "stroke: #{RATP::OpenData::COLORS[line]};" end
  def line() attributes[:line] end

  def to_svg
    "<line x1=#{x1} x2=#{x2} y1=#{y1} y2=#{y2} style='#{style}' data-hash='#{hash}'/>"
  end

  def time corres: nil
    time = 0
    if corres && corres.line != line
      time += 30 * node_a.attributes[:correspondances].size
      time += 240
    end
    time += [dist, 20].min * 1.5
    time += [dist - 20, 0].max * 1
    time *= 0.75 if line == '14'
    time

    time * 2.25
  end
end

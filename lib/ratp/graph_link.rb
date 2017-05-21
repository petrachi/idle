class RATP::GraphLink

  attr_accessor :attributes, :dist, :node_a, :node_b

  def initialize node_a, node_b, dist:, attrs: {}
    @attributes = attrs
    @dist = dist
    @node_a = node_a
    @node_b = node_b

    node_a.links << self
  end

  def hash
    [node_a.name, node_b.name].sort.join.hash
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
    "<line x1=#{x1} x2=#{x2} y1=#{y1} y2=#{y2} style='#{style}'/>"
  end

  def time
    ease, max = if dist < 20
      [dist, 0]
    else
      [20, dist - 20]
    end

    # fix = 20
    # trafic = (node_a.attributes[:trafic] + node_b.attributes[:trafic]) * 0.00000005


    time = ease * 1.5 + max * 1.0
    # time = ease * 1.5 + max * 1.0 + fix + trafic
    time *= 0.75 if line == '14'

    # p "time between #{node_a.name} & #{node_b.name} : #{ease * 1.5} + #{max * 1.0} + #{fix} + #{trafic}"

    time
  end

end

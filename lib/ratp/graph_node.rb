class RATP::GraphNode

  attr_accessor :attributes, :links

  def initialize attrs: {}
    @attributes = attrs
    @links = []
  end



  def name() attributes[:station] end
  def x() attributes[:pos][0] end
  def y() attributes[:pos][1] end

  def style
    if attributes[:correspondances].size == 1
      "fill: #{RATP::OpenData::COLORS[attributes[:correspondances].first]};"
    else
      "fill: #ffffff; stroke: #000000;"
    end
  end

  def to_svg
    "<circle cx=#{x} cy=#{y} r=5 style='#{style}'/><text x=#{x+10} y=#{y+5}>#{name}</text>"
  end

  def dist other
    Math.sqrt((x - other.x)**2 + (y - other.y)**2)
  end

end

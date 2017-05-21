class RATP::Graph

  attr_accessor :links, :nodes

  def initialize
    @links = []
    @nodes = []
  end

  def link node_a, node_b, **options
    links << RATP::GraphLink.new(node_a, node_b, **options)
  end

end

module RATP
  require_relative 'ratp/open_data'
  require_relative 'ratp/open_data_processor'
  require_relative 'ratp/open_data_preprocessor'

  require_relative 'ratp/graph'
  require_relative 'ratp/graph_node'
  require_relative 'ratp/graph_link'

  require_relative 'ratp/pathfinder'

  def graph_to_svg graph
    (graph.links.uniq + graph.nodes).map(&:to_svg).join
  end

  def path_to_svg method_name, from:, to:, text: nil
    node_a = OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == from }
    node_b = OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == to }

    svg_nodes = ""
    svg_links = ""

    Pathfinder.send(method_name, from: node_a, to: node_b).each do |e|
      node_text = text.call(e) if text

      svg_nodes << e[:node].to_svg(text: node_text)
      svg_links << e[:link].to_svg if e[:link]
    end

    svg_links << svg_nodes
  end

  extend self
end

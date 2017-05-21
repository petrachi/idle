module RATP
  require_relative 'ratp/open_data'
  require_relative 'ratp/open_data_processor'
  require_relative 'ratp/open_data_preprocessor'

  require_relative 'ratp/graph'
  require_relative 'ratp/graph_node'
  require_relative 'ratp/graph_link'

  require_relative 'ratp/pathfinder'

  def trafic_to_svg
    OpenDataPreprocessor::TRAFIC
      .select{ |e| e[:lat] && e[:lon] }
      .select{ |e| e[:correspondances].include? "1" }
      .map{ |e| "<circle cx=#{e[:x] * 100} cy=#{e[:y] * 100} r=0.1 />" << "<text x=#{e[:x] * 100} y=#{e[:y] * 100}>#{e[:station]}</text>" }
      .join("\n")
  end

  def stations_to_svg
    OpenDataPreprocessor::STATIONS
      .map{ |e| "<circle cx=#{e[:pos][0]} cy=#{e[:pos][1]} r=5 />" << "<text x=#{e[:pos][0]} y=#{e[:pos][1]}>#{e[:station]}</text>" }
      .join("\n")
  end

  def hashgraph_to_svg
    drawn = []

    x = OpenDataPreprocessor::HASHGRAPH
      .map do |station, links|
        elts = ""
        if drawn.exclude? station[0]
          elts << "<circle cx=#{station[1]} cy=#{station[2]} r=5 />"
          elts << "<text x=#{station[1]} y=#{station[2]}>#{station[0]}</text>"
        end
        links.each do |link|
          elts << "<line x1=#{station[1]} y1=#{station[2]} x2=#{link[1]} y2=#{link[2]} />"
        end

        drawn << station[0]
        elts
      end
      .join("\n")
  end

  def graph_to_svg
    (OpenDataPreprocessor::GRAPH.links.uniq + OpenDataPreprocessor::GRAPH.nodes).map(&:to_svg).join
  end



  def djikstra_example(a = "MAIRIE DE CLICHY",b = "VILLEJUIF-LEO LAGRANGE")
    node_a = OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == a }
    node_b = OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == b }

    Pathfinder.djikstra from: node_a, to: node_b
  end

  def djikstra_to_svg *args
    svg_nodes = ""
    svg_links = ""

    djikstra_example(*args).each do |e|
      svg_nodes << e[:node].to_svg
      svg_links << e[:link].to_svg if e[:link]
    end

    svg_links << svg_nodes
  end


  def a_star_example(a = "MAIRIE DE CLICHY",b = "VILLEJUIF-LEO LAGRANGE")
    node_a = OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == a }
    node_b = OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == b }

    Pathfinder.a_star from: node_a, to: node_b
  end

  def a_star_to_svg *args
    svg_nodes = ""
    svg_links = ""

    a_star_example(*args).each do |e|
      svg_nodes << e[:node].to_svg
      svg_links << e[:link].to_svg if e[:link]
    end

    svg_links << svg_nodes
  end


  extend self

end

class ArticlesController < ApplicationController
  def index
    @articles = Article.publication_asc
    @articles = @articles.published unless params[:preview]
  end

  def show
    @article = Article.tagged(params[:tag])
    render layout: false
  end

  def demo_ratp
    node_a = RATP::OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == params[:from] }
    node_b = RATP::OpenDataPreprocessor::GRAPH.nodes.find{|e| e.name == params[:to] }

    node_a and node_b or return head 500

    path = RATP::Pathfinder.send("astar_time", from: node_a, to: node_b).map do |e|
      {node_name: e[:node].name, node_hash: e[:node].hash.to_s, link_hash: (e[:link].hash.to_s if e[:link])}
    end

    render json: path.to_json
  end
end

class ArticlesController < ApplicationController
  def index
    @articles = Article.published.publication_asc
  end

  def show
    sleep(0.8)
    @article = Article.tagged(params[:tag])
    render layout: false
  end
end

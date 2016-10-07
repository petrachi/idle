class ArticlesController < ApplicationController
  def index
    @articles = Article.publication_asc
    @articles = @articles.published unless params[:preview]
  end

  def show
    @article = Article.tagged(params[:tag])
    render layout: false
  end
end

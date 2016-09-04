class ArticlesController < ApplicationController
  def index
    @articles = Article.published.publication_desc
  end

  def show
    @article = Article.tagged params[:tag]
  end
end

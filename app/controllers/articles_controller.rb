class ArticlesController < ApplicationController
  def index
    articles = Article.published.publication_desc

    @lamps = articles.lamps
    @transistors = articles.transistors

    p @lamps, @transistors
  end
end

class ArticleDecorator < ApplicationDecorator
  delegate :to_param, to: :__getobj__

  def published_at
    super().strftime "%a %e %b %Y"
  end


  def partial_exists?
    view.lookup_context.exists?("/articles/#{ group }/_#{ tag }")
  end

  def partial
    view.render partial: "/articles/#{ group }/#{ tag }"
  end
end

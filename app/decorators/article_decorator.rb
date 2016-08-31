class ArticleDecorator << ApplicationDecorator
  delegate :to_param, to: :__getobj__

  def published_at
    super().strftime "%a %e %b %Y"
  end
end

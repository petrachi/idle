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
  rescue ActionView::MissingTemplate
    view.content_tag :p, class: :error do
      "Ben t'es fou toi ! Cliquer partout sur mon beau site web alors que je suis encore en train de faire les réglages ! Non mais ça va pas bien, tu aurais pu tout me détraquer ! Heureusement que j'étais là, je vais pouvoir rattraper tes bêtises."
    end
  end
end

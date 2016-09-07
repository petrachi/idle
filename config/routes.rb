Rails.application.routes.draw do
  controller :articles do
    get 'articles' => :index, as: :articles
    get 'article/:tag' => :show, as: :article
  end

  controller :ratings do
    post 'ratings' => :create, as: :ratings
  end
end

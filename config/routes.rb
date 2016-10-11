Rails.application.routes.draw do
  root "articles#index"

  controller :articles do
    get 'articles' => :index, as: :articles
    get 'article/:tag' => :show, as: :article

    get 'd/:tag' => :index, as: :direct_to
    get 'p/:tag' => :index, as: :preview, preview: :true
  end

  controller :ratings do
    get 'ratings' => :index, as: :ratings
    post 'ratings' => :create
  end
end

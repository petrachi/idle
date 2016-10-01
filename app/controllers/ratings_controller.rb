class RatingsController < ApplicationController
  def index
    @ratings = Rating.select("max(value) as value, tag")
      .order(:tag, 'value')
      .group(:tag, :request_ip)
      .group_by(&:tag)
      .map{ |tag, ratings|
        [
          tag,
          ratings.group_by(&:value).map{ |value, g_ratings|
            [
              value,
              g_ratings.size * 100 / ratings.size
            ]
          }
        ]
      }
  end

  def create
    rating = Rating.new rating_params do |r|
      r.request_ip = request.remote_ip
    end

    if rating.save
      head 200
    else
      head 500
    end
  end

  protected def rating_params
    params.require(:rating).permit(:tag, :value)
  end
end

class RatingsController < ApplicationController
  def create
    p params
    p "-"

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

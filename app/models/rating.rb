class Rating < ApplicationRecord
  validates_presence_of :tag, :value, :request_ip
end

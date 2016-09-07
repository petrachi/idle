class Rating < ApplicationRecord
  validates_presence_of :tag, :value
end

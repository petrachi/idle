class Article < ApplicationRecord

  before_validation do
    self.published_at = Time.now if !published_at && published
  end

  validates_presence_of :tag
  validates_uniqueness_of :tag
  validates_presence_of :published_at, if: :published

  scope :published, ->{ where(published: true) }
  scope :publication_asc, ->{ order("published_at ASC") }
  scope :publication_desc, ->{ order("published_at DESC") }

  class << self
    def tagged tag
      find_by tag: tag.underscore
    end

    def decorate **options
      all.map{ |record| decorator_class.new record, **options }
    end
  end

  def to_param
    tag.dasherize
  end

  def decorate **options
    ArticleDecorator.new self, **options
  end
end

module ArticlesHelper
  def coderay code = nil, **options, &block
    if options.delete(:inline)
      CodeRay.scan(code, options.delete(:lang) || :ruby).span(:css => :class).html_safe
    else
      CodeRay.scan(code || capture(&block), options.delete(:lang) || :ruby).div(:css => :class, :tab_width => 2).html_safe
    end
  end
end

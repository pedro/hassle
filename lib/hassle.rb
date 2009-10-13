require 'sass'
require 'sass/plugin'

class Hassle
  def setup
    @original_css_location = options[:css_location]

    options.merge!(:cache        => false,
                   :never_update => false,
                   :css_location => css_location)
    FileUtils.mkdir_p(css_location)
  end

  def options
    Sass::Plugin.options
  end

  def css_location
    File.join(Dir.pwd, "tmp", "hassle")
  end

  def normalize
    template_location = options[:template_location]

    if template_location.is_a?(Hash)
      template_location.keys.each do |key|
        template_location[key] = css_location
      end
    elsif template_location.is_a?(Array)
      template_location.each do |location|
        location[-1] = css_location
      end
    else
      options[:template_location] = File.join(@original_css_location, "sass")
    end
  end

  def compile
    setup
    normalize
    Sass::Plugin.update_stylesheets
  end
end

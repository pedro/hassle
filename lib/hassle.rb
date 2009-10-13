require 'sass'
require 'sass/plugin'

class Hassle
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
      options.merge!(:template_location => File.join(options[:css_location], "sass"),
                     :css_location      => css_location)
    end
  end

  def prepare
    options.merge!(:cache        => false,
                   :never_update => false)
    FileUtils.mkdir_p(css_location)
  end

  def compile
    normalize
    prepare
    Sass::Plugin.update_stylesheets
  end
end

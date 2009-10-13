require 'sass'
require 'sass/plugin'

class Hassle
  def initialize
    @css_locations = []
  end

  def options
    Sass::Plugin.options
  end

  def css_location(path)
    expanded = File.expand_path(path)
    public_dir = File.join(File.expand_path(Dir.pwd), "public")

    File.join(Dir.pwd, "tmp", "hassle", expanded.gsub(public_dir, ''))
  end

  def normalize
    template_location = options[:template_location]

    if template_location.is_a?(Hash)
      template_location.keys.each do |key|
        template_location[key] = css_location(key)
        @css_locations << css_location(key)
      end
    elsif template_location.is_a?(Array)
      template_location.each do |location|
        location[-1] = css_location(location[0])
        @css_locations << css_location(location[0])
      end
    else
      default_location = File.join(options[:css_location], "sass")
      options.merge!(:template_location => default_location,
                     :css_location      => css_location(default_location))
      @css_locations << css_location(default_location)
    end
  end

  def prepare
    options.merge!(:cache        => false,
                   :never_update => false)

    @css_locations.each do |location|
      FileUtils.mkdir_p(location)
    end
  end

  def compile
    normalize
    prepare
    Sass::Plugin.update_stylesheets
  end
end

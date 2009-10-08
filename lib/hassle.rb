require 'sass'
require 'sass/plugin'

class Hassle
  def css_location
    File.join(Dir.pwd, "tmp", "hassle")
  end

  def compile
    FileUtils.mkdir_p(css_location)
    Sass::Plugin.options[:template_location] = File.join(Sass::Plugin.options[:css_location], "sass")
    Sass::Plugin.options[:css_location] = css_location
		Sass::Plugin.update_stylesheets
  end
end

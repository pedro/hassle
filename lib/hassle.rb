require 'sass'
require 'sass/plugin'

class Hassle
  def initialize(app)
    @app = app
    @compiler = Hassle::Compiler.new
    @compiler.compile
  end

  def call(env)
    if !@compiler.stylesheets.empty? && env['PATH_INFO'] =~ css_request_regexp
      return render_sass($1)
    end
    @app.call(env)
  end

  def render_sass(name)
    css_file = @compiler.compile_location(name)
    [
      200,
      {
        'Cache-Control'  => 'public, max-age=86400',
        'Content-Length' => File.size(css_file).to_s,
        'Content-Type'   => 'text/css'
      },
      File.read(css_file)
    ]
  end

  def css_request_regexp
    @css_request_regexp ||= build_regexp
  end

  def build_regexp
    files = @compiler.stylesheets.map { |f| Regexp.escape(f) }.join('|')
    /^(#{files})(\?.*)?$/
  end
end

class Hassle::Compiler
  def options
    Sass::Plugin.options
  end

  def css_location(path)
    expanded = File.expand_path(path)
    public_dir = File.join(File.expand_path(Dir.pwd), "public")

    File.expand_path(compile_location(expanded.gsub(public_dir, ''), '..'))
  end

  def compile_location(*subdirs)
    File.join(Dir.pwd, "tmp", "hassle", subdirs)
  end

  def normalize
    template_location = options[:template_location]

    if template_location.is_a?(Hash) || template_location.is_a?(Array)
      options[:template_location] = template_location.to_a.map do |input, output|
        [input, css_location(input)]
      end
    else
      default_location = File.join(options[:css_location], "sass")
      options[:template_location] = {default_location => css_location(default_location)}
    end
  end

  def prepare
    options.merge!(:cache        => false,
                   :never_update => false)

    options[:template_location].to_a.each do |location|
      FileUtils.mkdir_p(location.last)
    end
  end

  def stylesheets
    options[:template_location].to_a.map do |location|
      Dir[File.join(location.last, "**", "*.css")].map { |css| css.gsub(compile_location, "/") }
    end.flatten.sort
  end

  def compile
    normalize
    prepare
    Sass::Plugin.update_stylesheets
  end
end

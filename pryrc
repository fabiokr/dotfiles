# Sublime as default editor
Pry.config.editor = "sublime-text"

# Prompt with ruby version
Pry.prompt = [proc { |obj, nest_level| "pry[#{RUBY_VERSION}] (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]

# Loads Rails console utils, if any
if defined?(Rails)
  self.send(:include, Rails::ConsoleMethods)
end

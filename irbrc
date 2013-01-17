# Requires a gem outside of Bundler.
#
# gem - the gem name
# const - only requires the gem if const is not yet defined
#
# Reference: https://gist.github.com/3894925
def unbundled_require(*gems)
  if defined?(::Bundler)
    gems.each do |gem|
      spec_path = Dir.glob("#{Gem.dir}/specifications/#{gem}-*.gemspec").last

      if spec_path.nil?
        warn "Couldn't find #{gem}. Install it with 'gem install #{gem}'"
        return
      end

      begin
        spec = Gem::Specification.load spec_path
        spec.activate
      rescue Gem::LoadError
        # everything is fine, if we get here it means the gem was already activated
        # somewhere else
      end
    end
  end

  loaded = gems.all? do |gem|
    begin
      require gem
    rescue Exception => err
      warn "Couldn't load #{gem}: #{err}"
    end
  end

  yield if loaded && block_given?
end

# Loads a per-project .irbrc, if there is one
localrc = File.expand_path(File.join(Dir.pwd, ".irbrc"))
if File.exists?(localrc) && localrc != File.expand_path(__FILE__)
  load localrc
end

# Uses Pry for all irb sessions
unbundled_require 'awesome_print', 'pry' do
  # Starts awesome print
  AwesomePrint.pry!

  # Imports IRB hooks
  if IRB.conf[:IRB_RC]
    Pry.config.hooks.add_hook(:before_session, :irb_rc) do |out, target, _pry_|
      IRB.conf[:IRB_RC].call
    end
  end

  # Starts Pry as console
  Pry.start

  # quits irb
  exit
end
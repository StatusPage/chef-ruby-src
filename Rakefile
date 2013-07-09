
base_dir = File.dirname(File.expand_path(__FILE__))

desc "Runs foodcritic linter"
task :foodcritic do
  if Gem::Version.new("1.9.2") <= Gem::Version.new(RUBY_VERSION.dup)
    sh "foodcritic -I#{base_dir}/test/support/rules.rb --epic-fail any #{base_dir}"
  else
    puts "WARN: foodcritic run is skipped as Ruby #{RUBY_VERSION} is < 1.9.2."
  end
end

task :test => 'foodcritic'

task :default => 'foodcritic'


require 'knowtime_tools'

namespace :knowtime do
  namespace :simulate do
    desc "user dance"
    task :random_walk, [:root, :short_name] do |t, args|
      user = Knowtime::Simulator::User.new args.root, args.short_name
      walk = Knowtime::Simulator::RandomWalk.new user, 7

      trap('INT') do
        puts "\nFinishing..."
        walk.stop
      end
      walk.start.join
    end
  end
end
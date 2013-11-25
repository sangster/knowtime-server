module Rakeable
  extend ActiveSupport::Concern

  def call_rake(task, options={})
    options[:rails_env] = Rails.env
    args = options.collect { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "rake #{task} #{args.join ' '} >> #{Rails.root}/log/rake.log &"
  end
end
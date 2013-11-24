module Rakeable
  extend ActiveSupport::Concern

  def call_rake(task, options={})
    options[:rails_env] = Rails.env
    args = options.collect { |n, v| "#{n.to_s.upcase}='#{v}'" }
    system "env rake #{task} #{args.join ' '} &"
  end
end
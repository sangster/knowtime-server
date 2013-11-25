module Rakeable
  extend ActiveSupport::Concern

  def call_rake(task, options={})
    options[:rails_env] = Rails.env
    args = options.collect { |n, v| "#{n.to_s.upcase}='#{v}'" }
    cmd = "rake #{task} #{args.join ' '} 2>&1 >> #{Rails.root}/log/rake.log &"

    logger.info "Invoking rake task: #{cmd}"
    system cmd
  end
end
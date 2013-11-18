task environment: :disable_initializer

task :disable_initializer do
  ENV['DISABLE_INITIALIZER_FROM_RAKE'] = 'true'
end
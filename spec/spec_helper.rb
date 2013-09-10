require 'chatty_error'

Dir["#{File.dirname(__FILE__)}/support/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end

I18n.default_locale = :ja
I18n.load_path = Dir["#{File.dirname(__FILE__)}/locales/*.yml"]

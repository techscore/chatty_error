# coding: utf-8

module ChattyError

  class Configuration
    attr_accessor :default_scope, :default_message

    def initialize
      @default_scope = 'chatty_errors'
      @default_message = ''
    end
  end

end

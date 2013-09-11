require "chatty_error/version"
require "chatty_error/configuration"
require "i18n"

module ChattyError
  def cause
    @cause
  end

  def cause=(cause)
    @cause = cause
  end

  def options
    @options
  end

  def options=(options)
    @options = options
  end

  module ClassMethods
    def configuration
      if @configuration.nil? && self.superclass.methods.include?(:configuration)
        @configuration = self.superclass.configuration.clone
      else
        @configuration ||= Configuration.new
      end
    end

    def configuration=(conf)
      @configuration = conf
    end

    def configure
      yield configuration if block_given?
    end

    def underscore(string)
      string.gsub(/::/, '.') \
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2') \
        .gsub(/([a-z\d])([A-Z])/,'\1_\2') \
        .tr("-", "_").downcase
    end

    def generate_key(class_name, method_name)
      [underscore(class_name), method_name.to_s.downcase].join('.')
    end

    def error_message(name, method_name, options={})
      key = generate_key(name, method_name)
      I18n.t(key,
             :scope => configuration.default_scope,
             :default => [:default, configuration.default_message],
             :locale => options[:locale])
    end

    def caused_by(*args)
      args.each do |method_name|
        class_name = self.name
        define_singleton_method method_name do |options={}|
          message = self.error_message(class_name, method_name, options)
          e = self.new(message)
          e.cause = method_name
          e.options = options
          return e
        end
      end
    end
  end

  def self.included(klass)
    klass.extend ChattyError::ClassMethods
  end
end

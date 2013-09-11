# coding: utf-8

class FooError < StandardError
  include ChattyError

  configure do |c|
    c.default_scope = 'fooooo'
    c.default_message = 'foo error'
  end
end

class FooFooError < FooError
end

class Foo2Error < FooError
  configure do |c|
    c.default_scope = 'foo2'
    c.default_message = 'foo2 error'
  end
end

class BarError < StandardError
  include ChattyError

  configure do |c|
    c.default_scope = :other_scope
    c.default_message = "error"
  end
end

class BazError < StandardError
  include ChattyError
end

module Boo
  class Error < StandardError
    include ChattyError
  end

  module Foo
    class Error < StandardError
      include ChattyError
    end

    module Woo
      class Error < StandardError
        include ChattyError
      end

      class Error2 < Error
      end
    end
  end
end

class BaseError < StandardError
  include ChattyError
  caused_by :base
end

class HogeError < BaseError
  caused_by :hoge1, :hoge2
end

class HogeHogeError < HogeError
  caused_by :base
end

class PiyoError < BaseError
  caused_by :piyopiyo

  configure do |c|
    c.default_scope = 'my_errors'
    c.default_message = 'p_error'
  end
end

class PiyoPiyoError < PiyoError
  caused_by :base, :piyoooo
end

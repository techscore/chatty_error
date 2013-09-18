# ChattyError

'chatty_error' helps you create error with message easily. An error message is loaded from i18n locale file.

[![Build Status](https://drone.io/github.com/techscore/chatty_error/status.png)](https://drone.io/github.com/techscore/chatty_error/latest)

## Installation

Add this line to your application's Gemfile:

    gem 'chatty_error'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chatty_error

## Examples

my_error.rb

    class MyError < StandardError
      include ChattyError

      caused_by :file_not_found, :user_disabled
    end

en.yml

    en:
      chatty_errors:
        my_error:
          file_not_found: "File not found!!!"
          user_disabled: "User disabled!!!"

model.rb

    class Model
      def exist?(file_path)
        unless File.exist?(file_path)
          raise MyError.file_not_found
        end

        # some code ...

      rescue MyError => e
        puts e.message # => File not found!!! (autoload from en.yml)
      end

      def authenticate(user)
        if user.disabled?
          raise MyError.user_disabled
        end

        # some code ...
      rescue MyError => e
        puts e.message # => User disabled!!! (autoload from en.yml)
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

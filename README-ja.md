# ChattyError

`chatty_error`は例外に対応するエラーメッセージをロケールファイルから取得してくれるライブラリです。

メッセージをロケールファイルに切り出しておくことで、国際化対応が容易になるとともに、ソースコードもすっきりします。

## Installation
Gemfileに以下の行を追加します。

    gem 'chatty_error'

bundle を実行します。

    $ bundle

または、gemコマンドを使用します。

    $ gem install chatty_error

## Examples

my_error.rb

    class MyError < StandardError
      include ChattyError

      caused_by :file_not_found, :user_disabled
    end

ja.yml

    ja:
      chatty_errors:
        my_error:
          file_not_found: "ファイルが見つかりません!!!"
          user_disabled: "無効なユーザです!!!"

model.rb

    class Model
      def exist?(file_path)
        unless File.exist?(file_path)
          raise MyError.file_not_found
        end

        # 何かコード...

      rescue MyError => e
        puts e.message # => ファイルが見つかりません!!! (ja.yml から読み込まれる)
      end

      def authenticate(user)
        if user.disabled?
          raise MyError.user_disabled
        end

        # 何かコード...
      rescue MyError => e
        puts e.message # => 無効なユーザです!!! (ja.yml から読み込まれる)
      end
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


require 'css_variables_snippets'
require 'thor'
require 'json'

module CssVariablesSnippets
  class CLI < Thor
    desc "generate /path/to/variable.css, /path/to/Code/User/snippets", "vue-postcss用のユーザースニペットファイルを生成"
    def generate(variables_file, snippets_path)
      snippets = {}
      open(variables_file) do |file|
        file.grep(/--.*;$/).each do |line|
          color_name, color_code = line.scan(/--[\w-]+|#\w+/)
          snippets[color_name] = {
            "scope": "vue-postcss",
            "prefix": color_name,
            "body": color_name,
          }
          snippets[color_code] = {
            "scope": "vue-postcss",
            "prefix": color_code,
            "body": color_name,
          }
        end
      end
      File.write(
        "#{snippets_path}/color-var.code-snippets",
        JSON.pretty_generate(snippets)
      )
      puts "#{snippets_path}/ 配下に color-var.code-snippets を生成(上書き)しました！"
    end

    desc "g /path/to/variable.css, /path/to/Code/User/snippets", "generateのエイリアス"
    alias_method :g, :generate
  end
end

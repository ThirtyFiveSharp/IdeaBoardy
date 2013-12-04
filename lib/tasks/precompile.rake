module BuildTools
  class TemplatePrecompiler
    def initialize(dir)
      puts "Precompiling template files in #{dir}..."
      @precompiled_templates = precompile_dir dir
    end

    def write_to_file(file_name)
      begin
        file = ::File.open(file_name, "w")
        write_header file
        @precompiled_templates.each { |template| write_template template, file }
        write_footer file
        puts "Precompiled templates are saved in #{file_name}."
      ensure
        file.close if file
      end
    end

    private
    def precompile_dir(dir)
      raise "[#{dir}] is not a directory!" unless File.directory?(dir)
      templates = []
      ::Dir.entries(dir).each {|entry|
        next if entry == '.' or entry == '..'
        absolute_path = ::File.join(dir, entry)
        templates << precompile_file(absolute_path) if ::File.file?(absolute_path)
        templates += precompile_dir(absolute_path) if ::File.directory?(absolute_path)
      }
      templates
    end

    def precompile_file(file)
      raise "[#{file}] is not a file!" unless ::File.file?(file)
      key = '"' + (ENV['RAILS_RELATIVE_URL_ROOT'] || '') + '/assets/' + ::File.basename(file, '.erb') + '"'
      puts "  #{file}  =>  #{key}"
      javascript_str = html_to_javascript(::IO.read(file))
      {key: key, content: javascript_str}
    end

    def html_to_javascript(html)
      '"' + html.gsub("\n", "").gsub("\\", "\\\\").gsub("\"", "\\\"") + '"'
    end

    def write_header(file)
      file.puts %q<angular.module('idea-boardy').run(['$templateCache', function($templateCache){>
    end

    def write_footer(file)
      file.puts %q<}]);>
    end

    def write_template(template, file)
      file.puts <<heredoc
    $templateCache.put(#{template[:key]}, #{template[:content]});
heredoc
    end
  end

  TEMPLATE_DIR = ::File.expand_path('../../app/assets/templates', ::File.dirname(__FILE__))
  precompiled_templates_dir = ::File.expand_path('../../app/assets/javascripts/precompiled-templates', ::File.dirname(__FILE__))
  PRECOMPILED_TEMPLATE_FILE = ::File.join(precompiled_templates_dir, "templates.js.erb")

end

namespace :assets do
  task :precompile_angular_templates do
    precompiler = BuildTools::TemplatePrecompiler.new(BuildTools::TEMPLATE_DIR)
    precompiler.write_to_file(BuildTools::PRECOMPILED_TEMPLATE_FILE)
  end

  task :precompile => :precompile_angular_templates

  task :clean do
    file_to_delete = BuildTools::PRECOMPILED_TEMPLATE_FILE
    ::File.delete(file_to_delete) if ::File.exist?(file_to_delete)
    puts "Precompiled template file #{file_to_delete} has been deleted."
  end
end
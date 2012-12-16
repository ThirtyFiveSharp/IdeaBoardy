module BuildTools
  class TemplatePrecompiler
    def initialize(dir_name)
      puts "Precompiling template files in #{dir_name}..."
      @precompiled_templates = precompile_dir dir_name
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
    def precompile_dir(dir_name)
      raise "[#{dir_name}] is not a directory!" unless File.directory?(dir_name)
      templates = []
      ::Dir.entries(dir_name).each {|entry|
        next if entry == '.' or entry == '..'
        absolute_path = ::File.join(dir_name, entry)
        templates << precompile_file(absolute_path) if ::File.file?(absolute_path)
        templates += precompile_dir(absolute_path) if ::File.directory?(absolute_path)
      }
      templates
    end

    def precompile_file(file_name)
      raise "[#{file_name}] is not a file!" unless ::File.file?(file_name)
      puts "  #{file_name}"
      key = '"assets/' + ::File.basename(file_name) + '"'
      javascript_str = html_to_javascript(::IO.read(file_name))
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
end

task :precompile_angular do
  template_dir = ::File.expand_path('../../app/assets/templates', ::File.dirname(__FILE__))
  precompiled_templates_dir = ::File.expand_path('../../app/assets/javascripts/precompiled-templates', ::File.dirname(__FILE__))
  precompiled_template_file = ::File.join(precompiled_templates_dir, "templates.js")

  precompiler = BuildTools::TemplatePrecompiler.new template_dir
  precompiler.write_to_file precompiled_template_file
end

task :precompile => ['assets:clean', 'precompile_angular', 'assets:precompile']
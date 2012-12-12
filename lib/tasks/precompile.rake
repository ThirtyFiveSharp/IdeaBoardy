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
  puts file
  key = '"assets/' + ::File.basename(file) + '"'
  javascript_str = html_to_javascript(::IO.read(file))
  {key: key, content: javascript_str}
end

def html_to_javascript(html)
  '"' + html.gsub("\n", "").gsub("\\", "\\\\").gsub("\"", "\\\"") + '"'
end

task :precompile do
  template_dir = ::File.expand_path('../../app/assets/templates', ::File.dirname(__FILE__))
  puts "Precompiling template files in #{template_dir}..."
  templates = precompile_dir template_dir
  precompiled_templates_dir = ::File.expand_path('../../app/assets/javascripts/precompiled-templates', ::File.dirname(__FILE__))
  precompiled_template_file = ::File.join(precompiled_templates_dir, "templates.js")
  begin
    f = ::File.open(precompiled_template_file, "w")
    f.puts %q<angular.module('idea-boardy').run(['$templateCache', function($templateCache){>

    templates.each {|template|
      f.puts <<heredoc
    $templateCache.put(#{template[:key]}, #{template[:content]});
heredoc
    }
    f.puts %q<}]);>
    puts "Precompiled templates are saved in #{precompiled_template_file}."
  ensure
    f.close if f
  end

end
module IdeaBoardy
  class CoffeePrecompiler
    class << self
      def compile(dir)
        process_dir(dir) { |file| compile_file(file) }
      end

      def clean(dir)
        process_dir(dir) { |file| clean_file(file) }
      end

      private
      def process_dir(dir, &block)
        raise "[#{dir}] is not a directory!" unless File.directory?(dir)
        ::Dir.entries(dir).each { |entry|
          next if entry == '.' or entry == '..'
          absolute_path = ::File.join(dir, entry)
          process_file(absolute_path, &block) if ::File.file?(absolute_path)
          process_dir(absolute_path, &block) if ::File.directory?(absolute_path)
        }
      end

      def process_file(file, &block)
        raise "[#{file}] is not a coffee file!" unless ::File.file?(file)
        block.call(::File.expand_path(file)) if block_given?
      end

      def compile_file(file)
        return unless coffee_spec?(file)

        puts "Compile coffee spec: #{file}"
        compiled_spec = "#{file}.spec.js"
        begin
          compiled_file = ::File.open(compiled_spec, "w")
          compiled_file << CoffeeScript.compile(::IO.read(file))
        ensure
          compiled_file.close if compiled_file
        end
      end

      def clean_file(file)
        return unless compiled_spec?(file)
        puts "Clean coffee spec: #{file}"
        ::File.delete(file)
      end

      def coffee_spec?(file_name)
        ::File.file?(file_name) and ::File.extname(file_name).downcase == ".coffee"
      end

      def compiled_spec?(file_name)
        ::File.file?(file_name) and file_name.downcase.end_with?(".coffee.spec.js")
      end
    end
  end
end

namespace :coffee do
  spec_dir = ::File.join(::File.dirname(__FILE__), "../../spec/javascripts")

  task :compile do
    IdeaBoardy::CoffeePrecompiler.compile spec_dir
  end

  task :clean do
    IdeaBoardy::CoffeePrecompiler.clean spec_dir
  end
end

#task :jasmine => 'coffee:compile'
namespace :jasmine do
  task :local => ['coffee:clean', 'coffee:compile', :jasmine]
  task :ci => ['coffee:clean', 'coffee:compile']
end
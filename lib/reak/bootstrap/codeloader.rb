module Reak
  class CodeLoader
    @load_paths = []
    @loaded_files

    class << self
      attr_reader :load_paths, :loaded_files

      def check_version?
        Rubinius::CodeLoader.check_version
      end

      def compiled_hook
        Rubinius::CodeLoader.compiled_hook
      end

      def loaded_hook
        Rubinius::CodeLoader.loaded_hook
      end

      def save_compiled?
        Rubinius::CodeLoader.save_compiled?
      end

      def run(file, wrap = false)
        new(file).run(wrap)
      end

      def new(path)
        path = StringValue(path)
        path += '.st' unless path.end_with? '.st'
        load_paths.detect do |dir|
          joined = File.expand_path(path, dir)
          path = joined if File.exist? joined
        end
        super path
      end
    end

    attr_reader :path, :cm

    def initialize(path)
      @path = path
      @stat = File.stat(path)
    end

    def run(wrap = false)
      load_file(wrap)
      Rubinius.run_script(@cm)
      Rubinius::CodeLoader.loaded_hook.trigger! @path
      true
    end

    def load_file(wrap = false)
      signature = check_version? ? Reak::Signature : 0
      version   = Rubinius::RUBY_LIB_VERSION
      compiled  = Reak::Compiler.compiled_name path

      if compiled and File.exist? compiled and @stat.mtime < File.mtime(compiled)
        begin
          cm = load_compiled_file(compiled, signature, version)
        rescue TypeError, Rubinius::InvalidRBC
        end
      end

      cm ||= compile_file(@path, compiled)
      script = cm.create_script(wrap)
      script.file_path = @path
      script.data_path = @path

      @cm = cm
      self.class.compiled_hook.trigger! script
      script
    end

    def compile_file(file, compiled)
      if self.class.save_compiled?
        Reak::Compiler.compile(file, compiled)
      else
        Reak::Compiler.compile_file(file)
      end
    end

    def load_compiled_file(path, signature, version)
      Rubinius.primitive :compiledfile_load
      raise Rubinius::InvalidRBC, path
    end

    def check_version?
      self.class.check_version?
    end
  end
end

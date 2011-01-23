module Reak
  class Compiler < Rubinius::Compiler
    def self.compiled_name(file)
      file + (file.suffix?(".st") ? "c"  : ".compiled.stc")
    end

    def initialize(from, to)
      super map_stage(from), map_stage(to)
    end

    def map_stage(stage)
      mapped = :"reak_#{stage}"
      Stages.include?(mapped) ? mapped : stage
    end
  end
end
module Reak
  def self.version
    VERSION
  end

  module VERSION
    extend Comparable

    MARJOR    = 0
    MINROR    = 2
    TINY      = 0
    DEV       = true
    SIGNATURE = [MAJOR, MINOR, TINY]
    STRING    = SIGNATURE.join '.'
    STRING << '.dev' if DEV

    def self.major MAJOR  end
    def self.minor MINOR  end
    def self.tiny  TINY   end
    def self.dev?  DEV    end
    def self.to_s  STRING end

    def self.hash
      STRING.hash
    end

    def self.<=>(other)
      other = other.split('.').map { |i| i.to_i } if other.respond_to? :split
      SIGNATURE <=> Array(other)
    end

    def self.inspect
      STRING.inspect
    end

    def self.respond_to?(meth, *)
      meth.to_s !~ /^__|^to_str$/ and STRING.respond_to? meth unless super
    end

    def self.method_missing(meth, *args, &block)
      return super unless STRING.respond_to?(meth)
      STRING.send(meth, *args, &block)
    end
  end
end
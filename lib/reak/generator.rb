module Reak
  class Generator < Rubinius::Generator
    def smalltalk_send(name, args = 0)
      send name.to_sym, args
    end
  end
end

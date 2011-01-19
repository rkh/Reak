module Reak
  class Generator < Rubinius::Generator
    def smalltalk_send(name, args = 0)
      send "reak:#{name}".to_sym, args
    end

    def make_tuple(count)
      push_rubinius
      find_const :Tuple
      move_down count
      send :[], count
    end
  end
end

module Reak
  module Parser
    class Transformer < Parslet::Transform
      def self.arglist(list)
        list ? list.map { |l| l[:var] } : []
      end

      rule :var => simple(:name) do
        Reak::Syntax::Variable.new name
      end

      rule :expr => "" do
        Reak::Syntax::NilKind.new
      end

      rule :integer => {:radix => simple(:radix), :value => simple(:value)} do
        Reak::Syntax::Integer.new(value, radix)
      end

      rule :symbol => simple(:value) do
        Reak::Syntax::Symbol.new(value)
      end

      rule :character => simple(:character) do
        Reak::Syntax::Character.new(character)
      end

      rule :string => simple(:value) do
        Reak::Syntax::String.new value.gsub("''", "'")
      end

      rule :float => { :power => simple(:power), :base => simple(:base) } do
        Reak::Syntax::Float.new(base.to_f ** power.to_i)
      end

      rule :array => sequence(:values) do
        Reak::Syntax::Array.new values
      end

      rule :array => simple(:values) do
        Reak::Syntax::Array.new [values]
      end

      rule :expr => sequence(:ast) do
        Reak::Syntax::Expression.new(ast)
      end

      rule :expr => simple(:ast) do
        next if ast.respond_to? :to_str and ast =~ /^\s$/
        Reak::Syntax::Expression.new([ast])
      end

      rule :expr => { :return => simple(:expr) } do
        Reak::Syntax::ReturnValue.new expr
      end

      rule :entry => simple(:entry) do
        entry
      end

      rule :scaled_decimal => { :mantissa => { :minor => simple(:minor), :major=> simple(:major) }, :digits => simple(:digits) } do
        Reak::Syntax::ScaledDecimal.new major, minor, digits
      end

      rule :scaled_decimal => { :mantissa => { :major => simple(:major) }, :digits => simple(:digits) } do
        Reak::Syntax::ScaledDecimal.new major, "", digits
      end

      rule :reserved => "true" do
        Reak::Syntax::TrueKind.new
      end

      rule :reserved => "false" do
        Reak::Syntax::FalseKind.new
      end

      rule :reserved => "nil" do
        Reak::Syntax::NilKind.new
      end

      rule :reserved => "self" do
        Reak::Syntax::Self.new
      end

      rule :reserved => "super" do
        Reak::Syntax::Super.new
      end

      rule :locals => subtree(:locals), :code => simple(:code) do
        Reak::Syntax::Body.new Transformer.arglist(locals), code
      end

      rule :closure => { :args => subtree(:args), :body => simple(:body) } do
        Reak::Syntax::Closure.new Transformer.arglist(args), body
      end

      rule :call => { :type => :unary, :send => { :selector => simple(:selector) }} do
        Reak::Syntax::Message.new selector
      end

      rule :call => { :type => :binary, :send => { :selector => simple(:selector), :value => simple(:arg) }} do
        Reak::Syntax::Message.new selector, arg
      end

      rule :call => { :type => :chain, :send => sequence(:messages), :on => simple(:on) } do
        messages.inject(on) { |o,m| Reak::Syntax::Call.new(o,m) }
      end

      rule :keyword => simple(:key), :value => simple(:value) do
        Reak::Syntax::MessageKey.new key, value
      end

      rule :call => { :type => :keyword, :send => sequence(:keys) } do
        message = Reak::Syntax::Message.new ""
        keys.each do |key|
          message.selector << key.key
          message.args << key.arg
        end
        message
      end

      rule :call => { :type => :direct, :send => simple(:message), :on => simple(:on) } do
        Reak::Syntax::Call.new on, message
      end

      rule :call => { :type => :unbalanced_cascade, :send => sequence(:cascade), :on => simple(:first) } do
        Reak::Syntax::Cascade.new first.reciever, [first.message] + cascade
      end

      rule :assign => { :target => simple(:var), :value => simple(:value) } do
        Reak::Syntax::Assign.new var, value
      end
    end
  end
end
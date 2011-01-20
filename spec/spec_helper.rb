require 'rspec'
require 'reak'
require 'pp'

RSpec.configure do |config|
  config.expect_with :rspec
end

$oot = $stderr

RSpec::Matchers.define(:compile) do |input|
  match do |compiler|
    @compiler = compiler
    @result = compiler.compile(input)
  end

  chain(:to) do |sexp|
    @result.to_sexp.should == sexp
  end
end

RSpec::Matchers.define(:parse) do |input|
  match do |parser|
    @parser = parser
    begin
      @result = parser.parse(input)
      #pp Reak::Parser::Transformer.new.apply(@result)
      @as == @result or @as.nil?
    rescue Parslet::ParseFailed => e
      @error = e
      false
    end
  end

  chain(:as) { |as| @as = as }
  
  # embeds original error and backtrace, getting rid of anything that doesn't matter
  display_error = proc do |msg, error|
    ignore = [%r{lib/rspec}, %r{^kernel/}, /<internal:/]
    ignore.push(*RUBY_IGNORE_CALLERS) if defined?(RUBY_IGNORE_CALLERS)
    if error
      msg << "\n\n     Error was:\n     " << error.message << "\n     " << @parser.error_tree.to_s.gsub("\n", "\n     ")
      error.backtrace[0..-2].each do |line|
        next if ignore.any? { |p| line =~ p } 
        msg << "\n          " << line
      end
    end
    "Expected " << msg
  end

  failure_message_for_should do |is|
    display_error[@result ?
      "output of parsing #{input.inspect} with #{is.inspect} to equal #{@as.inspect}, but was #{@result.inspect}" :
      "#{is.inspect} to be able to parse #{input.inspect}", @error]
  end

  failure_message_for_should_not do |is|
    display_error[@as ?
      "output of parsing #{input.inspect} with #{is.inspect} not to equal #{@as.inspect}" :
      "#{is.inspect} not to be able to parse #{input.inspect}", @error]
  end
end

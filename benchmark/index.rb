require 'benchmark'
#droiuby ruby script
class Index < Activity
	def on_create
  	
  	$benchmarks = {}
  	
	  @duration_view = V('#results')
	  @benchmark_view = V('#benchmark_view')
	  
	  V('.start-btn').on(:click) do |view|
	    test_id = view.data('test')
      V('#results').text = "starting #{test_id}"
	    case test_id
	      when 'tictactoe'
	        benchmark(test_id) {
            require 'tictactoe'
            Game.new
          }
	      when 'fibN20'
	         benchmark(test_id) { fib(20) }
	      when 'fibN25'
	         benchmark(test_id) { fib(25) }
        when 'requireASdependencies'
           benchmark(test_id) { require 'active_support/deprecation'; require 'active_support/dependencies' }
        when 'requireyaml'
           benchmark(test_id) { require 'yaml' }
        when 'report'
          on_ui_thread do
            @benchmark_view.text = $benchmarks.inspect
          end
	     end
	  end
	end
	
	def on_activity_result(request_code, result_code, intent)
	  #callback from starting an activity with result 
	end
	
	private

   def benchmark(benchmark_name, &block)
    if $benchmarks[benchmark_name]
      @duration_view.text = "#{$benchmarks[benchmark_name]} ms"
      return
    end
    message = "Running '#{benchmark_name}' benchmark..."
    puts message
    Thread.with_large_stack do
      begin
        start = _time
        block.call
        $benchmarks[benchmark_name] = _time - start
        puts "Benchmark '#{benchmark_name}' completed in #{$benchmarks[benchmark_name]}ms."
        on_ui_thread do
          @duration_view.text = "#{$benchmarks[benchmark_name]} ms"
        end
      rescue
        puts $!
        puts $!.backtrace.join("\n")
      end
    end
    true
  end

  def fib(n)
    n <= 2 ? 1 : fib(n-2) + fib(n-1)
  end
	
end

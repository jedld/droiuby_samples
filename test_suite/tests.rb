
require 'tests/suite'
require 'tests/view_array'

#droiuby ruby script
class Test < Activity
	def on_create
	  V('#start').native.setOnClickListener do |view|
	    _thread {
	      Droiuby::TestSuite.start
	    }.start  
    end
	end
	
	def on_activity_result(request_code, result_code, intent)
	  #callback from starting an activity with result 
	end
end

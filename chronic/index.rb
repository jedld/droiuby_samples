require 'chronic'

#droiuby ruby script
class Index < Activity
	def on_create
	  V('#go').on(:click) do |v|
        V('#output').text = Chronic.parse(V('#display').text).strftime('%m-%d-%Y')
      end
	end
	
	def on_activity_result(request_code, result_code, intent)
	  #callback from starting an activity with result 
	end
end

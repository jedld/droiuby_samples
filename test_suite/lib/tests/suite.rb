module Droiuby
  class TestSuite
  
    class TestFailedException < Exception
    end
    
    def test_equal()
    end
     
    def self.inherited(subclass)
      @descendants = @descendants || []
      @descendants << subclass
    end
    
    def self.descendants
      @descendants
    end
     
    def self.start
      tests = {}
      results = {}
      Droiuby::TestSuite.descendants.each do |klass|
        klass_instance = klass.new
        test_name = if klass_instance.methods.include?(:name)
          klass_instance.name
        else
          klass.to_s
        end  
        
        tests[klass.to_s] = async.before {
          klass_instance.before if klass_instance.methods.include?(:before)
        }.done {
          klass_instance.after if klass_instance.methods.include?(:after)
        }.perform {
          klass_instance.methods.select { |m| m.to_s.match(/^test\_/) }.each do |m|
            val =  false
            message = nil
            begin
              klass_instance.send(m)
              val = true
            rescue Exception=>e
              message = e.message
              val = false
            end
            results["#{test_name} #{m.to_s}"] = {result: val, message: message}
          end
        }
      end
      
      tests.each do |k,v|
        v.start
      end
      
      on_ui_thread {
        results_div = V('#results_group')
        results.each do |k,v|
          results_div.append("<t>#{k}: #{v[:result] ? 'passed' : 'failed'}</t>")
        end
      }
    end

  end
end

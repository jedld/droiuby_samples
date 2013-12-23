module Droiuby
  class TestSuite
  
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
      Droiuby::TestSuite.descendants.each do |klass|
        klass_instance = klass.new
        tests[klass_instance.name] = async.before {
          klass_instance.before
        }.done {
          klass_instance.
        }.perform {
          klass_instance.perform
        }
      end
      
      tests.each do |k,v|
        v.start
      end
    end

  end
end

#droiuby ruby script
class Index < Activity

        def initialize
          @op1 = 0
          @op2 = 0
        end

	    def on_create

          display_view = V('#display')

	      V('.btn').each do |view|
                puts "setting #{view.id}"         
                view.on(:click) do |v|
                    value = v.data('value')
                    if (0..9).map(&:to_s).include?(value)

                        if (@op2 != 0)
                            @op2 = 0
                            display_view.text = ""
                        end

                        display_view = V('#display')
                        str = display_view.text
                        str += value
                        display_view.text = str
                    elsif value == 'cancel'
                        @op1 = 0;
                        @op2 = 0;
                        display_view.text = ""
                        display_view.hint = "Perform Operation :)"
                    elsif %w[add sub mul div].include? value
                        @optr = value
                        if(@op1 == 0)
                            @op1 = display_view.text.to_i
                            display_view.text = ""
                        elsif @op2 != 0
                            @op2 = 0;
                            display_view.text = ""
                        else
                            @op2 = display_view.text.to_i
                            display_view.text = ""
                            do_op
                            display_view.text = @op1.to_s
                        end
                    elsif value == 'equals'
                        if @optr.nil?
                        elsif @op2 != 0
                            if %w[add sub mul div].include? @optr
                                display_view.text = ""
                                display_view.text "Result : " + @op1.to_s;
                            end                    
                        else
                            operation;
                        end
                    end
             end
          end 

	    end
	
	    def on_activity_result(request_code, result_code, intent)
	      #callback from starting an activity with result 
	    end

    private

        def do_op
            case @optr
                when 'add'
                    @op1 += @op2
                when 'sub'
                    @op1 -= @op2
                when 'div'
                    @op1 /= @op2
                when 'mul'
                    @op1 *= @op2
            end
        end

        def operation

            display_view = V('#display')
            @op2 = display_view.text.to_i
            display_view.text = ""

            do_op

            display_view.text = "Result : " + @op1.to_s
        end
end

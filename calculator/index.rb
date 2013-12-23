#droiuby ruby script
class Index < Activity

  def initialize
    @op1 = 0
    @op2 = 0
  end

  def on_create

    @calc_display = V('#display')

    V('.btn').on(:click) do |v|
      handle_action(v)
    end

  end

  def on_activity_result(request_code, result_code, intent)
    #callback from starting an activity with result
  end

  private

  def handle_action(v)

    value = v.data('value')

    if (0..9).map(&:to_s).include?(value)

      if (@op2 != 0)
        @op2 = 0
        @calc_display.text = ""
      end

      @calc_display = V('#display')
      str = @calc_display.text
      str += value
      @calc_display.text = str

    elsif value == 'cancel'

      @op1 = 0;
      @op2 = 0;
      @calc_display.text = ""
      @calc_display.hint = "Perform Operation :)"

    elsif %w[add sub mul div].include? value

      @optr = value
      if (@op1 == 0)
        @op1 = @calc_display.text.to_i
        @calc_display.text = ""
      elsif @op2 != 0
        @op2 = 0
        @calc_display.text = ""
      else
        @op2 = @calc_display.text.to_i
        @calc_display.text = ""
        do_op
        @calc_display.text = @op1.to_s
      end

    elsif value == 'equals'

      unless @optr.nil?
        if @op2 != 0
          if %w[add sub mul div].include? @optr
            @calc_display.text = ""
            @calc_display.text "Result : " + @op1.to_s
          end
        else
          operation
        end
      end

    end
  end

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

    display_view.text = "Result : #{@op1.to_s}"
  end
end

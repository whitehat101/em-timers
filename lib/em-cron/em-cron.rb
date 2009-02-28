module EventMachine
    
  def self.do(options={}, &blk)
    increment = options[:every]
    starting = options[:starting]
    
    reschedule = proc {|inc, block| EM.add_timer(inc) { reschedule.call(inc, block) } ; block.call }
    
    if starting == :now
      EM.add_timer(increment) { reschedule.call(increment, blk) }
      blk.call
      return nil
    else
      if starting.is_a?(String)
        starting = Object.const_defined?("Chronic") ? Chronic.parse(starting) : Time.parse(starting)
      elsif starting.is_a?(Time)
        starting = starting
      else
        starting = Time.now
      end
    end

    time = starting - Time.now
    while time < 0
      time += increment
    end

    EM.add_timer(time) { reschedule.call(increment, blk) }
    
    return nil
  end
  
  def self.do_hourly(options={}, &blk)
    self.do({:every => 1.hour}.merge(options), &blk)
  end
  
  def self.do_daily(options={}, &blk)
    self.do({:every => 1.day}.merge(options), &blk)
  end
  
  def self.do_weekly(options={}, &blk)
    self.do({:every => 1.week}.merge(options), &blk)
  end
  
  def self.do_monthly(options={}, &blk)
    self.do({:every => 1.month}.merge(options), &blk)
  end
  
end
module EventMachine

  module Timers
    
    class Timer
      @list = []
      class << self
        attr :list, false
      end
      attr :options, true
      attr :reschedule_timer, false
      attr :kickoff_timer, false
      def initialize(options, block)
        @options = options
        @block = block
        Timer.list << self
      end
      def cancel
        if @kickoff_timer
          EM::cancel_timer(@kickoff_timer)
          @kickoff_timer = nil
        end
        if @reschedule_timer
          EM::cancel_timer(@reschedule_timer)
          @reschedule_timer = nil
        end
        Timer.list.delete(self)
      end
      def schedule
        increment = @options[:every]
        starting = @options[:starting]
        
        if starting == :now
          reschedule(increment)
          return self
        else
          if starting.is_a?(String)
            starting = Object.const_defined?("Chronic") ? 
                       Chronic.parse(starting) : 
                       Time.parse(starting)
          elsif starting.is_a?(Time) || starting.kind_of?(Numeric)
            starting = starting
          else
            starting = Time.now
          end
        end
        
        if starting.is_a?(Time)
          time = starting - Time.now
        else
          time = starting
        end
        
        while time < 0
          time += increment
        end
        
        @kickoff_timer = EM.add_timer(time) {
          @kickoff_timer = nil
          reschedule.call(increment)
        }
        self
      end

      protected
      
      def reschedule(inc)
        @reschedule_timer = EM.add_timer(inc) {
          reschedule(inc)
        }
        @block.call
      end
      
    end

    def self.do(options={}, &blk)
      Timer.new(options, blk).schedule
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

    def self.list
      Timer.list
    end

  end

end

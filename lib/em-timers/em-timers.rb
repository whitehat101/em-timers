module EventMachine

  module Timers
    
    class Timer
      @list = []
      class << self
        attr :list, false
      end
      attr :tag, false
      attr :name, false
      attr :options, true
      attr :reschedule_timer, false
      attr :kickoff_timer, false
      def initialize(options, block)
        @options = options
        if options[:tag]
          @tag = options[:tag]
        end
        if options[:name]
          @tag = options[:name]
        end
        @block = block
        @repeats = true
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
        increment = @options[:every] || 1
        starting = @options[:starting]

        if options[:cron]
          starting =
            EventMachine::Timers::CronLine.new(options[:cron]).next_time
          @kickoff_timer = EM.add_timer(calculate_delta_time(starting)) {
            @kickoff_timer = nil
            run_and_reschedule_cron
          }
          return self
        elsif @options[:at] || @options[:in]
          @repeats = false
          if @options[:at]
            starting = parse_time(@options[:at])
          else
            starting = Time.now + parse_time(@options[:in])
          end
        end
        
        if starting == :now
          run_and_reschedule(increment)
          return self
        else
          starting = parse_time(starting)
        end

        time = calculate_delta_time(starting)
        
        @kickoff_timer = EM.add_timer(time) {
          @kickoff_timer = nil
          run_and_reschedule(increment)
        }
        self
      end

      protected

      def calculate_delta_time(the_time)
        increment = @options[:every] || 1
        if the_time.is_a?(Time)
          time = the_time - Time.now
        else
          time = the_time
        end
        while time < 0
          time += increment
        end
        puts "delta is #{time}"
        time
      end

      def parse_time(some_time)
        if some_time.is_a?(String)
          Object.const_defined?("Chronic") ? 
            Chronic.parse(some_time) : 
            Time.parse(some_time)
        elsif some_time.is_a?(Time) || some_time.kind_of?(Numeric)
          some_time
        else
          Time.now
        end
      end

      def run_and_reschedule_cron
        starting =
          EventMachine::Timers::CronLine.new(options[:cron]).next_time
        @reschedule_timer = EM.add_timer(calculate_delta_time(starting)) {
          run_and_reschedule_cron
        }
        @block.call
      end
      
      def run_and_reschedule(inc)
        if @repeats
          @reschedule_timer = EM.add_timer(inc) {
            reschedule(inc)
          }
        end
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

    def self.cron(spec, &blk)
      self.do({:cron => spec}, &blk)
    end

    def self.list
      Timer.list
    end

    def self.find_by_tag(tag)
      Timer.list.find_all { |t|
        t.tag == tag
      }
    end

    def self.find_by_name(name)
      Timer.list.find_all { |t|
        t.name == name
      }
    end

  end

end

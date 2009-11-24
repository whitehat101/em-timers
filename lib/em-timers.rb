$:.unshift File.expand_path(File.dirname(File.expand_path(__FILE__)))
require 'eventmachine'
require 'time'
require 'em-timers/em-timers'
require 'em-timers/numericmixable'
require 'em-timers/cron_line'

Numeric.send :include, NumericMixable

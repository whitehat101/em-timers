$:.unshift File.expand_path(File.dirname(File.expand_path(__FILE__)))
require 'eventmachine'
require 'time'
require 'em-cron/em-cron'
require 'em-cron/numericmixable'

Numeric.send :include, NumericMixable
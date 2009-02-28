Gem::Specification.new do |s|
  s.name = "em-timers"
  s.version = "0.0.1"
  s.date = "2009-02-27"
  s.authors = ["Jake Douglas"]
  s.email = "jakecdouglas@gmail.com"
  s.has_rdoc = false
  s.summary = "helper methods for timers in EventMachine"
  s.homepage = "http://www.github.com/yakischloba/em-timers"
  s.description = "helper methods for timers in EventMachine"
  s.files = ["README",
             "lib/em-timers.rb",
             "lib/em-timers/numericmixable.rb",
             "lib/em-timers/em-timers.rb"]
  s.add_dependency('eventmachine')
end
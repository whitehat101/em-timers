Gem::Specification.new do |s|
  s.name = "em-cron"
  s.version = "0.0.1"
  s.date = "2009-02-27"
  s.authors = ["Jake Douglas"]
  s.email = "jakecdouglas@gmail.com"
  s.rubyforge_project = "em-cron"
  s.has_rdoc = false
  s.summary = "cron-style methods for timers in EventMachine"
  s.homepage = "http://www.github.com/yakischloba/em-cron"
  s.description = "cron-style methods for timers in EventMachine"
  s.files = ["README",
             "lib/em-cron.rb",
             "lib/em-cron/numericmixable.rb",
             "lib/em-cron/em-cron.rb"]
  s.add_dependency('eventmachine')
end
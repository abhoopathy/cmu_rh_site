# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sassy-buttons"
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jared Hardy"]
  s.date = "2011-06-03"
  s.description = "Sassy css3 buttons using compass"
  s.email = "jared@jaredhardy.com"
  s.homepage = "http://www.jaredhardy.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "css only buttons extension for compass"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<compass>, [">= 0.11"])
    else
      s.add_dependency(%q<compass>, [">= 0.11"])
    end
  else
    s.add_dependency(%q<compass>, [">= 0.11"])
  end
end

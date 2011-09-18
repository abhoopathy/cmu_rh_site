# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gdata4ruby"
  s.version = "0.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Reich"]
  s.date = "2010-08-15"
  s.description = "A full featured wrapper for interacting with the base Google Data API, including authentication and basic object handling"
  s.email = "mike@seabourneconsulting.com"
  s.homepage = "http://cookingandcoding.com/gdata4ruby/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "gdata4ruby"
  s.rubygems_version = "1.8.10"
  s.summary = "A full featured wrapper for interacting with the base Google Data API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

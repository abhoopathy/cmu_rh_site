# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "nesta"
  s.version = "0.9.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Graham Ashton"]
  s.date = "2011-09-08"
  s.description = "Nesta is a lightweight Content Management System, written in Ruby using\nthe Sinatra web framework. Nesta has the simplicity of a static site\ngenerator, but (being a fully fledged Rack application) allows you to\nserve dynamic content on demand.\n\nContent is stored on disk in plain text files (there is no database).\nEdit your content in a text editor and keep it under version control\n(most people use git, but any version control system will do fine).\n\nImplementing your site's design is easy, but Nesta also has a small\nselection of themes to choose from.\n"
  s.email = ["graham@effectif.com"]
  s.executables = ["nesta"]
  s.files = ["bin/nesta"]
  s.homepage = "http://nestacms.com"
  s.require_paths = ["lib"]
  s.rubyforge_project = "nesta"
  s.rubygems_version = "1.8.10"
  s.summary = "Ruby CMS, written in Sinatra"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<haml>, ["~> 3.1"])
      s.add_runtime_dependency(%q<sass>, ["~> 3.1"])
      s.add_runtime_dependency(%q<maruku>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<RedCloth>, ["~> 4.2"])
      s.add_runtime_dependency(%q<sinatra>, ["= 1.2.6"])
      s.add_runtime_dependency(%q<shotgun>, [">= 0.8"])
      s.add_development_dependency(%q<hpricot>, ["= 0.8.4"])
      s.add_development_dependency(%q<rack-test>, ["= 0.6.1"])
      s.add_development_dependency(%q<rspec>, ["= 1.3.0"])
      s.add_development_dependency(%q<rspec_hpricot_matchers>, ["= 1.0"])
      s.add_development_dependency(%q<test-unit>, ["= 1.2.3"])
    else
      s.add_dependency(%q<haml>, ["~> 3.1"])
      s.add_dependency(%q<sass>, ["~> 3.1"])
      s.add_dependency(%q<maruku>, [">= 0.6.0"])
      s.add_dependency(%q<RedCloth>, ["~> 4.2"])
      s.add_dependency(%q<sinatra>, ["= 1.2.6"])
      s.add_dependency(%q<shotgun>, [">= 0.8"])
      s.add_dependency(%q<hpricot>, ["= 0.8.4"])
      s.add_dependency(%q<rack-test>, ["= 0.6.1"])
      s.add_dependency(%q<rspec>, ["= 1.3.0"])
      s.add_dependency(%q<rspec_hpricot_matchers>, ["= 1.0"])
      s.add_dependency(%q<test-unit>, ["= 1.2.3"])
    end
  else
    s.add_dependency(%q<haml>, ["~> 3.1"])
    s.add_dependency(%q<sass>, ["~> 3.1"])
    s.add_dependency(%q<maruku>, [">= 0.6.0"])
    s.add_dependency(%q<RedCloth>, ["~> 4.2"])
    s.add_dependency(%q<sinatra>, ["= 1.2.6"])
    s.add_dependency(%q<shotgun>, [">= 0.8"])
    s.add_dependency(%q<hpricot>, ["= 0.8.4"])
    s.add_dependency(%q<rack-test>, ["= 0.6.1"])
    s.add_dependency(%q<rspec>, ["= 1.3.0"])
    s.add_dependency(%q<rspec_hpricot_matchers>, ["= 1.0"])
    s.add_dependency(%q<test-unit>, ["= 1.2.3"])
  end
end

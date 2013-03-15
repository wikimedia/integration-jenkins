# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "jsduck"
  s.version = "4.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rene Saarsoo", "Nick Poulden"]
  s.date = "2013-02-25"
  s.description = "Documentation generator for Sencha JS frameworks"
  s.email = "rene.saarsoo@sencha.com"
  s.executables = ["jsduck"]
  s.files = ["bin/jsduck"]
  s.homepage = "https://github.com/senchalabs/jsduck"
  s.require_paths = ["lib"]
  s.rubyforge_project = "jsduck"
  s.rubygems_version = "1.8.23"
  s.summary = "Simple JavaScript Duckumentation generator"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rdiscount>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<parallel>, [">= 0"])
      s.add_runtime_dependency(%q<therubyracer>, ["< 0.11.0", ">= 0.10.0"])
      s.add_runtime_dependency(%q<dimensions>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<compass>, [">= 0"])
    else
      s.add_dependency(%q<rdiscount>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<parallel>, [">= 0"])
      s.add_dependency(%q<therubyracer>, ["< 0.11.0", ">= 0.10.0"])
      s.add_dependency(%q<dimensions>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<compass>, [">= 0"])
    end
  else
    s.add_dependency(%q<rdiscount>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<parallel>, [">= 0"])
    s.add_dependency(%q<therubyracer>, ["< 0.11.0", ">= 0.10.0"])
    s.add_dependency(%q<dimensions>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<compass>, [">= 0"])
  end
end

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dimensions"
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Stephenson"]
  s.date = "2012-04-25"
  s.description = "A pure Ruby library for measuring the dimensions and rotation angles of GIF, PNG, JPEG and TIFF images."
  s.email = ["sstephenson@gmail.com"]
  s.homepage = "https://github.com/sstephenson/dimensions"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Pure Ruby dimension measurement for GIF, PNG, JPEG and TIFF images"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

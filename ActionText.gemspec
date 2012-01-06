# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ActionText"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maximilian Stroh"]
  s.date = "2012-01-06"
  s.description = "still under construction!"
  s.email = "hisako1337@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".yardoc/checksums",
    ".yardoc/objects/root.dat",
    ".yardoc/proxy_types",
    "ActionText.gemspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "doc/ActionText.html",
    "doc/String.html",
    "doc/StringCompare.html",
    "doc/StringTransform.html",
    "doc/StringUtility.html",
    "doc/_index.html",
    "doc/class_list.html",
    "doc/css/common.css",
    "doc/css/full_list.css",
    "doc/css/style.css",
    "doc/file.README.html",
    "doc/file_list.html",
    "doc/frames.html",
    "doc/index.html",
    "doc/js/app.js",
    "doc/js/full_list.js",
    "doc/js/jquery.js",
    "doc/method_list.html",
    "doc/top-level-namespace.html",
    "lib/action_text.rb",
    "lib/action_text/string_compare.rb",
    "lib/action_text/string_transform.rb",
    "lib/action_text/string_utility.rb",
    "test/helper.rb",
    "test/test_compare_texts.rb",
    "test/test_inheritance.rb",
    "test/test_samples.rb",
    "test/test_string_compare.rb",
    "test/test_string_utility.rb"
  ]
  s.homepage = "http://github.com/Anonyfox/ActionText"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Extends Ruby's String Class with some useful methods f\u{fc}r Texts."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<yard>, ["~> 0.6.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<yard>, ["~> 0.6.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end


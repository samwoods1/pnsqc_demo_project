# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "pnsqc_demo"
  spec.version       = 1.0

  spec.require_paths = ["test"]

  spec.add_runtime_dependency 'selenium-webdriver', '2.47.0'
  spec.add_runtime_dependency 'minitest', '5.8.1'

end

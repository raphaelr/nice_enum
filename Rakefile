require "fileutils"
require "rubygems"
require "rbconfig"

require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"

NICE_ENUM_VERSION = [0, 1, 1]

desc "Installs nice-enum to sitelib"
task :install do
	sitelib = RbConfig::CONFIG["sitelibdir"]
	
	def install_group(basedir, dst)
		Dir[basedir + "/**/*"].each do |f|
			dest = File.join(dst, File.dirname(f).sub(basedir, ""), "")
			FileUtils::mkdir_p dest
			FileUtils::cp f, dest
		end
	end
	
	puts "Installing nice-enum to #{sitelib}..."
	install_group "lib", sitelib
end

Rake::RDocTask.new do |t|
	t.main = "README.rdoc"
	t.title = "Nice-Enum #{NICE_ENUM_VERSION.join(".")} Documentation"
	t.rdoc_files.include("lib/**/*", "*.rdoc")
end

Rake::TestTask.new do |t|
	t.test_files = Dir["test/**/*_test.rb"]
end

gemspec = Gem::Specification.new do |s|
	s.name = "nice-enum"
	s.version = NICE_ENUM_VERSION.join(".")
	s.author = "Raphael Robatsch"
	s.email = "mf.m-f@rleahpar".reverse
	s.homepage = "http://raphaelr.github.com/nice-enum"
	s.summary = "Nice Enumerations for Ruby"
	s.has_rdoc = true
	
	s.files = FileList.new do |fl|
		fl.include "{lib,samples}/**/*"
		fl.include "README.rdoc", "LICENSE"
	end
	
	s.extra_rdoc_files = FileList.new do |fl|
		fl.include "README.rdoc"
	end
	
	s.test_files = Dir["test/**/*_test.rb"]
end

Rake::GemPackageTask.new(gemspec) do |t|
	t.need_zip = true
	t.need_tar_gz = true
end

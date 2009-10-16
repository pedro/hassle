Given /^I have a Rails app$/ do
  `rails #{TEST_DIR}`
end

And /^I have a file "(.*)" with:$/ do |path, content|
  FileUtils.mkdir_p(File.join(TEST_DIR, File.dirname(path)))
  File.open(File.join(TEST_DIR, path), "w") do |f|
    f.write content
  end
end

Then /^I should see the following in "(.*)":$/ do |path, content|
  content.strip.should == File.read(File.join(TEST_DIR, path)).strip
end

When /^Hassle is installed as a plugin$/ do
  FileUtils.cp_r(ORIGINAL_DIR, File.join(TEST_DIR, "vendor", "plugins", "hassle"))
end

When /^the Rails app is initialized in "(.*)" mode$/ do |environment|
  ENV["RAILS_ENV"] = environment
  require File.expand_path('./config/environment')
end

Then /^the file "([^\"]*)" should not exist$/ do |path|
  File.exists?(path).should be_false
end

require 'fileutils'

ORIGINAL_DIR = Dir.pwd
TEST_DIR = File.join('/', 'tmp', 'hassle')

Before do
  FileUtils.mkdir(TEST_DIR)
  Dir.chdir(TEST_DIR)
end

After do
  Dir.chdir(TEST_DIR)
  FileUtils.rm_rf(TEST_DIR)
end


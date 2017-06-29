require 'vcr'

VCR.configure do |vcr|
  vcr.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
end

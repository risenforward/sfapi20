guard 'rspec', cmd: 'bundle exec rspec', all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb') { "spec" }

  watch(%r{^lib/restforce/(.+)\.rb$}) { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch(%r{^lib/restforce/(.+)\.rb$}) { |m| "spec/integration/#{m[1]}_spec.rb" }
  watch(%r{^spec/support/(.+)\.rb$})  { "spec" }
end

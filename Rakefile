require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec]

desc "Generate protobuf stubs"
task :proto do
  system("protoc",
         "--proto_path=protocol",
         "--ruby_out=lib/livekit/proto",
         "--twirp_ruby_out=lib/livekit/proto",
         "-Iprotocol",
         "./protocol/livekit_egress.proto",
         "./protocol/livekit_ingress.proto",
         "./protocol/livekit_models.proto",
         "./protocol/livekit_room.proto",
         "./protocol/livekit_webhook.proto")
end

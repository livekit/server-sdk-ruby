require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: %i[spec]

desc "Generate protobuf stubs"
task :proto do
  system("protoc",
         "--proto_path=protocol/protobufs",
         "--ruby_out=lib/livekit/proto",
         "--twirp_ruby_out=lib/livekit/proto",
         "-Iprotocol",
         "./protocol/protobufs/livekit_agent.proto",
         "./protocol/protobufs/livekit_agent_dispatch.proto",
         "./protocol/protobufs/livekit_egress.proto",
         "./protocol/protobufs/livekit_ingress.proto",
         "./protocol/protobufs/livekit_sip.proto",
         "./protocol/protobufs/livekit_metrics.proto",
         "./protocol/protobufs/livekit_models.proto",
         "./protocol/protobufs/livekit_room.proto",
         "./protocol/protobufs/livekit_webhook.proto")
end

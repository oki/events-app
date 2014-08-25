require 'rubygems'
require 'bundler/setup'
Bundler.require

Faye::WebSocket.load_adapter('thin')
bayeux = Faye::RackAdapter.new(
  :mount => '/events', 
  :timeout => 25,
  :headers => {'Access-Control-Allow-Origin' => '*'},
)

bayeux.on(:handshake) do |client_id|
  puts "Connected: #{client_id}"
end
bayeux.on(:subscribed) do |client_id,channel|
  puts "#{client_id} subscribed #{channel}"
end
bayeux.on(:unsubscribe) do |client_id,channel|
  puts "#{client_id} unsubscribed #{channel}"
end
bayeux.on(:publish) do |client_id,channel,data|
  puts "#{client_id} published #{channel}: #{data}"
end
bayeux.on(:disconnect) do |client_id|
  puts "Disconected: #{client_id}"
end

run bayeux

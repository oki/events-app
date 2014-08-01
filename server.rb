require 'rubygems'
require 'bundler/setup'
Bundler.require

class Subscribe < Goliath::API
  use Goliath::Rack::Render, 'json'

  def response(env)
    logger.info 'New request! d-_-b'
    EM.synchrony do
      @redis = Redis.new(driver: :synchrony)
      @redis.psubscribe('event:*') do |on|
        on.psubscribe do |event,_|
          env.logger.info "Subscribed for ##{event}"
        end

        on.pmessage do |pattern, event, message|
          @event = event.split(':',2)[-1] # event:uptime -> uptime
          @message = message
          env.logger.debug "Sending: #{payload}"
          env.stream_send(payload)
        end

        on.punsubscribe do |event,_|
          env.logger.info "Unsubscribed for ##{event}"
        end
      end
    end
    streaming_response(200, { 'Access-Control-Allow-Origin' => '*', 'Content-Type' => "text/event-stream" })
  end

  def on_close(env)
    @redis.punsubscribe('event:*')
    env.logger.info "Disconected!"
  end

  def payload
    "id: #{Time.now}\n" +
    "event: #{@event}\n" +
    "data: #{@message}" +
    "\r\n\n"
  end
end

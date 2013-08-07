module AmqpExample
	class Consumer
	  def handle_message(metadata, payload)
	  	sleep(0.25)
	    puts "Received a message: #{payload}, content_type = #{metadata.content_type}"
	  end
	end

	class Worker
	  def initialize(channel, queue_name = AMQ::Protocol::EMPTY_STRING, consumer = Consumer.new)
	    @queue_name = queue_name
	 
	    @channel    = channel
	    @channel.on_error(&method(:handle_channel_exception))
	 
	    @consumer   = consumer
	  end
	 
	  def start
	    @queue = @channel.queue(@queue_name, :exclusive => false)
	    @queue.subscribe(&@consumer.method(:handle_message))
	  end
	 
	  def handle_channel_exception(channel, channel_close)
	    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
	  end
	end

	class Producer
	  def initialize(channel, exchange)
	    @channel  = channel
	    @exchange = exchange
	  end
	 
	  def publish(message, options = {})
	    @exchange.publish(message, options)
	  end
	 
	  def handle_channel_exception(channel, channel_close)
	    puts "Oops... a channel-level exception: code = #{channel_close.reply_code}, message = #{channel_close.reply_text}"
	  end
	end

	class ProducerTest
		def self.execute
			AMQP.start(:host => '127.0.0.1') do |connection, open_ok|
			  channel  = AMQP::Channel.new(connection)
			  producer = Producer.new(channel, channel.default_exchange)
			  puts "Publishing..."
			  50.times.each do |it|
			  	producer.publish("#{it} - Hello, world", :routing_key => "amqpgem.objects.integration")
			  end
			  EventMachine.add_timer(2.0) { connection.close { EventMachine.stop } }
			end
		end
	end

	class WorkerTest
		def self.execute
			AMQP.start(:host => '127.0.0.1') do |connection, open_ok|
			  channel  = AMQP::Channel.new(connection)
			  worker   = Worker.new(channel, "amqpgem.objects.integration")
			  worker.start
			 
			  # stop in 2 seconds
			  # EventMachine.add_timer(2.0) { connection.close { EventMachine.stop } }
			end
		end
	end
end
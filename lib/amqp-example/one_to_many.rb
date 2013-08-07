module AmqpExample
	class OneToMany
		def self.execute
			AMQP.start(:host => '127.0.0.1') do |connection|
			  channel  = AMQP::Channel.new(connection)
			  exchange = channel.fanout("nba.scores")
			 
			  channel.queue("joe", :auto_delete => true).bind(exchange).subscribe do |payload|
			    puts "#{payload} => joe"
			  end
			 
			  channel.queue("aaron", :auto_delete => true).bind(exchange).subscribe do |payload|
			    puts "#{payload} => aaron"
			  end
			 
			  channel.queue("bob", :auto_delete => true).bind(exchange).subscribe do |payload|
			    puts "#{payload} => bob"
			    sleep 0.1
			  end
			 
			 	10.times.each do |it|
			  	exchange
			  		.publish("#{it} - BO 101, NYK 89")
			  		.publish("#{it} - ORL 85, ALT 88")
			  end
			 
			  # disconnect & exit after 2 seconds
			  EventMachine.add_timer(10) do
			    exchange.delete
			 
			    connection.close { EventMachine.stop }
			  end
			end
		end
	end
end
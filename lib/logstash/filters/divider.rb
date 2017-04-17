# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"


class LogStash::Filters::Divider < LogStash::Filters::Base

	# filter {
	#   divider {
	#    value => "\n"
	#    cancel => true
	#    fields => ["host", "command"]
	#   } 
	# }
	#
	
	config_name "divider"

	# filter input message.
	config :message, :validate => :string, :default => ""

	# value to use to split the message ex '\n' or 'r'
	config :value, :validate => :string, :required => true

	# cancel flag tells if to cancel the input message.
	config :cancel, :validate => :boolean, :default => true
	
	# fields to be includes in the generated events
	config :fields, :validate => :array, :default => []

	public
	def register
		# Add instance variables
	end # def register

	public
	def filter(event)
		
		return unless filter?(event)
		newEventsList = [];
		cpt=0
	
		unless event.get('message').nil?

			messages =  event.get('message').split(@value)

			messages.each do |msg|
					
				newEventsList[cpt] = LogStash::Event.new();
					
				# Event fields : take the message and the liste of fields from the configuration
			
				newEventsList[cpt].set('message', msg.strip)
			
				#  Copy other remaining Fields
				@fields.each do |arr|
					newEventsList[cpt].set("#{arr}", event.get("#{arr}"))
				end
			
				# ? goes here ?
				filter_matched(newEventsList[cpt])
			
				# Launch the Event
				yield newEventsList[cpt]
					
				cpt=cpt+1

			end # def for each
		end # Unless

		# cancel original event if cancel is set
		if @cancel == true
		event.cancel
		end

		#filter_matched(event)
	end # def filter
end # class LogStash::Filters::Example

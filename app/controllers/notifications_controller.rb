class NotificationsController < ApplicationController
	include HTTParty

	def index
		
	end

	def receive
		parsed_request = JSON.parse(request.raw_post)
		byebug
		if parsed_request["SubscribeURL"].present?
			response = HTTParty.get(parsed_request["SubscribeURL"], verify: false)
		end
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end
end
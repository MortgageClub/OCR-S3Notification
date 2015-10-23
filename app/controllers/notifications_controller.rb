class NotificationsController < ApplicationController
	include HTTParty

	def index

	end

	def receive
		raw_post = JSON.parse(request.raw_post)

		if raw_post["SubscribeURL"].present?
    	ConfirmSubscriptionService.call(raw_post)
    else
    	DownloadFileService.call(raw_post)
    end

		render nothing: true, status: 200, content_type: 'text/html'
	end
end
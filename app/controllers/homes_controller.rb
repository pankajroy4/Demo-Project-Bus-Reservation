class HomesController < ApplicationController
	
	def index
		@approved_buses = Bus.where(approved: true)
	end
	
	def search 
		string = params[:user_query]
		@approved_buses = Bus.approved.search_by_name_or_route(string)
	end
end

class HomesController < ApplicationController
	
	def index
		@approved_buses = Bus.where(approved: true)
	end
	
	def search 
		string = params[:user_query]
		@approved_buses = Bus.approved.search_by_name_or_route(string)
		
		# string=params[:user_query]
		# sanitized_string = Bus.sanitize_sql_like(string)
		# @approved_buses = Bus.where("name LIKE ? ", "%#{sanitized_string}%")
		# .or(Bus.where("route LIKE ? ", "%#{sanitized_string}%")).and(Bus.where(approved: true))
	end
end

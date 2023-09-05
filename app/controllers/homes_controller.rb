class HomesController < ApplicationController
    def index
        @approved_buses = Bus.where(approved: true)
    end

    def search 
        string=params[:user_query]
        @approved_buses = Bus.where("name LIKE ? ", "%#{Bus.sanitize_sql_like(string)}%")
        .or(Bus.where("route LIKE ? ", "%#{Bus.sanitize_sql_like(string)}%"))
    end
    
end

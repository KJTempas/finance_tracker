class UserStocksController < ApplicationController
    def create
        stock = Stock.check_db(params[:ticker]) #first look in db to see if stock already there
        if stock.blank? # if not, lookup and use that to create new @user_stock object
            stock = Stock.new_lookup(params[:ticker])
            stock.save 
        end
        #now will have stock object either retrieved from db or created and saved
        @user_stock = UserStock.create(user: current_user, stock: stock)
        flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio"
        redirect_to my_portfolio_path
    end
end

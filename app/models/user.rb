class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_tracked?(ticker_symbol)
    #check if stock already in db assoc with this user
    stock = Stock.check_db(ticker_symbol)
    return false unless stock
    #is this user tracking this stock?
    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count <10
  end

  def can_track_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_tracked?(ticker_symbol) #will return T or F
  end

end

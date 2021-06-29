class Stock < ApplicationRecord
    has_many :user_stocks
    has_many :users, through: :user_stocks

    validates :name, :ticker, presence: true

    def self.new_lookup(ticker_symbol)#the self makes it a class method
        client = IEX::Api::Client.new(
                        publishable_token: Rails.application.credentials.iex_client[:sandbox_api_key_publ],
                        secret_token: Rails.application.credentials.iex_client[:secret_access_key],
                        endpoint: 'https://sandbox.iexapis.com/v1')
        #client.price(ticker_symbol) for initial testing
        
        begin #like Try and except in python; try to get a response; if not, throw an exception
        #to make a new ticker object
            new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, last_price: client.price(ticker_symbol))
        rescue => exception
            return nil
        end
    end
    def self.check_db(ticker_symbol)
        where(ticker: ticker_symbol).first
    end
end

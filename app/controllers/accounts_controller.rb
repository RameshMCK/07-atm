class AccountsController < ApplicationController
    
    def index
        #@accounts = Account.all
        @accounts = Account.order(id: :desc)
    end
    
    def atm
        @account = Account.find(params[:id])
    end
    
    
    def new
        @account =  Account.new
        render 'new'
    end
    
    def destroy
        
         redirect_to root_url
    end
    def create
        #binding.pry
        @accounts = Account.all
    
        name = params[:name].to_s
        category = params[:category].to_s
    
        @account = Account.new(name: name, category: category )
        
        @account.create(name, category)
        
        if @account.errors.any?
            render 'new'
        else
            redirect_to root_url
        end
        
    end 
    
    
    def deposit
        #binding.pry
        @account = Account.find(params[:id])
        @account.deposit(params[:amount].to_f)
        
        if @account.errors.any?
            render 'atm'
        else
            redirect_to root_url
        end
    end
    
    def withdraw
        @account = Account.find(params[:id])
        @account.withdraw(params[:amount].to_f)
        
        if @account.errors.any?
            render 'atm'
        else
            redirect_to root_url
        end 
    end
    
    def clear_suspension
        @account = Account.find(params[:id])
        @account.clear_suspension
        
        if @account.errors.any?
            render 'atm'
        else
            redirect_to root_url
        end 
    end 
end
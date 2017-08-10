class Account < ApplicationRecord
    has_many :transactions #plural
    
    #model validators.. this is done at rails side
    #unique validation
    #validates is the function and 
    #:name is the parameters 1
    #uniqueness: true is a Hash Key value pair - Parameter 2
    validates :name, uniqueness: true
    
    #check if the combination already exists
    validates :name, :category, presence: true
    after_save :check_suspension
    
    def deposits
        self.transaction.where(category: 'Deposit')
    end
   
    def withdrawals
        self.transaction.where(category: 'Withdraw')
    end

    def overdrafts
        self.transaction.where(category: 'Overdraft')
    end

    def deposit(amount)
        
        return if amount_is_not_valid(amount)
        #ActiveRecord is module or a name space
        #create transaction in rails
        ActiveRecord::Base.transaction do
            #note: need to use self or Account as a prefix when using balance, since it is not a variable or anythign defined in tis class
            self.update!(balance: self.balance + amount)
            #raise an error in rails
            #raise 'explode'
            Transaction.create!(amount: amount, category: 'deposit', account_id: self.id)
        end    
    end


    def withdraw(amount)
        return if amount_is_not_valid(amount)
    
        return if account_is_suspended
    
        if self.balance >= amount 
            ActiveRecord::Base.transaction do
                self.update!(balance: self.balance - amount)
                Transaction.create!(amount: amount, category: 'Withdraw', account_id: self.id)
            end
        else
            
            ActiveRecord::Base.transaction do
                self.update!(balance: self.balance - 50, flags: self.flags + 1)
                Transaction.create!(amount: 50, category: 'Overdraft', account_id: self.id)
            end
        end    
    end
    #ruby method seggregating the private methods. All he above is public
    private
    
    
    def insufficient_funds
        self.errors.add(:account, 'does not have sufficient funds') if self.balance < 100
        self.errors.any?
    end
    
    
    def clear_suspension
        return if insufficient_funds
        fee = 100
         ActiveRecord::Base.transaction do
                self.update!(balance: self.balance - fee, is_suspended: false)
                Transaction.create!(amount: fee, category: 'Unfreeze', account_id: self.id)
            end
        
    end
    def check_suspension
        if self.flags > 3 
            self.update!(is_suspended: true, flags: 0)
        end
    end
    
    def amount_is_not_valid(amount)
         #check if amount is not a numeric
        #self is Account class or use Accout
        if !amount.is_a? Numeric
            self.errors.add(:amount, 'not a number') 
            return
        end
        self.errors.add(:amount, 'less than zero') if amount <= 0 
        
        #return if self.errors.any?
        #return errors
        self.errors.any? #return a boolen
        
    end
    
    
    def account_is_suspended
        self.errors.add(:account, 'is suspended due to overdrafts') if self.is_suspended
        self.errors.any?
    end
end
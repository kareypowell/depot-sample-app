class PaymentType < ActiveRecord::Base
	has_many :oders

end

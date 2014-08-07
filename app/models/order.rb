class Order < ActiveRecord::Base
  has_many :order_details
  has_many :deliveries
  has_many :returns
  has_many :transactions, class_name: 'Transaction', foreign_key: 'parent_id'

  belongs_to :branch
  belongs_to :warehouse
  belongs_to :creator, class_name: 'MerchantAccount', foreign_key: 'creator_id'
  belongs_to :seller, class_name: 'MerchantAccount', foreign_key: 'seller_id'
  belongs_to :buyer, class_name: 'Customer', foreign_key: 'buyer_id'

  enum status: [:initialized, :finish, :delivery, :cancelled]

   # after_create :create_transaction
  private
  def find_transaction
    Transaction.where(type: :order, parent_id: self.id)
  end

  def create_transaction
    if self.finish?
      new_transaction = Transaction.create!(merchant_id: self.branch.merchant.id,
                                            branch_id: self.branch_id,
                                            warehouse_id: self.warehouse_id,
                                            type: :order,
                                            parent_id: self.id,
                                            creator_id: self.seller_id,
                                            owner_id: self.buyer_id,
                                            receivable: true,
                                            status: :closed )
    elsif self.delivery?
      new_transaction = Transaction.create!(merchant_id: self.branch.merchant.id,
                                            branch_id: self.branch_id,
                                            warehouse_id: self.warehouse_id,
                                            type: :order,
                                            parent_id: self.id,
                                            creator_id: self.seller_id,
                                            owner_id: self.buyer_id,
                                            receivable: true,
                                            status: :tracking )
    elsif self.cancelled?
      new_transaction = Transaction.create!(merchant_id: self.branch.merchant.id,
                                            branch_id: self.branch_id,
                                            warehouse_id: self.warehouse_id,
                                            type: :order,
                                            parent_id: self.id,
                                            creator_id: self.seller_id,
                                            owner_id: self.buyer_id,
                                            receivable: true,
                                            status: :cancelled )
    end



  end


end
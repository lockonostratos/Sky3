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

  after_update :create_transaction

  enum status: [:initializing, :finish, :delivery, :cancelled]

  
  def update_metro_summary #cập nhật tiền bán vào bảng MetroSummary
    metro_summary = MetroSummary.find_by_warehouse_id(self.warehouse_id)
    metro_summary.revenue += self.final_price  if self.delivery == 0
    metro_summary.revenue_day += self.final_price if self.delivery == 0
    metro_summary.revenue_month += self.final_price if self.delivery == 0
    metro_summary.save()
  end

  def create_new_delivery
      Delivery.create!(
          :order_id => self.id,
          :merchant_account_id => self.creator_id,
          :name => self.name,
          :creation_date => self.created_at,
          :delivery_date => self.updated_at,
          :delivery_address => 'Ho Chi Minh',
          :contact_name => 'Sang',
          :contact_phone => '0123456789',
          :transportation_fee => 200,
          :comment => 'Giao Hang Tan Noi',
          :status => 0
      )
  end
  
  private
  def find_transaction
    Transaction.where(type: :order, parent_id: self.id)
  end

  def create_transaction
    (if self.payment_method == 0 then true else false end)
    if self.finish? || self.delivery?
      new_transaction = Transaction.create!(merchant_id: self.branch.merchant.id,
                                            branch_id: self.branch_id,
                                            warehouse_id: self.warehouse_id,
                                            group: Transaction.groups[:sales],
                                            parent_id: self.id,
                                            creator_id: self.seller_id,
                                            owner_id: self.buyer_id,
                                            receivable: true,
                                            due_day: (if self.payment_method == 0 then Date.today else nil end),
                                            status: (if self.payment_method == 0 then Transaction.statuses[:closed] else Transaction.statuses[:tracking] end))
      TransactionDetail.create!(transaction_id: new_transaction.id,
                                merchant_id: self.branch.merchant.id,
                                branch_id: self.branch_id,
                                warehouse_id: self.warehouse_id,
                                total_cash: self.final_price,
                                deposit_cash: (if self.payment_method == 0 then self.final_price else self.deposit end),
                                debt_cash: (if self.payment_method == 0 then 0 else (self.final_price - self.deposit) end) )
    elsif self.cancelled?
      new_transaction = Transaction.create!(merchant_id: self.branch.merchant.id,
                                            branch_id: self.branch_id,
                                            warehouse_id: self.warehouse_id,
                                            group: Transaction.groups[:sales],
                                            parent_id: self.id,
                                            creator_id: self.seller_id,
                                            owner_id: self.buyer_id,
                                            receivable: true,
                                            status: Transaction.statuses[:cancelled])
    end




  end


end
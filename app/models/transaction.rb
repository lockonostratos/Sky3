class Transaction < ActiveRecord::Base
  belongs_to :merchant
  belongs_to :branch
  belongs_to :warehouse
  belongs_to :creator, class_name: 'MerchantAccount', foreign_key: 'creator_id'
  belongs_to :owner, class_name: 'Customer', foreign_key: 'owner_id'
  has_many :transaction_details

  enum group: [:import, :inventory, :sales]
  enum status: [:closed, :tracking,  :cancelled]

  # def find_parent
  #   if self.import?
  #     Import.find(self.parent_id)
  #   elsif self.inventory?
  #     Inventory.find(self.parent_id)
  #   elsif self.order?
  #     Order.find(self.parent_id)
  #   end
  # end

end
class MerchantApplicationController < ApplicationController
  def current_merchant_account
    @current_merchant_account ||= @current_account.merchant_account if @current_account
  end

  helper_method :current_merchant_account, :get_all_customers

  #Kiểm tra warehouse_id có cùng merchant với account hay ko , có thì return true
  def check_warehouse_permission(warehouse_id)
    branch = Branch.where(merchant_id:current_merchant_account.merchant_id)
    @warehouses = Warehouse.where(branch_id:(branch.pluck(:id)))
    warehoues=(@warehouses.pluck(:id))
    warehoues.each do |ex|
      return true if (ex.to_param == warehouse_id )
    end
  end

  #Lấy tất cả customers của một area
  def get_all_customers(area_id)
    @customers = Customer.where(area_id:area_id)
    @customers
  end
  #Lấy tất cả warehouse của một merchant
  def all_warehouse_on_merchant(merchant_id)
    warehouses = Warehouse.where(merchant_id:merchant_id)
    return warehouses
  end
  #Lấy tất cả warehouse của một branch
  def all_warehouse_on_branch(branch_id)
    warehouses = Warehouse.where(branch_id:branch_id)
    return warehouses
  end
  #Lấy tất cả order của một merchant
  def all_order_on_merchant(merchant_id)
    orders = Order.where(warehouse_id: (all_warehouse_on_merchant merchant_id).pluck(:id))
    return orders
  end
  #Lấy branch của một warehouse
  def brach_on_warehouse(warehouse_id)
    warehouse = Warehouse.find(warehouse_id)
    return warehouse.branch_id
  end



  #Report-------------------------------------------------------------------------------------------------------------->

  #Report bán hàng theo Ngày , Merchant, Branch , Warehouse (chưa lọc dữ liệu, chỉ nhận dữ liệu chính xác)
  #Trả về tổng quát trong bản Order theo
  # (Loai phieu, kieu phieu, xac nhan, ngay bat dau, ngay ket thuc, merchant, branch, warehouse, nhan vien)
  # Loai Phieu(report): order, return, delivery, import, export, inventory
  # Kieu Phieu(type_report): 0(Chua Xac Nhan), 1(Xac Nhan)
  # Merchant: nil(lấy tất cả)
  def report_all_time_and_warehouse_account(report, type_report, deliveries, returns, success, current_time_begin, current_time_end, merchant, branch, warehouse, merchant_account, customer)
    #Xử lý hàm nhận thời gian current_time_begin, current_time_end
    (current_time_begin == nil and current_time_end != nil) ?
        time_begin = Order.order(created_at: :asc).first.created_at.to_date :
        time_begin = current_time_begin
    (current_time_end == nil and current_time_end != nil) ? time_end = Time.new.to_date : time_end = current_time_end
    if time_begin != nil and time_end !=nil and time_begin > time_end
      temp = current_time_end
      time_end = current_time_begin
      time_begin = temp
    end
    #Xu ly Order, Return, Delivery
    if (report == 'order' || report == 'return' || report == 'delivery') and
        (type_report == 0 || type_report == 1) and
        (success == nil || success == 0 || success == 1) and
        (returns == nil || returns == 0 || returns == 1) and
        (deliveries == nil || deliveries == 0 || deliveries == 1)

      #Lấy tất cả order
      orders = (return_order_all time_begin, time_end, merchant, branch, warehouse, merchant_account, customer).uniq()
      #Tra ve Order
      if report == 'order'
        return returns_order_report orders, type_report, success
      end
      #Tra Ve Return
      if report == 'return'
        return  returns_return_report orders, type_report, success
      end
      # #Tra Ve Delivery
      if report == 'delivery'
        return returns_delivery_report orders, type_report, success
      end
      # #Xu ly Import, Export, Inventory
    elsif (report =='import' || report == 'export' || report == 'inventory') and
        (type_report == 0 || type_report == 1) and
        (success == nil || success == 0 || success == 1) and
        (returns == nil || returns == 0 || returns == 1) and
        (deliveries == nil || deliveries == 0 || deliveries == 1)
      #Trả về Import
      if report == 'import'
        return returns_import_report time_begin, time_end, merchant, branch, warehouse, merchant_account
      end
      #Trả về Export
      if report == 'export'
        return returns_export_report type_report, time_begin, time_end, merchant, branch, warehouse, merchant_account
      end
      #Trả về Inventory
      if report == 'inventory'
        return returns_inventory_report type_report, success, time_begin, time_end, merchant, branch, warehouse, merchant_account
      end
    else
      return []
    end
  end

  private
  #-------------------------------------------------------------------------------------------------------------------->
=begin

     # def return_order_by_branch_and_merchant_account_and_customer (time_begin, time_end, branch, merchant_account, customer)
     #   if merchant_account == nil
     #     if customer == nil
     #       if time_begin == nil and time_end == nil
     #         return Order.where(:branch_id => branch)
     #       else
     #         return Order.where(:created_at => time_begin.beginning_of_day..time_end.end_of_day,
     #                           :branch_id => branch)
     #       end
     #     else
     #       if time_begin == nil and time_end == nil
     #         return Order.where(:branch_id => branch, :customer_id => customer)
     #       else
     #         return Order.where(:created_at => time_begin.beginning_of_day..time_end.end_of_day,
     #                            :branch_id => branch,
     #                            :customer_id => customer)
     #       end
     #     end
     #   else
     #     if customer == nil
     #       if time_begin == nil and time_end == nil
     #         return Order.where(:branch_id => branch, :merchant_account_id => merchant_account)
     #       else
     #         return Order.where(
     #             :created_at => time_begin.beginning_of_day..time_end.end_of_day,
     #             :branch_id => branch,
     #             :merchant_account_id => merchant_account)
     #       end
     #     else
     #       if time_begin == nil and time_end == nil
     #         return Order.where(:branch_id => branch, :merchant_account_id => merchant_account, :customer_id => customer)
     #       else
     #         return Order.where(
     #             :created_at => time_begin.beginning_of_day..time_end.end_of_day,
     #             :branch_id => branch,
     #             :merchant_account_id => merchant_account,
     #             :customer_id => customer)
     #       end
     #     end
     #   end
     # end
=end
  def return_order_by_warehouse_and_merchant_account_and_customer (time_begin, time_end, warehouse, merchant_account, customer)
    if merchant_account == nil
      if customer == nil
        if time_begin == nil and time_end == nil
          if warehouse == nil
           return []
          else
            return Order.where(:warehouse_id => warehouse)
          end
        else
          if warehouse == nil
            return Order.where(:created_at => time_begin.beginning_of_day..time_end.end_of_day)
          else
            return Order.where(:created_at => time_begin.beginning_of_day..time_end.end_of_day, :warehouse_id => warehouse)
          end
        end
      else
        if time_begin == nil and time_end == nil
          if warehouse == nil
            return Order.where(:customer_id => customer)
          else
            return Order.where(:warehouse_id => warehouse, :customer_id => customer)
          end
        else
          if warehouse == nil
            return Order.where(
                :created_at => time_begin.beginning_of_day..time_end.end_of_day,
                :customer_id => customer)
          else
            return Order.where(
                :created_at => time_begin.beginning_of_day..time_end.end_of_day,
                :warehouse_id => warehouse,
                :customer_id => customer)
          end
        end
      end
    else
      if customer == nil
        if time_begin == nil and time_end == nil
          if warehouse == nil
            return Order.where(:merchant_account_id => merchant_account)
          else
            return Order.where(:warehouse_id => warehouse, :merchant_account_id => merchant_account)
          end
        else
          if warehouse == nil
            return Order.where(:created_at => time_begin.beginning_of_day..time_end.end_of_day,
                               :merchant_account_id => merchant_account)
          else
            return Order.where(
                :created_at => time_begin.beginning_of_day..time_end.end_of_day,
                :warehouse_id => warehouse,
                :merchant_account_id => merchant_account)
          end
        end
      else
        if time_begin == nil and time_end == nil
          if warehouse == nil
            return Order.where(:merchant_account_id => merchant_account, :customer_id => customer)
          else
            return Order.where(:warehouse_id => warehouse, :merchant_account_id => merchant_account, :customer_id => customer)
          end
        else
          if warehouse == nil
            return Order.where(
                :created_at => time_begin.beginning_of_day..time_end.end_of_day,
                :merchant_account_id => merchant_account,
                :customer_id => customer)
          else
            return Order.where(
                :created_at => time_begin.beginning_of_day..time_end.end_of_day,
                :warehouse_id => warehouse,
                :merchant_account_id => merchant_account,
                :customer_id => customer)
          end
        end
      end
    end
  end
  def return_order_all(time_begin, time_end, merchant, branch, warehouse, merchant_account, customer)
    #lấy tất cả order của Merchant
    if merchant != nil
      orders = return_order_by_warehouse_and_merchant_account_and_customer time_begin,
                                                                           time_end,
                                                                           all_warehouse_on_merchant(merchant).pluck(:id),
                                                                           merchant_account,
                                                                           customer
      # return orders

    #lấy order theo Branch
    elsif merchant == nil and branch != nil and warehouse == nil
      orders = return_order_by_warehouse_and_merchant_account_and_customer time_begin,
                                                                           time_end,
                                                                           all_warehouse_on_branch(branch),
                                                                           merchant_account,
                                                                           customer
      # return orders

    #lấy order theo Branch và Warehouse
    elsif merchant == nil and branch != nil and warehouse != nil
      orders = return_order_by_warehouse_and_merchant_account_and_customer time_begin,
                                                                            time_end,
                                                                            all_warehouse_on_branch(branch)+warehouse,
                                                                            merchant_account,
                                                                            customer
      # return orders
    #lấy theo Warehouse
    elsif merchant == nil and branch == nil and warehouse != nil
      orders = return_order_by_warehouse_and_merchant_account_and_customer time_begin,
                                                                            time_end,
                                                                            warehouse,
                                                                            merchant_account,
                                                                            customer
      return orders
    elsif merchant == nil and branch == nil and warehouse == nil
      orders = return_order_by_warehouse_and_merchant_account_and_customer time_begin,
                                                                           time_end,
                                                                           nil,
                                                                           merchant_account,
                                                                           customer
      # return orders
    else
      # return orders = []
    end
  end
  def returns_import_by_warehouse_and_merchant_account (time_begin, time_end, warehouse, merchant_account)
    if merchant_account == nil
      if time_begin == nil and time_end == nil
        return Import.where(:warehouse_id => warehouse)
      else
        return Import.where(
            :created_at => time_begin.beginning_of_day..time_end.end_of_day,
            :warehouse_id => warehouse)
      end
    else
      if time_begin == nil and time_end == nil
        if warehouse == nil
          return Import.where(:merchant_account_id => merchant_account)
        else
          return Import.where(:warehouse_id => warehouse, :merchant_account_id => merchant_account)
        end
      else
        if warehouse == nil
          return Import.where(
              :created_at => time_begin.beginning_of_day..time_end.end_of_day,
              :merchant_account_id => merchant_account)
        else
          return Import.where(
              :created_at => time_begin.beginning_of_day..time_end.end_of_day,
              :warehouse_id => warehouse,
              :merchant_account_id => merchant_account)
        end
      end
    end
  end
  #-------------------------------------------------------------------------------------------------------------------->
  def returns_export_by_warehouse_and_merchant_account (time_begin, time_end, warehouse, merchant_account)
    if merchant_account == nil
      if time_begin == nil and time_end == nil
        return Export.where(:warehouse_id => warehouse)
      else
        return Export.where(
            :created_at => time_begin.beginning_of_day..time_end.end_of_day,
            :warehouse_id => warehouse)
      end
    else
      if time_begin == nil and time_end == nil
        if warehouse == nil
          return Export.where(:merchant_account_id => merchant_account)
        else
          return Export.where(:warehouse_id => warehouse, :merchant_account_id => merchant_account)
        end
      else
        if warehouse == nil
          return Export.where(
              :created_at => time_begin.beginning_of_day..time_end.end_of_day,
              :merchant_account_id => merchant_account)
        else
          return Export.where(
              :created_at => time_begin.beginning_of_day..time_end.end_of_day,
              :warehouse_id => warehouse,
              :merchant_account_id => merchant_account)
        end
      end
    end
  end
  def returns_export_by_merchant_branch_warehouse_and_merchant_account (time_begin, time_end, merchant, branch, warehouse, merchant_account)
    #Lấy theo Merchant
    if merchant != nil
      return returns_export_by_warehouse_and_merchant_account time_begin, time_end, all_warehouse_on_merchant(merchant).pluck(:id), merchant_account
      #lấy order theo Branch
    elsif merchant == nil and branch != nil and warehouse == nil
      return returns_export_by_warehouse_and_merchant_account time_begin, time_end, all_warehouse_on_branch(branch).pluck(:id), merchant_account
      #lấy order theo Branch và Warehouse
    elsif merchant == nil and branch != nil and warehouse != nil
      warehouse_id = all_warehouse_on_branch(branch).pluck(:id) + warehouse
      return returns_export_by_warehouse_and_merchant_account time_begin, time_end, warehouse_id.uniq(), merchant_account
      #lấy theo Warehouse
    elsif merchant == nil and branch == nil and warehouse != nil
      return returns_export_by_warehouse_and_merchant_account time_begin, time_end, warehouse, merchant_account
      #lấy theo tất cả
    elsif merchant == nil and branch == nil and warehouse == nil and merchant_account != nil
      return returns_export_by_warehouse_and_merchant_account time_begin, time_end, nil, merchant_account
    else
      return []
    end
  end
  #-------------------------------------------------------------------------------------------------------------------->
  def returns_inventory_by_warehouse_and_merchant_account (time_begin, time_end, warehouse, merchant_account)
    if merchant_account == nil
      if time_begin == nil and time_end == nil
        return Inventory.where(:warehouse_id => warehouse)
      else
        return Inventory.where(
            :created_at => time_begin.beginning_of_day..time_end.end_of_day,
            :warehouse_id => warehouse)
      end
    else
      if time_begin == nil and time_end == nil
        if warehouse == nil
          return Inventory.where(:merchant_account_id => merchant_account)
        else
          return Inventory.where(:warehouse_id => warehouse, :merchant_account_id => merchant_account)
        end
      else
        if warehouse == nil
          return Inventory.where(
              :created_at => time_begin.beginning_of_day..time_end.end_of_day,
              :merchant_account_id => merchant_account)
        else
          return Inventory.where(
              :created_at => time_begin.beginning_of_day..time_end.end_of_day,
              :warehouse_id => warehouse,
              :merchant_account_id => merchant_account)
        end
      end
    end
  end
  def returns_inventory_by_merchant_branch_warehouse_and_merchant_account (time_begin, time_end, merchant, branch, warehouse, merchant_account)
    #Lấy theo Merchant
    if merchant != nil
      return returns_inventory_by_warehouse_and_merchant_account time_begin, time_end, all_warehouse_on_merchant(merchant).pluck(:id), merchant_account
      #lấy order theo Branch
    elsif merchant == nil and branch != nil and warehouse == nil
      return returns_inventory_by_warehouse_and_merchant_account time_begin, time_end, all_warehouse_on_branch(branch).pluck(:id), merchant_account
      #lấy order theo Branch và Warehouse
    elsif merchant == nil and branch != nil and warehouse != nil
      warehouse_id = all_warehouse_on_branch(branch).pluck(:id) + warehouse
      return returns_inventory_by_warehouse_and_merchant_account time_begin, time_end, warehouse_id.uniq(), merchant_account
      #lấy theo Warehouse
    elsif merchant == nil and branch == nil and warehouse != nil
      return returns_inventory_by_warehouse_and_merchant_account time_begin, time_end, warehouse, merchant_account
      #lấy theo tất cả
    elsif merchant == nil and branch == nil and warehouse == nil and merchant_account != nil
      return returns_inventory_by_warehouse_and_merchant_account time_begin, time_end, nil, merchant_account
    else
      return []
    end
  end
  #-------------------------------------------------------------------------------------------------------------------->
  def returns_order_report (orders, type_report, success)
    #Trả về nil nếu order trống
    if orders == []
      return []
      #Trả về theo dạng Tổng Quát
    elsif type_report == 0
      return orders if success == nil
      return orders.where(delivery:success).uniq() if (success == 0 || success == 1)
      #Trả về theo dạng Bảng Kê
    elsif type_report == 1
      return OrderDetail.where(order_id: orders.uniq()) if success == nil
      return OrderDetail.where(order_id: orders.where(delivery:success).uniq()) if (success == 0 || success == 1)
    end
  end
  def returns_return_report (orders, type_report, success)
    #Trả về nil nếu order trống
    if orders == []
      return []
      #Trả về theo dạng Tổng Quát
    elsif type_report == 0
      return Return.where(order_id: orders.pluck(:id)).uniq() if success == nil
      return Return.where(order_id: orders.where(deliveries: success).pluck(:id)).uniq() if (success == 0 || success == 1)
      #Trả về theo dạng Bảng Kê
    elsif type_report == 1
      if success == nil
        returns = Return.where(order_id: orders.pluck(:id))
        return ReturnDetail.where(return_id: returns.pluck(:id)).uniq()
      end
      if (success == 0 || success == 1)
        returns = Return.where(order_id: orders.where(deliveries: success))
        return ReturnDetail.where(return_id: returns.pluck(:id)).uniq()
      end
    end
  end
  def returns_delivery_report (orders, type_report, success)
    if orders == []
      return []
    elsif (type_report == 0 || type_report == 1)
      return Delivery.where(order_id:orders.pluck(:id)).uniq() if success == nil
      return Delivery.where(order_id:orders.pluck(:id), success:success).uniq() if (success == 0 || success == 1)
    end
  end
  def returns_import_report (time_begin, time_end, merchant, branch, warehouse, merchant_account)
    #Lấy theo Merchant
    if merchant != nil
      return returns_import_by_warehouse_and_merchant_account time_begin, time_end, all_warehouse_on_merchant(merchant).pluck(:id), merchant_account
    #lấy order theo Branch
    elsif merchant == nil and branch != nil and warehouse == nil
      return returns_import_by_warehouse_and_merchant_account time_begin, time_end, all_warehouse_on_branch(branch).pluck(:id), merchant_account
    #lấy order theo Branch và Warehouse
    elsif merchant == nil and branch != nil and warehouse != nil
      warehouse_id = all_warehouse_on_branch(branch).pluck(:id) + warehouse
      return returns_import_by_warehouse_and_merchant_account time_begin, time_end, warehouse_id.uniq(), merchant_account
    #lấy theo Warehouse
    elsif merchant == nil and branch == nil and warehouse != nil
      return returns_import_by_warehouse_and_merchant_account time_begin, time_end, warehouse, merchant_account
    #lấy theo tất cả
    elsif merchant == nil and branch == nil and warehouse == nil and merchant_account != nil
      return returns_import_by_warehouse_and_merchant_account time_begin, time_end, nil, merchant_account
    else
      return orders = []
    end
  end
  def returns_export_report (type_report, time_begin, time_end, merchant, branch, warehouse, merchant_account)
    #Trả về theo dạng Tổng Quát
    if type_report == 0
      return returns_export_by_merchant_branch_warehouse_and_merchant_account time_begin, time_end, merchant, branch, warehouse, merchant_account
    #Trả về theo dạng Bảng Kê
    elsif type_report == 1
      current_export = returns_export_by_merchant_branch_warehouse_and_merchant_account time_begin, time_end, merchant, branch, warehouse, merchant_account
      return ExportDetail.where(export_id: current_export.pluck(:id))
    end
  end
  def returns_inventory_report (type_report, success, time_begin, time_end, merchant, branch, warehouse, merchant_account)
    #Trả về theo dạng Tổng Quát
    if type_report == 0
      if success == nil
        return returns_inventory_by_merchant_branch_warehouse_and_merchant_account time_begin, time_end, merchant, branch, warehouse, merchant_account
      elsif success == 0 || success == 1
        current_inventory = returns_inventory_by_merchant_branch_warehouse_and_merchant_account time_begin, time_end, merchant, branch, warehouse, merchant_account
        return current_inventory.where(submited:1, success:success)
      end
      #Trả về theo dạng Bảng Kê
    elsif type_report == 1
      if success == nil
        current_inventory = returns_inventory_by_merchant_branch_warehouse_and_merchant_account time_begin, time_end, merchant, branch, warehouse, merchant_account
        return InventoryDetail.where(inventory_id: current_inventory.pluck(:id))
      elsif success == 0 || success == 1
        current_inventory =(returns_inventory_by_merchant_branch_warehouse_and_merchant_account time_begin, time_end, merchant, branch, warehouse, merchant_account).where(submited:1, success:success)
        return InventoryDetail.where(inventory_id: current_inventory.pluck(:id))
      end

    end
  end
  #-------------------------------------------------------------------------------------------------------------------->
end

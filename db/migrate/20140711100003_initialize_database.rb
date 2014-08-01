class InitializeDatabase < ActiveRecord::Migration
  def change
    create_table :option do |t|
      t.belongs_to :merchant
      t.belongs_to :branch
      t.integer :transport
      t.integer :payment_method

      t.timestamps
    end

    create_table :accounts do |t|
      t.string :auth_token, :null => false
      t.integer :extension, default: 1, null: false
      t.integer :headquater, :default =>0 #Id của tổ chức (merchant hay agency)
      t.integer :parent_id, :default => 0
      t.integer :status, :default => 0
      t.string :display_name
      t.string :last_name
      t.string :first_name
      t.string :email, :null => false
      t.string :phone
      t.string :password_digest, :null => false

      t.timestamps
    end
    #Tai khoan cua Gera
    create_table :gera_accounts do |t|
      t.belongs_to :account
      t.string :name
      t.string :position
      t.string :phone
      t.string :address
      t.timestamps
    end
    #Khu Vuc cua Gera
    create_table :gera_areas do |t|
      t.belongs_to :gera_account, :null => false
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end
    #Khach hang cua Gera
    create_table :gera_customers do |t|
      t.belongs_to :gera_area
      t.belongs_to :gera_account, :null => false
      t.string :name
      t.string :name_company
      t.string :position_company
      t.string :phone
      t.string :address
      t.boolean :sex
      t.integer :age
      t.string  :email
      t.timestamps
    end
    #Công ty đang làm của khach hang
    create_table :gera_customers_companies do |t|
      t.belongs_to :gera_area
      t.belongs_to :gera_account, :null => false
      t.string :name_company #Tên công ty
      t.string :industry_company #Ngành nghề công ty
      t.string :revenue #Doanh thu
      t.text :description
      t.string :address_street
      t.string :address_city
      t.string :address_state
      t.string :address_postcode
      t.string :address_country
      t.date :age

      t.timestamps
    end
    #Cơ hội của nhan vien gera
    create_table :gera_opportunities do |t|
      t.belongs_to :gera_area
      t.belongs_to :gera_account, :null => false
      t.belongs_to :gera_customers_company
      t.belongs_to :gera_customer
      t.string :name
      t.string :name_company
      t.string :position_company
      t.string :phone
      t.string :address
      t.boolean :sex
      t.integer :age
      t.timestamps
    end
    #Hoạt động của nhan vien gera
    create_table :gera_activities do |t|
      t.belongs_to :gera_area
      t.belongs_to :gera_account, :null => false
      t.belongs_to :gera_customers_company
      t.belongs_to :gera_customer
      t.string :name
      t.string :name_company
      t.string :position_company
      t.string :phone
      t.string :address
      t.boolean :sex
      t.integer :age
      t.timestamps
    end
    #Sản phẩm của gera
    create_table :gera_products do |t|
      t.belongs_to :gera_account, :null => false
      t.string :name
      t.timestamps
    end

#AGENCY SECTION------------------------------------------------------------------------------------------->
#Nha cung cap Agency
    create_table :agencies do |t|
      t.belongs_to :gera_accounts, :null => false
      t.string :name
      t.integer :headquater_id
      t.timestamps
    end
    #Tai khoan cua Agency
    create_table :agency_accounts do |t|
      t.belongs_to :account, :null => false
      t.belongs_to :agency, :null => false
      t.timestamps
    end
    #Khu Vuc cua Agency
    create_table :agency_areas do |t|
      t.belongs_to :agency, :null => false
      t.belongs_to :agency_account, :null => false
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end
    #Khach hang cua Agency
    create_table :agency_customers do |t|
      t.belongs_to :agency, :null => false
      t.belongs_to :agency_area
      t.belongs_to :agency_account, :null => false
      t.string :name
      t.timestamps
    end

#MERCHANTS SECTION---------------------------------------------------------------------------------------------------->
#Dai ly ban le------------------------------------------->
    create_table :merchants do |t|
      #Headquater: Id của tổ chức cấp trên (tức là merchant này là khách hàng của ai?)
      #là khách hàng trực tiếp của Gera (headquater=0) hay trực thuộc angency nào?
      t.integer :headquater, :null => false, :default => 0
      t.integer :owner_id, :null => false
      t.string :name, :null => false
      t.timestamps
    end
    #Tai khoan cua dai ly------------------------------------>
    create_table :merchant_accounts do |t|
      t.belongs_to :account, :null => false
      t.belongs_to :merchant, :null => false
      t.belongs_to :branch, :null => false , :default => 0
      t.integer :current_warehouse_id

      t.timestamps
    end
    #Khu Vuc---------------------------------------------->
    create_table :merchant_areas do |t|
      t.belongs_to :merchant, :null => false
      t.belongs_to :merchant_account, :null => false
      t.string :name, :null => false
      t.string :description

      t.timestamps
    end
    #Khach hang---------------------------------------------->
    create_table :customers do |t|
      t.belongs_to :merchant, :null => false
      t.belongs_to :merchant_account, :null => false
      t.belongs_to :merchant_area

      t.string :name, :null => false
      t.string :company_name
      t.string :phone, :null => false
      t.string :address
      t.string :email
      t.boolean :sex


      t.timestamps
    end
    #Nha cung cap-------------------------------------------->
    create_table :providers do |t|
      t.belongs_to :merchant, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    #Skull--------------------------------------------------->
    create_table :skulls do |t|
      t.belongs_to :merchant, :null => false
      t.belongs_to :merchant_account, :null => false

      t.string :skull_01
      t.string :skull_02
      t.string :skull_03
      t.string :unit, :null => false
      t.integer :unit_quality

      t.timestamps
    end
    #Chi nhanh----------------------------------------------->
    create_table :branches do |t|
      t.belongs_to :merchant, :null => false
      t.string :name, :null => false

      t.timestamps
    end
    #Kho----------------------------------------------------->
    create_table :warehouses do |t|
      t.belongs_to :merchant, :null => false
      t.belongs_to :branch, :null => false
      t.string :name, :null => false
      t.string :location

      t.timestamps
    end
    #Phieu nhap kho------------------------------------------>
    create_table :imports do |t|
      t.belongs_to :warehouse, :null => false
      t.belongs_to :merchant_account, :null => false
      t.integer :parent_export_id

      t.string :name
      t.text :description, :null => false

      t.timestamps
    end

    #Phieu nhap kho tạm------------------------------------------>
    create_table :temp_imports do |t|
      t.belongs_to :warehouse, :null => false
      t.belongs_to :merchant_account, :null => false

      t.string :name
      t.text :description

      t.timestamps
    end

    #Bảng tạm CHI TIẾT NHẬP KHO!--------------------------------->
    create_table :temp_import_details do |t|
      t.belongs_to :product_summary, :null => false
      t.belongs_to :merchant_account, :null => false
      t.belongs_to :provider

      t.integer :import_quality, :default => 0 #so luong nhap
      t.decimal :import_price, :presence => 15 #gia

      t.timestamps
    end

    #San pham------------------------------------------------>
    create_table :product_summaries do |t|
      t.string :product_code, :null => false
      t.belongs_to :skull
      t.belongs_to :warehouse, :null => false
      t.belongs_to :merchant_account, :null => false

      t.string :name, :null => false
      t.integer :quality, :default => 0
      t.decimal :price, :presence => 15

      t.timestamps
    end

    #Bang CHI TIET san pham!-------------------------------->
    create_table :products do |t|
      t.string :product_code, :null => false
      t.belongs_to :merchant_account, :null => false
      t.belongs_to :skull
      t.belongs_to :provider, :null => false
      t.belongs_to :warehouse, :null => false
      t.belongs_to :import, :null => false

      t.string :name, :null => false
      t.integer :import_quality, :null => false #so luong nhap
      t.integer :available_quality, :null => false, :default => 0 #so luong kha di~
      t.integer :instock_quality, :null => false, :default => 0 #so luong thuc te con trong kho
      t.decimal :import_price, :presence => 15
      t.datetime :expire

      t.timestamps
    end
    #Phieu xuat kho------------------------------------------>
    create_table :exports do |t|
      t.belongs_to :merchant_account, :null => false
      t.belongs_to :warehouse, :null => false
      t.integer :target_warehouse_id

      t.string :name
      t.text :description, :null => false

      t.timestamps
    end
    #Chi tiet xuat kho--------------------------------------->
    create_table :export_details do |t|
      t.belongs_to :export, :null => false
      t.string :name
      t.belongs_to :product, :null => false

      t.integer :quality, :null => false

      t.timestamps
    end
    #Phieu kiem ton------------------------------------------>
    create_table :inventories do |t|
      t.belongs_to :warehouse, :null => false
      t.belongs_to :merchant_account, :null => false
      t.string :name

      t.boolean :submited, :default => false #của nhân viên
      t.text :decription
      t.boolean :success, :null => false, :default => false #hoàn thành tất cả thì true

      t.boolean :resolved, :null => false, :default => false #true khi có vấn đề
      t.text :resolve_description

      t.timestamps
    end
    #Chi tiet kiem ton--------------------------------------->
    create_table :temp_inventory_details do |t|
      t.belongs_to :product, :null => false
      t.belongs_to :inventory, :null => false

      t.integer :original_quality, :null => false #số lượng trong kho
      t.integer :real_quality, :null => false , :default=>0#số kiem tra
      t.integer :quality #SO LUONG HANG DA BAN TRONG KHI KIEM KHO
      t.boolean :submited, :default =>0
      t.timestamps
    end
    #Chi tiet kiem ton--------------------------------------->
    create_table :inventory_details do |t|
      t.belongs_to :product, :null => false
      t.belongs_to :inventory, :null => false
      t.string :name

      t.integer :original_quality, :null => false #số lượng trong kho
      t.integer :real_quality, :null => false #số kiem tra
      t.integer :sale_quality, :null=>false

      t.integer :lost_quality, :default => 0 #không được lớn hơn số lượng mất trước đó
      t.string  :resolve_description
      t.boolean :resolved, :null => false, :default => false

      t.timestamps
    end
    #Don dat hang-------------------------------------------->
    create_table :orders do |t|
      t.belongs_to :branch, :null => false                         #bán chi nhánh nào
      t.belongs_to :warehouse, :null => false                      #bán cửa hàng nào
      t.belongs_to :merchant_account, :null => false               #người bán
      t.belongs_to :customer, :null => false                       #người mua
      t.string :name                                               #tên phiếu order(tính lại khi cập nhật)

      t.boolean :return, :null => false, :default => false         #Id don tra hang (neu co)
      t.integer :payment_method, :null => false                    #cách thanh toán (tiền mặt, nợ)
      t.boolean :delivery,:null => false, :default =>false         #phương thức vận chuyển(trực tiếp, giao hàng)
                                                                      #false ko co giao hàng, true có giao hàng
      t.boolean :bill_discount, :default => false                  #cách tích giảm giá của order theo từng sản phẩm hay tổng phiếu order
                                                                      #false tính theo từng sp, true tính theo tổng hóa đơn
      t.decimal :total_price, :null => false                       #Tổng giá trị hóa đơn chưa giảm giá
      t.decimal :discount_voucher, :null => false, :default => 0   #giam gia theo phiếu giảm giá
      t.decimal :discount_cash, :null => false, :default => 0      #giam gia tinh bang tien mat
      t.decimal :final_price, :null => false, :default=>0          #Tổng tiền còn lại khi trừ giảm giá.

      t.decimal :deposit, :null => false, :default=>0              #số tiền trả trước
      t.decimal :currency_debit, :null => false, :default => 0     #số tiền còn nợ
      #tinh trang don hang
      #1 giao dich trực tiếp thành công (ko nợ)
      #2 giao dich trực tiếp thành công (có nợ)
      #3 giao dịch có giao hàng (ko nợ)
      #4 giao dịch có giao hàng (có nợ)
      #5 giao dịch có giao hàng thành công (ko nợ)
      #6 giao dịch có giao hàng thành công (có nợ)
      #7 giao dịch có giao hàng thất bại (ko nợ)
      #8 giao dịch có giao hàng thất bại(có nợ)
      t.integer :status, :null => false, :default => 0

      t.timestamps
    end

    #Chi tiet don hang---------------------------------------->
    create_table :order_details do |t|
      t.belongs_to :order, :null => false
      t.string :name
      t.belongs_to :product, :null => false
      t.integer :quality, :null => false
      t.integer :return_quality, :null => false, :default => 0
      t.decimal :price, :null => false
      t.decimal :discount_cash, :null => false, :default => 0
      t.decimal :discount_percent, :null => false, :default => 0
      t.decimal :total_amount, :null => false, :default => 0
      #tinh trang don hang
      #1 giao dich trực tiếp thành công (ko nợ)
      #2 giao dich trực tiếp thành công (có nợ)
      #3 giao dịch có giao hàng (ko nợ)
      #4 giao dịch có giao hàng (có nợ)
      #5 giao dịch có giao hàng thành công (ko nợ)
      #6 giao dịch có giao hàng thành công (có nợ)
      #7 giao dịch có giao hàng thất bại (ko nợ)
      #8 giao dịch có giao hàng thất bại(có nợ)
      t.integer :status, :null => false, :default => 0

      t.timestamps
    end
    #Phieu giao hang------------------------------------------>
    create_table :deliveries do |t|
      t.belongs_to :order, :null => false
      t.belongs_to :merchant_account, :null => false
      t.string :name
      t.boolean :success, :default=>false

      t.datetime :creation_date,:null => false #ngay dat hang
      t.datetime :delivery_date, :null => false #ngay giao hang
      t.string :delivery_address, :null => false #đia chi giao hang
      t.string :contact_name, :null => false #tên nguoi lien lac
      t.string :contact_phone, :null => false #so dt nguoi lien lac
      t.decimal :transportation_fee, :null => false
      t.string :comment, :null => false
      t.integer :status, :null => false

      t.timestamps
    end
    #Phieu tra hang------------------------------------------->
    create_table :returns do |t|
      t.belongs_to :order, :null => false
      t.belongs_to :merchant_account, :null => false
      t.string :name
      t.boolean :submited, :default =>false

      t.decimal :total_return_money
      t.datetime :creation_date, :null => false
      t.string :comment, :null => false

      t.timestamps
    end
    #Chi tiet tra hang---------------------------------------->
    create_table :return_details do |t|
      t.belongs_to :return, :null => false
      t.string :name
      t.integer :return_product_id, :null => false #id product tra hang
      t.integer :return_quality, :null => false #so luong tra
      t.boolean :type_return, :default =>false #loai hinh tra hang =false thi doi, =true tra tien
      t.integer :product_id #id product hang doi
      t.integer :quality #so luong hang doi
      t.decimal :price, :default=>0 #giá tiền sản phẩm
      t.boolean :submited, :default =>false #xác nhận

      t.timestamps
    end

    #Don dat hang tạm-------------------------------------------->
    create_table :temp_orders do |t|
      t.belongs_to :branch, :null => false                              #bán chi nhánh nào
      t.belongs_to :warehouse, :null => false                           #bán cửa hàng nào
      t.belongs_to :merchant_account, :null => false                    #người bán
      t.belongs_to :customer, :null => false                            #người mua
      t.string :name                                                    #tên phiếu order(tính lại khi cập nhật)

      t.boolean :return, :null => false, :default => false              #Id don tra hang (neu co)
      t.integer :payment_method, :null => false, :default => 0          #cách thanh toán (tiền mặt, nợ)
      t.boolean :delivery, :null => false, :default =>false             #phương thức vận chuyển(trực tiếp, giao hàng)
                                                                        #true có giao hàng, false ko co giao hàng
      t.boolean :bill_discount, :null => false, :default => false       #cách tích giảm giá hóa đơn,
                                                                        #false tính theo từng sp, true tính theo tổng hóa đơn
      t.decimal :total_price, :null => false, :default => 0             #Tổng giá trị hóa đơn chưa giảm giá
      t.decimal :discount_voucher, :null => false, :default => 0        #giam gia theo phiếu giảm giá
      t.decimal :discount_cash, :null => false, :default => 0           #giam gia tinh bang tien mat
      t.decimal :final_price, :null => false, :default=>0               #Tổng tiền còn lại khi trừ giảm giá.

      t.decimal :deposit, :null => false, :default=>0                   #số tiền trả trước
      t.decimal :currency_debit, :null => false, :default => 0          #số tiền còn nợ

      t.timestamps
    end
    #Chi tiet don hang tạm ---------------------------------------->
    create_table :temp_order_details do |t|
      t.belongs_to :order, :null => false
      t.integer :product_summary_id, :null => false
      t.string :product_code, :null => false
      t.integer :skull_id, :null => false
      t.integer :warehouse_id, :null => false

      t.integer :quality, :null => false, :default => 0
      t.decimal :price, :null => false, :default => 0

      t.decimal :discount_cash, :null => false, :default => 0
      t.decimal :discount_percent, :null => false, :default => 0
      t.decimal :temp_discount_percent, :null => false, :default => 0
      t.decimal :total_amount, :null => false, :default => 0

      t.timestamps
    end

    #Chi tiet Mertro_Summary---------------------------------->
    create_table :metro_summaries do |t|
      t.belongs_to :warehouse
      t.integer :product_count, :default=>0 #Done
      t.integer :stock_count, :default=>0 #Done
      t.integer :customer_count, :default=>0 #Done
      t.integer :staff_count, :default=>0 #Done
      t.integer :staff_count_branch, :default=>0 #Done
      t.integer :sale_count, :default=>0 #Done
      t.integer :sale_count_day, :default=>0 #Done
      t.integer :sale_count_month, :default=>0 #Done
      t.integer :return_count, :default=>0 #Done
      t.integer :return_count_day, :default=>0 #Done
      t.integer :return_count_month, :default=>0 #Done
      t.integer :revenue ,:limit => 8, :default=>0 #Done
      t.integer :revenue_day ,:limit => 8, :default=>0 #Done
      t.integer :revenue_month ,:limit => 8, :default=>0 #Done
    end

#Phân quyền------------------------------------------------------------------------------------------------------->

    #Của Merchant
    create_table :roles do |t|
      t.integer :headquater, default: 0 #trường hợp = 0 tức là Role này dùng chung (global) cho mọi merchant!
      t.string :name
      t.string :permissions
      t.timestamps
    end

    #Của Merchant
    create_table :role_permissions do |t|
      t.belongs_to :role
      t.integer :permission_key
      t.timestamps
    end

    create_table :merchant_account_roles do |t|
      t.belongs_to :merchant_account
      t.belongs_to :role
    end

    #Ho so mackay-------------------------------------------------------------------------------------------->
    create_table :mackay_profiles do |t|
      t.belongs_to :gera_customer
      t.belongs_to :agency_customer
      t.belongs_to :customer
      t.integer :last_updator_id, :null => false #id của Account
      t.text :notes
      t.timestamps
    end
    #Hồ sơ Mackay - cá nhân ---------------------------------------------->
    create_table :mackay_personals do |t|
      t.belongs_to :mackay_profile
      t.string :first_name
      t.string :last_name
      t.string :position

      t.string :company_name
      t.string :company_address
      t.string :company_phone

      t.string :home_address
      t.string :home_phone

      t.string :date_of_birth
      t.string :place_of_birth
      t.string :home_town
      t.integer :gender
      t.float :height
      t.float :weight
      t.text :comment #ghi chú về những thứ quan trọng như là: bị hói, rất nhạy cảm, độc thân và mê gái...
    end
    #Ho so mackay hoc van ---------------------------------------------->
    create_table :mackay_educations do |t|
      t.belongs_to :mackay_profile
      t.string :high_school_name
      t.date :high_school_year
      t.string :high_school_graduation_grade

      t.string :university_name
      t.date :university_start_year
      t.date :university_graduate_year
      t.string :university_graduation_grade #loại bằng cấp, khá, giỏi, trung bình?

      t.string :university_award #giải thưởng trong khi học đh?
      t.string :university_club
      t.string :sports
      t.string :activities

      t.text :feeling_university #cảm nhận không học đại học?
      t.string :alternative #thay vì học đại học, họ đã làm gì?
      t.string :army_name
      t.string :army_grade
      t.string :army_atitude #thái độ trong quân ngũ
    end
    #Ho so mackay gia dinh ---------------------------------------------->
    create_table :mackay_families do |t|
      t.belongs_to :mackay_profile
      t.integer :mariage_status #đã kết hôn, độc thân, đang hẹn hò, góa..
      t.string :spouse_name
      t.string :spouse_education
      t.string :spouse_hobbies
      t.date :mariage_at
    end
    #Ho so mackay gia dinh con cái ---------------------------------------------->
    create_table :mackay_childrens do |t|
      t.belongs_to :mackay_profile
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.string :education
      t.date :birthday
      t.integer :age
      t.string :hobbies
      t.text :comment
    end
    #Ho so mackay cong viec (sự nghiệp) ---------------------------------------------->
    create_table :mackay_careers do |t|
      t.belongs_to :mackay_profile

      t.string :last_company_name
      t.string :last_company_address
      t.date :last_start_working_date
      t.string :last_position
      t.string :last_company_award
      t.string :last_company_attitude

      t.string :current_company_name
      t.string :current_company_address
      t.string :current_position
      t.date :current_start_working_date
      t.string :current_company_award
      t.string :current_company_attitude

      t.string :short_term_career_plan
      t.string :medium_term_career_plan
      t.string :long_term_career_plan
      t.string :current_concerns #mối lo ngại khach hang
      t.string :relation_with_our_staffs #mối quan hệ với nhân viên nào trong c.ty mình
      t.string :relation_status #tình trạng, mối quan hệ có tốt không?
      t.string :relation_description #lý do của tình trạng đó, tại sao tốt, tại sao không
      t.string :relation_essense #bản chất của mối quan hệ
    end
    #Ho so mackay so thich ---------------------------------------------->
    create_table :mackay_hobbies do |t|
      t.belongs_to :mackay_profile
      t.string :club_name
      t.string :community_activity
      t.string :political_activity
      t.string :religious
      t.string :conversation_avoids #những thứ tuyệt đối phải tránh khi trò chuyện với họ!
      t.string :conversation_enjoy #những thứ họ rất thích nói về (ngoài kinh doanh)
    end
    #Ho so mackay phong cach song ---------------------------------------------->
    create_table :mackay_life_styles do |t|
      t.belongs_to :mackay_profile
      t.string :sickness_history
      t.string :current_heath_status

      t.boolean :enjoy_drink
      # nếu có uống rượu-------------------------->
      t.string :famous_drink #thích loại nào
      t.string :drink_tolarence #tửu lượng
      # nếu không uống rượu-------------------->
      t.boolean :dislike_drink

      t.boolean :smoke
      t.string :dislike_smoke
      t.string :famous_lunch_restaurant
      t.string :famous_diner_restaurant
      t.string :famous_dishes #món ăn ưa thích
      t.boolean :hate_feed #không thích ăn đồ người khác mua?
      t.string :hoobies
      t.string :entertainment_hobbies
      t.string :reading_hoobies
      t.string :holiday_hobbies
      t.string :famous_sports
      t.string :targeted_object #người mà khách hàng muốn gây ấn tượng
      t.string :expected_from_object #khách hàng mong muốn gì từ đối tượng
      t.string :adjectives_about_customer #những tính từ miêu tả khách hàng
      t.string :best_prounds #những thứ mà khách hàng tự hào nhất
      t.string :long_term_target #cảm nhận của bạn về mục tiêu dài hạn của khách hàng
      t.string :short_term_target # cảm nhận của bạn về mục tiêu TRUNG hạn của khách hàng
    end
    #Ho so mackay khach hang va ban---------------------------------------------->
    create_table :mackay_and_companies do |t|
      t.belongs_to :mackay_profile
      t.string :ethic_cautious #những thứ cần để ý thuộc về quy trù đạo đức
      t.boolean :customer_feel_obligation #khách hàng có cảm thấy có nghĩa vụ với bạn hay không
      t.string :obligation_descriptions
      t.boolean :very_focus
      t.boolean :very_ethic
      t.string :customer_key_aspect #vấn đề mấu chốt của khách hàng
    end

   end
end

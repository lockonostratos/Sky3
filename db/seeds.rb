# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# t.string :product_code, :null => false
# t.belongs_to :skull
# t.belongs_to :warehouse, :null => false
# t.belongs_to :merchant_account, :null => false
#
# t.string :name, :null => false
# t.integer :quality, :default => 0
# t.decimal :price, :presence => 15
#
# t.timestamps

#Default Roles!
saleRole = Role.create!(name: "Bán Hàng")
saleRole.add_permission(:sale)
managerRole = Role.create!(name: "Quản Lý")
managerRole.add_permission(:sale)
managerRole.add_permission(:return)
managerRole.add_permission(:import)
managerRole.add_permission(:export)
managerRole.clone("Quản Lý", "Quản Lý Ext")


#1.Tạo tài khoản của chính Gera
Account.create({extension: :gera, display_name: 'hongky', email: 'hongky@gmail.com', password: '123'})

#2.Tạo tài khoản:------------------------------------------------------------------------------------------------------>
tai = Account.create({extension: :merchant, display_name: 'chitai', email: 'chitai@gmail.com', password: '123'})
loc = Account.create({extension: :merchant, display_name: 'locquoc', email: 'lelongking@gmail.com', password: '123'})

son = Account.create({parent_id: loc.id, extension: :merchant, display_name: 'sonle', email: 'lehaoson@gmail.com', password: '123'})
pham = Account.create({parent_id: son.id, extension: :merchant, display_name: 'tieupham', email: 'tieupham@gmail.com', password: '123'})
ky = Account.create({parent_id: son.id, extension: :merchant, display_name: 'hongky', email: 'nguyenhongky@gmail.com', password: '123'})

tehao = Account.create({parent_id: son.id, extension: :merchant, display_name: 'tehao', email: 'tehao@gmail.com', password: '123'})

#Tạo chi nhánh mới
dongthap = Branch.create({name: 'HỒ CHÍ MINH', merchant_id: loc.headquater})

khoHcm = Warehouse.find(loc.merchant_account.current_warehouse_id)
khoDongThap = Warehouse.find_by_branch_id(dongthap.id)

tai_mer_acc = tai.merchant_account
loc_mer_acc = loc.merchant_account
son_mer_acc = son.merchant_account
tehao_mer_acc = tehao.merchant_account

#Gán quyền
loc_mer_acc.add_role_by_name("Bán Hàng")
loc_mer_acc.add_role_by_name("Quản Lý")
son_mer_acc.add_role_by_name("Bán Hàng")
tehao_mer_acc.add_role_by_name("Bán Hàng")

tehao_mer_acc.move_to_warehouse(khoDongThap.id)


#3. Tạo Skull---------------------------------------------------------------------------------------------------------->
skull_goi_800gr_25 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'800gr', unit:'goi', unit_quality:25})
skull_goi_200gr_56 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'200gr', unit:'goi', unit_quality:56})
skull_goi_30gr_300 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'30gr', unit:'goi', unit_quality:300})
skull_lo_200gr_56 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'200gr', unit:'lo', unit_quality:56})
skull_lo_400gr_30 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'400gr', unit:'lo', unit_quality:30})
skull_goi_700gr_32 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'700gr', unit:'goi', unit_quality:32})
skull_lo_300gr_30 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'300gr', unit:'lo', unit_quality:30})
skull_goi_50gr_200 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'50gr', unit:'Goi', unit_quality:200})
skull_chai_1000ml_15 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'1000ml', unit:'chai', unit_quality:15})
skull_chai_500ml_28 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'500ml', unit:'chai', unit_quality:28})
skull_goi_2kg_10 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'2kg', unit:'goi', unit_quality:10})
skull_chai_100ml_30 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'100ml', unit:'chai', unit_quality:30})
skull_goi_10gr_300 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'10gr', unit:'goi', unit_quality:300})
skull_lo_100gr_50 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'100gr', unit:'lo', unit_quality:50})
skull_goi_1kg_20 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'1kg', unit:'goi', unit_quality:20})
skull_goi_15gr_360 = Skull.create({merchant_id:khoDongThap.merchant_id, merchant_account_id:loc_mer_acc.id, skull_01:'15gr', unit:'goi', unit_quality:360})


#4. Tạo Provider----------------------------------------------------------------------------------------------------->
provider_hcm_q1 = Provider.create({merchant_id:loc_mer_acc.merchant_id, name:'Quận 1 - Hồ Chí Minh'})
provider_hcm_q2 = Provider.create({merchant_id:loc_mer_acc.merchant_id, name:'Quận 2 - Hồ Chí Minh'})
provider_hcm_q3 = Provider.create({merchant_id:loc_mer_acc.merchant_id, name:'Quận 3 - Hồ Chí Minh'})
provider_hcm_q4 = Provider.create({merchant_id:loc_mer_acc.merchant_id, name:'Quận 4 - Hồ Chí Minh'})

#5. Tạo Khu Vực Area----------------------------------------------------------------------------------------------------->
area_hcm_q1 = MerchantArea.create({merchant_id:tai_mer_acc.merchant_id, merchant_account_id:tai_mer_acc.account_id, name:'Quận 1 - Hồ Chí Minh', description:''})
area_hcm_q2 = MerchantArea.create({merchant_id:tai_mer_acc.merchant_id, merchant_account_id:tai_mer_acc.account_id, name:'Quận 2 - Hồ Chí Minh', description:''})
area_hcm_q3 = MerchantArea.create({merchant_id:loc_mer_acc.merchant_id, merchant_account_id:loc_mer_acc.account_id, name:'Quận 3 - Hồ Chí Minh', description:''})
area_hcm_q4 = MerchantArea.create({merchant_id:loc_mer_acc.merchant_id, merchant_account_id:loc_mer_acc.account_id, name:'Quận 4 - Hồ Chí Minh', description:''})

#6. Tạo Khách hàng----------------------------------------------------------------------------------------------------->
customer_hoangnam = Customer.create({merchant_id:tai_mer_acc.merchant_id, merchant_account_id:tai_mer_acc.account_id, merchant_area_id:area_hcm_q1.id, name:'Nguyễn Hoàng Nam', company_name:'Cty TNHH Hoàng Nam', phone:'0123456789', address:'Hồ Chí Minh', email:'hoangnam@gmail.com', sex:0})
customer_thuanthai = Customer.create({merchant_id:tai_mer_acc.merchant_id, merchant_account_id:tai_mer_acc.account_id, merchant_area_id:area_hcm_q1.id, name:'Huỳnh Thuận Thái', company_name:'CSC Vietnam', phone:'0123456789', address:'Hồ Chí Minh', email:'thuanthai@gmail.com', sex:0})

customer_hongky = Customer.create({merchant_id:loc_mer_acc.merchant_id, merchant_account_id:loc_mer_acc.account_id, merchant_area_id:area_hcm_q3.id, name:'Nguyễn Hồng Kỳ', company_name:'Thien Ban Tech', phone:'0123456789', address:'Hồ Chí Minh', email:'nguyenhongkynhk@gmail.com', sex:0})
customer_trunghau = Customer.create({merchant_id:loc_mer_acc.merchant_id, merchant_account_id:loc_mer_acc.account_id, merchant_area_id:area_hcm_q3.id, name:'Lê Trung Hậu', company_name:'Domexco', phone:'0123456789', address:'Đồng Tháp', email:'hauletrung@gmail.com', sex:0})
customer_vanhung = Customer.create({merchant_id:loc_mer_acc.merchant_id, merchant_account_id:loc_mer_acc.account_id, merchant_area_id:area_hcm_q3.id, name:'Huỳnh Văn Hùng', company_name:'SK Telecom', phone:'0123456789', address:'Hồ Chí Minh', email:'huangwenxiong@gmail.com', sex:0})
customer_vansang = Customer.create({merchant_id:loc_mer_acc.merchant_id, merchant_account_id:loc_mer_acc.account_id, merchant_area_id:area_hcm_q3.id, name:'Nguyễn Văn Sang', company_name:'iThink', phone:'0123456789', address:'Hồ Chí Minh', email:'sangnv@gmail.com', sex:0})

#Tạo phiếu Import----------------------------------------------------------------------------------------------------->
new_import = Import.create({warehouse_id:khoHcm.id, merchant_account_id:loc_mer_acc.id, name:'Nhập Kho Lần Đầu 2014', description:'Nhập Đầu Năm'})

#Tạo Product-------------------------------------------------------------------------------------------------------->
Product.create({product_code:'1234567890001', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX1',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890002', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX4',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890003', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX5',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890004', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX9 (Magiephos)',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890005', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX(F.Bo)',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890006', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'HCR ',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890007', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_30gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Việt Long',  import_quality:500, available_quality:500, instock_quality:500, import_price:4700})
Product.create({product_code:'1234567890008', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX1',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890009', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX2',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890010', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX3',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890011', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX4',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890012', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX5',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890013', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX12',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890014', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'HCR ',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890015', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX(F.Bo)',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890016', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX9 (Magiephos)',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890017', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX1',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890018', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX2',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890019', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX3',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890020', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX4',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890021', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX5',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890022', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX12',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890023', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'HCR ',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890024', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX(F.Bo)',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890025', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_400gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX9 (Magiephos)',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890026', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_700gr_32.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Tưới 1',  import_quality:500, available_quality:500, instock_quality:500, import_price:38000})
Product.create({product_code:'1234567890027', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_700gr_32.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Tưới 4',  import_quality:500, available_quality:500, instock_quality:500, import_price:38000})
Product.create({product_code:'1234567890028', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_700gr_32.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Magie',  import_quality:500, available_quality:500, instock_quality:500, import_price:38000})
Product.create({product_code:'1234567890029', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_700gr_32.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Tưới 2',  import_quality:500, available_quality:500, instock_quality:500, import_price:44000})
Product.create({product_code:'1234567890030', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_700gr_32.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Tưới 3',  import_quality:500, available_quality:500, instock_quality:500, import_price:44000})
Product.create({product_code:'1234567890031', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_300gr_30.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX TriCho hòa tan ( Giá net )',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890032', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_2kg_10.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX TriCho  ',  import_quality:500, available_quality:500, instock_quality:500, import_price:90000})
Product.create({product_code:'1234567890033', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_500ml_28.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX6 (Ra hoa CAT)',  import_quality:500, available_quality:500, instock_quality:500, import_price:29000})
Product.create({product_code:'1234567890034', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_1000ml_15.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX6 (Ra hoa CAT)',  import_quality:500, available_quality:500, instock_quality:500, import_price:55000})
Product.create({product_code:'1234567890035', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_500ml_28.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Tăng trưởng',  import_quality:500, available_quality:500, instock_quality:500, import_price:55000})
Product.create({product_code:'1234567890036', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_500ml_28.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:' Nutrimix',  import_quality:500, available_quality:500, instock_quality:500, import_price:55000})
Product.create({product_code:'1234567890037', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_1000ml_15.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX19 (Dưỡng trái) ',  import_quality:500, available_quality:500, instock_quality:500, import_price:60000})
Product.create({product_code:'1234567890038', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_1000ml_15.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX8 (Đậu trái)',  import_quality:500, available_quality:500, instock_quality:500, import_price:60000})
Product.create({product_code:'1234567890039', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_1000ml_15.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Đồng xanh ',  import_quality:500, available_quality:500, instock_quality:500, import_price:60000})
Product.create({product_code:'1234567890040', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_1000ml_15.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX 774 Humic ',  import_quality:500, available_quality:500, instock_quality:500, import_price:60000})
Product.create({product_code:'1234567890041', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_1000ml_15.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:' MX SiCan',  import_quality:500, available_quality:500, instock_quality:500, import_price:60000})
Product.create({product_code:'1234567890042', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_500ml_28.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Canxi',  import_quality:500, available_quality:500, instock_quality:500, import_price:38000})
Product.create({product_code:'1234567890043', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_500ml_28.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'MX Bo',  import_quality:500, available_quality:500, instock_quality:500, import_price:47000})
Product.create({product_code:'1234567890044', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_500ml_28.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Sữa thấm ướt',  import_quality:500, available_quality:500, instock_quality:500, import_price:29000})
Product.create({product_code:'1234567890057', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_15gr_360.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie1',  import_quality:500, available_quality:500, instock_quality:500, import_price:3000})
Product.create({product_code:'1234567890058', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_15gr_360.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie2',  import_quality:500, available_quality:500, instock_quality:500, import_price:3000})
Product.create({product_code:'1234567890059', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_15gr_360.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie3 ',  import_quality:500, available_quality:500, instock_quality:500, import_price:3000})
Product.create({product_code:'1234567890060', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_15gr_360.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie4',  import_quality:500, available_quality:500, instock_quality:500, import_price:3000})
Product.create({product_code:'1234567890061', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_50gr_200.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie1',  import_quality:500, available_quality:500, instock_quality:500, import_price:7000})
Product.create({product_code:'1234567890062', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_50gr_200.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie2',  import_quality:500, available_quality:500, instock_quality:500, import_price:7000})
Product.create({product_code:'1234567890063', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_50gr_200.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie3 ',  import_quality:500, available_quality:500, instock_quality:500, import_price:7000})
Product.create({product_code:'1234567890064', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_50gr_200.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie4',  import_quality:500, available_quality:500, instock_quality:500, import_price:7000})
Product.create({product_code:'1234567890065', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie1',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890066', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie2',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890067', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie3 ',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890068', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_200gr_56.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'Tankie4',  import_quality:500, available_quality:500, instock_quality:500, import_price:25000})
Product.create({product_code:'1234567890069', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_800gr_25.id, provider_id: provider_hcm_q1.id, warehouse_id: new_import.warehouse_id, import_id:new_import.id, name:'VIỆT LONG ( Giá net )',  import_quality:500, available_quality:500, instock_quality:500, import_price:80000})

sonTempImport = TempImport.create({warehouse_id: khoHcm.id, merchant_account_id: son_mer_acc.id, description: 'Nhập kho bổ sung đợt 2?'})
TempImportDetail.create({product_summary_id: ProductSummary.find_by_product_code('1234567890038').id, merchant_account_id: son_mer_acc.id, provider_id: provider_hcm_q1.id})


importDT = Import.create({warehouse_id:khoDongThap.id, merchant_account_id:loc_mer_acc.id, name:'Nhập Kho Lần Đầu 2014', description:'Nhập Đầu Năm'})
Product.create({product_code:'1234567890045', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_2kg_10.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Tata 25WG',  import_quality:500, available_quality:500, instock_quality:500, import_price:11000})
Product.create({product_code:'1234567890046', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Vicidi-M 50ND',  import_quality:500, available_quality:500, instock_quality:500, import_price:34000})
Product.create({product_code:'1234567890047', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Decis 250WDG',  import_quality:500, available_quality:500, instock_quality:500, import_price:35500})
Product.create({product_code:'1234567890048', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Alfamite 15EC',  import_quality:500, available_quality:500, instock_quality:500, import_price:31500})
Product.create({product_code:'1234567890049', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'SK Enpray 99EC',  import_quality:500, available_quality:500, instock_quality:500, import_price:18500})
Product.create({product_code:'1234567890050', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Padan 95SP',  import_quality:500, available_quality:500, instock_quality:500, import_price:60500})
Product.create({product_code:'1234567890051', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Oncol 20EC',  import_quality:500, available_quality:500, instock_quality:500, import_price:28700})
Product.create({product_code:'1234567890052', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_10gr_300.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Viroval 50BTN',  import_quality:500, available_quality:500, instock_quality:500, import_price:10000})
Product.create({product_code:'1234567890053', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_lo_100gr_50.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Viben – C',  import_quality:500, available_quality:500, instock_quality:500, import_price:34000})
Product.create({product_code:'1234567890054', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_1kg_20.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Vimoca 10G',  import_quality:500, available_quality:500, instock_quality:500, import_price:83500})
Product.create({product_code:'1234567890055', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_1kg_20.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Vifuran 3G',  import_quality:500, available_quality:500, instock_quality:500, import_price:29500})
Product.create({product_code:'1234567890056', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_1kg_20.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT.warehouse_id, import_id: importDT.id, name:'Vibasu 10H',  import_quality:500, available_quality:500, instock_quality:500, import_price:36500})

importDT2 = Import.create({warehouse_id:khoDongThap.id, merchant_account_id:son_mer_acc.id, name:'Nhập Kho Lần Đầu 2014 (Bổ sung)', description:'Nhập Đầu Năm 2014'})
Product.create({product_code:'1234567890045', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_goi_2kg_10.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT2.warehouse_id, import_id: importDT2.id, name:'Tata 25WG',  import_quality:500, available_quality:500, instock_quality:500, import_price:12000})
Product.create({product_code:'1234567890046', merchant_account_id: loc_mer_acc.account_id, skull_id:skull_chai_100ml_30.id, provider_id: provider_hcm_q1.id, warehouse_id: importDT2.warehouse_id, import_id: importDT2.id, name:'Vicidi-M 50ND',  import_quality:500, available_quality:500, instock_quality:500, import_price:35000})
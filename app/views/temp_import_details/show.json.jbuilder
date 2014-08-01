json.(@temp_import_detail, :id, :import_quality)

json.product do |json|
  json.(@temp_import_detail.product_summary, :id, :name)
end
#
# json.comments @article.comments do |json, comment|
#   json.partial! comment
# end
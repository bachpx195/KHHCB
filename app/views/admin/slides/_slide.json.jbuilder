json.extract! slide, :id, :name, :image, :description, :url, :status, :created_at, :updated_at
json.url slide_url(slide, format: :json)
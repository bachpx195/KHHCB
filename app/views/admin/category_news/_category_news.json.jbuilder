json.extract! category_news, :id, :name, :description, :created_at, :updated_at
json.url category_news_url(category_news, format: :json)
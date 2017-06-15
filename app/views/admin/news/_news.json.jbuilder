json.extract! news, :id, :category_news_id, :title, :image, :description, :content, :created_at, :updated_at
json.url news_url(news, format: :json)
json.extract! virtual_user, :id, :last_name, :first_name, :gender, :email, :civ_style, :created_at, :updated_at
json.url virtual_user_url(virtual_user, format: :json)

User.new(
  :name => 'admin',
  :email => 'admin@example.com', 
  :created_at => Date.today, 
  :updated_at => Date.today,
  :password_digest => ->(string) {
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  }.call('passworld1!'),
  :admin => true
).save!(validate: false)


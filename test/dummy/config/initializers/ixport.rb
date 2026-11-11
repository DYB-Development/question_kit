Ixport.configure do |config|
  config.authentication_method = :require_a_customer
  config.current_person_method = :current_customer
  config.current_account_method = :current_customer
end

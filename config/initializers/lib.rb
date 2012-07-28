
Dir[Rails.root+'lib'+'ext'+'*.rb'].each do |file|
  require file
end

Fabricator(:easy_admin) do
  email "esteban@easypeasyapp.com"
  password "Password1"
  confirmed_at { Time.now }
end

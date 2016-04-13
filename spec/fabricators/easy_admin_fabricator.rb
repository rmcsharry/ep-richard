Fabricator(:easy_admin) do
  email "bsafwat@gmail.com"
  password "Password1"
  confirmed_at { Time.now }
end

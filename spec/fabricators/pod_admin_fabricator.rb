Fabricator(:pod_admin) do
  email "esteban+podadmin@easypeasyapp.com"
  password "Password2"
  confirmed_at { Time.now }
  preferred_name "basil"
  pod
end

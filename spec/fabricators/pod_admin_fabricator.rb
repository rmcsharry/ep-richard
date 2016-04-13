Fabricator(:pod_admin) do
  email "bsafwat+podadmin@gmail.com"
  password "Password2"
  confirmed_at { Time.now }
  pod
end

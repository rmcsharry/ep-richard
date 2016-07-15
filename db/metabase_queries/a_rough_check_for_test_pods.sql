select * from pods
where is_test is false and
lower(name)like '%test%' or lower(name) like '%demo%'
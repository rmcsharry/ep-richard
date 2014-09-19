live_pods = Pod.where("go_live_date IS NOT null")

live_pods.each do |pod|
  pod.parents.each do |parent|
    parent.notify
  end
end

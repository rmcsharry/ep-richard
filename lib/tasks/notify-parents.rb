puts "\n== Starting notify job #{Time.now}\n\n"

live_pods = Pod.where("go_live_date IS NOT null")

live_pods.each do |pod|

  puts "  Pod ##{pod.id}: #{pod.name} \n\n"

  pod.parents.each do |parent|
    if parent.notify
      puts "  - SENT WELCOME SMS: #{parent.name} (#{parent.phone}) "
    else
      puts "  - SKIPPED WELCOME SMS: #{parent.name} (#{parent.phone}) "
    end
  
    puts "\n"
  end

end

puts "== Finished notify job #{Time.now}\n\n"

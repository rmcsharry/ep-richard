puts "\n== Starting notify job #{Time.now}\n\n"

live_pods = Pod.where("go_live_date IS NOT null")

live_pods.each do |pod|

  puts "  Pod ##{pod.id}: #{pod.name}\n\n"

  pod.parents.each do |parent|
    if parent.notify
      puts "  - NOTIFIED: #{parent.name} (#{parent.phone})"
    else
      puts "  - SKIPPED: #{parent.name} (#{parent.phone})"
    end
  end

  puts "\n"

end

puts "== Finished notify job #{Time.now}\n\n"

puts "\n== Starting notify job #{Time.now}\n\n"

live_pods = Pod.where("go_live_date IS NOT null")

live_pods.each do |pod|

  puts "  Pod ##{pod.id}: #{pod.name} - Extra SMS \n\n"

  pod.parents.each do |parent|
    if parent.send_did_you_know_fact
      puts "  - SENT DID YOU KNOW FACT: #{parent.name} (#{parent.phone})"
    else
      puts "  - SKIPPED DID YOU KNOW FACT: #{parent.name} (#{parent.phone})"
    end
  
    if parent.send_top_tip
      puts "  - SENT TOP TIP: #{parent.name} (#{parent.phone})"
    else
      puts "  - SKIPPED TOP TIP: #{parent.name} (#{parent.phone})"
    end
  
    puts "\n"
  end

end

puts "== Finished notify job #{Time.now}\n\n"

# lib/tasks/migrate_topics.rake
desc 'Split top tip and did you know fact from game instructions to new fields'
task split_instructions: :environment do
  log = ActiveSupport::Logger.new('log/split_instructions.log')

  log.info "Task started at #{Time.now} for #{Game.count} games"
  
  game1 = Game.find_by_name("Treasure Hunt")
  if game1
    log.info "Fixing instructions for game #{game1.name} first"
    
    game1.instructions = "#Did you know?\r\n**Patience** and **determination** are two of the most important skills for your child to learn.\r\n\r\n#How to play
1. **Find** some 'treasure' (small, briht things, or treats).\r\n
2. **Explain** to your child that they are going on a treasure hunt. \r\n
3. **To play**, your child needs to wait in another room while you hide the items\r\n
4. **Once you've finished**, your little one can start searching. \r\n\r\n
Encourage them to keep going until they find all the treasure!\r\n\r\n#Top tip\r\nTo help your child with harder-to-find items you can call out 'hotter' as your child gets closer, or 'colder' as they move farther away."
    game1.save!
  else
    log.info "ERROR: Cannot find game Treasure Hunt"
  end
  
  counter = 0
  Game.all.each do |game|
    counter += 1
    instructions = game.instructions
    newline = "\r\n"
    start_pos = instructions.index(newline) + 2
    end_pos = instructions.index(newline, start_pos) - 1
    did_you_know = instructions[start_pos..end_pos].squish
    instructions = instructions[(end_pos+1)..-1]
    
    # unable to extract the fact for this game due to formatting, so hard-code it
    if game.name == "Band Practice"
      did_you_know = "Making music together is a great way to build listening and concentration skills in your child, and help them express themselves."
    end

    log.info newline
    log.info "Game #{counter} with id:#{game.id} - #{game.name}"
    log.info "Did you know fact extracted:"
    log.info "#{did_you_know}\n"
    
    top_tip_pos = instructions.downcase.index("top tip") + 9
    top_tip = instructions[top_tip_pos..-1].squish
    instructions = instructions[0..(top_tip_pos-1)]
    
    log.info "Top tip fact extracted:"
    log.info "#{top_tip}\n"

    start_pos = instructions.index("#How to")
    instructions = instructions[start_pos..-14]        
    log.info "Final instructions extracted:"
    log.info "#{instructions}"

    game.did_you_know_fact = did_you_know
    game.top_tip = top_tip
    game.instructions = instructions
    if game.save
      log.info "*** GAME SUCCESSFULLY UPDATED ***\n"
    else
      log.info "*** GAME UPDATE FAILED ***\n#{game.errors.full_messages}\n"
    end
           
  end    
end
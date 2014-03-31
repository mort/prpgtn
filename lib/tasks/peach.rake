namespace :peach do
  
  task :engage_robotos => :environment do
  
    robotos = Roboto.find_rand
    
    puts "Engaging #{robotos.size} robotos ..."
    
    robotos.each {|roboto| 
      puts "- Engaging #{roboto.name}"
      roboto.bootup 
    }
  
  end
  
  
end
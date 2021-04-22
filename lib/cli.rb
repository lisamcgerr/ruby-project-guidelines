require "pry"
require 'ruby2d'


class CLI 

    def user_input
        gets.chomp
    end

    def self.quit
        system "clear"
        exit!
    end 


    def run
        Sound.new('dundundun.wav').play
        clear_screen
        puts ""
        puts " FEDERAL BUREAU OF INVESTIVATIONS ".blue.bold.center(120, "*")
        puts ""
        sleep(3)
        puts "You are now entering the FBI's 50 most wanted database".underline.center(115) 
        puts ""
        sleep(2)
        puts "⛔️ Unauthorized entry prohibited ⛔️".center(100).red
        puts "             Violators will be prosecuted".italic.center(100).red
        sleep (2)
        puts ""
        main_menu
    end 

    def main_menu
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Access Records'
            menu.choice 'Update Records'
            menu.choice 'Create New Records'
            menu.choice 'Delete Records'
            menu.choice 'Exit' 
        end 
        
        case my_menu
        when "Access Records" 
            access_records
        when "Update Records"
            update_records
        when "Create New Records"
            create_new_records
        when "Delete Records"
            delete_records
        when "Exit"
            CLI.quit
        end
    end


    def access_records
        clear_screen

        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Access Fugitive Data'
            menu.choice 'Access Crime Data'
            menu.choice 'Main Menu'
            menu.choice 'Exit'
        end 
       
        case my_menu
        when "Access Fugitive Data"
            fugitive_data
        when "Access Crime Data"
            crime_data
        when "Main Menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 

    end 

    
    def fugitive_data
        clear_screen
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Find by name'
            menu.choice 'Find by location'
            menu.choice 'Find by ID'
            menu.choice 'Data analysis'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Find by name"
            print "Enter name: "
            input = user_input
            found_fugitive = Fugitive.find_by(name: input.upcase)
            if !found_fugitive 
                clear_screen
                puts "Fugitive not found, verify spelling."
                puts ""
                sleep (0.5)
                main_menu
            else
                clear_screen
                puts ""
                puts "Fugitive record ID #{found_fugitive.id} was located:"
                puts ""
                found_fugitive.print_data
                puts ""
                sleep (0.5)
                main_menu
            end

        when "Find by location"
            clear_screen
            print "Enter location: "
            input = user_input
            found_city = City.find_by(name: input.downcase.gsub(/\s/,""))
            if !found_city
                clear_screen
                puts "City not found, verify spelling."
                puts ""
                sleep (0.5)
                main_menu
            else 
                clear_screen
                puts ""
                puts "The following records were located:"
                puts ""
                found_fugitives = found_city.fugitives
                found_fugitives.map {|fugitive| fugitive.print_data}
                puts ""
                sleep (0.5)
                main_menu
            end   
        when "Find by ID"
            clear_screen
            puts "Enter ID to locate fugitive records:"
            input = user_input.strip.to_i
            entry = Fugitive.find_by(id: input)
            if !entry
                puts ""
                puts "Fugitive not located"
                puts ""
                sleep (0.5)
                main_menu
            else 
                clear_screen
                puts "Fugitive ID #{entry.id} was located:"
                puts ""
                sleep (0.75)
                entry.print_data
                puts ""
                sleep (0.5)
                main_menu
            end 



        when "Data analysis"
            analyze_fugitive_data
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end
    end

    def analyze_fugitive_data
        clear_screen

        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Oldest fugitive'
            menu.choice 'Youngest fugitive'
            menu.choice 'Average age'
            menu.choice 'Most common hair color'
            menu.choice 'Most wanted'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        clear_screen

        case my_menu
        when "Oldest fugitive"
            puts "The oldest fugitive currently in our database is: "
            puts ""
            Fugitive.oldest_fugitive.print_data      
            puts ""
            sleep (0.5)
            main_menu
        when "Youngest fugitive"
            puts "The youngest fugitive currently in our database is fugitive ID #{Fugitive.youngest_fugitive.id}: "
            puts ""
            Fugitive.youngest_fugitive.print_data      
            puts ""
            sleep (0.5)
            main_menu
        when "Average age"
            puts "The average age of the fugitives in our database is #{Fugitive.average_age}."
            puts ""
            sleep (0.5)
            main_menu
        when "Most common hair color"
            puts "The most common hair color for fugitives in our database is: #{Fugitive.most_common_hair_color}."
            puts ""
            sleep (0.5)
            main_menu
        when "Most wanted"
            puts "The most wanted fugitive in our database is: "
            puts ""
            Fugitive.all.first.print_data
            puts ""
            sleep (0.5)
            main_menu
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end
    end 



    def crime_data
        clear_screen

        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Find by fugitive'
            menu.choice 'Find by city'
            menu.choice 'Find by ID'
            menu.choice 'Most common location'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Find by fugitive"
            puts ""
            print "Enter name: "
            input = user_input
            found_fugitive = Fugitive.find_by(name: input.upcase)
            if !found_fugitive 
                puts "Fugitive not found, verify spelling."
                puts ""
                sleep (0.5)
                main_menu
            else
                puts "#{input} is wanted for the following crimes:"
                found_crimes = Crime.all.select {|crime| crime.fugitive_id == found_fugitive.id}
                found_crimes.map {|crime| crime.print_data}
                puts ""
                sleep (0.5)
                main_menu
            end
        when "Find by city" 
            puts ""
            print "Enter city name: "
            input = user_input
            found_city = City.find_by(name: input.downcase.gsub(/\s/,""))
            if !found_city 
                puts ""
                puts "City not found, verify spelling."
                puts ""
                sleep (0.5)
                main_menu
            else
                found_crimes = Crime.all.select {|crime| crime.city_id == found_city.id}
                puts ""
                puts "There were a total of #{found_crimes.count} found in #{input}:"
                puts ""
                found_crimes.map {|crime| crime.print_data}
                puts ""
                sleep (0.5)
                main_menu
            end
        when 'Find by ID'
            clear_screen
            puts "Enter crime ID to locate crime record: "
            input = user_input.strip.to_i
            entry = Crime.find_by(id: input)
            if !entry
                puts ""
                puts "Crime not located"
                puts ""
                sleep (0.5)
                main_menu
            else 
                clear_screen
                puts "Crime ID #{entry.id} was located: "
                puts ""
                sleep (0.75)
                entry.print_data
                puts ""
                sleep (0.5)
                main_menu
            end
        when "Most common location"
            puts ""
            puts "The most common location where crimes in our databased have occured is #{Crime.most_common_location.capitalize()}."
            puts ""
            sleep (0.5)
            main_menu
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 

    end

   
    def update_records
        clear_screen
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Update fugitive data'
            menu.choice 'Update crime data'
            menu.choice 'Update city data'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end 
        clear_screen
        case my_menu
        when "Update fugitive data"
            update_fugitive
        when "Update crime data"
            update_crime        
        when "Update city data"
            update_city
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 

    end 

    def update_fugitive
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Locate fugitive record by:") do |menu|
            menu.choice 'Name'
            menu.choice 'Id'
        end 
        
        case my_menu
        when "Name" 
            puts ""
            print "Enter name to locate fugitive record: "
            input = user_input.upcase
            entry = Fugitive.find_by(name: input)
        when "Id"
            puts ""
            print "Enter ID to locate fugitive record: "
            input = user_input.strip.to_i
            entry = Fugitive.find_by(id: input)
        end

        if !entry 
            puts ""
            puts "Fugitive not located."
            puts ""
            sleep (0.5)
            main_menu
        else 
            clear_screen
            puts ""
            entry.print_data
            puts ""
            prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
            update_menu = prompt.select("Select category to update:") do |menu|
                menu.choice 'Name'
                menu.choice 'Alias'
                menu.choice 'Age'
                menu.choice 'Hair color'
                menu.choice 'Eye color'
                menu.choice 'At large?'
                menu.choice 'Gender'
                menu.choice 'Warning'
                menu.choice 'Scars and marks'
                menu.choice 'Main menu'
                menu.choice 'Exit'
            end

            case update_menu
            when 'Name'
                puts ""
                puts "Fugitive name was previously recorded as #{entry.name}."
                puts ''
                print "Enter new name: "
                input = user_input.upcase
                entry.update(name: input)
                puts ''
                puts "Name has been updated to #{entry.name}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Alias'
                puts ''
                puts "Fugitive alias was previously recorded as #{entry.alias}."
                puts ''
                print "Enter an additional alias: "
                input = user_input.downcase
                aliases = "#{entry.alias}, #{input}."
                entry.update(alias: aliases)
                puts ''
                puts "Alias has been updated to #{entry.alias}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Age'
                puts ''
                puts "Fugitive age was previously recorded as #{entry.age}."
                puts ''
                print "Enter new age: "
                input = user_input.to_i
                entry.update(age: input)
                puts ''
                puts "Age has been updated to #{entry.age}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Hair color'
                puts ''
                puts "Fugitive hair color was previously recorded as #{entry.hair_color}."
                puts ''
                print "Enter new hair color: "
                input = user_input.downcase
                entry.update(hair_color: input)
                puts ''
                puts "Hair color has been updated to #{entry.hair_color}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Eye color'
                puts ''
                puts "Fugitive's eye color was previously recorded as #{entry.eye_color}."
                puts ''
                print "Enter new eye color: "
                input = user_input.downcase.capitalize()
                entry.update(eye_color: input)
                puts ''
                puts "Eye color has been updated to #{entry.eye_color}."
                puts ""
                sleep (0.5)
                main_menu
            when 'At large?'
                puts ''
                if entry.at_large == true
                    puts "Fugitive is still at large." 
                    puts ''
                    puts "     Type 1 to update fugitive status to captured."
                    puts "     Type 2 to confirm status still at large."
                    input = gets.chomp.strip.to_i
                    if input == 1 
                        entry.update(at_large: false)
                        puts "Fugitive has been captured. "
                        puts ""
                        sleep (0.5)
                        main_menu
                        #animation
                    elsif input == 2
                        entry.update(at_large: true)
                        # Sound.new('dundundun.wav').play
                        puts "Fugitive is still at large."
                        #animation
                        puts ""
                        sleep (0.5)
                        main_menu
                    else
                        puts "Invalid selection. "
                        puts ""
                        sleep (0.5)
                        main_menu
                    end     
            elsif entry.at_large == false
                    puts "Fugitive status is captured." 
                    puts ''
                    puts "     Type 1 to update fugitive status to at large."
                    puts "     Type 2 to confirm status still captured."
                    input = gets.chomp.strip.to_i
                    if input == 1 
                        entry.update(at_large: true)
                        # Sound.new('dundundun.wav').play
                        puts "Fugitive status has been updated to at large."
                        puts ""
                        sleep (0.5)
                        main_menu
                    elsif input == 2
                        entry.update(at_large: false)
                        puts "Fugitive status captured is confirmed"
                        puts ""
                        sleep (0.5)
                        main_menu
                        #animation
                    else
                        puts "Invalid selection. "
                        puts ""
                        sleep (0.5)
                        main_menu
                    end     
                end
                
            when 'Gender'
                puts ''
                puts "Fugitive gender was previously recorded as #{entry.gender}."
                puts ''
                print "Enter new gender: "
                input = user_input.downcase.capitalize()
                entry.update(gender: input)
                puts ''
                puts "Gender has been updated to #{entry.gender}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Warning'
                puts ''
                puts "Fugitive warning was previously recorded as #{entry.warning}."
                puts ''
                print "Enter new warning: "
                input = user_input.upcase
                entry.update(warning: input)
                puts ''
                puts "Warning has been updated to #{entry.warning}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Scars and marks'
                puts ''
                puts "Fugitive scars and marks were previously recorded as #{entry.scars_and_marks}."
                puts ''
                print "Enter additional scars and marks: "
                input = user_input.downcase
                scars = "#{entry.scars_and_marks}, #{input}."
                entry.update(scars_and_marks: scars)
                puts ''
                puts "Scars and marks have been updated to #{entry.scars_and_marks}"
                puts ""
                sleep (0.5)
                main_menu
            when 'Main menu'
                clear_screen
                main_menu
            when "Exit"
                CLI.quit
            end 
        
        end 

     end 



    def update_crime
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Locate crime record by:") do |menu|
            menu.choice 'Crime ID'
            menu.choice 'Fugitive ID'
            menu.choice 'Main menu'
        end 

        case my_menu
        when "Crime ID" 
            puts ""
            print "Enter crime ID to locate crime record: "
            input = user_input.strip.to_i
            entry = Crime.find_by(id: input)
            if !entry 
                puts ""
                puts "Crime not located. Select from the following options:"
                puts ""
                sleep (0.5)
                update_crime

            else 
            puts ""
            puts "Crime located, crime ID: #{entry.id}"
            puts ""
            entry.print_data
            puts ""
            prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
            update_menu = prompt.select("Select category to update:") do |menu|
                menu.choice 'Description'
                menu.choice 'Subject'
                menu.choice 'Reward'
                menu.choice 'Main menu'
                menu.choice 'Exit'
            end
        end 
            case update_menu
            when 'Description'
                puts ""
                puts "Crime description was previously recorded as #{entry.description}."
                puts ''
                print "Enter new crime description: "
                input = user_input.downcase.capitalize()
                entry.update(description: input)
                puts ''
                puts "Description has been updated to #{entry.description}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Subject'
                puts ""
                puts "Crime subject was previously recorded as #{entry.subject}."
                puts ''
                print "Enter new crime subject: "
                input = user_input.downcase.capitalize()
                entry.update(subject: input)
                puts ''
                puts "Subject has been updated to #{entry.subject}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Reward'
                puts ""
                puts "Crime reward was previously recorded as #{entry.reward}."
                puts ''
                print "Enter new crime reward: "
                input = user_input.downcase.capitalize()
                entry.update(reward: input)
                puts ''
                puts "Reward has been updated to #{entry.reward}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Main menu'
                clear_screen
                main_menu
            when "Exit"
                CLI.quit
            end     

        when "Fugitive ID"
            puts ""
            print "Enter fugitive ID to locate city record: "
            input = user_input.strip.to_i
            entry = Crime.find_by(fugitive_id: input)
            if !entry 
                puts ""
                puts "Crime not located. Select from the following options:"

                update_crime
            else 
                puts ""
                puts "Crime located, crime ID: #{entry.id}"
                puts ""
                entry.print_data
                puts ""
                prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
                update_menu = prompt.select("Select category to update:") do |menu|
                    menu.choice 'Description'
                    menu.choice 'Subject'
                    menu.choice 'Reward'
                    menu.choice 'Main menu'
                    menu.choice 'Exit'
                end
            end 
                case update_menu
                when 'Description'
                    puts ""
                    puts "Crime description was previously recorded as #{entry.description}."
                    puts ''
                    print "Enter new crime description: "
                    input = user_input.downcase.capitalize()
                    entry.update(description: input)
                    puts ''
                    puts "Description has been updated to #{entry.description}."
                    puts ""
                    sleep (0.5)
                    main_menu
                when 'Subject'
                    puts ""
                    puts "Crime subject was previously recorded as #{entry.subject}."
                    puts ''
                    print "Enter new crime subject: "
                    input = user_input.downcase.capitalize()
                    entry.update(subject: input)
                    puts ''
                    puts "Subject has been updated to #{entry.subject}."
                    puts ""
                    sleep (0.5)
                    main_menu
                when 'Reward'
                    puts ""
                    puts "Crime reward was previously recorded as #{entry.reward}."
                    puts ''
                    print "Enter new crime reward: "
                    input = user_input.downcase.capitalize()
                    entry.update(reward: input)
                    puts ''
                    puts "Reward has been updated to #{entry.reward}."
                    puts ""
                    sleep (0.5)
                    main_menu
                when 'Main menu'
                    clear_screen
                    main_menu
                when "Exit"
                    CLI.quit
                end     
        when 'Main menu'
            main_menu
        end
    end 

    def update_city
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Locate city record by:") do |menu|
            menu.choice 'Name'
            menu.choice 'ID'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end 
        
        case my_menu
        when "Name" 
            puts ""
            print "Enter name to locate city record: "
            input = user_input.downcase.gsub(/\s/,"")
            entry = City.find_by(name: input)
        when "ID"
            puts ""
            print "Enter ID to locate city record: "
            input = user_input.strip.to_i
            entry = City.find_by(id: input)
        when 'Main menu'
            main_menu
        when 'Exit'
            CLI.quit
        end

        if !entry 
            puts ""
            puts "City not located."
            puts ""
            sleep (0.5)
            main_menu
        else 
            puts ""
            entry.name.capitalize()
            puts ""
            prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
            update_menu = prompt.select("Select category to update:") do |menu|
                menu.choice 'Name'
                menu.choice 'Main menu'
                menu.choice 'Exit'
            end

            case update_menu
            when 'Name'
                puts ""
                puts "City name was previously recorded as #{entry.name}."
                puts ''
                print "Enter new city name: "
                input = user_input.downcase.gsub(/\s/,"")
                entry.update(name: input)
                puts ''
                puts "Name has been updated to #{entry.name}."
                puts ""
                sleep (0.5)
                main_menu
            when 'Main menu'
                clear_screen
                main_menu
            when "Exit"
                CLI.quit
            end 

        end 
                
    end
 


    def create_new_records
        clear_screen

        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Add fugitive'
            menu.choice 'Add crime'
            menu.choice 'Add city'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Add fugitive"
            new_fugitive
        when "Add crime"
            new_crime
        when "Add city"
            new_city
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 
    end 

    def new_fugitive
        clear_screen
        fugitive_new = Fugitive.new
        puts "Enter fugitive name: "
        fugitive_new.name = gets.chomp.upcase
        puts "Enter fugitive alias: "
        fugitive_new.alias = gets.chomp
        puts "Enter fugitive age: "
        fugitive_new.age = gets.chomp.to_i
        puts "Enter fugitive hair color: "
        fugitive_new.hair_color = gets.chomp.downcase
        puts "Enter fugitive eye color: "
        fugitive_new.eye_color = gets.chomp.downcase.capitalize()
        fugitive_new.at_large = true
        puts "Enter fugitive gender: "
        fugitive_new.gender = gets.chomp.downcase.capitalize()
        puts "Enter fugitive warning: "
        fugitive_new.warning = gets.chomp.upcase
        puts "Enter fugitive scars and marks: "
        fugitive_new.scars_and_marks = gets.chomp.downcase.capitalize()

        fugitive_new.save
        # Sound.new('dundundun.wav').play
        clear_screen
        puts "Fugitive has been saved to database, fugitive_id is : #{fugitive_new.id}. "
        puts ""
        sleep (0.5)
        fugitive_new.print_data
        sleep (0.5)
        main_menu
    end 

    def new_crime
        clear_screen
        crime_new = Crime.new
        puts "Enter fugitive ID: "
        crime_new.fugitive_id = gets.chomp.strip.to_i
        puts "Enter city ID: "
        crime_new.city_id = gets.chomp.strip.to_i
        puts "Enter description: "
        crime_new.description = gets.chomp
        puts "Enter subject: "
        crime_new.subject = gets.chomp
        puts "Enter reward: "
        crime_new.reward = gets.chomp

        crime_new.save
        # Sound.new('dundundun.wav').play
        clear_screen
        puts "Crime has been saved to database, crime_id is : #{crime_new.id}."
        puts ""
        sleep (0.5)
        crime_new.print_data
        puts ""
        sleep (0.5)
        main_menu
        
        
    end 

    def new_city
        clear_screen
        city_new = City.find_or_create_by(name: gets.chomp.downcase.gsub(/\s+/, ""))
        puts "City_id is #{city_new.id}. "
        puts ""
        sleep (0.5)
        main_menu
    end 

    def delete_records
        clear_screen
        
        prompt = TTY::Prompt.new(active_color: :blue, symbols: {marker: "✪".red})
        my_menu = prompt.select("Please select from the following options:") do |menu|
            menu.choice 'Delete fugitive'
            menu.choice 'Delete crime'
            menu.choice 'Delete city'
            menu.choice 'Main menu'
            menu.choice 'Exit'
        end

        case my_menu
        when "Delete fugitive"
            delete_fugitive
        when "Delete crime"
            delete_crime
        when "Delete city"
            delete_city
        when "Main menu"
            clear_screen
            main_menu
        when "Exit"
            CLI.quit
        end 
    end 

    def delete_fugitive
        puts "Enter fugitive ID to remove fugitive from database: "
        input = gets.chomp.strip.to_i
        Fugitive.all.find_by(id: input).destroy
        puts "This fugitive has been removed from the database. "
        puts ""
        sleep (0.5)
        main_menu
    end 

    def delete_crime
        puts "Enter crime ID to remove from crime from database: "
        input = gets.chomp.strip.to_i
        puts ""
        puts "The following crime has been removed from the database: "
        puts ""
        Crime.all.find_by(id: input).print_data
        Crime.all.find_by(id: input).destroy
        puts ""
        sleep (0.5)
        main_menu
    end 

    def delete_city
        puts "Enter city_id to remove from city from database: "
        input = gets.chomp.strip.to_i
        sleep (0.5)
        puts ""
        puts "The following record was removed from the database: "
        puts ""
        City.all.find_by(id: input).print_data
        City.all.find_by(id: input).destroy
        puts ""
        #puts ""
        sleep (0.5)
        main_menu
    end

    def clear_screen
        system "clear"
    end

end 
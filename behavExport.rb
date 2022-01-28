require 'Datavyu_API.rb'

begin
    
    project_dir ="~/Documents/Hana/behavExtract/" 

    input_dir = project_dir + "data_in/"
    output_dir = project_dir + "data_out/"    

    filedir = File.expand_path(input_dir)
    filenames = Dir.new(filedir).entries

    for file in filenames
        if file.include?(".opf") and file[0].chr != '.'
        
        filename = File.basename(file, ".opf")
        outname = filename + ".txt"

        puts "Loading: " + filename
        $db,proj = load_db(filedir+file)
        puts "Loaded"


    
        end
    end

end
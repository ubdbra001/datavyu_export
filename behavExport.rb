require 'Datavyu_API.rb'

begin
    ## This needs editing to point to the correct dir
    project_dir ="~/Documents/Hana/behavExtract/"

    frame_gap = 40
    outfile_type = ".csv"


    input_dir = File.expand_path(project_dir + "data_in/")
    output_dir = File.expand_path(project_dir + "data_out/")   
       

    filenames = Dir.new(input_dir).entries

    for file in filenames
        # Skip files that are not opf or are hidden
        if !file.include?(".opf") or file[0].chr == '.'
            next
        end
        
        # Generate full file path 
        fullfile = File.join(input_dir, file)

        # Extract filename
        filename = File.basename(file, ".opf")
        
        # Generate outname and path
        outname = filename + outfile_type
        outpath = File.join(output_dir, outname)

        # Load the data
        puts "Loading: " + fullfile
        $db,proj = load_db(fullfile)
        puts "Loaded file"


    end

end
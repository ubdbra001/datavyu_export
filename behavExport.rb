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

        column_list = getColumnList()
        columns = Array.new

        puts "Building header..."
        header = Array.new
        for col in column_list
          col = getVariable(col)
          args = col.arglist
          header << col.name + ".ordinal"
          header << col.name + ".onset"
          header << col.name + ".offset"
          header += args.collect { |arg| col.name + "." + arg }
          columns << col
        end
    
        # Get min and max times
        puts "Getting the minimum and maximium times for the files..."
        min = 99999999999999
        max = 0
        for col in columns
          if col.cells.length > 0
            lmin = col.cells[0].onset
            lmax = col.cells[col.cells.length-1].offset
            if lmin < min
              min = lmin
            end
            if lmax > max
              max = lmax
            end
          end
        end
    
        # Now go from min to max time in 40ms intervals, getting the cell value at each time
        puts "Getting the data for each time point..."
        time = min
        i = 0
        total_i = (max - min) / frame_gap
        output = "time" + ',' + header.join(',') + "\n"
        while time <= max
          output += time.to_s + ','
          for col in columns
            cell = getCellFromTime(col, time)
            if cell != nil
              data = printCellArgs(cell)
              #puts data
            else
              data = [''] * (col.arglist.length + 3)
            end
            output += data.join(',') + ','
          end
          output += "\n"
          time += frame_gap
          i += 1
          if i % 1000 == 0
            puts "On row " + i.to_s + " out of " + total_i.to_s
          end
        end
    
        puts "Completed building data.  Writing to file " + outname
        fo = File.new(outpath, 'a')
        fo.write(output)
        fo.flush()
        fo.close()
        puts "Finished" + filename


    end

end
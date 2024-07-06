#Last modified by Taylor Stone
#Last modified July 9

require_relative 'Datavyu_API.rb'

begin
	#change this directory if the path changes
filedir = File.expand_path("/Users/lafayettekidslab/Desktop/VideoChatReading/TV")
filedir2 = File.expand_path("/Users/lafayettekidslab/Desktop/VideoChatReading/AM")
#filedir2 = second location where the script will put the exports

	#change these for the two coders to compare
	#make a folder for each coder with files ending in their initials (8_IW.opf)
	coder_1_dir = filedir
	coder_1_suffix = "_TV"
	coder_2_dir = filedir2
	coder_2_suffix = "_AM"

	coder_1_files = Dir.glob(coder_1_dir + '/*.opf')
	coder_2_files = Dir.glob(coder_2_dir + '/*.opf')

	csv_file = File.expand_path(filedir2 + coder_1_suffix + coder_2_suffix + "_" + DateTime.now.strftime('%m-%d-%Y') + ".csv")
	csv = File.new(csv_file, 'w')
	csv.write("id,initiator1,initiator2,response1,response2,environment1,environment2\n")

	for coder_1 in coder_1_files
		# get the codenumber, which is the filename without the ending
		codenumber = File.basename(coder_1, coder_1_suffix + ".opf")
		# find the corresponding file for coder 2
		coder_2_index = coder_2_files.index {|file| file.include? codenumber }
		if coder_2_index.nil?
			puts "Can't find file " + coder_1 + " for coder 2"
			next
		end

		coder_2 = coder_2_files[coder_2_index]

		# get gesture and connection data for coder 1
		puts "LOADING DATABASE: " + coder_1
		$db,proj = load_db(coder_1)
		puts "SUCCESSFULLY LOADED"

		jva_paired1 = getColumn("jva_paired")

		# get gesture and connection data for coder 2
		puts "LOADING DATABASE 2: " + coder_2
		$db,proj = load_db(coder_2)
		puts "SUCCESSFULLY LOADED"

		jva_paired2 = getColumn("jva_paired")

		#write the data as a new row in the csv file

		jva_paired1.cells.each_with_index do |initiator, index|
			# write the codenumber on the first line for each subject
			if index == 0
				csv.write(codenumber)
			end

			initiator1 = (jva_paired1.cells[index].nil? ? "" : jva_paired1.cells[index].initiator.to_s.tr(",", ";"))
			initiator2 = (jva_paired2.cells[index].nil? ? "" : jva_paired2.cells[index].initiator.to_s.tr(",", ";"))
			response1 = (jva_paired1.cells[index].nil? ? "" : jva_paired1.cells[index].response.to_s.tr(",", ";"))
			response2 = (jva_paired2.cells[index].nil? ? "" : jva_paired2.cells[index].response.to_s.tr(",", ";"))
			environment1 = (jva_paired1.cells[index].nil? ? "" : jva_paired1.cells[index].environment.to_s.tr(",", ";"))
			environment2 = (jva_paired2.cells[index].nil? ? "" : jva_paired2.cells[index].environment.to_s.tr(",", ";"))
			

			csv.write( "," + initiator1 + "," + initiator2 + "," + response1 + "," + response2 + "," + environment1 + "," + environment2 + "\n")
		end
	end

end

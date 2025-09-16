#to check if the user provided a path when executing otherwise it will exit with error code 1
if { [llength $argv] < 1} {
    puts "Error! Please provide the directory path."
    exit 1
}

#here we take the path provided by the user and assign dir_path with its value
set dir_path [lindex $argv 0]

#we need to check if the provided path is indeed a directory and if not we exit with error code 1
if { ![file isdirectory $dir_path]} {
    puts "Error, not a valid directory."
    exit 1
}

puts "Processing the directory: $dir_path"

#create an empty list to put all the files within the directory in so we can sort them later
set my_files {}

#iterate on all files using glob option to list all files in the directory specified and the * is to put everything and we append then in my_files to sort them
foreach file [glob -nocomplain -directory $dir_path *] {
    lappend my_files $file
}

#set names for the directories I want the sorting to happen in, v_dir is equal to /home/mohammad/v_files andits just a variable nothing more so the created directory name is v_files

set v_dir [file join /home/mohammad v_files]
set rpt_dir [file join /home/mohammad rpt_files]
set tcl_dir [file join /home/mohammad tcl_dir]

#here we check if the needed directories are created already or not and if not we create them by using isdirectory to do the check and as the previous v_dir is holding the path for the dir I want to make
if { ![file isdirectory $v_dir]} {file mkdir $v_dir}
if { ![file isdirectory $rpt_dir]} {file mkdir $rpt_dir}
if { ![file isdirectory $tcl_dir]} {file mkdir $tcl_dir}

#here we iterate on all files and extract the extension using externsion method and the file name using tail
#method and put them into variables
foreach file $my_files {
    set ext [file extension $file]
    set filename [file tail $file]
#here we use switch case to match the file extension with its corresponding directory and we move it there
    switch $ext {
        .v {
            puts "Moving $filename to $v_dir"
            # Using catch to handle potential errors during file rename
            if {[catch {file rename $file [file join $v_dir $filename]} result]} {
                puts "Error moving $filename: $result"
            }
        }
        .rpt {
            puts "Moving $filename to $rpt_dir"
            if {[catch {file rename $file [file join $rpt_dir $filename]} result]} {
                puts "Error moving $filename: $result"
            }
        }
        .tcl {
            puts "Moving $filename to $tcl_dir"
            if {[catch {file rename $file [file join $tcl_dir $filename]} result]} {
                puts "Error moving $filename: $result"
            }
        }
        # Add a default case to handle other file types
        default {
            puts "Ignoring $filename (unknown file type)."
        }
    }
}

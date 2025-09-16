if { [llength $argv] < 1} {
    puts "Error! Please provide the directory path."
    exit 1
}

# Corrected comment: use 'argv'
set dir_path [lindex $argv 0]

if { ![file isdirectory $dir_path]} {
    puts "Error, not a valid directory."
    exit 1
}

puts "Processing the directory: $dir_path"

set my_files {}

foreach file [glob -nocomplain -directory $dir_path *] {
    lappend my_files $file
}

# Use 'file join' for platform-independent paths
set v_dir [file join /home/mohammad v_files]
set rpt_dir [file join /home/mohammad rpt_files]
set tcl_dir [file join /home/mohammad tcl_dir]

# Combined directory creation for cleaner code
if { ![file isdirectory $v_dir]} {file mkdir $v_dir}
if { ![file isdirectory $rpt_dir]} {file mkdir $rpt_dir}
if { ![file isdirectory $tcl_dir]} {file mkdir $tcl_dir}

foreach file $my_files {
    set ext [file extension $file]
    set filename [file tail $file]

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

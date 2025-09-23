# Recursive procedure to collect all files
proc get_files {dir} {
    set files {}
    foreach f [glob -nocomplain -directory $dir *] {
        if {[file isdirectory $f]} {
            set subfiles [get_files $f]
            set files [concat $files $subfiles]
        } else {
            lappend files $f
        }
    }
    return $files
}

# ----------------------------
# Main program
# ----------------------------
if { [llength $argv] < 1} {
    puts "Usage: tclsh find_repeated_names.tcl <directory>"
    exit 1
}

set dir_path [lindex $argv 0]

if { ![file isdirectory $dir_path]} {
    puts "Error: please provide a valid directory path"
    exit 1
}

# Get all files recursively
set my_files [get_files $dir_path]

set found 0
foreach file $my_files {
    set fname [file tail $file]

    # Match names like name_name.fileext or name_name_name.fileext
    # Regex: one word, underscore, same word again, possibly repeated
    if {[regexp {^([a-zA-Z0-9]+)(_\1)+\.[a-zA-Z0-9]+$} $fname]} {
        puts "Repeated pattern found: $fname  ->  $file"
        set found 1
    }
}

if {!$found} {
    puts "No repeated-name filenames found."
}

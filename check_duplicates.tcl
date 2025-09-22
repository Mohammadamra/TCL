#procedure to make sure we are doing recursion on all subdirectories 
proc get_files {dir} {
    set files {}
    foreach f [glob -nocomplain -directory $dir *] {
        if {[file isdirectory $f]} {
            # Recurse into subdirectory
            set subfiles [get_files $f]
            set files [concat $files $subfiles]
        } else {
            lappend files $f
        }
    }
    return $files
}

# ------------------------------
# Main program
# ------------------------------
#error handling to make sure there is a path provided 
if { [llength $argv] < 1} {
    puts "please enter a directory path"
    exit 1
}

set dir_path [lindex $argv 0]
#error handling for checking if the provided path in indeed a directory 
if { ![file isdirectory $dir_path]} {
    puts "please provide a valid path"
    exit 1
}

set my_files [get_files $dir_path]
set search_files {}
set dup_files {}
#Looping on all files and taking the file name to compare with empty list (all the comming comparisons will be valid because we are comparing the current iterator with all list elements)
foreach file $my_files {
    set filename [file tail $file]
    if { [lsearch -exact $search_files $filename] == -1} {
        lappend search_files $filename
    } else {
        lappend dup_files $filename
    }
}
#printing the duplicate files 
if { [llength $dup_files] > 0 } {
    puts "found duplicates: $dup_files"
} else {
    puts "no duplicates"
}

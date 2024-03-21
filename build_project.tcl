# Create a new project
# Comment the line below after project created
create_project my_project ./my_project -part xc7a35tcpg236-1

# Open an existing project
# Uncomment the line below after project created
#open_project C:/Users/User/Documents/Basys3-Sorting-Visualisations/my_project/my_project.xpr

# Add Verilog source files
# Comment the lines below after project created
add_files C:/Users/User/Documents/Basys3-Sorting-Visualisations/bubble_sort.v
add_files C:/Users/User/Documents/Basys3-Sorting-Visualisations/selection_sort.v
add_files C:/Users/User/Documents/Basys3-Sorting-Visualisations/seg_display.v
add_files C:/Users/User/Documents/Basys3-Sorting-Visualisations/lfsr.v
add_files C:/Users/User/Documents/Basys3-Sorting-Visualisations/top_module.v

# Set the top module
set_property top top_module [current_fileset]

# Add constraints file
read_xdc C:/Users/User/Documents/Basys3-Sorting-Visualisations/constraints.xdc

# Run synthesis, implementation, and generate bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8

# Wait for the process to complete
wait_on_run impl_1

# Program the board
# Uncomment the lines below to program the board immediately when connected
#open_hw_manager
#connect_hw_server
#open_hw_target
#current_hw_device [lindex [get_hw_devices] 0]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
#set_property PROGRAM.FILE {./my_project.runs/impl_1/top_module.bit} [lindex [get_hw_devices] 0]
#program_hw_devices [lindex [get_hw_devices] 0]

# Close the project
close_project

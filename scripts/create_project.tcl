# Create a new project
create_project my_project ./my_project -part xc7a35tcpg236-1

# Add Verilog source files from the src/ directory
add_files [glob ./src/*.v]

# Set the top module
set_property top top_module [current_fileset]

# Add constraints file from the constraints/ directory
read_xdc ./constraints/constraints.xdc

# Run synthesis, implementation, and generate bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8

# Wait for the process to complete
wait_on_run impl_1

# Program the board
#open_hw_manager
#connect_hw_server
#open_hw_target
#current_hw_device [lindex [get_hw_devices] 0]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
#set_property PROGRAM.FILE {./my_project.runs/impl_1/top_module.bit} [lindex [get_hw_devices] 0]
#program_hw_devices [lindex [get_hw_devices] 0]

# Close the project
close_project

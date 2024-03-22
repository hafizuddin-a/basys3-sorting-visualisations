# Assuming this script is located in the project_root/scripts directory
# and the Vivado project is located in the project_root directory

# Open the existing project
open_project my_project/my_project.xpr

# Reset the implementation run
reset_run impl_1

# Run synthesis and implementation
launch_runs impl_1 -jobs 8

# Wait for the process to complete
wait_on_run impl_1

# Generate the bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8

# Wait for the bitstream generation to complete
wait_on_run impl_1

# Program the board. Uncomment below to program
#open_hw_manager
#connect_hw_server
#open_hw_target
#current_hw_device [lindex [get_hw_devices] 0]
#refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
#set_property PROGRAM.FILE {./my_project.runs/impl_1/top_module.bit} [lindex [get_hw_devices] 0]
#program_hw_devices [lindex [get_hw_devices] 0]

# Close the project
close_project

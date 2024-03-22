# Assuming this script is located in the project_root/scripts directory
# and the Vivado project is located in the project_root directory

# Open the existing project
open_project ../my_project/my_project.xpr

# Run synthesis and implementation
launch_runs impl_1 -jobs 8

# Wait for the process to complete
wait_on_run impl_1

# Generate the bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 8

# Wait for the bitstream generation to complete
wait_on_run impl_1

# Close the project
close_project

# Adding Vivado to the PATH Environment Variable on Windows

## Overview
To run Vivado commands from the terminal, you need to add the Vivado bin directory to your system's PATH environment variable. This guide provides step-by-step instructions on how to do this.

## Steps

1. **Locate Vivado Installation Directory**:
   - Find the installation directory of Vivado on your system. Typically, it is installed in a path like `C:\Xilinx\Vivado\<version>`, where `<version>` is the version of Vivado you have installed (e.g., `2021.1`).

2. **Open System Properties**:
   - Right-click on the Start button and select "System" from the context menu.
   - Click on "Advanced system settings" on the left side of the System window.
   - In the System Properties dialog, go to the "Advanced" tab and click on the "Environment Variables" button.

3. **Edit PATH Environment Variable**:
   - In the Environment Variables dialog, under the "System variables" section, find the variable named "Path" and select it.
   - Click on the "Edit..." button to modify the PATH variable.
   - In the Edit Environment Variable dialog, click on the "New" button and add the path to the Vivado bin directory. It should look something like `C:\Xilinx\Vivado\<version>\bin`.
   - Click "OK" to close the dialogs and save your changes.

4. **Verify the Configuration**:
   - Open a new Command Prompt window (the changes won't apply to already open windows).
   - Type `vivado -version` and press Enter. If Vivado is correctly configured, you should see the version information of your Vivado installation.

By following these steps, you should have successfully added Vivado to your system's PATH environment variable, allowing you to run Vivado commands from the Command Prompt.

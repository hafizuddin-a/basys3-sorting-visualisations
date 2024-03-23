# Sorting Algorithm Visualizations on Basys3 Board

## Overview
This project demonstrates various sorting algorithms through visualizations on the Basys3 FPGA board using Verilog. The goal is to provide a clear and engaging way to understand how different sorting algorithms work by visualizing their operations in real-time on the FPGA board. The visualizations are displayed on a Pmod OLED connected to the Basys3 board.

## Prerequisites
- **Hardware**: 
  - Basys3 FPGA Board
  - Pmod OLED (connected to the Basys3 board)
- **Software**: 
  - Xilinx Vivado (for synthesis and programming)
  - A text editor or IDE for Verilog development (e.g., Visual Studio Code with Verilog extensions)

## Installation
1. Clone the repository to your local machine:
   ```
   git clone https://github.com/yourusername/basys3-sorting-visualisations.git
   ```
2. Navigate to the project directory:
   ```
   cd basys3-sorting-visualisations
   ```
3. Ensure that Vivado is added to your system's PATH environment variable. This allows you to run Vivado commands from the terminal. For instructions on how to add Vivado to your PATH, see [this guide](./PATH_INSTRUCTIONS.md).

## Using the Tcl Scripts
- **For the first-time setup**, run the `create_project.tcl` script to create the project and configure it with the necessary source files and constraints:
  ```
  vivado -mode batch -source scripts/create_project.tcl
  ```
- **For subsequent runs**, use the `run_implementation.tcl` script to run synthesis, implementation, and generate the bitstream:
  ```
  vivado -mode batch -source scripts/run_implementation.tcl
  ```
  Make sure to run the terminal as an administrator when executing these commands.

## Visualizing Sorting on the Pmod OLED
The Pmod OLED will display a graphical representation of the array being sorted. Each element in the array is represented by a vertical bar, with the height of the bar corresponding to the value of the element. As the sorting algorithm progresses, you'll see the bars being sorted in real-time, providing a visual understanding of how the algorithm works.

## Supported Sorting Algorithms
- Bubble Sort
- Insertion Sort
- Selection Sort
- Quick Sort
- Merge Sort

*Note: More algorithms may be added in future updates.*

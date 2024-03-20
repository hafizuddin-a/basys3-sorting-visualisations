# Sorting Algorithm Visualisations on Basys3 Board

## Overview
This project aims to demonstrate various sorting algorithms through visualisations on the Basys3 FPGA board using Verilog, a hardware description language known for its complexity. The goal is to provide a clear and engaging way to understand how different sorting algorithms work by visualizing their operations in real-time on the FPGA board. The visualisations are displayed on a Pmod OLED connected to the Basys3 board.

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
   git clone https://github.com/hafizuddin-a/Basys3-Sorting-Visualisations
   ```
2. Open the project in Xilinx Vivado:
   - Launch Vivado and open the project file located in the cloned repository.
3. Generate the bitstream and program the Basys3 board with the generated bitstream file.

## Usage
Once the Basys3 board is programmed, the sorting visualisations will start automatically on the Pmod OLED. The board's switches and buttons can be used to control the visualisation, such as selecting different sorting algorithms, starting or pausing the sorting process, and resetting the visualisation.

### Visualizing Sorting on the Pmod OLED
The Pmod OLED will display a graphical representation of the array being sorted. Each element in the array is represented by a vertical bar, with the height of the bar corresponding to the value of the element. As the sorting algorithm progresses, you'll see the bars being sorted in real-time, providing a visual understanding of how the algorithm works.

## Supported Sorting Algorithms
- Bubble Sort
- Insertion Sort
- Selection Sort
- Quick Sort
- Merge Sort

*Note: More algorithms may be added in future updates.*

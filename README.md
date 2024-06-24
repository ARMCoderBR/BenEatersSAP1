# BenEatersSAP1
## Yet another FPGA implementation of Ben Eater's SAP-1 computer!

![Basys 3 board running SAP-1](https://repository-images.githubusercontent.com/819211078/52954e30-02a5-4ecc-87c8-8abfb1fd9ab4)

For a long time I've been curious about developing projects on FPGA, and I recently purchased a Digilent's BASYS 3 board to begin my studies on FPGA logic synthesis and Verilog language. 

The basic info on the BASYS3 board is:

* FPGA: Xilinx Artix-7 XC7A35T-1CPG236C
* GPIOs:
  * 16 slide switches
  * 16 configurable LEDs
  * 5 pushbuttons
* Display output: 4 digit LED 7-segment, common anode, multiplexed
* Connectivity
  * Micro USB for power, JTAG and UART
  * USB-A to allow loading the FPGA's bitmap from a thumb drive
  * Sub-D analog VGA port
  * 4 x 6x2 Molex headers w/ Power/GND and free GPIOs (one configurable for ADCs)

Official info on the BASYS 3 board is available [here](https://digilent.com/reference/programmable-logic/basys-3/start).

## The Project

__Environment__

The project is totally written in Verilog on AMD Vivado 2024.1 IDE, that's available for Windows and Linux. I've used Ubuntu 2022.04.04 LTS for the whole development, AFAIK as of now Vivado doesn't support the recently released 2024 Ubuntu yet.

__Inspiration__

Of course, Ben Eater has been around for a long time and for most he doesn't need much of an introduction. Anyway, here follows Ben's relevant links that I know about:

Youtube: https://www.youtube.com/@BenEater

GitHub: https://github.com/beneater

The still free, World Wide Wweb: https://eater.net/

The project that I'm reimplementing here is closed based on Ben's 8-bit computer project [here](https://eater.net/8bit). This project is sometimes called "SAP-1" (from "simple as possible", AFAIK), but not in every instance.

__Specific Details__

Assuming you are acquainted to the 


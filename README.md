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




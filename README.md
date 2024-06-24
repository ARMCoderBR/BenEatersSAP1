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

* Youtube: https://www.youtube.com/@BenEater

* GitHub: https://github.com/beneater

* The still free, World Wide Wweb: https://eater.net/

The project that I'm reimplementing here is closed based on Ben's 8-bit computer project that can be found [here](https://eater.net/8bit). This project is sometimes called "SAP-1" (from "simple as possible", AFAIK), but even Ben seem not to use this moniker frequently (or anytime, I'm not really sure TBH). What I'm sure is that I've seen "SAP-1" being used in some sources around the web referring to this very project.

__Specific Details__

Assuming you are already acquainted to the SAP-1 project (if you aren't, some research is recommended, this is quite a nice project!), there are a few particular details that are worth knowing.

* The whole implementation was made in Verilog. System Verilog and VHDL are more capable languages, but I'm still learning and this project is not (very) hard to express in pure Verilog, so I decided to stick to Verilog, and the results were good enough!
* The original project was built on breadboards with TTL chips and a helluva of LEDs, much more than the ones supplied by the BASYS 3.
* I needed to take a few liberties on the original SAP-1 project, as not all its parts would translate efficiently to the FPGA's realm.
  * The original SAP-1 uses an EEPROM to decode a byte to its decimal representation in the 7-segment display, I preferred to use a more gate-oriented approach, including the [double-dabble](https://en.wikipedia.org/wiki/Double_dabble) algorithm to obtain BCD from binary, then finally translating each BCD digit to 7-segment.
  * All counters/clocks are now sinchronized under a main clock domain, this is not really enforced but highly recommended in FPGA projects. So, unlike in the original SAP-1, there are no "ripple clocks" in this implementation, everything is synchronized to the nanosecond.
  * Because of the change above, the microcode sequencing for the ALU operations (ADD/SUB) required one more clock cycle (6 clocks for ADD/SUB versus 5 clocks in the original SAP-1). This was needed to guarantee that the Zero and Carry flags were stable long enough to be correctly sampled before the A-Register was finally updated in the end of the ALU operation.

With these changes, this "BASYS-3 SAP-1" implementation became a quite fast machine. I tested it successfully at 1 MHz, but I'm REALLY sure it can run much, much faster. I could (*aham*) bet it would run at the BASYS 3's base clock of 100 MHz, or even more using the FPGA's PLLs.

A small demo program is pre-loaded in RAM, but you can switch the SAP-1 into program mode and insert your own program that you've crafted with so much love. With that whopping 16-bytes RAM, the sky is the limit!

__SWITCHES AND BUTTONS - PROGRAM MODE__

* SW[4]: Prog/Run
  * 0: Run mode.
  * 1: Program mode.
    
* SW[3] to SW[0]: RAM Address
  * Used for programming, select the RAM address to be programmmed.

* SW[15] to SW[8]: RAM Data
  * Used for programming, select the RAM data to be programmed.

* BTNL (Pushbutton, Left)
   * Used for programming, executes the WRITE command (RAM Data -> RAM[RAM Address]).
 
__SWITCHES AND BUTTONS - RUN MODE__

* BTNL  (Pushbutton, Left)
  * Pause/Step Execution Clock.

* BTNR  (Pushbutton, Right)
  * Resume Execution Clock.

* BTNU  (Pushbutton, Up)
  * Increase Clock Speed.

* BTND  (Pushbutton, Down)
  * Decrease Clock Speed.

* BTNC  (Pushbutton, Center)
  * Reset.

__LEDS__

* LED[4]
  * Flashes whenever in Program Mode (SW[4] ON). Off in RUN Mode.
 
* LED[5]
  * Positive Clock (Registers).

* LED[6]
  * Negative Clock (Control Unit).

* LED [7]
  * Halt executed (system stopped).


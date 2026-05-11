# 8-Bit Arithmetic Logic Unit (ALU) in SystemVerilog 

A fully modular, synthesizable 8-bit Arithmetic Logic Unit (ALU) designed in SystemVerilog. This project implements a robust 16-to-1 multiplexed datapath capable of executing arithmetic, bitwise logic, and advanced shift/rotate operations with dynamic signed and unsigned support.

## Key Features
* **Modular Architecture:** The datapath is decoupled into dedicated Arithmetic, Logic, and Shift units, all routed through a main TOP multiplexer.
* **Dynamic Signed/Unsigned Execution:** Seamlessly handles Two's Complement arithmetic, ensuring accurate flag generation and logical vs. arithmetic right shifts depending on the `is_signed` input.
* **Robust Edge-Case Handling:** Bulletproof hardware protections against common synthesis pitfalls, including division-by-zero protection (avoids `XX` unknown states) and absolute-value boundary limits for barrel shifting.
* **Decoupled Status Register:** Implements an industry-standard flag extraction system, decoupling the 8-bit data bus from the Condition Codes (`OF, CF, SF, ZF`).

## Architecture Breakdown
The project is strictly structured into the following hardware modules:

* `Arithmetic_Unit.sv`: Handles ADD, SUB, MUL, DIV, NEG, ABS, MIN, and MAX. Includes explicit logic for overflow detection during signed operations and carry generation for unsigned math.
* `Logic_Unit.sv`: Executes parallel bitwise operations (AND, OR, XOR, NOT).
* `Shift_Unit.sv`: A dynamic barrel shifter supporting Logical Shift Left/Right, Arithmetic Shift Right, and hardware-safe Rotations (ROL/ROR).
* `ALU_Top.sv`: The main wrapper that instantiates the sub-modules, routes the 16-to-1 operation multiplexer, and extracts the global status flags.
* `tb_ALU.sv`: An exhaustive testbench utilizing automated task-based stimuli to verify corner cases (e.g., division by zero, signed overflow boundaries, out-of-bounds shifts).

## Instruction Set (Opcodes)
The ALU operation is determined by a 4-bit `sel` signal. 

| `sel` (Binary) | `sel` (Dec) | Operation | Category |
| :---: | :---: | :--- | :--- |
| `0000` | 0 | **ADD** | Arithmetic |
| `0001` | 1 | **SUB** | Arithmetic |
| `0010` | 2 | **MUL** | Arithmetic |
| `0011` | 3 | **DIV** | Arithmetic |
| `0100` | 4 | **NEG** | Arithmetic (Two's Comp) |
| `0101` | 5 | **ABS** | Arithmetic (Absolute) |
| `0110` | 6 | **MIN** | Arithmetic |
| `0111` | 7 | **MAX** | Arithmetic |
| `1000` | 8 | **AND** | Logic |
| `1001` | 9 | **OR** | Logic |
| `1010` | 10 | **XOR** | Logic |
| `1011` | 11 | **NOT** | Logic |
| `1100` | 12 | **SHL** | Shift (Logical Left) |
| `1101` | 13 | **SHR** | Shift (Logical/Arithmetic Right) |
| `1110` | 14 | **ROL** | Rotate Left |
| `1111` | 15 | **ROR** | Rotate Right |

## Status Flags
The ALU generates 4 standard condition codes based on the selected output:
* **`OF` (Overflow Flag):** Set to `1` when a signed mathematical operation exceeds the 8-bit Two's Complement limits (-128 to +127).
* **`CF` (Carry Flag):** Set to `1` when an unsigned operation requires a carry-out or borrow, when a bit is shifted out of bounds, or to flag a Division-by-Zero error.
* **`SF` (Sign Flag):** Mirrors the Most Significant Bit (MSB) of the result. Set to `1` if the result is negative.
* **`ZF` (Zero Flag):** Set to `1` if all 8 bits of the data result are `0`.

## Tools & Technologies
* **Language:** SystemVerilog (IEEE 1800-2012)
* **IDE/Synthesis:** Xilinx Vivado
* **Simulation:** Vivado Simulator (XSim) / Behavioral Simulation

## How to Run the Simulation
1. Clone the repository: `git clone https://github.com/YourUsername/YourRepoName.git`
2. Open Xilinx Vivado and create a new project.
3. Add the `.sv` files from the `srcs` folder as **Design Sources**.
4. Add `tb_ALU.sv` as a **Simulation Source**.
5. Set `tb_ALU` as the top module for simulation.
6. Click **Run Behavioral Simulation** to view the generated waveforms and the exhaustive Tcl console verification log.

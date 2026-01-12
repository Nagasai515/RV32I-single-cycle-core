# RV32I Single-Cycle CPU

A Verilog implementation of a 32-bit RISC-V single-cycle processor
supporting a subset of the RV32I base integer instruction set,
designed and simulated using Xilinx Vivado.

## Features
- 32-bit RISC-V RV32I (subset) core
- Single-cycle datapath architecture
- Modular Verilog RTL design
- Support for selected arithmetic, logical, memory, and branch instructions
- Functional verification using simulation waveforms and execution traces

## Tools
- Verilog HDL
- Xilinx Vivado (simulation)

## Verification
The processor has been functionally verified through:
- Waveform-level simulation in Vivado
- Register file and execution trace observation
- A documented instruction program covering ALU, memory, and branch operations

## Status
✅ Single-cycle RISC-V RV32I (subset) CPU implementation complete and verified.  
This design serves as a baseline reference for a five-stage pipelined RISC-V processor.



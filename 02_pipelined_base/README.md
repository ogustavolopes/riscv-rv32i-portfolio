# Project 02: RISC-V RV32I 5-Stage Pipelined Processor

## Overview
To overcome the critical path limitation of the single-cycle model, this project divides the datapath into a **5-stage pipeline**, allowing up to five instructions to be processed concurrently and increasing the operating clock frequency.

## Pipeline Stages
1. **IF (Instruction Fetch):** Fetches the instruction from `imem` using `PCF` and computes `PC + 4`.
2. **ID (Instruction Decode):** Decodes the instruction, reads source registers (`rs1`, `rs2`), and performs sign extension.
3. **EX (Execute):** Executes arithmetic/logical operations in the ALU and calculates branch target addresses.
4. **MEM (Memory):** Accesses data memory (`dmem`) for load and store operations.
5. **WB (Write Back):** Writes the final result (from ALU or Memory) back into the Register File (`rd`).

## Key Features
* Dedicated pipeline registers isolating each stage (`IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`).
* Synchronous propagation of both datapath signals and control signals across stages.
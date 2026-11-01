```markdown
# Project 01: RISC-V RV32I Single-Cycle Processor

## Overview
This project implements a 32-bit single-cycle RISC-V processor core based on the **RV32I** base integer instruction set. Every instruction is fetched, decoded, executed, and written back within a single clock cycle.

## Microarchitecture Components
* **Datapath:** Contains the Program Counter (`PC`), 32x32-bit Register File (`x0` hardwired to `0`), Immediate Generator (`Extend`), Arithmetic Logic Unit (`ALU`), and word-aligned instruction/data memories (`imem` and `dmem`).
* **Control Unit:** Divided into a Main Decoder and an ALU Decoder, generating multiplexer select lines, register write-enable (`RegWrite`), and memory write-enable (`MemWrite`) signals.
* **Supported Instructions:** Core RV32I subset including `lw`, `sw`, `add`, `sub`, `and`, `or`, `slt`, `addi`, `beq`, and `jal`.

## Simulation & Validation
The processor is verified by loading hexadecimal machine code (`riscvtest.txt`) into the instruction memory via `$readmemh` and monitoring memory writes, register states, and waveforms during execution.
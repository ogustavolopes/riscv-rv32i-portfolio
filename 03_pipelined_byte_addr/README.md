# Project 03: Pipelined RV32I with Byte-Addressable Memory

## Overview
This capstone project upgrades the 5-stage pipelined RV32I processor by replacing the word-only memory interface with a complete **byte-addressable memory subsystem**. This enhancement enables sub-word data manipulation required by real-world compilers and C programs.

## Architectural Enhancements
* **Byte & Half-Word Load Support (`lb`, `lbu`, `lh`, `lhu`, `lw`):** Implements post-memory read alignment logic using the lower address bits (`DataAdr[1:0]`) to extract specific bytes or 16-bit half-words, applying proper sign-extension or zero-extension.
* **Byte & Half-Word Store Support (`sb`, `sh`, `sw`):** Implements write-masking / byte-enable logic to update individual bytes or half-words in data memory without overwriting adjacent bytes within the same 32-bit word.

## Verification & Synthesis
* **UVM Verification:** Verified using a modular SystemVerilog/UVM environment (`uvm_agent`, `uvm_driver`, `uvm_monitor`, `uvm_sequencer`, and transactions) compiled via `files.f`.
* **PPA Analysis (Power, Performance, and Area):** Synthesized using **Cadence Genus** to evaluate logic area, power consumption, and timing slack compared to previous architectures.
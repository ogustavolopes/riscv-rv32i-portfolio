# RISC-V RV32I Processor Portfolio: From Single-Cycle to Pipelined with Byte-Addressable Memory

This repository showcases the design, RTL implementation, functional verification, and logic synthesis of 32-bit RISC-V soft-core processors based on the **RV32I** base integer instruction set. 

Developed within the **CI Digital / CI Brasil Microelectronics Training Program (UNIFEI / SOFTEX)** and grounded in the architectural models by *Sarah L. Harris and David Money Harris (Digital Design and Computer Architecture: RISC-V Edition)*, this portfolio demonstrates the complete microarchitectural evolution across two semesters.

---

## 🏗️ Architectural Evolution Summary

| Stage | Microarchitecture | Key Features & Enhancements | Verification & Synthesis |
| :--- | :--- | :--- | :--- |
| **01** | **Single-Cycle RV32I** | Executes each instruction in a single clock cycle; foundational datapath and combinational control unit integration. | Directed Testbench & Waveform Analysis |
| **02** | **5-Stage Pipelined RV32I** | Classic 5-stage RISC pipeline (`IF`, `ID`, `EX`, `MEM`, `WB`) with pipeline registers for increased clock frequency and throughput. | SystemVerilog Testbenches & PPA Analysis |
| **03** | **Pipelined + Byte-Addressable Memory** | Upgraded memory subsystem supporting sub-word accesses (`byte` and `half-word`) with alignment, sign/zero-extension, and UVM verification. | **UVM Methodology** & Cadence Genus PPA Synthesis |

---

## 🛠️ EDA Tools & Methodology
* **Hardware Description Languages:** Verilog / SystemVerilog (`.v`, `.sv`)
* **IDE & Documentation:** Visual Studio Code + TerosHDL
* **Simulation & Verification:** Cadence Xcelium (`xrun`), SystemVerilog Testbenches, and Universal Verification Methodology (**UVM**)
* **Logic Synthesis & PPA Analysis:** Cadence Genus (Power, Performance, and Area evaluation)
* **Build Automation:** GNU Make (`Makefile` and `files.f`)

---

## 📂 Repository Directory Structure

```text
├── README.md                      # Main portfolio overview
├── docs/                          # Technical reports, PPA analysis, and schematics
├── 01_single_cycle/               # Project 1: RV32I Single-Cycle Processor
│   ├── rtl/                       # Datapath, ALU, Register File, Control Unit
│   ├── testbench/                 # Directed testbench and hex instruction files
│   └── README.md                  # Single-Cycle documentation
├── 02_pipelined_base/             # Project 2: RV32I 5-Stage Pipelined Processor
│   ├── rtl/                       # Pipelined datapath and stage registers
│   ├── testbench/                 # Verification environment
│   └── README.md                  # Pipelined Base documentation
└── 03_pipelined_byte_addr/        # Project 3: Pipelined RV32I with Byte-Addressable Memory
    ├── rtl/                       # Byte/Half-word alignment logic and memory
    ├── tb_uvm/                    # UVM verification environment (Agents, Drivers, Monitor)
    └── README.md                  # Byte-Addressable & UVM documentation

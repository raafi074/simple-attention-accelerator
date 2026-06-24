# simple-attention-accelerator
Hardware implementation of a simplified scaled dot-product attention mechanism using Verilog/SystemVerilog.
### Simple Attention Accelerator
**Overview**

This project implements a simplified scaled dot-product attention mechanism in Verilog/SystemVerilog. The design computes Query (Q), Key (K), and Value (V) matrices from input tokens and learned weight matrices, calculates attention scores, applies scaling and a softmax approximation, and generates the final attention output.

The primary goal of this project is to demonstrate how transformer attention computations can be mapped onto a resource-efficient hardware architecture.

**Attention Equation**

Attention(Q,K,V) = softmax(QKᵀ / √dk)V

**Proposed Architecture**

Unlike a fully parallel implementation, this design uses a shared Multiply-Accumulate (MAC) unit controlled by a Finite State Machine (FSM).

Input Files
     ↓
Input Memory
     ↓
Shared MAC Engine
     ↓
Q Computation
     ↓
K Computation
     ↓
V Computation
     ↓
Score Computation (QKᵀ)
     ↓
Scaling Unit
     ↓
Softmax Approximation Unit
     ↓
Output Computation
     ↓
Output File

The same MAC engine is reused throughout the entire attention pipeline, reducing hardware resource utilization while increasing execution latency.

### Design Decisions
**Shared MAC Architecture**

A single MAC unit is reused for:

- Q = XWQ
- K = XWK
- V = XWV
- QKᵀ computation
- Output computation

### Fixed-Point Arithmetic

The design uses 16-bit signed fixed-point representation (Q8.8 format).

### Scaling Strategy

The design uses:

- dk = 4
- √dk = 2

Scaling is implemented using a simple right-shift operation.

### Softmax Approximation

To avoid expensive exponential computations, a simplified comparator-based approximation is used.

**Example:**

If score1 > score2:

Attention Weights = [0.75, 0.25]

Else:

Attention Weights = [0.25, 0.75]

### FSM Control Flow
IDLE
 ↓
LOAD_DATA
 ↓
COMPUTE_Q
 ↓
COMPUTE_K
 ↓
COMPUTE_V
 ↓
COMPUTE_SCORE
 ↓
SCALE_SCORE
 ↓
SOFTMAX
 ↓
COMPUTE_OUTPUT
 ↓
WRITE_OUTPUT
 ↓
DONE

The FSM orchestrates all stages of computation using the shared MAC engine.

**Directory Structure**

simple-attention-accelerator/
│
├── src/
├── tb/
├── data/
├── scripts/
├── docs/
└── README.md

**Input Files**

Input matrices are loaded from text files using Verilog file I/O mechanisms.

Files:

- x.mem
- wq.mem
- wk.mem
- wv.mem

### Simulation Environment

Tools Used:

- Icarus Verilog
- GTKWave
- Python Verification Script

**Compile:**

iverilog -o sim tb/tb_attention.v src/attention_top.v

**Run:**

vvp sim

**Open waveform:**

gtkwave attention.vcd

**Verification**

A Python reference implementation is provided to verify the correctness of the hardware-generated outputs.

**The verification flow compares:**

Hardware Output ↔ Python Reference Output

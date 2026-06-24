# Design Decisions

## Architecture Choice

The design uses a shared MAC (Multiply-Accumulate) architecture controlled by a finite state machine (FSM). A single MAC unit is reused for Q, K, V, attention score, and output computations.

### Advantages
- Reduced hardware area
- Lower resource utilization
- Simpler implementation

### Disadvantages
- Increased execution latency
- Lower throughput compared to parallel architectures

## Number Representation

The design uses integer arithmetic for simplicity and ease of verification.

## Scaling

The attention scores are divided by sqrt(dk). For this implementation, dk = 4, so scaling is implemented as division by 2.

## Softmax Approximation

Instead of implementing exponential functions, a comparator-based approximation is used.

If score0 >= score1:
- Attention = [0.75, 0.25]

Else:
- Attention = [0.25, 0.75]

This significantly reduces hardware complexity.

## Verification

A Python reference model is used to verify correctness. The Verilog output is compared against the Python-generated output.

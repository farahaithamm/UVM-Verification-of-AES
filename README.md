# UVM-Based Verification of AES

A SystemVerilog UVM testbench for functional verification of an AES-128 encryption/decryption hardware design. The design under test (DUT) is checked against a Python reference model using the PyCryptodome library.

## Overview

This project implements a complete UVM verification environment for a pipelined AES-128 block that supports both encryption and decryption. Random stimulus is generated via UVM sequences, applied through a driver, and observed by a monitor. A scoreboard compares DUT output against golden results from a Python AES reference model running in ECB mode.

## Features

- **UVM testbench** with agent, driver, monitor, sequencer, scoreboard, and subscriber
- **AES-128 DUT** with pipelined input/output registers
- **Encrypt and decrypt** modes selected via a `flag` signal
- **Python reference model** (`pycryptodome`) for scoreboard checking
- **Functional coverage** on reset, `valid_in`, and `valid_out` signals
- **Randomized sequences** for encryption (100 transactions by default)

## Project Structure

```
UVM-Based-Verification-of-AES/
├── AES Encrypy&Decrypt/     # Combined encrypt/decrypt RTL (DUT used in simulation)
│   ├── AES_128.sv           # Top-level pipelined AES wrapper
│   ├── AES_piplined.sv      # AES core (encrypt + decrypt mux)
│   ├── AES_Encrypt.v
│   ├── AES_Decrypt.v
│   └── ...                  # Sub-modules (subBytes, shiftRows, mixColumns, etc.)
├── AES Encrypt/             # Standalone AES encryption RTL modules
├── AES Decrypt/             # Standalone AES decryption RTL modules
├── ref_model/               # Golden reference models
│   ├── aes_enc.py           # Python AES encryption (ECB)
│   └── aes_dec.py           # Python AES decryption (ECB)
├── uvm/                     # UVM testbench
│   ├── top.sv               # Top module with DUT instantiation
│   ├── AES_test.sv          # UVM test (reset + encrypt sequences)
│   ├── AES_env.sv           # UVM environment
│   ├── AES_agent.sv         # UVM agent
│   ├── AES_driver.sv        # Stimulus driver
│   ├── AES_monitor.sv       # Signal monitor
│   ├── AES_sequencer.sv     # Sequencer
│   ├── AES_sequences.sv     # Reset, encrypt, decrypt sequences
│   ├── AES_seq_item.sv      # Transaction class
│   ├── AES_scoreboard.sv    # DUT vs reference model checker
│   ├── AES_subscriber.sv    # Functional coverage collector
│   ├── AES_interface.sv     # SystemVerilog interface
│   └── run.do               # ModelSim/Questa run script
└── sim/                     # Simulation support files
    ├── data.txt             # Input data for reference model (generated at runtime)
    ├── output.txt           # Expected output from reference model
    └── run.do               # Alternate simulation script
```

| Component    | Role |
|-------------|------|
| **Driver**  | Drives `plain_text`, `cipher_key`, `valid_in`, `flag`, and `rst_n` onto the interface |
| **Monitor** | Samples DUT signals and broadcasts transactions to the scoreboard and subscriber |
| **Scoreboard** | Writes inputs to `data.txt`, runs the Python reference model, and compares `cipher_text` |
| **Subscriber** | Collects functional coverage on reset and valid signals |
| **Sequences** | `AES_reset_sequence`, `AES_encrypt_sequence`, `AES_decrypt_sequence`, `AES_enc_dec_sequence` |

## DUT Interface

| Signal        | Width   | Direction | Description |
|---------------|---------|-----------|-------------|
| `clk`         | 1       | Input     | Clock |
| `rst_n`       | 1       | Input     | Active-low reset |
| `plain_text`  | 128     | Input     | Plaintext block |
| `cipher_key`  | 128     | Input     | AES-128 key |
| `valid_in`    | 1       | Input     | Input valid strobe |
| `flag`        | 1       | Input     | `1` = encrypt, `0` = decrypt |
| `cipher_text` | 128     | Output    | Ciphertext or decrypted output |
| `valid_out`   | 1       | Output    | Output valid strobe |

## Prerequisites

- **Simulator:** ModelSim or QuestaSim with UVM support
- **Python 3** with [PyCryptodome](https://pypi.org/project/pycryptodome/):

  ```bash
  pip install pycryptodome
  ```

## How to Run

1. Open ModelSim/QuestaSim and change to the `uvm/` directory.

2. Compile the RTL and UVM testbench (example compile order):

   ```tcl
   vlib work
   vlog ../AES\ Encrypy\&Decrypt/*.v
   vlog ../AES\ Encrypy\&Decrypt/*.sv
   vlog AES_interface.sv AES_seq_item.sv AES_sequencer.sv
   vlog AES_driver.sv AES_monitor.sv AES_agent.sv
   vlog AES_scoreboard.sv AES_subscriber.sv AES_env.sv
   vlog AES_sequences.sv AES_test.sv top.sv
   ```

3. Run the simulation:

   ```tcl
   do run.do
   ```

   Or launch directly:

   ```tcl
   vsim -voptargs=+acc work.AES_top -cover -classdebug -uvmcontrol=all +UVM_VERBOSITY=UVM_HIGH
   run -all
   ```

4. Check the transcript for `SUCCESS` or `FAILURE` messages from the scoreboard.

> **Note:** The scoreboard invokes Python from the `sim/` working directory. Run the simulation with `sim/` as the current directory, or ensure `data.txt` and `output.txt` paths match the scoreboard expectations.

## Test Sequences

All sequences are defined in `AES_sequences.sv` and started from `AES_test.sv`.

| Sequence | Class | Transactions | `flag` | Description |
|----------|-------|--------------|--------|-------------|
| Reset | `AES_reset_sequence` | 1 | — | Asserts reset (`rst_n = 0`, `valid_in = 0`) |
| Encrypt | `AES_encrypt_sequence` | 100 | `1` | Randomized plaintext/key; checks encryption against `aes_enc.py` |
| Decrypt | `AES_decrypt_sequence` | 100 | `0` | Randomized plaintext/key; checks decryption against `aes_dec.py` |
| Encrypt/Decrypt | `AES_enc_dec_sequence` | 50 | `1` | Randomized encrypt-only burst (combined-mode test) |

### Default run

By default, `AES_Test` runs **reset** then **encrypt** only. Decrypt and encrypt/decrypt are commented out in `AES_test.sv`.

### Enable all three operational sequences

Uncomment the decrypt and enc/dec declarations, creation, and `start` calls in `AES_test.sv`:

```systemverilog
AES_decrypt_sequence decrypt_seq;
AES_enc_dec_sequence both_seq;

1. **Reset sequence** — Asserts reset (`rst_n = 0`)
2. **Encrypt sequence** — 100 randomized encryption transactions (`flag = 1`)

Decrypt and combined encrypt/decrypt sequences are available in `AES_sequences.sv` but commented out in `AES_test.sv`. Uncomment them in the test's `run_phase` to enable those modes.
```
## Scoreboard Flow

1. Monitor captures a transaction when `valid_out` is asserted.
2. Scoreboard writes `plain_text` and `cipher_key` to `data.txt`.
3. Depending on `flag`, it runs `aes_enc.py` or `aes_dec.py`.
4. The reference model writes the expected result to `output.txt`.
5. Scoreboard reads `output.txt` and compares against `cipher_text`.

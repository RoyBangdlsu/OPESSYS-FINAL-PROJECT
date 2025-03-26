# CPU Scheduling Simulator

The CPU Scheduling Simulator is a Bash-based project. It performs a simulation of the two basic CPU scheduling algorithms, First Come First Serve (FCFS) and Round Robin (RR). The program describes how the scheduling process was broken down, step by step: waiting time, turnaround time, throughput, and context switching overhead.

## Features

- Simulates **FCFS** and **RR** scheduling algorithms.
- Displays step-by-step execution logs.
- Calculates key performance metrics:
  - **Average Waiting Time**
  - **Average Turnaround Time**
  - **Throughput**
  - **Total Context Switching Overhead**
- User can input context switch time and time quantum for RR.

## Usage

Run the script using the following command:

```bash
sh project.sh
```

### Input Details

- Enter the **number of processes**.
- Provide the following for each process:
  - **Player Name** (Process Identifier)
  - **Arrival Time** (ms)
  - **Action Time** (ms)
- Enter the **Context Switch Time** (ms).
- Enter the **Time Quantum**.

### Example Run

```plaintext
🎯 WELCOME TO THE CPU SCHEDULER SIMULATOR 🎯
Enter number of players: 3
👉 Enter name for player 1: P1
🎮 Enter arrival time for P1 (ms): 0
⚡ Enter action time for P1 (ms): 8
👉 Enter name for player 2: P2
🎮 Enter arrival time for P2 (ms): 2
⚡ Enter action time for P2 (ms): 4
👉 Enter name for player 3: P3
🎮 Enter arrival time for P3 (ms): 4
⚡ Enter action time for P3 (ms): 9
Enter context switch time (ms): 2
Enter time quantum for RR (default = 20 ms): 4
```

FCFS and RR algorithms will be simulated and detailed results will be displayed through the program.


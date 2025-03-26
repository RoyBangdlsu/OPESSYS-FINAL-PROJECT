#!/bin/bash

# Color codes for styling
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ✅ Function to sort based on arrival time
sort_by_arrival() {
    local n=$1
    local -a temp_names=("${!2}")
    local -a temp_arrival=("${!3}")
    local -a temp_action=("${!4}")

    for ((i = 0; i < n-1; i++)); do
        for ((j = 0; j < n-i-1; j++)); do
            if ((temp_arrival[j] > temp_arrival[j + 1])); then
                temp=${temp_arrival[j]}
                temp_arrival[j]=${temp_arrival[j + 1]}
                temp_arrival[j + 1]=$temp

                temp=${temp_action[j]}
                temp_action[j]=${temp_action[j + 1]}
                temp_action[j + 1]=$temp

                temp=${temp_names[j]}
                temp_names[j]=${temp_names[j + 1]}
                temp_names[j + 1]=$temp
            fi
        done
    done

    for ((i = 0; i < n; i++)); do
        players[i]=${temp_names[i]}
        arrival[i]=${temp_arrival[i]}
        action[i]=${temp_action[i]}
    done
}

# ✅ Function to simulate FCFS scheduling
fcfs() {
    local n=$1
    local names=("${!2}")
    local arrival=("${!3}")
    local action=("${!4}")
    
    local start=()
    local waiting=()
    local turnaround=()
    local total_waiting=0
    local total_turnaround=0
    local total_context_switch=0

    echo -e "\n${CYAN}=== Step-by-Step FCFS Scheduling ===${RESET}"

    start[0]=${arrival[0]}
    waiting[0]=0
    turnaround[0]=${action[0]}

    echo -e "${GREEN}➡️ Process ${names[0]} starts at time ${start[0]} ms, finishes at time $((start[0] + action[0])) ms${RESET}"

    for ((i = 1; i < n; i++)); do
        start[i]=$((start[i - 1] + action[i - 1] + context_switch_time))

        if ((start[i] < arrival[i])); then
            echo -e "${YELLOW}⏳ CPU is waiting for ${names[i]} to arrive at time ${arrival[i]} ms${RESET}"
            start[i]=${arrival[i]}
        fi
        
        waiting[i]=$((start[i] - arrival[i]))
        turnaround[i]=$((waiting[i] + action[i]))

        total_waiting=$((total_waiting + waiting[i]))
        total_turnaround=$((total_turnaround + turnaround[i]))

        echo -e "${GREEN}➡️ Process ${names[i]} starts at time ${start[i]} ms, finishes at time $((start[i] + action[i])) ms${RESET}"
        echo -e "   ➡️ Waiting Time: ${waiting[i]} ms"
        echo -e "   ➡️ Turnaround Time: ${turnaround[i]} ms"
        echo "-------------------------------------"

        # ✅ Add context switch overhead (between processes)
        total_context_switch=$((total_context_switch + context_switch_time))
    done
    
    avg_waiting=$((total_waiting / n))
    avg_turnaround=$((total_turnaround / n))
    throughput=$(echo "scale=4; $n / $((start[n-1] + action[n-1] + total_context_switch))" | bc)

    echo -e "\n${GREEN}FCFS - Average Waiting Time: ${avg_waiting} ms${RESET}"
    echo -e "${GREEN}FCFS - Average Turnaround Time: ${avg_turnaround} ms${RESET}"
    echo -e "${GREEN}FCFS - Throughput: ${throughput} actions/ms${RESET}"
    echo -e "${GREEN}FCFS - Total Context Switching Overhead: ${total_context_switch} ms${RESET}"
}

# ✅ Function to simulate RR scheduling
rr() {
    local n=$1
    local names=("${!2}")
    local arrival=("${!3}")
    local action=("${!4}")
    local quantum=$5
    
    local remaining=("${action[@]}")
    local completion=()
    local waiting=()
    local turnaround=()
    local time=0
    local total_context_switch=0
    local total_waiting=0
    local total_turnaround=0

    echo -e "\n${CYAN}=== Step-by-Step Round Robin Scheduling (Quantum = ${quantum} ms) ===${RESET}"

    while true; do
        done=true
        for ((i = 0; i < n; i++)); do
            if ((remaining[i] > 0)); then
                done=false
                if ((remaining[i] > quantum)); then
                    echo -e "${GREEN}➡️ Process ${names[i]} runs for ${quantum} ms (Remaining: $((remaining[i] - quantum)) ms)${RESET}"
                    time=$((time + quantum))
                    remaining[i]=$((remaining[i] - quantum))
                else
                    echo -e "${GREEN}➡️ Process ${names[i]} runs for ${remaining[i]} ms (Completes)${RESET}"
                    time=$((time + remaining[i]))
                    remaining[i]=0
                    completion[i]=$time
                fi

                # ✅ Add context switch time after each switch
                total_context_switch=$((total_context_switch + context_switch_time))
            fi
        done
        if $done; then break; fi
    done

    for ((i = 0; i < n; i++)); do
        turnaround[i]=$((completion[i] - arrival[i]))
        waiting[i]=$((turnaround[i] - action[i]))

        total_waiting=$((total_waiting + waiting[i]))
        total_turnaround=$((total_turnaround + turnaround[i]))
    done

    avg_waiting=$((total_waiting / n))
    avg_turnaround=$((total_turnaround / n))
    throughput=$(echo "scale=4; $n / $((time + total_context_switch))" | bc)

    echo -e "\n${GREEN}RR - Average Waiting Time: ${avg_waiting} ms${RESET}"
    echo -e "${GREEN}RR - Average Turnaround Time: ${avg_turnaround} ms${RESET}"
    echo -e "${GREEN}RR - Throughput: ${throughput} actions/ms${RESET}"
    echo -e "${GREEN}RR - Total Context Switching Overhead: ${total_context_switch} ms${RESET}"
}

# ✅ MAIN SCRIPT
echo -e "${BLUE}🎯 WELCOME TO THE CPU SCHEDULER SIMULATOR 🎯${RESET}"
read -p "Enter number of players: " n

for ((i = 0; i < n; i++)); do
    read -p "👉 Enter name for player $((i + 1)): " name
    players+=("$name")
    read -p "🎮 Enter arrival time for $name (ms): " at
    arrival+=("$at")
    read -p "⚡ Enter action time for $name (ms): " bt
    action+=("$bt")
done

sort_by_arrival "$n" players[@] arrival[@] action[@]

read -p "Enter context switch time (ms): " context_switch_time
read -p "Enter time quantum for RR (default = 20 ms): " quantum
quantum=${quantum:-20}

fcfs "$n" players[@] arrival[@] action[@]
rr "$n" players[@] arrival[@] action[@] "$quantum"

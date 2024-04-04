#!/bin/bash

# Set default values
# Multiple RPC supported
RPC_URLS=("https://api.mainnet-beta.solana.com")
KEYS_FILE="keys.txt"
DEFAULT_FEE=100000
DEFAULT_THREADS=20

# Assign arguments with defaults
FEE=${2:-$DEFAULT_FEE}
THREADS=${3:-$DEFAULT_THREADS}

while IFS= read -r KEY; do
  # Loop indefinitely for each key
  (
    while true; do
      echo "Starting the process for key: ${KEY:0:8}..."
      RPC_URL=${RPC_URLS[$RANDOM % ${#RPC_URLS[@]}]}
      echo "Using RPC URL: ${RPC_URL}"
      
      # Execute the command in background
      "./target/release/ore" --rpc ${RPC_URL} --keypair "${KEY}" --priority-fee ${FEE} mine --threads ${THREADS} &
      
      PID=$!
      wait $PID
      [ $? -eq 0 ] && break
      
      echo "Process for key: ${KEY:0:8} exited with an error. Restarting in 5 seconds..."
      sleep 5
    done
  ) &
done < "$KEYS_FILE"

# Wait for all background processes to finish
wait

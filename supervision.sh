#!/bin/bash

# Set default values
# Multiple RPC supported
RPC_URLS=("https://api.mainnet-beta.solana.com")
DEFAULT_KEY="id.json"
DEFAULT_FEE=100000
DEFAULT_THREADS=20

# Assign arguments with defaults
KEY=${1:-$DEFAULT_KEY}
FEE=${3:-$DEFAULT_FEE}
THREADS=${4:-$DEFAULT_THREADS}

# Command and its arguments, with dynamic values
COMMAND="./target/release/ore --rpc ${RPC_URL} --keypair ${KEY} --priority-fee ${FEE} mine --threads ${THREADS}"

# Loop indefinitely
while true; do
  echo "Starting the process..."
  RPC_URL=${RPC_URLS[$RANDOM % ${#RPC_URLS[@]}]}
  echo "Starting the process with RPC URL: ${RPC_URL}"
  # Execute the command
  eval $COMMAND
  
  # If the command was successful, exit the loop
  # Remove this if you always want to restart regardless of exit status
  [ $? -eq 0 ] && break
  
  echo "Process exited with an error. Restarting in 5 seconds..."
  sleep 5
done
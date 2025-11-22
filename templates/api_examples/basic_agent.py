"""
Basic Agent API Example

This example shows how to create and run an agent via the REST API.
"""

import requests

# Base URL
BASE_URL = "http://localhost:8000/api/v1"

# Authentication token (get from login endpoint)
TOKEN = "your-auth-token"

headers = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json"
}

# Create an agent
agent_data = {
    "id": "calculator",
    "name": "Calculator Agent",
    "instructions": "You are a helpful calculator assistant."
}

response = requests.post(
    f"{BASE_URL}/agents/",
    json=agent_data,
    headers=headers
)
agent = response.json()
print(f"Created agent: {agent['id']}")

# Run the agent
run_data = {
    "input": "What's 15% tip on $87.50?"
}

response = requests.post(
    f"{BASE_URL}/agents/{agent['id']}/run",
    json=run_data,
    headers=headers
)
result = response.json()
print(f"Result: {result['output']}")

package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/agentfactory/go-sdk"
)

// Example: Create a new agent
func exampleCreateAgent(client *agentfactory.Client) (*agentfactory.Agent, error) {
	agent, err := client.Agents.Create(&agentfactory.CreateAgentRequest{
		Name:           "Customer Support Bot",
		BlueprintID:    "support_bot_blueprint",
		KnowledgeBaseID: "kb_123",
		Description:    "AI-powered customer support agent",
	})
	if err != nil {
		return nil, fmt.Errorf("error creating agent: %w", err)
	}
	fmt.Printf("Agent created: %s\n", agent.ID)
	return agent, nil
}

// Example: Get an agent
func exampleGetAgent(client *agentfactory.Client, agentID string) (*agentfactory.Agent, error) {
	agent, err := client.Agents.Get(agentID)
	if err != nil {
		return nil, fmt.Errorf("error getting agent: %w", err)
	}
	fmt.Printf("Agent: %s\n", agent.Name)
	return agent, nil
}

// Example: Chat with an agent
func exampleChatWithAgent(client *agentfactory.Client, agentID, message string) (*agentfactory.Message, error) {
	agent, err := client.Agents.Get(agentID)
	if err != nil {
		return nil, fmt.Errorf("error getting agent: %w", err)
	}

	conversation, err := agent.Conversations.Create()
	if err != nil {
		return nil, fmt.Errorf("error creating conversation: %w", err)
	}

	response, err := conversation.SendMessage(message)
	if err != nil {
		return nil, fmt.Errorf("error sending message: %w", err)
	}
	fmt.Printf("Agent response: %s\n", response.Text)
	return response, nil
}

// Example: Create a knowledge base
func exampleCreateKnowledgeBase(client *agentfactory.Client) (*agentfactory.KnowledgeBase, error) {
	kb, err := client.KnowledgeBases.Create(&agentfactory.CreateKnowledgeBaseRequest{
		Name:        "Product Knowledge Base",
		Description: "Knowledge base for product information",
	})
	if err != nil {
		return nil, fmt.Errorf("error creating knowledge base: %w", err)
	}
	fmt.Printf("Knowledge base created: %s\n", kb.ID)

	// Add documents
	doc := &agentfactory.Document{
		Content: "Product X is our flagship product...",
		Metadata: map[string]interface{}{
			"title":    "Product X Overview",
			"category": "products",
		},
	}
	err = kb.Documents.Add(doc)
	if err != nil {
		return nil, fmt.Errorf("error adding document: %w", err)
	}
	fmt.Println("Document added to knowledge base")
	return kb, nil
}

// Example: Query a knowledge base
func exampleQueryKnowledgeBase(client *agentfactory.Client, kbID, query string) ([]*agentfactory.SearchResult, error) {
	kb, err := client.KnowledgeBases.Get(kbID)
	if err != nil {
		return nil, fmt.Errorf("error getting knowledge base: %w", err)
	}

	results, err := kb.Query(query, &agentfactory.QueryOptions{Limit: 5})
	if err != nil {
		return nil, fmt.Errorf("error querying knowledge base: %w", err)
	}
	fmt.Printf("Found %d results:\n", len(results))
	for _, result := range results {
		fmt.Printf("- %s: %s\n", result.Title, result.Snippet)
	}
	return results, nil
}

// Example: Create a webhook
func exampleCreateWebhook(client *agentfactory.Client) (*agentfactory.Webhook, error) {
	webhook, err := client.Webhooks.Create(&agentfactory.CreateWebhookRequest{
		Name:   "My Webhook",
		URL:    "https://example.com/webhooks/agentfactory",
		Events: []string{"agent.created", "conversation.message"},
		Secret: "your_webhook_secret",
	})
	if err != nil {
		return nil, fmt.Errorf("error creating webhook: %w", err)
	}
	fmt.Printf("Webhook created: %s\n", webhook.ID)
	return webhook, nil
}

// Example: List all agents
func exampleListAgents(client *agentfactory.Client) ([]*agentfactory.Agent, error) {
	agents, err := client.Agents.List(&agentfactory.ListOptions{Limit: 10})
	if err != nil {
		return nil, fmt.Errorf("error listing agents: %w", err)
	}
	fmt.Printf("Found %d agents:\n", len(agents))
	for _, agent := range agents {
		fmt.Printf("- %s (%s)\n", agent.Name, agent.ID)
	}
	return agents, nil
}

// Example: Handle rate limits with retry
func exampleRateLimitHandling(client *agentfactory.Client) ([]*agentfactory.Agent, error) {
	maxRetries := 3
	retryCount := 0

	for retryCount < maxRetries {
		agents, err := client.Agents.List(nil)
		if err == nil {
			return agents, nil
		}

		if rateLimitErr, ok := err.(*agentfactory.RateLimitError); ok {
			retryCount++
			if retryCount >= maxRetries {
				return nil, fmt.Errorf("max retries reached: %w", err)
			}

			waitTime := rateLimitErr.RetryAfter
			if waitTime == 0 {
				waitTime = 60
			}
			fmt.Printf("Rate limit exceeded. Retrying in %d seconds...\n", waitTime)
			time.Sleep(time.Duration(waitTime) * time.Second)
		} else {
			return nil, err
		}
	}
	return nil, fmt.Errorf("max retries reached")
}

// Example: Comprehensive error handling
func exampleErrorHandling(client *agentfactory.Client) {
	_, err := client.Agents.Get("invalid_agent_id")
	if err != nil {
		if apiErr, ok := err.(*agentfactory.APIError); ok {
			switch apiErr.StatusCode {
			case 404:
				fmt.Println("Agent not found")
			case 401:
				fmt.Println("Authentication failed")
			case 429:
				fmt.Println("Rate limit exceeded")
			default:
				fmt.Printf("API Error: %s (Status: %d)\n", apiErr.Message, apiErr.StatusCode)
			}
		} else {
			fmt.Printf("Error: %v\n", err)
		}
	}
}

func main() {
	// Initialize client
	apiKey := os.Getenv("AGENTFACTORY_API_KEY")
	if apiKey == "" {
		apiKey = "your_api_key"
	}
	client := agentfactory.NewClient(apiKey)

	fmt.Println("Agent Factory Go SDK Examples")
	fmt.Println("==============================")

	// Example 1: Create agent
	fmt.Println("\n1. Creating agent...")
	agent, err := exampleCreateAgent(client)
	if err != nil {
		log.Printf("Error: %v\n", err)
	} else {
		// Example 2: Get agent
		fmt.Println("\n2. Getting agent...")
		_, err = exampleGetAgent(client, agent.ID)
		if err != nil {
			log.Printf("Error: %v\n", err)
		}

		// Example 3: Chat with agent
		fmt.Println("\n3. Chatting with agent...")
		_, err = exampleChatWithAgent(client, agent.ID, "Hello, how can you help me?")
		if err != nil {
			log.Printf("Error: %v\n", err)
		}
	}

	// Example 4: Create knowledge base
	fmt.Println("\n4. Creating knowledge base...")
	kb, err := exampleCreateKnowledgeBase(client)
	if err != nil {
		log.Printf("Error: %v\n", err)
	} else {
		// Example 5: Query knowledge base
		fmt.Println("\n5. Querying knowledge base...")
		_, err = exampleQueryKnowledgeBase(client, kb.ID, "What is Product X?")
		if err != nil {
			log.Printf("Error: %v\n", err)
		}
	}

	// Example 6: Create webhook
	fmt.Println("\n6. Creating webhook...")
	_, err = exampleCreateWebhook(client)
	if err != nil {
		log.Printf("Error: %v\n", err)
	}

	// Example 7: List agents
	fmt.Println("\n7. Listing agents...")
	_, err = exampleListAgents(client)
	if err != nil {
		log.Printf("Error: %v\n", err)
	}

	// Example 8: Rate limit handling
	fmt.Println("\n8. Rate limit handling...")
	_, err = exampleRateLimitHandling(client)
	if err != nil {
		log.Printf("Error: %v\n", err)
	}

	// Example 9: Error handling
	fmt.Println("\n9. Error handling...")
	exampleErrorHandling(client)

	fmt.Println("\n==============================")
	fmt.Println("Examples completed!")
}

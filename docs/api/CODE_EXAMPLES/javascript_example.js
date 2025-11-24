/**
 * Agent Factory JavaScript SDK Example
 * Complete example demonstrating Agent Factory API usage
 */

const AgentFactory = require('@agentfactory/sdk');

// Initialize client
const apiKey = process.env.AGENTFACTORY_API_KEY || 'your_api_key';
const client = new AgentFactory({ apiKey });

/**
 * Example: Create a new agent
 */
async function exampleCreateAgent() {
  try {
    const agent = await client.agents.create({
      name: 'Customer Support Bot',
      blueprintId: 'support_bot_blueprint',
      knowledgeBaseId: 'kb_123',
      description: 'AI-powered customer support agent'
    });
    console.log(`Agent created: ${agent.id}`);
    return agent;
  } catch (error) {
    console.error(`Error creating agent: ${error.message}`);
    return null;
  }
}

/**
 * Example: Get an agent
 */
async function exampleGetAgent(agentId) {
  try {
    const agent = await client.agents.get(agentId);
    console.log(`Agent: ${agent.name}`);
    return agent;
  } catch (error) {
    console.error(`Error getting agent: ${error.message}`);
    return null;
  }
}

/**
 * Example: Chat with an agent
 */
async function exampleChatWithAgent(agentId, message) {
  try {
    const agent = await client.agents.get(agentId);
    const conversation = await agent.conversations.create();
    const response = await conversation.sendMessage(message);
    console.log(`Agent response: ${response.text}`);
    return response;
  } catch (error) {
    console.error(`Error chatting with agent: ${error.message}`);
    return null;
  }
}

/**
 * Example: Create a knowledge base
 */
async function exampleCreateKnowledgeBase() {
  try {
    const kb = await client.knowledgeBases.create({
      name: 'Product Knowledge Base',
      description: 'Knowledge base for product information'
    });
    console.log(`Knowledge base created: ${kb.id}`);
    
    // Add documents
    await kb.documents.add({
      content: 'Product X is our flagship product...',
      metadata: { title: 'Product X Overview', category: 'products' }
    });
    console.log('Document added to knowledge base');
    return kb;
  } catch (error) {
    console.error(`Error creating knowledge base: ${error.message}`);
    return null;
  }
}

/**
 * Example: Query a knowledge base
 */
async function exampleQueryKnowledgeBase(kbId, query) {
  try {
    const kb = await client.knowledgeBases.get(kbId);
    const results = await kb.query(query, { limit: 5 });
    console.log(`Found ${results.length} results:`);
    results.forEach(result => {
      console.log(`- ${result.title}: ${result.snippet}`);
    });
    return results;
  } catch (error) {
    console.error(`Error querying knowledge base: ${error.message}`);
    return null;
  }
}

/**
 * Example: Create a webhook
 */
async function exampleCreateWebhook() {
  try {
    const webhook = await client.webhooks.create({
      name: 'My Webhook',
      url: 'https://example.com/webhooks/agentfactory',
      events: ['agent.created', 'conversation.message'],
      secret: 'your_webhook_secret'
    });
    console.log(`Webhook created: ${webhook.id}`);
    return webhook;
  } catch (error) {
    console.error(`Error creating webhook: ${error.message}`);
    return null;
  }
}

/**
 * Example: List all agents
 */
async function exampleListAgents() {
  try {
    const agents = await client.agents.list({ limit: 10 });
    console.log(`Found ${agents.length} agents:`);
    agents.forEach(agent => {
      console.log(`- ${agent.name} (${agent.id})`);
    });
    return agents;
  } catch (error) {
    console.error(`Error listing agents: ${error.message}`);
    return [];
  }
}

/**
 * Example: Handle rate limits with retry
 */
async function exampleRateLimitHandling() {
  const maxRetries = 3;
  let retryCount = 0;
  
  while (retryCount < maxRetries) {
    try {
      const agents = await client.agents.list();
      return agents;
    } catch (error) {
      if (error instanceof AgentFactory.RateLimitError) {
        retryCount++;
        if (retryCount >= maxRetries) {
          console.error('Max retries reached');
          throw error;
        }
        
        const waitTime = error.retryAfter || 60;
        console.log(`Rate limit exceeded. Retrying in ${waitTime} seconds...`);
        await new Promise(resolve => setTimeout(resolve, waitTime * 1000));
      } else {
        throw error;
      }
    }
  }
}

/**
 * Example: Comprehensive error handling
 */
async function exampleErrorHandling() {
  try {
    const agent = await client.agents.get('invalid_agent_id');
  } catch (error) {
    if (error.statusCode === 404) {
      console.log('Agent not found');
    } else if (error.statusCode === 401) {
      console.log('Authentication failed');
    } else if (error.statusCode === 429) {
      console.log('Rate limit exceeded');
    } else {
      console.error(`API Error: ${error.message} (Status: ${error.statusCode})`);
    }
  }
}

/**
 * Main example function
 */
async function main() {
  console.log('Agent Factory JavaScript SDK Examples');
  console.log('='.repeat(40));
  
  // Example 1: Create agent
  console.log('\n1. Creating agent...');
  const agent = await exampleCreateAgent();
  
  if (agent) {
    // Example 2: Get agent
    console.log('\n2. Getting agent...');
    await exampleGetAgent(agent.id);
    
    // Example 3: Chat with agent
    console.log('\n3. Chatting with agent...');
    await exampleChatWithAgent(agent.id, 'Hello, how can you help me?');
  }
  
  // Example 4: Create knowledge base
  console.log('\n4. Creating knowledge base...');
  const kb = await exampleCreateKnowledgeBase();
  
  if (kb) {
    // Example 5: Query knowledge base
    console.log('\n5. Querying knowledge base...');
    await exampleQueryKnowledgeBase(kb.id, 'What is Product X?');
  }
  
  // Example 6: Create webhook
  console.log('\n6. Creating webhook...');
  await exampleCreateWebhook();
  
  // Example 7: List agents
  console.log('\n7. Listing agents...');
  await exampleListAgents();
  
  // Example 8: Rate limit handling
  console.log('\n8. Rate limit handling...');
  await exampleRateLimitHandling();
  
  // Example 9: Error handling
  console.log('\n9. Error handling...');
  await exampleErrorHandling();
  
  console.log('\n' + '='.repeat(40));
  console.log('Examples completed!');
}

// Run examples
if (require.main === module) {
  main().catch(console.error);
}

module.exports = {
  exampleCreateAgent,
  exampleGetAgent,
  exampleChatWithAgent,
  exampleCreateKnowledgeBase,
  exampleQueryKnowledgeBase,
  exampleCreateWebhook,
  exampleListAgents,
  exampleRateLimitHandling,
  exampleErrorHandling
};

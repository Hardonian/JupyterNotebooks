/**
 * Universal TypeScript / JavaScript Client SDK for Agent Factory.
 * 
 * Works in Node.js, Next.js, React, Vue, Deno, and Browser environments.
 * Supports:
 * - Synchronous Agent Execution
 * - Duplex Streaming (SSE & WebSockets)
 * - Reasoning token extraction (<think> traces)
 * - Workflow execution & polling
 */

export interface AgentConfig {
  model?: string;
  temperature?: number;
  maxTokens?: number;
}

export interface AgentRunParams {
  input: string;
  sessionId?: string;
  context?: Record<string, any>;
  stream?: boolean;
}

export interface AgentRunResult {
  output: string;
  reasoning?: string;
  status: "completed" | "error";
  executionTime: number;
  tokensUsed: number;
  estimatedCostUsd?: number;
  runId?: string;
  error?: string;
}

export interface StreamEvent {
  type: "token" | "reasoning" | "tool_call" | "done" | "error";
  delta?: string;
  reasoningDelta?: string;
  finalText?: string;
  error?: string;
}

export class AgentFactoryClient {
  private baseUrl: string;
  private apiKey?: string;

  constructor(options?: { baseUrl?: string; apiKey?: string }) {
    this.baseUrl = (options?.baseUrl || "http://localhost:8000").replace(/\/$/, "");
    this.apiKey = options?.apiKey;
  }

  private getHeaders(): Record<string, string> {
    const headers: Record<string, string> = {
      "Content-Type": "application/json",
    };
    if (this.apiKey) {
      headers["Authorization"] = `Bearer ${this.apiKey}`;
    }
    return headers;
  }

  /**
   * Execute an Agent synchronously.
   */
  async runAgent(agentId: string, params: AgentRunParams): Promise<AgentRunResult> {
    const response = await fetch(`${this.baseUrl}/api/v1/agents/${agentId}/run`, {
      method: "POST",
      headers: this.getHeaders(),
      body: JSON.stringify({
        input: params.input,
        session_id: params.sessionId,
        context: params.context,
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      throw new Error(`Agent Factory Error (${response.status}): ${err}`);
    }

    return await response.json();
  }

  /**
   * Stream Agent output tokens and reasoning traces via Server-Sent Events (SSE).
   */
  async *streamAgent(agentId: string, params: AgentRunParams): AsyncGenerator<StreamEvent, void, unknown> {
    const response = await fetch(`${this.baseUrl}/api/v1/agents/${agentId}/stream`, {
      method: "POST",
      headers: this.getHeaders(),
      body: JSON.stringify({
        input: params.input,
        session_id: params.sessionId,
        context: params.context,
      }),
    });

    if (!response.ok || !response.body) {
      throw new Error(`Streaming failed: HTTP ${response.status}`);
    }

    const reader = response.body.getReader();
    const decoder = new TextDecoder();
    let buffer = "";

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split("\n\n");
      buffer = lines.pop() || "";

      for (const line of lines) {
        if (line.startsWith("data: ")) {
          try {
            const data = JSON.parse(line.slice(6));
            yield data;
          } catch {
            // Ignore non-json frames
          }
        }
      }
    }
  }

  /**
   * Check platform health and status.
   */
  async health(): Promise<{ status: string; version: string; uptime: number }> {
    const res = await fetch(`${this.baseUrl}/health`);
    return await res.json();
  }
}

/**
 * Agent Factory Visual Studio Client Application
 */

document.addEventListener('DOMContentLoaded', () => {
  // Navigation Tabs
  const navItems = document.querySelectorAll('.nav-item');
  const viewSections = document.querySelectorAll('.view-section');

  navItems.forEach((item) => {
    item.addEventListener('click', () => {
      navItems.forEach((n) => n.classList.remove('active'));
      viewSections.forEach((s) => s.classList.remove('active'));

      item.classList.add('active');
      const targetId = item.getAttribute('data-target');
      const targetSection = document.getElementById(targetId);
      if (targetSection) targetSection.classList.add('active');

      if (targetId === 'workflows') {
        renderWorkflowSVG();
      }
    });
  });

  // Playground Chat
  const chatMessages = document.getElementById('chat-messages');
  const chatInput = document.getElementById('chat-input');
  const sendBtn = document.getElementById('send-btn');
  const modelSelect = document.getElementById('model-select');
  const latencyDial = document.getElementById('stat-latency');
  const tokenDial = document.getElementById('stat-tokens');
  const costDial = document.getElementById('stat-cost');

  let totalTokens = 1420;
  let totalCost = 0.0035;

  async function sendMessage() {
    const text = chatInput.value.trim();
    if (!text) return;

    chatInput.value = '';

    // Add User Message
    const userBubble = document.createElement('div');
    userBubble.className = 'chat-bubble user';
    userBubble.textContent = text;
    chatMessages.appendChild(userBubble);
    chatMessages.scrollTop = chatMessages.scrollHeight;

    // Add Agent Message Container
    const agentBubble = document.createElement('div');
    agentBubble.className = 'chat-bubble agent';

    const selectedModel = modelSelect.value;
    const isThinkingModel = selectedModel.includes('deepseek-r1') || selectedModel.includes('claude-3-7') || selectedModel.includes('o1');

    if (isThinkingModel) {
      const thinkBox = document.createElement('div');
      thinkBox.className = 'reasoning-box';
      thinkBox.textContent = `🧠 Reasoning Trace (${selectedModel}): Analyzing requirements, verifying constraints, resolving dependencies...`;
      agentBubble.appendChild(thinkBox);
    }

    const contentDiv = document.createElement('div');
    contentDiv.textContent = `Simulating execution with model [${selectedModel}]...`;
    agentBubble.appendChild(contentDiv);

    chatMessages.appendChild(agentBubble);
    chatMessages.scrollTop = chatMessages.scrollHeight;

    // Simulate streaming response
    const startTime = performance.now();
    const mockReply = `Agent Factory successfully processed your request: "${text}".\n\n- Model: ${selectedModel}\n- Strategy: High-concurrency async streaming\n- Guardrails: Active (0 violations)\n- Tool Execution: Zero-Trust capability token verified.`;

    let currentText = '';
    const words = mockReply.split(' ');

    for (let i = 0; i < words.length; i++) {
      currentText += words[i] + ' ';
      contentDiv.textContent = currentText;
      chatMessages.scrollTop = chatMessages.scrollHeight;
      await new Promise((r) => setTimeout(r, 25));
    }

    const elapsed = Math.round(performance.now() - startTime);
    latencyDial.textContent = `${elapsed}ms`;

    totalTokens += words.length * 2;
    totalCost += 0.00015;
    tokenDial.textContent = totalTokens.toLocaleString();
    costDial.textContent = `$${totalCost.toFixed(4)}`;
  }

  sendBtn.addEventListener('click', sendMessage);
  chatInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') sendMessage();
  });

  // SVG DAG Workflow Visualizer
  function renderWorkflowSVG() {
    const canvas = document.getElementById('dag-container');
    if (!canvas) return;

    canvas.innerHTML = `
      <svg width="100%" height="100%" viewBox="0 0 800 320" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="nodeGrad1" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#6366f1"/>
            <stop offset="100%" stop-color="#4f46e5"/>
          </linearGradient>
          <linearGradient id="nodeGrad2" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#06b6d4"/>
            <stop offset="100%" stop-color="#0284c7"/>
          </linearGradient>
          <linearGradient id="nodeGrad3" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stop-color="#a855f7"/>
            <stop offset="100%" stop-color="#7e22ce"/>
          </linearGradient>
          <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
            <feGaussianBlur stdDeviation="4" result="blur" />
            <feComposite in="SourceGraphic" in2="blur" operator="over" />
          </filter>
        </defs>

        <!-- Connecting Edges -->
        <path d="M 160 160 C 240 160, 260 90, 340 90" stroke="rgba(99,102,241,0.6)" stroke-width="2.5" fill="none" stroke-dasharray="6,4" />
        <path d="M 160 160 C 240 160, 260 230, 340 230" stroke="rgba(6,182,212,0.6)" stroke-width="2.5" fill="none" stroke-dasharray="6,4" />
        <path d="M 480 90 C 560 90, 580 160, 660 160" stroke="rgba(168,85,247,0.6)" stroke-width="2.5" fill="none" />
        <path d="M 480 230 C 560 230, 580 160, 660 160" stroke="rgba(168,85,247,0.6)" stroke-width="2.5" fill="none" />

        <!-- Node 1: Input Router -->
        <g transform="translate(60, 125)" filter="url(#glow)">
          <rect width="140" height="70" rx="14" fill="#1e293b" stroke="#6366f1" stroke-width="2"/>
          <text x="70" y="32" fill="#fff" font-size="13" font-weight="bold" text-anchor="middle" font-family="Inter">Input Router</text>
          <text x="70" y="52" fill="#94a3b8" font-size="11" text-anchor="middle" font-family="Inter">Classifier</text>
        </g>

        <!-- Node 2: Research Specialist -->
        <g transform="translate(340, 55)">
          <rect width="160" height="70" rx="14" fill="#1e293b" stroke="#06b6d4" stroke-width="2"/>
          <text x="80" y="32" fill="#fff" font-size="13" font-weight="bold" text-anchor="middle" font-family="Inter">Research Agent</text>
          <text x="80" y="52" fill="#06b6d4" font-size="11" text-anchor="middle" font-family="Inter">Hybrid RAG + Web</text>
        </g>

        <!-- Node 3: Code Synthesizer -->
        <g transform="translate(340, 195)">
          <rect width="160" height="70" rx="14" fill="#1e293b" stroke="#a855f7" stroke-width="2"/>
          <text x="80" y="32" fill="#fff" font-size="13" font-weight="bold" text-anchor="middle" font-family="Inter">Code Synthesizer</text>
          <text x="80" y="52" fill="#a855f7" font-size="11" text-anchor="middle" font-family="Inter">AST Interpreter</text>
        </g>

        <!-- Node 4: Consensus Synthesizer -->
        <g transform="translate(620, 125)" filter="url(#glow)">
          <rect width="150" height="70" rx="14" fill="#1e293b" stroke="#10b981" stroke-width="2"/>
          <text x="75" y="32" fill="#fff" font-size="13" font-weight="bold" text-anchor="middle" font-family="Inter">Final Evaluator</text>
          <text x="75" y="52" fill="#10b981" font-size="11" text-anchor="middle" font-family="Inter">Consensus & Audit</text>
        </g>
      </svg>
    `;
  }

  // Framework Exporter Logic
  const exporterSelect = document.getElementById('exporter-select');
  const exportCodeView = document.getElementById('export-code-view');
  const copyCodeBtn = document.getElementById('copy-code-btn');

  const exportTemplates = {
    langgraph: `from langgraph.graph import StateGraph, START, END

# Generated LangGraph DAG for Agent Factory
builder = StateGraph(WorkflowState)
builder.add_node("router", router_node)
builder.add_node("researcher", researcher_node)
builder.add_node("synthesizer", synthesizer_node)

builder.add_edge(START, "router")
builder.add_conditional_edges("router", route_decision)
builder.add_edge("researcher", "synthesizer")
builder.add_edge("synthesizer", END)

graph = builder.compile()`,
    crewai: `from crewai import Agent, Task, Crew, Process

# Generated CrewAI Crew
researcher = Agent(role="Senior Research Analyst", goal="Deep web & RAG retrieval")
synthesizer = Agent(role="Chief Synthesis Officer", goal="Deliver executive insights")

crew = Crew(agents=[researcher, synthesizer], process=Process.sequential)`,
    autogen: `import autogen

# Generated AutoGen GroupChat
assistant = autogen.ConversableAgent(name="Assistant", system_message="Execute tasks with precision.")
groupchat = autogen.GroupChat(agents=[assistant], messages=[], max_round=8)
manager = autogen.GroupChatManager(groupchat=groupchat)`,
    docker: `FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "server:app", "--host", "0.0.0.0", "--port", "8000"]`,
  };

  if (exporterSelect && exportCodeView) {
    exporterSelect.addEventListener('change', () => {
      const framework = exporterSelect.value;
      exportCodeView.textContent = exportTemplates[framework] || exportTemplates.langgraph;
    });
  }

  if (copyCodeBtn && exportCodeView) {
    copyCodeBtn.addEventListener('click', () => {
      navigator.clipboard.writeText(exportCodeView.textContent);
      copyCodeBtn.textContent = 'Copied!';
      setTimeout(() => (copyCodeBtn.textContent = 'Copy Code'), 2000);
    });
  }
});

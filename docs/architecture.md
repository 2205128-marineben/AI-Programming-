# System Architecture

## M-Float AI Customer Support Assistant

### High-Level Design

The system follows a **modular expert system architecture** where each component has a single responsibility. Data flows through a linear pipeline from user input to response output.

```
┌─────────────┐     ┌─────────────┐     ┌──────────────────┐
│    User     │────▶│  Chatbot    │────▶│   NLP Module     │
│  Interface  │◀────│  (UI Loop)  │◀────│  (Preprocess)    │
└─────────────┘     └──────┬──────┘     └────────┬─────────┘
                           │                       │
                           │              ┌────────▼─────────┐
                           │              │ Pattern Matcher  │
                           │              │ (Intent Detect)│
                           │              └────────┬─────────┘
                           │                       │
                           │              ┌────────▼─────────┐
                           │              │ Inference Engine │
                           │              │  (IF-THEN Rules) │
                           │              └────────┬─────────┘
                           │                       │
                           │              ┌────────▼─────────┐
                           └──────────────│ Response Generator│
                                          │ + Knowledge Base  │
                                          └──────────────────┘
```

### Module Responsibilities

| Module | File | Responsibility |
|--------|------|----------------|
| Main Program | `main.lisp` | Load modules, provide entry points |
| User Interface | `chatbot.lisp` | Conversation loop, greeting, follow-up prompts |
| NLP Module | `nlp.lisp` | Orchestrate preprocessing pipeline |
| Tokenizer | `tokenizer.lisp` | Lowercase, strip punctuation, tokenize, remove stopwords |
| Pattern Matcher | `pattern_matcher.lisp` | Score keyword groups, select best intent |
| Inference Engine | `inference_engine.lisp` | Apply IF-THEN rules to intents |
| Knowledge Base | `knowledge_base.lisp` | Intent patterns and response content |
| Response Generator | `response_generator.lisp` | Retrieve and format responses |
| Test Cases | `test_queries.lisp` | Automated intent recognition tests |

### Data Flow

1. **Input** — User types a natural language question
2. **NLP** — Text is lowercased, punctuation removed, tokenized, stopwords filtered
3. **Pattern Matching** — Normalized text is scored against keyword groups per intent
4. **Inference** — Matched intent triggers a symbolic rule (e.g., `IF BUY_FLOAT THEN respond-buy-float`)
5. **Response** — Knowledge base content is retrieved and displayed
6. **Loop** — System asks if more help is needed, or exits on goodbye

### Design Principles

- **Separation of concerns** — Rules and knowledge are data, not buried in code
- **Extensibility** — New intents require only knowledge base entries and one inference rule
- **Transparency** — Demonstration mode shows the full reasoning trace
- **Graceful degradation** — Unknown queries receive a helpful fallback message

### Technology Constraints

- Language: Common Lisp only
- AI approach: Symbolic / rule-based (no ML, no APIs, no LLMs)
- Search method: Substring pattern matching with scoring
- Knowledge representation: Associative lists (property lists)

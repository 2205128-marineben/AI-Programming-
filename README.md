# M-Float AI Customer Support Assistant

**Course:** CPP 4103 – Artificial Intelligence Programming  
**Project:** Design and Development of an Intelligent Customer Service Chatbot Using LISP and Natural Language Processing
**Group: I**
**Members:**
- Marine Benard — 22/05128
- Edison Ndungu — 24/03270
- Trevor Kabiriri — 24/04495
- Mark Mukenia — 24/03330


## Overview

This is a **classical AI expert system** with a conversational interface, built entirely in **Common Lisp**. It simulates customer support for **M-Float Tech Communications** using symbolic AI techniques:

- Natural Language Processing (NLP) preprocessing
- Pattern matching (keyword-group search)
- Rule-based inference engine
- Rule-based knowledge base

No machine learning, APIs, or large language models are used.

## Architecture

```
M-Float AI Chatbot
│
├── main.lisp              — Entry point
├── chatbot.lisp           — User interface & conversation loop
├── nlp.lisp               — NLP orchestration
├── tokenizer.lisp         — Text normalization & tokenization
├── pattern_matcher.lisp   — Intent detection via keyword groups
├── inference_engine.lisp  — IF intent THEN action rules
├── knowledge_base.lisp    — Intents, patterns, and responses
└── response_generator.lisp — Response retrieval
```

## Requirements

We Installed a Common Lisp implementation:

- **SBCL** (recommended): https://www.sbcl.org/
- **CLISP**: https://clisp.sourceforge.io/
- **ECL**: https://ecl.common-lisp.dev/

## Running the Chatbot

### Web interface (browser)

```bash
.\run-web.bat
```

Then open **http://localhost:8765** in your browser.

- Toggle **Demo: ON** to show NLP, intent, and inference traces
- All AI processing still runs in LISP (Hunchentoot web server)

### Interactive terminal mode

```bash
cd MFloat-AI-Chatbot/src
sbcl --load main.lisp
```

Then at the REPL:

```lisp
(main)
```

### Demonstration mode (shows AI reasoning traces)

```lisp
(main :demo)
```

Or from the command line:

```bash
sbcl --script main.lisp --demo
```

### Run tests (55 test queries)

```bash
sbcl --script main.lisp --test
```

Or at the REPL:

```lisp
(run-tests)
```

## Example Session

```
You: Hello
[Intent detected: Greeting]
Bot: Welcome to M-Float Tech Communications! I am your AI customer support assistant...

You: How do I become an agent?
[Intent detected: Agent Registration]
Bot: To become an M-Float agent: 1) Visit www.mfloat.co.ke/register...

You: Goodbye
Bot: Thank you for contacting M-Float Tech Communications. Have a great day! Goodbye.
```

## Knowledge Base

The system recognizes **29 intents** across these domains:

| Domain | Intents |
|--------|---------|
| Company | Info, Location, Hours, Contact |
| Float Services | Buy, Sell, Pricing, Limits, Transfer |
| Registration | Agent, Dealer, Documents |
| Accounts | Create, Login, Password Reset, Balance |
| Payments | Tokens, Methods, Confirmation |
| Support | Failed Transactions, Refunds, Complaints, Technical |

See `docs/knowledge_base.md` for the full intent catalog.

## Project Structure

```
MFloat-AI-Chatbot/
├── README.md
├── docs/
│   ├── architecture.md
│   ├── knowledge_base.md
│   └── algorithms.md
├── src/
│   ├── main.lisp
│   ├── chatbot.lisp
│   ├── nlp.lisp
│   ├── tokenizer.lisp
│   ├── pattern_matcher.lisp
│   ├── inference_engine.lisp
│   ├── knowledge_base.lisp
│   └── response_generator.lisp
├── tests/
│   ├── test_queries.lisp
│   └── expected_results.md
├── report/
├── presentation/
└── assets/
```

## Academic Framing

This project is an **expert system**, not a modern chatbot. The intelligence resides in:

1. **Knowledge Base** — domain facts and response templates
2. **Inference Engine** — symbolic IF-THEN rules mapping intents to actions
3. **NLP Pipeline** — preprocessing that enables flexible pattern matching

The chat interface is simply how users interact with the expert system.

## License

Academic project — CPP 4103, 2026.

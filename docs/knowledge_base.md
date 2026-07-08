# Knowledge Base

## M-Float Tech Communications — Intent Catalog

The knowledge base contains **29 intents** organized into 6 domains. Each intent has multiple keyword patterns (phrasings) and one response template.

---

## 1. Company Information

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `COMPANY_INFO` | "what is mfloat", "about company", "who are you" | Describes M-Float as a float management platform |
| `COMPANY_LOCATION` | "where are you located", "office address" | Nairobi, Kenya headquarters |
| `BUSINESS_HOURS` | "working hours", "when are you open" | Mon–Fri 8–6, Sat 9–1 |
| `CONTACT_INFO` | "contact support", "phone number", "email" | Phone, email, website |

---

## 2. Float Services

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `BUY_FLOAT` | "buy float", "purchase float", "top up float", "i want float" | Step-by-step float purchase procedure |
| `SELL_FLOAT` | "sell float", "transfer float", "send float" | Step-by-step float selling procedure |
| `FLOAT_PRICING` | "float price", "how much float", "commission rate" | Tier-based pricing and commission |
| `FLOAT_LIMITS` | "float limit", "maximum float", "daily limit" | Daily and minimum transaction limits |
| `FLOAT_TRANSFER` | "transfer float to sub agent", "allocate float" | Dealer-to-sub-agent transfer steps |

---

## 3. Agent & Dealer Registration

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `BECOME_AGENT` | "become agent", "register agent", "join as agent" | Agent registration procedure |
| `BECOME_DEALER` | "become dealer", "dealer registration" | Dealer application requirements |
| `REQUIRED_DOCUMENTS` | "required documents", "what documents" | ID, KRA PIN, business permit |
| `AGENT_COMMISSION` | "agent commission", "how much commission" | Commission structure by tier |

---

## 4. Customer Accounts

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `CREATE_ACCOUNT` | "create account", "open account", "sign up" | Account registration steps |
| `LOGIN` | "login", "log in", "sign in" | Login procedure |
| `RESET_PASSWORD` | "forgot password", "reset password" | Password recovery via OTP |
| `ACCOUNT_BALANCE` | "check balance", "my balance", "float balance" | Balance check methods |

---

## 5. Payments

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `BUY_TOKENS` | "buy tokens", "purchase tokens" | Token purchase procedure |
| `PAYMENT_METHODS` | "payment methods", "how to pay", "mpesa" | M-Pesa, bank transfer, wallet |
| `TRANSACTION_CONFIRMATION` | "transaction confirmation", "receipt" | SMS and dashboard confirmation |

---

## 6. Support

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `FAILED_TRANSACTION` | "transaction failed", "payment failed" | Troubleshooting steps |
| `REFUNDS` | "refund", "get money back", "reversal" | Refund policy and timeline |
| `COMPLAINTS` | "complaint", "file complaint", "unhappy" | Complaint submission process |
| `TECHNICAL_SUPPORT` | "technical support", "app not working" | Technical troubleshooting steps |
| `SECURITY` | "account security", "fraud", "protect account" | Security best practices |

---

## 7. Conversation Control

| Intent | Example Patterns | Response Summary |
|--------|-----------------|------------------|
| `GREETING` | "hello", "hi", "good morning" | Welcome message |
| `EXIT` | "goodbye", "bye", "exit", "quit" | Farewell message |
| `HELP` | "help", "what can you do", "menu" | List of available topics |
| `THANK_YOU` | "thank you", "thanks" | Acknowledgment |
| `UNKNOWN` | (no patterns — fallback) | Contact support suggestion |

---

## Updating the Knowledge Base

To add a new intent:

1. Add patterns to `*intent-patterns*` in `src/knowledge_base.lisp`
2. Add response text to `*intent-responses*` in the same file
3. Add a display name in `intent-display-name`
4. Add an inference rule in `*inference-rules*` in `src/inference_engine.lisp`
5. Add test cases in `tests/test_queries.lisp`

No other modules need modification.

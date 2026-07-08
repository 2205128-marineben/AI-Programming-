# Algorithms

## NLP Preprocessing Pipeline

The NLP module applies these steps in sequence:

```
Raw Input → Lowercase → Remove Punctuation → Normalize Spaces → Tokenize → Remove Stopwords → Tokens
```

### Step Details

1. **Lowercase** — `(string-downcase text)` for case-insensitive matching
2. **Remove punctuation** — Strip `? ! , . ; : " ' ( ) [ ]` and other non-alphanumeric characters
3. **Normalize spaces** — Collapse multiple spaces, trim leading/trailing whitespace
4. **Tokenize** — Split on whitespace into a list of word tokens
5. **Remove stopwords** — Filter common filler words (`the`, `a`, `is`, `can`, `please`, etc.)

### Example

```
Input:  "How do I buy float?"
Step 1: "how do i buy float?"
Step 2: "how do i buy float"
Step 3: "how do i buy float"
Step 4: ("how" "do" "i" "buy" "float")
Step 5: ("buy" "float")
Normalized text: "buy float"
```

## Pattern Matching Algorithm

### Approach: Keyword Group Scoring

Rather than exact sentence matching, the system uses **keyword groups** — multiple phrasings per intent stored in the knowledge base.

### Algorithm

```
FOR each intent IN knowledge_base:
    score = 0
    FOR each pattern IN intent.patterns:
        IF pattern is substring of normalized_text:
            score += length(pattern) × 10
    STORE (intent, score)

RETURN intent with highest score, or UNKNOWN if all scores are 0
```

### Why Scoring?

- Longer phrase matches are more specific (e.g., "buy float" scores higher than "float" alone)
- Multiple pattern hits accumulate, improving confidence
- Ties are broken by sort order (first highest wins)

### Example

```
Input: "I want to purchase float"
Normalized: "want purchase float"

BUY_FLOAT patterns matched:
  "purchase float" → score 140 (14 chars × 10)
  "want float"     → not matched (words reordered)

Result: BUY_FLOAT
```

## Rule-Based Inference

### Rule Format

Each rule is a symbolic IF-THEN mapping:

```
IF intent = BUY_FLOAT
THEN :respond-buy-float → retrieve BUY_FLOAT response from knowledge base
```

### Inference Process

```
1. Receive intent symbol (e.g., BECOME_AGENT)
2. Look up rule in *inference-rules* association list
3. Execute action (retrieve response from knowledge base)
4. Return response string to UI
```

### Rule Independence

Rules are stored as data in `*inference-rules*`, separate from procedural code. Adding a new intent requires:

1. Add patterns to `*intent-patterns*` in knowledge base
2. Add response to `*intent-responses*` in knowledge base
3. Add one rule to `*inference-rules*` in inference engine

## Complexity

| Operation | Complexity |
|-----------|------------|
| NLP preprocessing | O(n) where n = input length |
| Pattern matching | O(i × p × n) where i = intents, p = patterns per intent, n = text length |
| Inference | O(1) — direct association list lookup |
| Response retrieval | O(1) — direct association list lookup |

For 29 intents with ~8 patterns each, the system processes queries in sub-millisecond time on modern hardware.

## Unknown Query Handling

If no pattern scores above zero, the system:

1. Assigns intent `UNKNOWN`
2. Applies the unknown inference rule
3. Returns: *"I'm sorry, I don't have information about that yet..."*

This prevents silent failures and guides users toward supported topics.

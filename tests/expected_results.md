# Expected Test Results

## Test Suite: Intent Recognition

The test suite in `tests/test_queries.lisp` contains **67 test queries** covering all 29 intents plus unknown-query fallback.

Run tests:

```bash
sbcl --script src/main.lisp --test
```

---

## Core Test Cases (from project specification)

| User Input | Expected Intent |
|------------|----------------|
| Hello | Greeting |
| I want float | Buy Float |
| Become an agent | Agent Registration |
| Forgot password | Password Reset |
| My transaction failed | Failed Transaction |
| Working hours | Business Hours |
| Contact support | Contact Information |
| Goodbye | Exit |

---

## Full Test Matrix

### Greeting & Conversation

| Input | Expected Intent |
|-------|----------------|
| Hello | GREETING |
| Hi there! | GREETING |
| Good morning | GREETING |
| Hey | GREETING |
| Greetings | GREETING |
| Goodbye | EXIT |
| Bye | EXIT |
| Exit | EXIT |
| Quit | EXIT |
| See you later | EXIT |
| Help | HELP |
| What can you do? | HELP |
| Show me the menu | HELP |
| Thank you | THANK_YOU |
| Thanks a lot | THANK_YOU |

### Company Information

| Input | Expected Intent |
|-------|----------------|
| What is M-Float? | COMPANY_INFO |
| Tell me about the company | COMPANY_INFO |
| Who are you? | COMPANY_INFO |
| Where are you located? | COMPANY_LOCATION |
| Company address | COMPANY_LOCATION |
| Office location | COMPANY_LOCATION |
| Working hours | BUSINESS_HOURS |
| When are you open? | BUSINESS_HOURS |
| Opening hours | BUSINESS_HOURS |
| Contact support | CONTACT_INFO |
| Phone number | CONTACT_INFO |
| How to reach you? | CONTACT_INFO |
| Customer care number | CONTACT_INFO |

### Float Services

| Input | Expected Intent |
|-------|----------------|
| I want float | BUY_FLOAT |
| Buy float | BUY_FLOAT |
| Purchase float | BUY_FLOAT |
| Top up float | BUY_FLOAT |
| Sell float | SELL_FLOAT |
| Float pricing | FLOAT_PRICING |
| How much does float cost? | FLOAT_PRICING |
| Float limits | FLOAT_LIMITS |
| Maximum float amount | FLOAT_LIMITS |

### Registration & Accounts

| Input | Expected Intent |
|-------|----------------|
| Become an agent | BECOME_AGENT |
| How do I register as agent? | BECOME_AGENT |
| Agent registration | BECOME_AGENT |
| Become a dealer | BECOME_DEALER |
| Dealer registration | BECOME_DEALER |
| Required documents | REQUIRED_DOCUMENTS |
| What documents do I need? | REQUIRED_DOCUMENTS |
| Create account | CREATE_ACCOUNT |
| How to register? | CREATE_ACCOUNT |
| Login | LOGIN |
| How do I log in? | LOGIN |
| Forgot password | RESET_PASSWORD |
| Reset my password | RESET_PASSWORD |

### Payments & Support

| Input | Expected Intent |
|-------|----------------|
| Buy tokens | BUY_TOKENS |
| Payment methods | PAYMENT_METHODS |
| How can I pay? | PAYMENT_METHODS |
| Transaction confirmation | TRANSACTION_CONFIRMATION |
| Get receipt | TRANSACTION_CONFIRMATION |
| My transaction failed | FAILED_TRANSACTION |
| Payment failed | FAILED_TRANSACTION |
| I need a refund | REFUNDS |
| Refund policy | REFUNDS |
| File a complaint | COMPLAINTS |
| Technical support | TECHNICAL_SUPPORT |
| App not working | TECHNICAL_SUPPORT |

### Other & Unknown

| Input | Expected Intent |
|-------|----------------|
| Agent commission | AGENT_COMMISSION |
| Transfer float to sub agent | FLOAT_TRANSFER |
| Check my balance | ACCOUNT_BALANCE |
| Account balance | ACCOUNT_BALANCE |
| Account security | SECURITY |
| Protect my account | SECURITY |
| What is the weather today? | UNKNOWN |
| Tell me a joke | UNKNOWN |

---

## Expected Output Format

```
[PASS] Hello -> Greeting
[PASS] I want float -> Buy Float
...
Results: 67 passed, 0 failed, 67 total
```

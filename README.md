# No-Nonsense Split

No-Nonsense Split is a lightweight, offline-first finance tracking app designed to simplify splitting expenses among friends or groups. It allows users to add, remove, and track expenses without the need for an account or internet connection. **Currently, only internet based availability because I am not paying for app publication or web-hosting.**

---

# Telegram Bot commands:
- /get to get all expenses
- /add <Note> <Amount> [Date] *Optional
- /edit <id> <Note> <Amount> [Date] *Optional BUT BUGGY RN
- /delete <id>

---

## Features

- **Add Expenses**: Easily input expenses with details like amount, description, and date.
- **Split Expenses**: Automatically calculate how much each person owes.
- **View Balances**: See who owes what at any time.
- **No Login Required**: Start using the app immediately without creating an account.
- **Offline Functionality**: Manage expenses without needing an internet connection.

---

## Tech Stack

### Front-end
- **Flutter**: A cross-platform framework for building beautiful and performant mobile apps.
- **Packages**:
  - `sqflite`: For local SQLite database storage.
  - `http`: For making API calls to the back-end (if cloud sync is added later).

### Back-end
- **Go (Golang)**: A fast and efficient programming language for building the back-end.
- **Gin**: A high-performance HTTP web framework for Go.
- **SQLite**: A lightweight, file-based database for local storage.

* Note : https://res.cloudinary.com/acloud-guru/image/fetch/c_thumb,f_auto,q_auto/https://acg-wordpress-content-production.s3.us-west-2.amazonaws.com/app/uploads/2020/06/tmux-3-1-1024x640.png

---

## Getting Started

### Prerequisites
- **Flutter**: Install Flutter by following the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **Go**: Install Go by following the official [Go installation guide](https://golang.org/doc/install).
- **SQLite**: Ensure SQLite is installed on your system (usually pre-installed on macOS/Linux).

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/GrowthVVork/no-nonsense-split.git
   cd no-nonsense-split

---

## API Documentation

* Root Endpoint (`GET /`)
Returns a welcome message.
```
curl http://localhost:8080/
```

* Add an Expense (`POST /expenses`)
Adds a new expense.
```
curl -X POST http://localhost:8080/expenses \
-H "Content-Type: application/json" \
-d '{
  "description": "Groceries",
  "amount": 50.75,
  "date": "2023-10-15"
}'
```

* Get All Expenses (`GET /expenses`)
Retrieves all expenses.
```
curl http://localhost:8080/expenses
```

* Edit an Expense (`PUT /expenses/:id`)
Updates an existing expense.
```
curl -X PUT http://localhost:8080/expenses/1 \
-H "Content-Type: application/json" \
-d '{
  "description": "Updated Groceries",
  "amount": 60.00,
  "date": "2023-10-15"
}'
```

*  Delete an Expense (`DELETE /expenses/:id`)
Deletes an expense.
```
 curl -X DELETE http://localhost:8080/expenses/1
 ```

**Note** : Whatsapp Bot integration Reference https://developers.facebook.com/docs/whatsapp/cloud-api

**Note** : Telegram Integration check below curls :
```
url -X GET "https://api.curl -X GET "https://api.telegram.org/bot{BOT_TOKEN}/getWebhookInfo" 
{"ok":true,"result":{"url":""}}


curl -X POST "https://api.telegram.org/bot{BOT_TOKEN}/setWebhook" \
     -H "Content-Type: application/json" \
     --data '{"url": "RENDER/webhook"}'
```
**Note** : Deployed @ render
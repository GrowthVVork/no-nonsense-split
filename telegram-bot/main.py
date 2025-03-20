# gunicorn -w 4 -b 0.0.0.0:5000 main:app
import os
import requests
import json
from flask import Flask, request
from datetime import datetime

app = Flask(__name__)
TELEGRAM_BOT_TOKEN = os.getenv("TELEGRAM_BOT_TOKEN")
TELEGRAM_API_URL = f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage"
EXPENSE_API_URL = os.getenv("EXPENSE_API_URL")

def send_telegram_message(chat_id, text):
    requests.post(TELEGRAM_API_URL, json={"chat_id": chat_id, "text": text})

@app.route("/webhook", methods=["POST"])
def webhook():
    update = request.json
    if "message" in update:
        chat_id = update["message"]["chat"]["id"]
        text = update["message"].get("text", "").strip().lower()

        parts = text.split()

        if text.startswith("/add"):
            if len(parts) < 3:
                send_telegram_message(chat_id, "Usage: /add <description> <amount> [date]")
                return {"error": "Invalid format"}
            
            description, amount = parts[1], parts[2]
            date = parts[3] if len(parts) > 3 else datetime.now().isoformat()
            
            try:
                data = {"description": description, "amount": float(amount), "date": date}
                response = requests.post(EXPENSE_API_URL, json=data)
                send_telegram_message(chat_id, f"Expense added: {response.json()}")
            except ValueError:
                send_telegram_message(chat_id, "Amount must be a valid number.")

        elif text.startswith("/get"):
            response = requests.get(EXPENSE_API_URL)
            send_telegram_message(chat_id, f"Expenses: {json.dumps(response.json(), indent=2)}")

        elif text.startswith("/edit"):
            if len(parts) < 5:
                send_telegram_message(chat_id, "Usage: /edit <id> <description> <amount> [date]")
                return {"error": "Invalid format"}
            
            expense_id, description, amount = parts[1], parts[2], parts[3]
            date = parts[4] if len(parts) > 4 else datetime.now().isoformat()
            
            try:
                data = {"description": description, "amount": float(amount), "date": date}
                response = requests.put(f"{EXPENSE_API_URL}/{expense_id}", json=data)
                send_telegram_message(chat_id, f"Expense updated: {response.json()}")
            except ValueError:
                send_telegram_message(chat_id, "Amount must be a valid number.")

        elif text.startswith("/delete"):
            if len(parts) < 2:
                send_telegram_message(chat_id, "Usage: /delete <id>")
                return {"error": "Invalid format"}

            expense_id = parts[1]
            response = requests.delete(f"{EXPENSE_API_URL}/{expense_id}")
            send_telegram_message(chat_id, f"Expense deleted: {response.json()}")

        else:
            send_telegram_message(chat_id, "Invalid command. Use /add, /get, /edit, /delete.")

    return {"status": "ok"}

if __name__ == "__main__":
    port_val = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=port_val)
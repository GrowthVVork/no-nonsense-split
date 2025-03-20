# gunicorn -w 4 -b 0.0.0.0:5000 main:app
import os
import requests
import json
from flask import Flask, request

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

        if text.startswith("/add"):
            _, description, amount, date = text.split(maxsplit=3)
            data = {"description": description, "amount": float(amount), "date": date}
            response = requests.post(EXPENSE_API_URL, json=data)
            send_telegram_message(chat_id, f"Expense added: {response.json()}")

        elif text.startswith("/get"):
            response = requests.get(EXPENSE_API_URL)
            send_telegram_message(chat_id, f"Expenses: {json.dumps(response.json(), indent=2)}")

        elif text.startswith("/edit"):
            _, expense_id, description, amount, date = text.split(maxsplit=4)
            data = {"description": description, "amount": float(amount), "date": date}
            response = requests.put(f"{EXPENSE_API_URL}/{expense_id}", json=data)
            send_telegram_message(chat_id, f"Expense updated: {response.json()}")

        elif text.startswith("/delete"):
            _, expense_id = text.split(maxsplit=1)
            response = requests.delete(f"{EXPENSE_API_URL}/{expense_id}")
            send_telegram_message(chat_id, f"Expense deleted: {response.json()}")

        else:
            send_telegram_message(chat_id, "Invalid command. Use /add, /get, /edit, /delete.")

    return {"status": "ok"}

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    app.run(host="0.0.0.0", port=5000)

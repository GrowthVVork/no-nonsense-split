# No-Nonsense Split

No-Nonsense Split is a lightweight, offline-first finance tracking app designed to simplify splitting expenses among friends or groups. It allows users to add, remove, and track expenses without the need for an account or internet connection.

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
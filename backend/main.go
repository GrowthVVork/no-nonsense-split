package main

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/mattn/go-sqlite3"
)

type Expense struct {
	ID          int     `json:"id"`
	Description string  `json:"description"`
	Amount      float64 `json:"amount"`
	Date        string  `json:"date"`
}

var db *sql.DB

func main() {
	// Initialize SQLite database
	var err error
	db, err = sql.Open("sqlite3", "./expenses.db")
	if err != nil {
		fmt.Println("Failed to open database:", err)
		return
	}
	defer db.Close()

	// Create expenses table if it doesn't exist
	_, err = db.Exec(`CREATE TABLE IF NOT EXISTS expenses (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		description TEXT,
		amount REAL,
		date TEXT
	)`)
	if err != nil {
		fmt.Println("Failed to create table:", err)
		return
	}

	// Initialize Gin router
	r := gin.Default()

	// Define API endpoints
	r.POST("/expenses", addExpense)
	r.GET("/expenses", getExpenses)
	r.PUT("/expenses/:id", editExpense) // New endpoint for editing expenses
	r.DELETE("/expenses/:id", deleteExpense)
	r.GET("/", welcome)

	// Start the server
	r.Run(":8080")
}

func welcome(c *gin.Context) {
	welcomeMsg := map[string]string{"hello": "world"}
	c.JSON(http.StatusOK, welcomeMsg)
}


// Add Expense
func addExpense(c *gin.Context) {
	var expense Expense
	if err := c.ShouldBindJSON(&expense); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	result, err := db.Exec("INSERT INTO expenses (description, amount, date) VALUES (?, ?, ?)",
		expense.Description, expense.Amount, expense.Date)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	id, _ := result.LastInsertId()
	expense.ID = int(id)
	c.JSON(http.StatusCreated, expense)
}

// Get Expenses
func getExpenses(c *gin.Context) {
	rows, err := db.Query("SELECT id, description, amount, date FROM expenses")
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	var expenses []Expense
	for rows.Next() {
		var expense Expense
		if err := rows.Scan(&expense.ID, &expense.Description, &expense.Amount, &expense.Date); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		expenses = append(expenses, expense)
	}

	// Return an empty list if no expenses are found
	if expenses == nil {
		expenses = []Expense{}
	}

	c.JSON(http.StatusOK, expenses)
}

// Edit Expense
func editExpense(c *gin.Context) {
	id := c.Param("id")

	var expense Expense
	if err := c.ShouldBindJSON(&expense); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Update the expense in the database
	_, err := db.Exec("UPDATE expenses SET description = ?, amount = ?, date = ? WHERE id = ?",
		expense.Description, expense.Amount, expense.Date, id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Expense updated successfully"})
}

// Delete Expense
func deleteExpense(c *gin.Context) {
	id := c.Param("id")

	_, err := db.Exec("DELETE FROM expenses WHERE id = ?", id)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Expense deleted"})
}

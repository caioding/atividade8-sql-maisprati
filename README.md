[![pt-br](https://img.shields.io/badge/lang-pt--br-green.svg)](README.pt-br.md)

# ☕ +PraTI - SQL Challenge: BomGosto Cafeteria

This repository contains SQL scripts created for the Data/SQL practice module in the [MaisPraTI](https://www.maisprati.com.br/) (+PraTI) Full Stack Jr. Developer program.

The project models a coffee shop order system and includes queries that cover:
- 📋 Menu listing ordered by coffee name
- 🧾 Orders with their items and per-item totals
- 💰 Order totals per order
- 🧃 Orders that contain more than one coffee type
- 📅 Daily revenue totals

Each query is implemented in standard SQL and is compatible with common databases (SQLite, PostgreSQL, MySQL) with minimal adjustments.

---

## 🛠️ Technologies Used

- **SQL (ANSI)** – Queries and basic DDL
- **SQLite** – Fast local testing via CLI (recommended for quick validation)
- **PostgreSQL / MySQL** – Alternative database engines
- **VS Code** – Editing and running scripts
- `sqlite3` CLI – To run the self-contained test script

---

## ⚙️ Installation and Setup

### 1) Clone the repository
```bash
git clone https://github.com/caioding/atividade8-sql-maisprati.git
cd atividade8-sql-maisprati
```

### 2) Choose your database
- Recommended: SQLite (no server needed)
- Alternatively: PostgreSQL or MySQL/MariaDB

---

## ▶️ How to Run and Test

### Recommended: SQLite (1-minute test)

Run the self-contained script that creates tables, inserts sample data, and executes all five queries:

```bash
sqlite3 bomgosto.db < test_sqlite.sql
```

You should see outputs matching the examples described in the script comments (totals per item, per order, and per date).

To run only the main script (with optional DDL commented):

```bash
sqlite3 bomgosto.db < queries_bomgosto.sql
```

### PostgreSQL

```bash
createdb bomgosto
psql -d bomgosto -f queries_bomgosto.sql
```

### MySQL/MariaDB

```bash
mysql -u <user> -p -e "CREATE DATABASE IF NOT EXISTS bomgosto;"
mysql -u <user> -p bomgosto < queries_bomgosto.sql
```

> Note: If your engine complains about DDL details, comment out the CREATE TABLE section in `queries_bomgosto.sql` and run only the SELECTs, or adjust types/constraints for your DBMS.

---

## 📄 Challenge (translated)

The BomGosto coffee shop wants to manage its coffee sales. Sales are tracked via an “order” (comanda). Each order stores a unique code, date, table number, and customer name. Order items can reference multiple coffees listed in the menu. Each order item contains the menu code and the requested quantity, and the same menu code cannot be inserted more than once in the same order. The menu presents a unique coffee name, a description of its composition, and the unit price.

Develop SQL scripts to answer each of the requests below:

1) List the entire menu ordered by coffee name.

2) Show all orders (code, date, table, and customer name) and order items (order code, coffee name, description, quantity, unit price, and total price for the item). Sort by date and order code, and also by coffee name.

3) List all orders (code, date, table, and customer name) plus a column with the total value for the order. Sort by date.

4) Repeat the previous list, but only return orders that contain more than one coffee type.

5) What is the total revenue per date? Sort by date.

---

## 📂 Project Structure

```
atividade8-sql-maisprati/
├── queries_bomgosto.sql   # Main script: optional DDL + the 5 required queries
├── test_sqlite.sql        # Self-contained: DDL + sample data + the 5 queries (for quick tests)
├── README.md              # English documentation (this file)
└── README.pt-br.md        # Portuguese documentation (original brief + challenge)
```

---

## 🧪 Notes

- The `queries_bomgosto.sql` file contains optional DDL (commented). Uncomment only if you need to create the tables.
- For engines that treat dates differently, adjust literals accordingly: e.g., `DATE 'YYYY-MM-DD'` (PostgreSQL/Oracle) vs `'YYYY-MM-DD'` (MySQL/SQLite).
- If you want orders without items to appear in totals, use LEFT JOIN and wrap sums with `COALESCE`.

---

## 📝 License

This project does not currently include a license. If you plan to reuse or share, consider adding a LICENSE file (MIT is a common choice).

---

## 🤝 Acknowledgements

Project developed as part of the educational program **MaisPraTI (+PraTI) – Full Stack Jr. Developer**, promoted by [Codifica](https://www.codificaedu.com.br/) and partners.

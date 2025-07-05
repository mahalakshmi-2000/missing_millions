# The Missing Millions: Transaction Forensics Using SQL & Python

Uncovering hidden financial fraud patterns using SQL, unsupervised ML, and Python.
This project traces how millions were siphoned through balance-draining transactions, transfer loops, and suspicious patterns in digital banking logs.

## Project Structure

missing-millions/
├── data/
│   ├── raw_data.csv               # Original Kaggle dataset
│   └── cleaned_transactions.csv   # Cleaned & filtered dataset
├── 01_data_cleaning.ipynb         # Preprocessing, cleaning, filtering
├── 02_sql_analysis.ipynb          # Forensic SQL queries on fraud types
├── 03_python_anomaly_detection.ipynb # Isolation Forest & behavioral features
├── 04_dashboard.ipynb             # Metrics exported for Looker Studio
├── README.md
└── requirements.txt

## Code Execution Flow (Step-by-Step)

### 01. Data Cleaning (01_data_cleaning.ipynb)

- Load dataset (~6.3M rows)
- Remove irrelevant transaction types (DEBIT, etc.)
- Focus only on TRANSFER and CASH_OUT where fraud actually occurs
- Add features like:
  - balanceChange = oldbalanceOrg - newbalanceOrig
  - hour and day from step
- Save as cleaned_transactions.csv

Output: Clean CSV to be used in SQL and ML steps.

### 02. SQL-Based Forensics (02_sql_analysis.ipynb)

Uses SQLite via pandas for SQL-style querying.

Main patterns detected:

Pattern                             | SQL Logic
-----------------------------------|------------------------------------------------
Full Balance Drains                | oldbalanceOrg = amount AND newbalanceOrig = 0
Circular Transfers                 | Recursive join on nameOrig → nameDest → nameOrig
Top Recipients of Fraud            | GROUP BY nameDest WHERE isFraud = 1
Repeat Fraud Senders               | COUNT(DISTINCT step) per nameOrig with high amount
Day-wise Fraud Loss                | SUM(amount) GROUP BY day

Use this notebook to inspect patterns before applying ML.

### 03. Anomaly Detection (03_python_anomaly_detection.ipynb)

This notebook applies unsupervised ML on behavior-based features.

Steps:

1. Feature Selection (amount, oldbalanceOrg, newbalanceOrig, balanceChange, hour)
2. Standardization using StandardScaler
3. Model: Isolation Forest (contamination=0.001)
4. Predictions: Adds anomaly_score and isAnomaly
5. Evaluation: Compares isAnomaly vs isFraud using confusion matrix and classification report
6. Cumulative Plot: Fraud loss over days via cumsum()

### 04. Dashboard / Export (04_dashboard.ipynb)

- Converts key metrics to CSV format
- Uploadable into Looker Studio or Power BI
- Metrics included:
  - Total Fraud Loss Over Time
  - Top Fraudulent Senders/Receivers
  - High-velocity anomalies
  - "Missing Millions" KPI: total money lost

## Key Features Implemented

Feature                          | Technique
--------------------------------|---------------------------------------------
Full Balance Drain Detection     | SQL conditional filtering
Circular Transfer Loops          | Self-joins in SQL
Anomaly Detection                | Isolation Forest
Behavior Analytics               | step_gap, amount spikes
Visualization                    | Seaborn, Matplotlib, Looker Studio

## How to Run the Project

1. Clone the Repo

git clone https://github.com/yourusername/missing-millions.git
cd missing-millions

2. Install Dependencies

pip install -r requirements.txt

You can use a venv if needed.

3. Run Notebooks in Order

jupyter notebook

Open the following notebooks in this order:

- 01_data_cleaning.ipynb
- 02_sql_analysis.ipynb
- 03_python_anomaly_detection.ipynb
- 04_dashboard.ipynb (Optional for Looker Studio)

## Dashboard (Optional)

Hosted on Looker Studio (Insert your link here)

Includes:
- Big Number Card: Total Money Lost
- Timeline: Day-wise cumulative fraud
- Table: Top 10 suspicious users
- Filters: Type, amount, sender, receiver

## Requirements

- Python ≥ 3.8
- Jupyter Notebook
- pandas, seaborn, sklearn, sqlite3, matplotlib

## Key Terms

Column                       | Meaning
----------------------------|---------------------------------------------
step                        | Hour of transaction (1–744 for 30 days)
type                        | Transaction type: CASH_OUT, TRANSFER, etc.
isFraud                     | 1 if transaction was fraudulent
amount                      | Value of transaction
nameOrig / nameDest         | Sender / Receiver
oldbalanceOrg / newbalanceOrig | Before / After sender balance
oldbalanceDest / newbalanceDest | Before / After receiver balance

## Credits

- Dataset: Kaggle – Sriharsha
- Tools: scikit-learn, pandas, SQLite

## Contact

Mahalakshmi Rajabattula
LinkedIn: https://linkedin.com/in/your-profile
GitHub: https://github.com/yourusername
Hyderabad, India
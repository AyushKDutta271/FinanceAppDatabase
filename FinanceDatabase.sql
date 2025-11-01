CREATE DATABASE IF NOT EXISTS FinanceApp;
USE FinanceApp;

CREATE TABLE IF NOT EXISTS User(
user_id INT PRIMARY KEY,
user_type ENUM('individual', 'company'),
email VARCHAR(255),
password_hash VARCHAR(255),
phoneNumber BIGINT,
kyc_status ENUM('pending', 'verified', 'rejected'),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
last_login_at DATETIME DEFAULT NULL
);


CREATE TABLE IF NOT EXISTS KYC_Document(
kyc_id INT PRIMARY KEY ,
user_id INT,
FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
document_type ENUM('aadhar', 'pan', 'gst', 'incorporation_certificate'),
document_url VARCHAR(255),
verification_status ENUM('pending', 'verified', 'rejected'),
verified_at DATETIME
);

CREATE TABLE IF NOT EXISTS Wallet(
wallet_id INT PRIMARY KEY,
user_id INT,
FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
balance DECIMAL,
currency VARCHAR(255),
created_at DATETIME,
updated_at DATETIME
);

CREATE TABLE IF NOT EXISTS Loan_Request(
loan_id INT PRIMARY KEY,
borrower_id INT,
FOREIGN KEY (borrower_id) REFERENCES User(user_id) ON DELETE CASCADE,
loan_amount DECIMAL,
interest_rate DECIMAL,
tenure_months int,
purpose VARCHAR(255),
status ENUM('open','funded','active', 'close', 'defaulted'),
created_at DATETIME
);

CREATE TABLE IF NOT EXISTS Wallet_Transaction(
tansaction_id INT PRIMARY KEY,
wallet_id INT,
FOREIGN KEY (wallet_id) REFERENCES Wallet(wallet_id) ON DELETE RESTRICT,
type ENUM('deposit','withdrawal','lending', 'repayment','interest','free'),
amount DECIMAL,
status ENUM('pending','completed','failed'),
reference_id VARCHAR(255),
created_at DATETIME
);

CREATE TABLE IF NOT EXISTS Repayment_Schedule(
repayment_id INT PRIMARY KEY,
loan_id INT,
FOREIGN KEY (loan_id) REFERENCES Loan_Request(loan_id) ON DELETE CASCADE,
due_date DATE,
amount_due DECIMAL,
amount_paid DECIMAL,
payment_status ENUM('pending', 'paid', 'late','defaulted'),
paid_at DATETIME 
);

CREATE TABLE IF NOT EXISTS Loan_Investment(
investment_id INT PRIMARY KEY,
loan_id INT,
FOREIGN KEY (loan_id) REFERENCES Loan_Request(loan_id) ON DELETE SET NULL,
lender_id INT,
FOREIGN KEY (lender_id) REFERENCES User(user_id) ON DELETE SET NULL,
amount_invested DECIMAL,
expected_return DECIMAL,
interest_rate DECIMAL,
repayment_status ENUM('pending','in progress', 'completed'),
created_at DATETIME
);
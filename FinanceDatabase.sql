CREATE DATABASE IF NOT EXISTS FinanceApp;
USE FinanceApp;

CREATE TABLE IF NOT EXISTS User_Profile (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number BIGINT UNIQUE NOT NULL,
    user_type ENUM('MSME', 'LENDER_PARTNER') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS KYC_Data (
    kyc_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES User_Profile(user_id) ON DELETE CASCADE,
    pan_number VARCHAR(10) UNIQUE,
    business_name VARCHAR(255),
    udyam_number VARCHAR(50),
    verification_status ENUM('PENDING', 'VERIFIED', 'REJECTED') DEFAULT 'PENDING'
);

/* This is important' */
CREATE TABLE IF NOT EXISTS Financial_Data_Store (
    data_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES User_Profile(user_id) ON DELETE CASCADE,
    data_source ENUM('ACCOUNT_AGGREGATOR', 'GSTN', 'UPI_PARSE') NOT NULL,
    raw_data JSON, /* Store the raw, encrypted JSON payload */
    consent_handle VARCHAR(255), /* Store the AA consent ID */
    fetched_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_start_date DATE,
    data_end_date DATE
);

/* This is the output of our AI model */
CREATE TABLE IF NOT EXISTS AI_Risk_Score (
    score_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES User_Profile(user_id) ON DELETE CASCADE,
    score DECIMAL(5, 2), /* Our internal credit score */
    risk_level ENUM('LOW', 'MEDIUM', 'HIGH'),
    summary_report JSON, /* avg daily balance, GST compliance %, etc. */
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Loan_Application (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    msme_user_id INT,
    FOREIGN KEY (msme_user_id) REFERENCES User_Profile(user_id) ON DELETE CASCADE,
    requested_amount DECIMAL(12, 2) NOT NULL,
    requested_tenure_months INT NOT NULL,
    purpose VARCHAR(255),
    status ENUM('DRAFT', 'PENDING_DATA', 'IN_REVIEW', 'OFFERS_AVAILABLE', 'REJECTED', 'LOAN_ACCEPTED') NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

/*  Core of our platform */
CREATE TABLE IF NOT EXISTS Loan_Offer (
    offer_id INT PRIMARY KEY AUTO_INCREMENT,
    application_id INT,
    FOREIGN KEY (application_id) REFERENCES Loan_Application(application_id) ON DELETE CASCADE,
    lender_user_id INT, /* The ID of the NBFC partner */
    FOREIGN KEY (lender_user_id) REFERENCES User_Profile(user_id) ON DELETE CASCADE,
    
    offer_amount DECIMAL(12, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    tenure_months INT NOT NULL,
    processing_fee DECIMAL(10, 2),
    status ENUM('PENDING', 'ACCEPTED_BY_MSME', 'REJECTED_BY_MSME', 'WITHDRAWN_BY_LENDER'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

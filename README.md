Fintech SQL Database Project

Overview

This project simulates the backend data structure and operations of a fictional fintech company . The goal was to build a robust and normalized SQL database system that can securely store, retrieve, and analyze data related to users, wallets, transactions, and internal money transfers.

Objective

To design and implement a bulletproof database where:  
\- Data can be securely stored, with proper normalization and structure.  
\- Data can be extracted for analysis and reporting.  
\- Real-world fintech activities can be simulated and traced end-to-end.

 Key Features

\- Fully Normalized Database: Tables are normalized up to 3NF.  
\- Data Integrity & Referential Constraints: Foreign keys and data rules enforce structure and consistency.  
\- Stored Procedures: Reusable procedures to automate tasks like user onboarding, wallet creation, transaction logging, and internal transfers.  
\- Simulated Real-Time Activities: Signups, wallet funding, user-to-user transfers.  
\- Data Analysis Queries: Transaction summaries, user activity monitoring, wallet balances, and more.

 Tables Created

\- users – Stores user profile data.  
\- wallets – Links each user to a financial wallet.  
\- transactions – Stores every credit or debit operation.  
\- schools – Represents associated educational institutions.  
\- business\_profiles – Stores business accounts for users registered as businesses.

Stored Procedures

1\. create\_user\_with\_wallet – Registers a new user and automatically creates their wallet.  
2\. process\_transaction – Processes and records a credit or debit transaction, updating wallet balance.  
3\. transfer\_funds – Handles wallet-to-wallet transfers between users (internal transfers).

 Sample Simulated Flow

\- User signs up via API → create\_user\_with\_wallet procedure runs.  
\- Wallet is initialized with a zero balance.  
\- User receives money (credit) → process\_transaction logs it and updates balance.  
\- User sends money to another user → transfer\_funds handles transfer and balance updates for both parties.

Tools Used

\- MySQL Workbench  
\- SQL (DDL, DML, Stored Procedures)  
\- Power BI (upcoming)

What This Repository Contains

\-  README.md – This file you're reading now  
\-  Project Qualitative Report – Explains the thought process, objectives, design, and implementation strategy.  
\- SQL Script – Contains all the SQL code for table creation, data insertion, and stored procedures.  
\- EER Diagram – Visual representation of the entire database schema and relationships.  
\- Project Report Document– A detailed, narrative report describing all phases of the project from design to simulation and analysis.

Why This Matters

Understanding how a real fintech database works is critical for any data analyst working in the financial sector. This project shows the \*backbone\* of where and how data is stored and how analysts can trust, extract, and model it.

Created with ❤ by Sylvia Imisi  


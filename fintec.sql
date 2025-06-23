/*
===========================================================
  Fintech SQL Database Project
  Created by: Sylvia Imisi (https://github.com/sylvia772)
  Date: 06/June/2025
  Description: SQL database simulating core fintech features
===========================================================
*/





create database fintech;
use fintech;

-- creating the users table
create table users
(user_id int auto_increment primary key,
ful_name varchar(150) not null,
email varchar(100) unique,
phone varchar(20) unique,
user_type enum('student', 'parent', 'business_owner', 'staff', 'farmer', 'vendor', 'other') not null,
created_at timestamp default current_timestamp);
alter table users
change column ful_name full_name varchar(150) not null;
alter table users
modify column user_type enum( 'student', 'parent', 'business_owner', 'staff', 'school_owner', 'admin', 'other');

---- creating the business table
create table businesses(
business_id int auto_increment primary key,
name varchar(150) not null,
type enum('school', 'store', 'farm', 'other') not null,
registered_by int,
created_at timestamp default current_timestamp,
foreign key (registered_by) references users(user_id));

--- creating the wallet table a wallet can belong to a user or a bussiness although all users automatically have a wallet
create table wallets(
wallet_id int auto_increment primary key,
user_id int,
business_id int,
balance decimal(12, 2) default 0.00,
created_at timestamp default current_timestamp,
foreign key (user_id) references users(user_id),
foreign key (business_id) references businesses(business_id),
check (
(user_id is not null and business_id is null) or
(user_id is null and business_id is not null)));

select * from wallets;

---- creating the transaction table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    wallet_id INT NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    transaction_type ENUM('credit', 'debit') NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wallet_id) REFERENCES wallets(wallet_id)
);

--- creating student table

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    business_id INT NOT NULL,
    admission_date DATE,
    status ENUM('active', 'inactive', 'graduated') DEFAULT 'active',
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (business_id) REFERENCES businesses(business_id)
);
alter table students
modify column user_id int null;

show tables;
select * from users;

--- insert into the user table
INSERT INTO users (full_name, email, phone, user_type)
values
('Ada Nwosu', 'Ada@gmail.com', 0987665554, 'student'),
('Linda Oke', 'linda.oke@cyluxury.com', '08011112222', 'school_owner'),
('Uche Nwosu', 'uche.nwosu@bookstore.com', '08022223333', 'business_owner'),
('Tunde Martins', 'tunde.martins@gmail.com', '08033334444', 'parent'),
('Ada Nwosu', 'ada.nwosu@studentmail.com', '08044445555', 'student'),
('Deborah Ojo', 'deborah.ojo@cyluxury.com', '08055556666', 'staff'),
('Chidi Eze', 'chidi.eze@vendor.com', '08066667777', 'business_owner'),
('Admin Bot', 'admin@sproutly.africa', '08077778888', 'admin'),
('Grace Opara', 'grace.opara@gmail.com', '08088889999', 'parent'),
('David Balogun', 'david.balogun@trainerhub.com', '08099990000', 'other'),
('Bisi Ade', 'bisi.ade@storemanager.com', '08012121212', 'staff');


select * from businesses ;
--- insert into business table

insert into businesses ( name, type, registered_by)
VALUES 
('cy_school', 'school', 8);
insert into businesses ( name, type, registered_by)
VALUES 
('mount_stores', 'store', 3),
('chidi_ventures', 'store', 7),
('linda_school', 'school', 2),
('money_grows', 'store', 7),
('busy_minds_store', 'school', 8),
('corn', 'farm', 11);



-- insert into student table
INSERT INTO students ( user_id, business_id, admission_date, status)
values
(null, 1, '2025-09-06', 'active');

INSERT INTO students ( user_id, business_id, admission_date, status)
values
(null, 7, '2025-09-06', 'active'),
(null, 7, '2025-09-06', 'active'),
(null, 7, '2025-09-06', 'active'),
(null, 7, '2025-09-06', 'active'),
(null, 7, '2025-09-06', 'active'),
(null, 7, '2025-09-06', 'active'),
(null, 7, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active'),
(null, 10, '2025-09-06', 'active');

--- inserting into wallet table
select * from wallets;
insert into wallets(user_id, business_id, balance)
values
(1, null, 5000),
(2, null, 40000),
(3, null, 30000),
(4, null, 20000),
(5, null, 29999),
(6, null, 6990),
(7, null, 7000),
(8, null, 0.00),
(9, null, 7000),
(10, null, 68892);

insert into wallets(user_id, business_id, balance)
values
(null, 7, 6000000),
(null, 8, 450000),
(null, 9, 120000),
(null, 10, 56888938),
(null, 11, 56354269),
(null, 12, 8766655),
(null, 13, 340000);


select * from wallets;

---- creating a procedure to process transaction and reduce current user balance

delimiter $$
create procedure process_transaction (
in p_wallet_id int,
in p_amount decimal(10, 2),
in p_transaction_type enum ('credit', 'transfer'),
in p_description text)
BEGIN
 DECLARE current_balance decimal (10, 2);

 select balance into current_balance
 from wallets
 where wallet_id = p_wallet_id;

 if p_transaction_type = 'debit' then
  if current_balance < p_amount then
  signal sqlstate '45000'
  set message_text = 'inssuficient amount in wallet';
  else
  update wallets
  set balance = balance - p_amount
  where wallet_id = p_wallet_id;
  end if;
  
elseif p_transaction_type = 'credit' then
update wallets
set balance = balance + p_amount
where wallet_id = p_wallet_id;
end if;
INSERT INTO transactions (wallet_id, amount, transaction_type, description, created_at)
    VALUES (p_wallet_id, p_amount, p_transaction_type, p_description, NOW());

END $$
DELIMITER ; 
select * from wallets;

CALL process_transaction (24, 85000, 'credit', 'for drinks') ;

--- creating a procedure fortransfer of funds from one one user to another user

DELIMITER $$

CREATE PROCEDURE transfer_funds (
    IN p_sender_wallet_id INT,
    IN p_receiver_wallet_id INT,
    IN p_amount DECIMAL(10, 2),
    IN p_description TEXT
)
BEGIN
    --  Declare variable to hold the sender's balance
    DECLARE sender_balance DECIMAL(10, 2);

    --  Get the current balance of the sender's wallet
    SELECT balance INTO sender_balance
    FROM wallets
    WHERE wallet_id = p_sender_wallet_id;

    -- Check if the sender has enough balance
    IF sender_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient balance to complete the transfer';
    END IF;

    -- Deduct the amount from the sender's wallet
    UPDATE wallets
    SET balance = balance - p_amount
    WHERE wallet_id = p_sender_wallet_id;

    --  Add the amount to the receiver's wallet
    UPDATE wallets
    SET balance = balance + p_amount
    WHERE wallet_id = p_receiver_wallet_id;

    -- Record both the debit and credit transactions
    INSERT INTO transactions (wallet_id, amount, transaction_type, description)
    VALUES
    (p_sender_wallet_id, p_amount, 'debit', p_description),
    (p_receiver_wallet_id, p_amount, 'credit', p_description);

END$$

DELIMITER ;

call transfer_funds ( 2, 11, 10000, 'for school books');

select * from users;

---- create a procedure to create a new user and wallet 

DELIMITER //

CREATE PROCEDURE create_new_user (
    IN p_full_name VARCHAR(150),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_user_type ENUM('student', 'parent', 'business_owner', 'staff', 'farmer', 'vendor', 'other')
)
BEGIN
    -- Step 1: Insert new user into the users table
    INSERT INTO users (full_name, email, phone, user_type)
    VALUES (p_full_name, p_email, p_phone, p_user_type);

    -- Step 2: Get the new user_id just created
    SET @new_user_id = LAST_INSERT_ID();

    -- Step 3: Create a wallet for the new user with zero balance
    INSERT INTO wallets (user_id, balance, created_at)
    VALUES (@new_user_id, 0.00, NOW());
END //
DELIMITER ;


call create_new_user( 'Sylvia imisi', 'sylvia@gmail.com',  09765432113, 'other');
select * from wallets;

--- populating the  users table  using the stored procedure
CALL create_new_user('Aisha Bello', 'aisha@gmail.com', '0998765437', 'student');
CALL create_new_user('Tony Dafe', 'tony@vendor.com', '0908766532', 'student');
CALL create_new_user('Zainab Yusuf', 'zainaby@farm.com', '0998765432', 'other');
CALL create_new_user('Emeka Ojo', 'emeka@school.com', '0123456124', 'staff');
call create_new_user('Glory chisom', 'glory@gmail.com', '09887766544', 'other');

--- querying the data

--- total num of users excluding businesses
select count(*) as total_users from users;

--- total num of business
select count(*) as total_business from businesses;

--- total wallet on the platform
select count(*) as total_wallets from wallets;

select * from wallets;
select users.user_id, users.full_name
from users
left join wallets on users.user_id = wallets.user_id
where wallets.user_id is null;

insert into wallets (user_id, business_id, balance)
values
(11, null, 60000),
(12, null, 652347),
(15, null, 87765),
(16, null, 588760),
(17, null, 763333);

select * from transactions;

--- top 5 highest value transaction
select  transaction_id, wallet_id, amount from transactions 
order by amount desc ;


--- internal user to user transfer breakdown

select users.full_name, count(transactions.transaction_id) as internal_transfered,
sum(transactions.amount) as total_transferred
from transactions
join wallets on transactions.transaction_id = wallets.wallet_id
join users on wallets.user_id = users.user_id
where transactions.transaction_type = 'credit'
group by users.full_name
order by total_transferred desc;

--- count of transaction per user

select users.user_id, users.full_name, 
count(transactions.transaction_id) as transaction
from 
users
join  wallets on users.user_id = wallets.user_id
join transactions on wallets.wallet_id = transactions.wallet_id
group by  users.user_id, users.full_name
order by transaction;
select * from transactions;

CREATE TABLE metadata (
    id INT PRIMARY KEY,
    project_name VARCHAR(100),
    author_name VARCHAR(100),
    github_url VARCHAR(255),
    created_at DATE
);

INSERT INTO metadata (id, project_name, author_name, github_url, created_at)
VALUES (1, 'Fintech SQL Database', 'Sylvia Imisi', 'https://github.com/sylvia772', curdate());
select * from metadata











 











 
 
 











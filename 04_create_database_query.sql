--CREATE DATABASE
CREATE DATABASE company;
--USE DATABASE
USE company;
--CREATE TABLES 
CREATE TABLE employee 
(
emp_id  INT IDENTITY(100,1) CONSTRAINT pk_emp_id PRIMARY KEY ,
first_name VARCHAR(255) NOT NULL,
last_name VARCHAR(255),
birth_date DATE,
gender VARCHAR(5) , CHECK (gender IN ('M','F')),
salary INT,
)

CREATE TABLE branch 
(
branch_id INT IDENTITY(1,1) CONSTRAINT pk_branch_id PRIMARY KEY ,
branch_name VARCHAR(255) UNIQUE NOT NULL,
mgr_start_date DATE
)

CREATE TABLE client 
(
client_id INT IDENTITY(400,1) CONSTRAINT pk_client_id PRIMARY KEY,
client_name VARCHAR(255) NOT NULL 
)

CREATE TABLE works_with 
(
emp_id INT CONSTRAINT fk_works_with_emp_id FOREIGN KEY REFERENCES employee(emp_id),
client_id INT CONSTRAINT fk_works_with_client_id FOREIGN KEY REFERENCES client(client_id),
CONSTRAINT pk_works_with PRIMARY KEY (emp_id, client_id),
total_sales REAL 
)

CREATE TABLE branch_supplier
(
branch_id INT CONSTRAINT fk_branch_supplier_branch_id FOREIGN KEY REFERENCES branch(branch_id),
supplier_name VARCHAR(255) NOT NULL ,
CONSTRAINT pk_branch_supplier PRIMARY KEY (branch_id, supplier_name),
supply_type VARCHAR(255) NOT NULL 
)

--ADD foreign keys for strong and weak entities tables
ALTER TABLE employee 
ADD super_id INT CONSTRAINT fk_emp_super_id FOREIGN KEY REFERENCES employee(emp_id),
branch_id INT CONSTRAINT fk_emp_branch_id FOREIGN KEY REFERENCES branch(branch_id)

ALTER TABLE branch
ADD mgr_id INT CONSTRAINT fk_branch_mgr_id FOREIGN KEY REFERENCES employee(emp_id)

ALTER TABLE client 
ADD branch_id INT CONSTRAINT fk_client_branch_id FOREIGN KEY REFERENCES branch(branch_id)

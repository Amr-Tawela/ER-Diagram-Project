--CREATE DATABASE 
CREATE DATABASE company_2;
--USE DATABASE
USE company_2;
--CREATE TABLES 
CREATE TABLE employee 
(
emp_id INT IDENTITY(100,1) CONSTRAINT pk_employee PRIMARY KEY ,
first_name VARCHAR(255) NOT NULL , 
last_name VARCHAR(255) NOT NULL, 
birth_date DATE ,
gender VARCHAR(10) CONSTRAINT check_gender CHECK (gender IN ('M','F')),
salary INT
)

CREATE TABLE branch 
(
branch_id INT IDENTITY(1,1) CONSTRAINT pk_branch PRIMARY KEY , 
branch_name VARCHAR(255) UNIQUE NOT NULL,
mgr_start_date DATE NOT NULL
)

CREATE TABLE client 
(
client_id INT IDENTITY(400,1) CONSTRAINT pk_client PRIMARY KEY ,
client_name VARCHAR(255) UNIQUE NOT NULL 
)

CREATE TABLE branch_supplier
(
branch_id INT CONSTRAINT fk_branch_supplier_branch_id FOREIGN KEY REFERENCES branch(branch_id),
supplier_name VARCHAR(255) NOT NULL ,
CONSTRAINT pk_branch_supplier PRIMARY KEY (branch_id , supplier_name),
supply_type VARCHAR(255)
)

CREATE TABLE works_on 
(
emp_id INT CONSTRAINT fk_works_on_emp_id FOREIGN KEY REFERENCES employee(emp_id),
client_id INT CONSTRAINT fk_works_on_client_id FOREIGN KEY REFERENCES client(client_id),
CONSTRAINT pk_works_on PRIMARY KEY (emp_id,client_id),
total_sales INT NOT NULL
)

--ADD FOREIGN KEY COLUMNS FOR STRONG AND WEAK ENTITY TABLES
ALTER TABLE employee 
  ADD super_id INT CONSTRAINT fk_super_id FOREIGN KEY REFERENCES employee(emp_id)
ALTER TABLE employee
  ADD branch_id INT CONSTRAINT fk_employee_branch_id FOREIGN KEY REFERENCES branch(branch_id)

ALTER TABLE branch
ADD mgr_id INT CONSTRAINT fk_branch_mgr_id FOREIGN KEY REFERENCES employee(emp_id)

ALTER TABLE client 
ADD branch_id INT CONSTRAINT fk_client_branch_id FOREIGN KEY REFERENCES branch(branch_id)

--CREATE VIEWS FOR Differenct users 
CREATE VIEW finance_view AS
SELECT emp.emp_id , emp.first_name , emp.last_name, client.client_id , client.client_name , works_on.total_sales
  FROM employee emp 
  JOIN works_on 
    ON emp.emp_id = works_on.emp_id
  JOIN client 
    ON works_on.client_id = client.client_id

CREATE VIEW hr_view AS
SELECT *
  FROM employee 

--CREATE login ,user for financial_department , hr_department

USE MASTER


CREATE LOGIN financial_department WITH PASSWORD = 'finance123'
CREATE LOGIN hr_department WITH PASSWORD = 'hr123'

USE company_2
CREATE USER financial_department FOR LOGIN financial_department 
CREATE USER hr_department FOR LOGIN hr_department 

--GRANST A SELECT privielege to both users 
GRANT SELECT 
   ON dbo.finance_view 
   TO financial_department 
 WITH GRANT OPTION 

GRANT SELECT 
   ON dbo.hr_view     
   TO hr_department
 WITH GRANT OPTION 

GRANT SELECT 
   ON employee
   TO hr_department
 WITH GRANT OPTION 

--REVOKE INSERT , UPDATE privileges from both users 

REVOKE INSERT , UPDATE 
    ON dbo.finance_view
  FROM financial_department 
CASCADE 

REVOKE INSERT , UPDATE 
    ON dbo.hr_view 
  FROM hr_department
CASCADE 

-- ITHRA LIBRARY DATABASE (Oracle SQL)
-- Cleaned schema & sample data
-- Author: Joud Alsuhaibany
-- Date: 2025-08-27

------------------------------------------------------------------------
-- SAFELY DROP TABLES (ignore if they don't exist)
------------------------------------------------------------------------
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MANAGES CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE BORROW CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE VISIT CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PUBLISH CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EMPLOYEE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MANAGER CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AUTHOR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MEMBER CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE BOOK CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE BRANCH CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
------------------------------------------------------------------------
-- TABLES
------------------------------------------------------------------------
CREATE TABLE BRANCH (
  branch_num      CHAR(1)      NOT NULL,
  branch_location VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_branch PRIMARY KEY (branch_num)
);

CREATE TABLE MANAGER (
  manager_id   CHAR(4)       NOT NULL,
  manager_name VARCHAR2(40)  NOT NULL,
  CONSTRAINT pk_manager PRIMARY KEY (manager_id)
);

CREATE TABLE EMPLOYEE (
  employee_id     CHAR(4)        NOT NULL,
  first_name      VARCHAR2(30)   NOT NULL,
  last_name       VARCHAR2(30)   NOT NULL,
  employee_salary NUMBER(7,0)    CHECK (employee_salary >= 10000),
  employee_email  VARCHAR2(100),
  branch_num      CHAR(1)        NOT NULL,
  employee_num    VARCHAR2(10),
  CONSTRAINT pk_employee PRIMARY KEY (employee_id),
  CONSTRAINT fk_employee_branch FOREIGN KEY (branch_num) REFERENCES BRANCH(branch_num)
);

-- Relationship between MANAGER and EMPLOYEE
CREATE TABLE MANAGES (
  manager_id  CHAR(4) NOT NULL,
  employee_id CHAR(4) NOT NULL,
  CONSTRAINT pk_manages PRIMARY KEY (manager_id, employee_id),
  CONSTRAINT fk_manages_manager  FOREIGN KEY (manager_id)  REFERENCES MANAGER(manager_id),
  CONSTRAINT fk_manages_employee FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
);

CREATE TABLE MEMBER (
  phone_number VARCHAR2(20)  NOT NULL,
  address      VARCHAR2(100) NOT NULL,
  member_name  VARCHAR2(60)  NOT NULL,
  branch_num   CHAR(1)       NOT NULL,
  CONSTRAINT pk_member PRIMARY KEY (phone_number),
  CONSTRAINT fk_member_branch FOREIGN KEY (branch_num) REFERENCES BRANCH(branch_num)
);

CREATE TABLE BOOK (
  book_number CHAR(10)     NOT NULL,
  title       VARCHAR2(100) NOT NULL,
  book_price  NUMBER(7,2),
  pages       NUMBER(5),
  CONSTRAINT pk_book PRIMARY KEY (book_number)
);

CREATE TABLE AUTHOR (
  author_id   CHAR(4)      NOT NULL,
  author_name VARCHAR2(60) NOT NULL,
  CONSTRAINT pk_author PRIMARY KEY (author_id)
);

-- M:N author ↔ book
CREATE TABLE PUBLISH (
  author_id   CHAR(4)  NOT NULL,
  book_number CHAR(10) NOT NULL,
  CONSTRAINT pk_publish PRIMARY KEY (author_id, book_number),
  CONSTRAINT fk_publish_author FOREIGN KEY (author_id) REFERENCES AUTHOR(author_id),
  CONSTRAINT fk_publish_book   FOREIGN KEY (book_number) REFERENCES BOOK(book_number)
);

-- M:N member ↔ book
CREATE TABLE BORROW (
  phone_number VARCHAR2(20) NOT NULL,
  book_number  CHAR(10)     NOT NULL,
  CONSTRAINT pk_borrow PRIMARY KEY (phone_number, book_number),
  CONSTRAINT fk_borrow_member FOREIGN KEY (phone_number) REFERENCES MEMBER(phone_number),
  CONSTRAINT fk_borrow_book   FOREIGN KEY (book_number)  REFERENCES BOOK(book_number)
);

CREATE TABLE VISIT (
  branch_num   CHAR(1)      NOT NULL,
  phone_number VARCHAR2(20) NOT NULL,
  CONSTRAINT pk_visit PRIMARY KEY (branch_num, phone_number),
  CONSTRAINT fk_visit_branch FOREIGN KEY (branch_num)   REFERENCES BRANCH(branch_num),
  CONSTRAINT fk_visit_member FOREIGN KEY (phone_number) REFERENCES MEMBER(phone_number)
);

------------------------------------------------------------------------
-- SEED DATA
------------------------------------------------------------------------
-- Branches
INSERT INTO BRANCH VALUES ('1', 'Riyadh');
INSERT INTO BRANCH VALUES ('2', 'Dhahran');
INSERT INTO BRANCH VALUES ('3', 'AlQassim');

-- Managers
INSERT INTO MANAGER VALUES ('1234', 'Abdullah');
INSERT INTO MANAGER VALUES ('1221', 'Mohammed');
INSERT INTO MANAGER VALUES ('1323', 'Khaled');

-- Employees
INSERT INTO EMPLOYEE VALUES ('2232', 'Haya', 'Alkahtani', 10000, 'haya1@gmail.com', '1', '15');
INSERT INTO EMPLOYEE VALUES ('1152', 'Nouf', 'Alsuhaibani', 12000, 'nouf2@gmail.com', '2', '20');
INSERT INTO EMPLOYEE VALUES ('3341', 'Sara', 'AlShehri', 15000, 'sara3@gmail.com', '3', '30');

-- Who manages whom
INSERT INTO MANAGES VALUES ('1234', '2232');
INSERT INTO MANAGES VALUES ('1221', '1152');
INSERT INTO MANAGES VALUES ('1323', '3341');

-- Books
INSERT INTO BOOK VALUES ('SA21918274', 'Programming Language Pragmatics', 116, 330);
INSERT INTO BOOK VALUES ('SA98718563', 'SQL for Data Analysis', 305, 500);
INSERT INTO BOOK VALUES ('SA08166283', 'Basic Java Programming', 244, 420);

-- Members (now associated to a branch)
INSERT INTO MEMBER VALUES ('0501234567', 'King Fahad street Riyadh',   'Sarah Alotabi',    '1');
INSERT INTO MEMBER VALUES ('0509876543', 'Tahlia street Riyadh',       'Asma Alkahtani',   '2');
INSERT INTO MEMBER VALUES ('0551122334', 'King Salman street Riyadh',  'Ahmad Alshehri',   '3');

-- Visits
INSERT INTO VISIT VALUES ('1', '0501234567');
INSERT INTO VISIT VALUES ('2', '0509876543');
INSERT INTO VISIT VALUES ('3', '0551122334');

-- Authors
INSERT INTO AUTHOR VALUES ('1332', 'Asma Khalid');
INSERT INTO AUTHOR VALUES ('2776', 'Noura Ali');
INSERT INTO AUTHOR VALUES ('3099', 'Sara Ahmad');

-- Publish (author ↔ book)
INSERT INTO PUBLISH VALUES ('1332', 'SA21918274');
INSERT INTO PUBLISH VALUES ('2776', 'SA98718563');
INSERT INTO PUBLISH VALUES ('3099', 'SA08166283');

-- Borrow (member ↔ book)
INSERT INTO BORROW VALUES ('0501234567', 'SA21918274');
INSERT INTO BORROW VALUES ('0509876543', 'SA98718563');
INSERT INTO BORROW VALUES ('0551122334', 'SA08166283');

------------------------------------------------------------------------
-- SAMPLE QUERIES (Lecture 7, 8–9 requirements)
------------------------------------------------------------------------

-- 1) Get member(s) who live on King Fahad street Riyadh (WHERE)
SELECT member_name
FROM MEMBER
WHERE address = 'King Fahad street Riyadh';

-- 2) All authors whose name begins with 'N' (WHERE + LIKE)
SELECT *
FROM AUTHOR
WHERE author_name LIKE 'N%';

-- 3) Delete visits for a specific phone number, then show remaining (DELETE + WHERE)
DELETE FROM VISIT
WHERE phone_number = '0551122334';
SELECT * FROM VISIT;

-- 4) Titles that cost more than 200, with a count (GROUP BY)
SELECT title, COUNT(*) AS copies_counted
FROM BOOK
WHERE book_price > 200
GROUP BY title;

-- 5) Branches that have exactly 1 employee (GROUP BY + HAVING)
SELECT branch_num, COUNT(employee_id) AS employee_count
FROM EMPLOYEE
GROUP BY branch_num
HAVING COUNT(employee_id) = 1;

-- 6) Member names and the book they have (JOIN across MEMBER→BORROW→BOOK)
SELECT m.member_name, b.title
FROM MEMBER m
JOIN BORROW br ON br.phone_number = m.phone_number
JOIN BOOK   b  ON b.book_number   = br.book_number;

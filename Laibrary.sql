Create Database Laibrarry;
Use Laibrarry;
CREATE TABLE Books (
    Book_ID VARCHAR(10) PRIMARY KEY,
    Title VARCHAR(255),
    Author VARCHAR(255),
    Genre VARCHAR(100),
    Publisher VARCHAR(255),
    Year INT,
    Total_Copies INT,
    Available_Copies INT
);

CREATE TABLE Members (
    Member_ID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(255),
    Email VARCHAR(255),
    Phone VARCHAR(50),
    Membership_Date DATE,
    Status VARCHAR(20)
);

CREATE TABLE Issued_Books (
    Issue_ID VARCHAR(10) PRIMARY KEY,
    Book_ID VARCHAR(10),
    Member_ID VARCHAR(10),
    Issue_Date DATE,
    Due_Date DATE,
    Returned VARCHAR(5),
    FOREIGN KEY (Book_ID) REFERENCES Books(Book_ID),
    FOREIGN KEY (Member_ID) REFERENCES Members(Member_ID)
);

CREATE TABLE Return_Records (
    Return_ID VARCHAR(10) PRIMARY KEY,
    Issue_ID VARCHAR(10),
    Return_Date DATE,
    Fine_Amount DECIMAL(10, 2),
    FOREIGN KEY (Issue_ID) REFERENCES Issued_Books(Issue_ID)
);
-- 1. Most Borrowed Books
SELECT b.Title, COUNT(*) AS Borrow_Count
FROM Issued_Books ib
JOIN Books b ON ib.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Borrow_Count DESC
LIMIT 10;
-- 2. Most Active Members
SELECT m.Name, COUNT(*) AS Issues
FROM Issued_Books ib
JOIN Members m ON ib.Member_ID = m.Member_ID
GROUP BY m.Name
ORDER BY Issues DESC
LIMIT 10;
-- 3. Books Currently Issued and Not Returned

SELECT b.Title, ib.Member_ID, ib.Issue_Date
FROM Issued_Books ib
JOIN Books b ON ib.Book_ID = b.Book_ID
WHERE UPPER(ib.Returned) = 'NO';

-- 4. Books Never Borrowed
SELECT b.Title
FROM Books b
LEFT JOIN Issued_Books ib ON b.Book_ID = ib.Book_ID
WHERE ib.Book_ID IS NULL;
-- 5. Members With Overdue Books
SELECT m.Name, ib.Due_Date
FROM Issued_Books ib
JOIN Members m ON ib.Member_ID = m.Member_ID
WHERE UPPER(ib.Returned) = 'NO' AND ib.Due_Date < CURRENT_DATE;
-- 6. Total Fine Collected
SELECT SUM(Fine_Amount) AS Total_Fines
FROM Return_Records;
-- 7. Average Fine Per Return
SELECT AVG(Fine_Amount) AS Average_Fine
FROM Return_Records;

-- 8Top 5 Members Who Paid the Highest Total Fines
SELECT m.Name, SUM(rr.Fine_Amount) AS Total_Fine
FROM Members m
JOIN Issued_Books ib ON m.Member_ID = ib.Member_ID
JOIN Return_Records rr ON ib.Issue_ID = rr.Issue_ID
GROUP BY m.Name
ORDER BY Total_Fine DESC
LIMIT 5;

-- 9Books Returned Late with Fine (Including Book & Member Details)

SELECT b.Title, m.Name AS Member_Name, rr.Return_Date, ib.Due_Date, rr.Fine_Amount
FROM Return_Records rr
JOIN Issued_Books ib ON rr.Issue_ID = ib.Issue_ID
JOIN Books b ON ib.Book_ID = b.Book_ID
JOIN Members m ON ib.Member_ID = m.Member_ID
WHERE rr.Fine_Amount > 0;
--- 13. Members Who Borrowed the Same Book More Than Once
SELECT m.Name, b.Title, COUNT(*) AS Times_Borrowed
FROM Issued_Books ib
JOIN Books b ON ib.Book_ID = b.Book_ID
JOIN Members m ON ib.Member_ID = m.Member_ID
GROUP BY m.Name, b.Title
HAVING COUNT(*) > 1;

-- 10. Members Who Borrowed the Same Book More Than Once

SELECT m.Name, b.Title, COUNT(*) AS Times_Borrowed
FROM Issued_Books ib
JOIN Books b ON ib.Book_ID = b.Book_ID
JOIN Members m ON ib.Member_ID = m.Member_ID
GROUP BY m.Name, b.Title
HAVING COUNT(*) > 1;

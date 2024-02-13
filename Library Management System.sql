create database library_management_system;

use library_management_system;

CREATE TABLE readers
(readerid varchar(6) NOT NULL PRIMARY KEY,
fname varchar(30),
lname varchar(30),
city varchar(15),
mobile varchar(10),
occupation varchar(10),
dob date
);

INSERT INTO readers VALUES('C00001','John','Leon','Greenwich','0712354676','Lawyer','1995-02-12');
INSERT INTO readers VALUES('C00002','Samuel','Francis','Liverpool','0712353546','Accountant','1990-12-12');
INSERT INTO readers VALUES('C00003','Tay','Machado','Brighton','0784654676','Model','1991-08-01');
INSERT INTO readers VALUES('C00004','Blossom','Shresthaeon','Woolwich','0712846776','Manager','1999-02-10');
INSERT INTO readers VALUES('C00005','Sam','Sharma','Abbey Wood','0712364676','Cook','1994-05-22');
INSERT INTO readers VALUES('C00006','Sunny','Aryal','Heathrow','0712359475','Manager','1994-10-12');
INSERT INTO readers VALUES('C00007','Isha','Subedi','Stratford','0712846576','Lecturer','1993-05-20');
INSERT INTO readers VALUES('C00008','Sony','Shrestha','Woolwich','0712937476','Nurse','1990-07-11');
INSERT INTO readers VALUES('C00009','Suchita','Dali','Plumstead','0712834576','Nurse','1980-09-12');
INSERT INTO readers VALUES('C00010','Manita','Shrestha','Plumstead','0719186676','Student','2015-03-17');

SELECT * FROM readers;

CREATE TABLE Book
(
BookId VARCHAR(6) NOT NULL PRIMARY KEY,
BName VARCHAR(40),
BDomain VARCHAR(30)
);

INSERT INTO Book VALUES('B00001','Heaven Official Blessing','Fiction');
INSERT INTO Book VALUES('B00002','Untamed','Fiction');
INSERT INTO Book VALUES('B00003','Good Dad Bad Dad','Story');

SELECT * FROM Book;

CREATE TABLE ActiveReaders
(
AccountID VARCHAR(6) NOT NULL PRIMARY KEY,
ReaderID VARCHAR(6),
Type VARCHAR(20),
Status VARCHAR(20),
CONSTRAINT ReaderID_FK FOREIGN KEY(ReaderID) REFERENCES readers(readerid)
);

SELECT * FROM ActiveReaders;

INSERT INTO ActiveReaders VALUES('A00001','C00001','Premium','Active');
INSERT INTO ActiveReaders VALUES('A00002','C00003','Premium','Active');
INSERT INTO ActiveReaders VALUES('A00003','C00006','Regular','Active');
INSERT INTO ActiveReaders VALUES('A00004','C00005','Premium','Terminated');
INSERT INTO ActiveReaders VALUES('A00005','C00009','Regular','Terminated');
INSERT INTO ActiveReaders VALUES('A00006','C00008','Premium','Active');
INSERT INTO ActiveReaders VALUES('A00007','C00002','Regular','Active');
INSERT INTO ActiveReaders VALUES('A00008','C00004','Premium','Suspended');
INSERT INTO ActiveReaders VALUES('A00009','C00007','Regular','Suspended');
INSERT INTO ActiveReaders VALUES('A00010','C00010','Premium','Active');

SELECT * FROM ActiveReaders;

CREATE TABLE BookIssueDetails
(
IssueNumber VARCHAR(6) NOT NULL PRIMARY KEY,
AccountID VARCHAR(6),
BookID VARCHAR(6),
BookName VARCHAR(40),
IssueDate DATE,
CONSTRAINT AccountID_FK FOREIGN KEY(AccountID) REFERENCES ActiveReaders(AccountID),
CONSTRAINT BookID_FK FOREIGN KEY(BookID) REFERENCES Book(BookID)
);

INSERT INTO BookIssueDetails VALUES('IN0001','A00007','B00001','Heaven Official Blessing','2024-02-01');
INSERT INTO BookIssueDetails VALUES('IN0002','A00005','B00002','Untamed','2024-01-01');
INSERT INTO BookIssueDetails VALUES('IN0003','A00001','B00003','Good Dad Bad Dad','2024-01-20');
INSERT INTO BookIssueDetails VALUES('IN0004','A00003','B00003','Good Dad Bad Dad','2024-02-02');

SELECT * FROM BookIssueDetails;

CREATE TABLE BookSold
(
BookSoldID VARCHAR(6) NOT NULL PRIMARY KEY,
BookID VARCHAR(6),
ReaderID VARCHAR(6),
CONSTRAINT ReadersID_FK FOREIGN KEY(ReaderID) REFERENCES Readers(ReaderID),
CONSTRAINT BooksID_FK FOREIGN KEY(BookID) REFERENCES Book(BookID)
);

INSERT INTO BookSold VALUES('BS0001','B00001','C00001');
INSERT INTO BookSold VALUES('BS0002','B00001','C00001');
INSERT INTO BookSold VALUES('BS0003','B00002','C00001');
INSERT INTO BookSold VALUES('BS0004','B00002','C00003');
INSERT INTO BookSold VALUES('BS0005','B00003','C00002');

/*List of accounts whose account have been terminated*/
SELECT * FROM ActiveReaders where Status='Terminated';

/*How many readers have premium account type*/

SELECT count(accountid) as Count from activereaders where type='Premium';

/*Showing accont details of all readers*/
SELECT r.fname,r.lname,b.type,b.status 
from readers r
join ActiveReaders b
where r.readerid=b.readerid;

/*How man books have been sold*/

SELECT * from BookSold;
SELECT count(bookid) from BookSold;

/*How many times have the Heaven Official Blessing Book been sold*/
SELECT b.BookID,b.BName,count(b.Bookid) as Qty
from BookSold a
JOIN Book b
on a.BookID=b.BookID
GROUP BY BookID
HAVING b.BName="Heaven Official Blessing";





